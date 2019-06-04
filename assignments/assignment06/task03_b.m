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
u_blocks = [1 1 2 4 8 14];

if sum(u_blocks) ~= N
    error('Sum of time step blocks is not equal to the total number of time steps!')
end

%% Cost function
I_N = eye(N);
I_N_tilde = eye(N_tilde);
Q = 2*diag([0, 0, 1]);
Q_rep = kron(I_N, Q);
R = 2*1;
R_tilde_rep = kron(I_N_tilde, R);
G = blkdiag(Q_rep, R_tilde_rep);

%% Equality constraint

% State components
Aeq_c1 = eye(N*nx);
Aeq_c2 = kron(diag(ones(N-1,1),-1), -A);

% Input component
I_tilde = kron(eye(N_tilde), ones(t_tilde, nu));
Aeq_c3 = kron(I_tilde, -B);
Aeq = [Aeq_c1 + Aeq_c2, Aeq_c3];

beq = [A*x0; zeros((N-1)*nx,1)];

%% Inequality constraints
x_lb = -Inf(N*nx,1);
x_ub =  Inf(N*nx,1);

u_lb = -ones(N_tilde*nu,1);
u_ub =  ones(N_tilde*nu,1);

lb = [x_lb; u_lb];
ub = [x_ub; u_ub];

%% Solver
opt = optimset('Display','notify', 'Diagnostics','off', 'LargeScale','off');
[z,fval,exitflag,output,lambda] = quadprog(G,[],[],[],Aeq,beq,lb,ub,[],opt);

y = [x0(3); z(nx:nx:N*nx)];
u = repelem(z(N*nx+1:N*nx+N_tilde*nu), t_tilde);
t = 1:N;

%% Plotting
figure(4);
subplot(2,1,1);
plot([0,t],y,'-ko'); % Plot on 0 to N
grid('on');
ylabel('y_t')
subplot(2,1,2);
stairs(t-1,u,'-ko'); % Plot on 0 to N-1
grid('on');
xlabel('t');
ylabel('u_t');
