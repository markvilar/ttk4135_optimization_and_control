% Initialization for the helicopter assignment in TTK4135.
% Run this file before you execute QuaRC -> Build.

% Updated spring 2018, Andreas L. Flåten
% Updated Spring 2019, Joakim R. Andersen

clear all;
close all;
clc;

% The encoder for travel for Helicopter 2 is different from the rest.
travel_gain = 1; %

load('u_lqr.mat');
load('travel_plot.mat');
load('u_star_plot.mat');



%% Physical constants
m_h = 0.4; % Total mass of the motors.
m_g = 0.03; % Effective mass of the helicopter.
l_a = 0.65; % Distance from elevation axis to helicopter body
l_h = 0.17; % Distance from pitch axis to motor

% Moments of inertia
J_e = 2 * m_h * l_a *l_a;         % Moment of interia for elevation
J_p = 2 * ( m_h/2 * l_h * l_h);   % Moment of interia for pitch
J_t = 2 * m_h * l_a *l_a;         % Moment of interia for travel

% Identified voltage sum and difference
V_s_eq = 6.5; % Identified equilibrium voltage sum.
V_d_eq = 0.52; % Identified equilibrium voltage difference.

% Model parameters
K_p = m_g*9.81; % Force to lift the helicopter from the ground.
K_f = K_p/V_s_eq; % Force motor constant.
K_1 = l_h*K_f/J_p;
K_2 = K_p*l_a/J_t;
K_3 = K_f*l_a/J_e;
K_4 = K_p*l_a/J_e;

%% Pitch closed loop syntesis
% Controller parameters
w_p = 1.8; % Pitch controller bandwidth.
d_p = 1.0; % Pitch controller rel. damping.
K_pp = w_p^2/K_1;
K_pd = 2*d_p*sqrt(K_pp/K_1);
Vd_ff = V_d_eq;

% Closed loop transfer functions
Vd_max = 10 - V_s_eq; % Maximum voltage difference
deg2rad = @(x) x*pi/180;
Rp_max = deg2rad(15); % Maximum reference step
s = tf('s');
G_p = K_1/(s^2);
C_p = K_pp + K_pd*s/(1+0.1*w_p*s);
L_p = G_p*C_p;
S_p = (1 + L_p)^(-1);

plot_pitch_response = 0;
if plot_pitch_response
    figure;
    step(S_p*Rp_max); hold on;
    step(C_p*S_p*Rp_max/Vd_max);
    legend('norm error', 'norm input')
    title('Pitch closed loop response')
end

%% Elevation closed loop analysis
% Controller parameters
w_e = 0.5; % Elevation controller bandwidth.
d_e = 1.0; % Elevation controller rel. damping.
K_ep = w_e^2/K_3;
K_ed = 2*d_e*sqrt(K_ep/K_3);
K_ei = K_ep*0.1;
Vs_ff = V_s_eq;

% Closed loop transfer functions
Vs_max = 10 - V_s_eq; % Maximum voltage sum
Re_max = deg2rad(10); % Maximum elevation step
G_e = K_3/(s^2);
C_e = K_ep + K_ed*s/(1+0.1*w_e*s) + K_ei/s;
L_e = G_e*C_e;
S_e = (1 + L_e)^(-1);

% Optimal trajectory travel
T = 0.25;

N = 100;

M = N;

mx = 4;

mu = 1;

lambda0 = pi;

x0 = [lambda0 0 0 0]';

z0 = zeros(N*mx+M*mu,1);

q = 1;

A1 = [1 T 0 0;0 1 -K_2*T 0;0 0 1 T;0 0 -K_1*K_pp*T 1-K_1*K_pd*T];

B1 = [0;0;0;K_1*K_pp*T];

Aeq = gen_aeq(A1,B1,N,mx,mu);

beq = zeros(N*mx,1);

beq(1:4) = A1*x0; 

xl = [-inf -inf -30*pi/180 -inf]';

xu = [inf inf 30*pi/180 inf]';

ul = -30*pi/180;

uu = 30*pi/180;

[vlb, vub] = gen_constraints(N,M,xl,xu,ul,uu); 

Q1 = [2 0 0 0;0 0 0 0;0 0 0 0;0 0 0 0];

P1 = 2*q;

Q = gen_q(Q1,P1,N,M);

f = zeros(N*mx+M*mu,1);

[Z,fval,exitflag,output,lambda] = quadprog(Q,f,[],[],Aeq,beq,vlb,vub,z0);

Time = (0:T:T*(N-1))';

pitch_ref = Z(401:1:500);

pitch = Z(3:4:399);

travel = Z(1:4:397);

x_star = [zeros(1,30),Z(1:4:397)',zeros(1,30);zeros(1,30),Z(2:4:398)',...
    zeros(1,30);zeros(1,30),Z(3:4:399)',zeros(1,30);zeros(1,30),...
    Z(4:4:400)',zeros(1,30)];

x_star(1,1:30) = pi;

u_star = [zeros(30,1);Z(401:1:500);zeros(30,1)];

t = (0:T:T*(length(u_star)-1));

input = timeseries(u_star,t);

%% Optimal control - LQ
x_star_s = timeseries(x_star, t);

Q_lq = diag([10 10 1 1]);

R_lq = 1;

[K,S,E] = dlqr(A1,B1,Q_lq,R_lq);

figure;
hold on
plot(u_star_plot(1,:),u_star_plot(2,:),u_lqr(1,:),u_lqr(2,:));
xlabel('Time [s]');
ylabel('Angle [Rad]');
legend('Pitch optimal','Pitch LQR');
title('Task 10.3.2');

figure;
hold on
plot(travel_plot(1,:),travel_plot(2,:));
xlabel('Time [s]');
ylabel('Angle [deg]');
legend('Travel angle');
title('Task 10.3.2');

% figure;
% hold on
% plot(Time,pitch_ref,Time,pitch);
% xlabel('Time [s]');
% ylabel('Angle [Rad]');
% legend('Pitch reference','Pitch');
% title('Task 10.2.3, q = 0.1');
% 
% figure;
% hold on
% plot(Time,travel);
% xlabel('Time [s]');
% ylabel('Angle [rad]');
% title('Task 10.2.3, q = 1, Travel');

plot_elev_response = 0;
if plot_elev_response
    figure;
    step(S_e*Re_max);
    hold on;
    step(C_e*S_e*Re_max/Vs_max);
    legend('norm error', 'norm input')
    title('Elevation closed loop response')
end
