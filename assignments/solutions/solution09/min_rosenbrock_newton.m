function [x_opt, fval_opt, x_iter, f_iter, alpha] = min_rosenbrock_newton(x0)

maxiter = 1e3;
grad_tol = 1e-3;

x0 = x0(:);
n = size(x0,1); % Number of variables
x =     NaN(n,maxiter);
p =     NaN(n,maxiter);
grad =  NaN(n,maxiter);
alpha = NaN(n,maxiter);
fval =  NaN(n,maxiter);

k = 1;
x(:,k) = x0;
grad(:,k) = gradient(x(:,k));
while (k < maxiter) && (norm(grad(:,k)) >= grad_tol)
    fval(k) = f(x(:,k));
    p(:,k) = newton(x(:,k), grad(:,k));
    alpha_0 = 1;
    alpha(k) = linesearch(x(:,k), p(:,k), fval(k), grad(:,k), alpha_0);
    x(:,k+1) = x(:,k) + alpha(k)*p(:,k);
    grad(:,k+1) = gradient(x(:,k+1));
    k = k+1;
end
fval(k) = f(x(:,k));

% Delete unused space
x = x(:,1:k);
p = p(:,1:k);
grad = grad(:,1:k);
alpha = alpha(1:k);
fval = fval(1:k);

% Return values
x_opt = x(:,end);
fval_opt = f(x_opt);
x_iter = x;
f_iter = fval;

end

function p = newton(x, grad)
    B = hessian(x);
    p = -B\grad; % inv(B)*grad
end

function alpha_k = linesearch(xk, pk, fk, gradk, alpha_0)
    alpha = alpha_0;
    rho = 0.95;
    c1 = 1e-4;
    while f(xk + alpha*pk) > fk + c1*alpha*gradk'*pk
        alpha = rho*alpha;
    end
    alpha_k = alpha;
end

function fval = f(x)
    fval = 100*(x(2)-x(1)^2)^2 + (1-x(1))^2;
end

function grad = gradient(x)
    grad = [ -400*(x(1)*x(2)-x(1)^3) + 2*x(1) - 2 ;
             200*(x(2)-x(1)^2)                   ];
end

function B = hessian(x)
    B = [ -400*x(2) + 1200*x(1)^2 + 2  ,  -400*x(1)  ;
          -400*x(1)                    ,  200       ];
end