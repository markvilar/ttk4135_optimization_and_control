function [x_opt, fval_opt, x_iter, f_iter, alpha] = min_rosenbrock_sd(x0)

maxiter = 2e3;
grad_tol = 1e-3;

x0 = x0(:);
n = size(x0,1); % Number of variables
x =     NaN(n,maxiter);
p =     NaN(n,maxiter);
grad =  NaN(n,maxiter);
alpha = NaN(1,maxiter);
fval =  NaN(1,maxiter);

% First iteration
k = 1;
x(:,k) = x0;
fval(k) = f(x(:,k));
grad(:,k) = gradient(x(:,k)); 
p(:,k) = sd(grad(:,k));
alpha_0 = 1/norm(p(:,k)); % So that ||alpha p|| = 1;
alpha(k) = linesearch(x(:,k), p(:,k), fval(k), grad(:,k), alpha_0);
x(:,k+1) = x(:,k) + alpha(k)*p(:,k);
grad(:,k+1) = gradient(x(:,k+1));
k = k+1;

while (k < maxiter) && (norm(grad(:,k)) >= grad_tol)
    fval(k) = f(x(:,k));
    p(:,k) = sd(grad(:,k));
    alpha_0 = alpha(k-1)*(grad(:,k-1)'*p(:,k-1))/(grad(:,k)'*p(:,k)); % p. 59 N&W
    alpha(k) = linesearch(x(:,k), p(:,k), fval(k), grad(:,k), alpha_0);
    x(:,k+1) = x(:,k) + alpha(k)*p(:,k);
    grad(:,k+1) = gradient(x(:,k+1)); % Done here since needed in the while condition
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

function p = sd(grad)
    p = -grad;
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