function [x_opt, fval_opt, x_iter, f_iter, alpha] = min_rosenbrock_bfgs(x0)

maxiter = 2e3;
grad_tol = 1e-3;

e_1 = [1 0]';
e_2 = [0 1]';

% Initial approximation of the Hessian
B0_1 = (gradient(x0 + eps*e_1) - gradient(x0 - eps*e_1)) / (2*eps);
B0_2 = (gradient(x0 + eps*e_2) - gradient(x0 - eps*e_2)) / (2*eps);
B0 = [B0_1, B0_2];
H0 = inv(B0);

x0 = x0(:);
H0 = H0(:,:);
n = size(x0,1); % Number of variables
x =     NaN(n,maxiter);
p =     NaN(n,maxiter);
grad =  NaN(n,maxiter);
H =  NaN(n,n,maxiter);
s = NaN(n,maxiter);
y = NaN(n,maxiter);
alpha = NaN(1,maxiter);
fval =  NaN(1,maxiter);


% First iteration
k = 1;
x(:,k) = x0;
H(:,:,k) = H0;
grad(:,k) = gradient(x(:,k));
p(:,k) = bfgs(H(:,:,k), grad(:,k));
alpha0 = 1;

while (k < maxiter) && (norm(grad(:,k)) >= grad_tol)
    fval(k) = f(x(:,k));
    p(:,k) = bfgs(H(:,:,k), grad(:,k));
    alpha(k) = linesearch(x(:,k), p(:,k), fval(k), grad(k), alpha0);
    
    x(:,k+1) = x(:,k) + alpha(k)*p(:,k);
    grad(:,k+1) = gradient(x(:,k+1));
    
    s(:,k) = x(:,k+1) - x(:,k);
    y(:,k) = grad(:,k+1) - grad(:,k);
    
    H(:,:,k+1) = calc_H(H(:,:,k), s(:,k), y(:,k));
    
    k = k + 1;
end

x_opt = x(:,end);
fval_opt = fval(:,end);
x_iter = x;
f_iter = fval;

end

function alpha_k = linesearch(x, p, fk, grad, alpha_0)
    alpha = alpha_0;
    rho = 0.95;
    c1 = 1e-4;
    while f(x + alpha*p) > fk + c1*alpha*grad'*p
        alpha = rho*alpha;
    end
    alpha_k = alpha;
end

function H = calc_H(H,s,y)
    rho = 1/(y'*s);
    I = eye(numel(s));
    
    H = (I - rho*s*y')*H*(I - rho*y*s') + rho*(s*s');
end

function p = bfgs(H, grad)
    p = -H * grad;
end

function fval = f(x)
    fval = 100*(x(2)-x(1)^2)^2 + (1-x(1))^2;
end

function grad = gradient(x)
    grad = [ -400*(x(1)*x(2)-x(1)^3) + 2*x(1) - 2 ;
             200*(x(2)-x(1)^2)                   ];
end