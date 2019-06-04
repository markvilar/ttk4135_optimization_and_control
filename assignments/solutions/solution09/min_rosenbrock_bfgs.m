function [x_opt, fval_opt, x_iter, f_iter, alpha] = min_rosenbrock_bfgs(x0)

maxiter = 1e3;
% maxiter = 40;
grad_tol = 1e-3;

x0 = x0(:);
n = size(x0,1); % Number of variables
x =     NaN(n,maxiter);
p =     NaN(n,maxiter);
grad =  NaN(n,maxiter);
H =     NaN(n,n,maxiter);
alpha = NaN(1,maxiter);
fval =  NaN(1,maxiter);

k = 1;

% Approximate initial Hessian using central differences
e1 = [1, 0]';
e2 = [0, 1]';
% eps = 1e-6;
% Aprroximate each column separately:
B_col1 = (gradient(x0+eps*e1)-gradient(x0-eps*e1))/(2*eps);
B_col2 = (gradient(x0+eps*e2)-gradient(x0-eps*e2))/(2*eps);
B0 = [B_col1, B_col2];
H(:,:,k) = inv(B0);

x(:,k) = x0;
grad(:,k) = gradient(x(:,k));
while (k < maxiter) && (norm(grad(:,k)) >= grad_tol)
    fval(k) = f(x(:,k));
    p(:,k) = -H(:,:,k)*grad(:,k);
%     if p(:,k) ~= zeros(n,1); % Normalize p
%         p(:,k) = p(:,k)/norm(p(:,k));
%     end
    alpha_0 = 1;
    alpha(k) = linesearch(x(:,k), p(:,k), fval(k), grad(:,k), alpha_0);
    x(:,k+1) = x(:,k) + alpha(k)*p(:,k);
    grad(:,k+1) = gradient(x(:,k+1));
    s_k = x(:,k+1) - x(:,k);
    y_k = grad(:,k+1) - grad(:,k);
    H(:,:,k+1) = H_kp1(H(:,:,k), s_k, y_k);
    k = k+1;
end
fval(k) = f(x(:,k));

% Delete unused space
x = x(:,1:k);
p = p(:,1:k);
grad = grad(:,1:k);
H = H(:,:,1:k);
alpha = alpha(1:k);
fval = fval(1:k);

% Return values
x_opt = x(:,end);
fval_opt = f(x_opt);
x_iter = x;
f_iter = fval;

end

function alpha_k = linesearch(xk, pk, fk, gradk, alpha_0)
    % Checks both Wolfe conditions
    alpha = alpha_0;
    rho = 0.9;
    c1 = 1e-4;
    c2 = 0.90; % see p. 142
    while ( f(xk + alpha*pk) > fk + c1*alpha*gradk'*pk ) || ...
            ( gradient(xk + alpha*pk)'*pk < c2*gradk'*pk )
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

function H_next = H_kp1(H_k, s_k, y_k)
    rho_k = 1/(y_k'*s_k);
    I = eye(numel(s_k));
    H_next = (I - rho_k*s_k*y_k')*H_k*(I - rho_k*y_k*s_k') + rho_k*(s_k*s_k');
end