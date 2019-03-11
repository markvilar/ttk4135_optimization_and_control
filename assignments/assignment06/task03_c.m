%% Workspace

clc
clear all

%% System matrices

A = [0     0      0    ;
     0     0      1    ;
     0.1  -0.79   1.78];
 
B = [1 0 0.1]';

C = [0 0 1];

nx = size(A,2);
nu = size(B,2);

%% Initial state

x0 = [0 0 1]';

%% Time horizon

N = 30;
blocks = [1 1 2 4 8 14];

if sum(blocks) ~= N
    error('Sum of time step blocks is not equal to the total number of time steps!')
end

%% Cost function
I_N = eye(N);
I_N_tilde = eye(length(blocks));
Q = 2*diag([0, 0, 1]);
Q_rep = kron(I_N, Q);
R = 2*1;
R_rep = kron(I_N_tilde, R);
G = blkdiag(Q_rep, R_rep);

%% Equality constraint

% State components
Aeq_c1 = eye(N*nx);
Aeq_c2 = kron(diag(ones(N-1,1),-1), -A);

% Input component
Aeq_c3 = gen_input_equality(blocks, B);
Aeq = [Aeq_c1 + Aeq_c2, Aeq_c3];

beq = [A*x0; zeros((N-1)*nx,1)];

%% Inequality constraints
x_lb = -Inf(N*nx,1);
x_ub =  Inf(N*nx,1);

u_lb = -ones(length(blocks)*nu,1);
u_ub =  ones(length(blocks)*nu,1);

lb = [x_lb; u_lb];
ub = [x_ub; u_ub];

%% Solver
opt = optimset('Display','notify', 'Diagnostics','off', 'LargeScale','off');
[z,fval,exitflag,output,lambda] = quadprog(G,[],[],[],Aeq,beq,lb,ub,[],opt);

y = [x0(3); z(nx:nx:N*nx)];
u = gen_input_sequence(N, nx, nu, z, blocks);
t = 1:N;

figure();
subplot(2,1,1);
plot([0,t],y,'-o');
grid('on');
grid('on');
ylabel('y_t')
subplot(2,1,2);
stairs(t-1,u,'-ko'); % Plot on 0 to N-1
grid('on');
xlabel('t');
ylabel('u_t');
