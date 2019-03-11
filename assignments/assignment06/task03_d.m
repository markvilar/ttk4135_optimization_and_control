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
n_blocks = length(blocks);

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

%% Inequality constraints
x_lb = -Inf(N*nx,1);
x_ub =  Inf(N*nx,1);

u_lb = -ones(n_blocks*nu,1);
u_ub =  ones(n_blocks*nu,1);

lb = [x_lb; u_lb];
ub = [x_ub; u_ub];

%% Solver
opt = optimset('Display','notify', 'Diagnostics','off', 'LargeScale','off');

u = NaN(nu,N);
x = NaN(nx,N+1);
x(:,1) = x0;

beq = [zeros(nx,1); zeros((N-1)*nx,1)];
ones_block = gen_ones_blocks(blocks);

for t = 1:N
    
    beq(1:nx) = A*x(:,t);
    
    [z,fval,exitflag,output,lambda] = quadprog(G,[],[],[],Aeq,beq,lb,ub,[],opt);
    
    u_blocks = z(N*nx+1:N*nx+n_blocks*nu);
    u_ol = ones_block*u_blocks;
    u(t) = u_ol(1);
    
    x(:,t+1) = A*x(:,t) + B*u(t);
    
end

y = C*x;

%% Plotting
t = 1:N;

figure();
subplot(2,1,1);
plot([0,t],y,'-ko');
grid('on');
grid('on');
ylabel('y_t')
subplot(2,1,2);
plot(t-1,u,'-ko'); % Plot on 0 to N-1
grid('on');
xlabel('t');
ylabel('u_t');
