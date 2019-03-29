function [x, fval, f_avg_iter, x_iter] =  nelder_mead(x0, outp)
%NELDER_MEAD Unconstrainded optimization with the Nelded-Mead method
%   [X,FVAL,X_ITER] = NELDER_MEAD(X0, OUTP) attempts to solve the 
%   unconstrained nonlinear optimization problem
%        
%                              min f(x)    
%                               x
%   
%   The initial set of points (the initial simplex) contains X0 and
%   nearby points. The proximity of the nearby points is set with the
%   parameter perturb_param. Upon successful termination, X is the best
%   point found, and FVAL the objective function value at this point.
%   X_ITER contains the best point x at every iteration. If outp is passed
%   as 'report', the function prints a detailed report at every iteration.
%   If report is passed as [], no report is printed.
%
%   The function prints a report and plots f(x) as a function of the best x
%   at iteration k. The objective function is specified in the subfunction
%   function fvals = f(x); note that the function accepts a matrix x, whose
%   columns are points, and returns the function value at all these points
%   in a row vector. This file implements f(x) as the Rosenbrock function,
%   but the subfunction may of course be modified to implement other
%   functions.
%   
%   NOTE: This function is written for educational purposes only. The
%         algorithm is neither quick nor robust, and should only be used on
%         very small problems. The implementation is meant to illustrate
%         Procedure 9.5 in Nocedal and Wright: Numerical Optimization,
%         2nd ed., Springer, 2006. There are probably some errors in the
%         implementation, please report any to heirung@itk.ntnu.no. See
%         fminsearch.m for a much better (although more complicated) 
%         implementation of the Nelded-Mead algorithm.
% 
%   Version 0.9.1: Fixed bugs in lines 108 and 117 discovered by Lars 
%   Skj�rpe Midttun and Dag Sletteb�.
%   Tor Aksel N. Heirung, 04.12.2013



% Algorithm options
iterlim = 1e2;  % Max number of iterations
fun_tol = 1e-5; % Tolerence for difference in function values at simplex points - "flatness"
x_tol = 1e-5;   % Maximum coordinate difference between the current best point and the 
                % other points in the simplex - "size" of simplex


% Perturbation paramater for initial point x0 (determines size of initial simplex):
perturb_param = 0.05;
% Generate initial simplex (a set of start points):
x = startpoint(x0, perturb_param);

 % Problem dimension:
n = size(x,1);

% For storing iteration data:
x_iter = zeros(n, iterlim); % Storing BEST x at each iteration
f_iter = zeros(1, iterlim); % Storing f at BEST x at each iteration
f_avg_iter = zeros(1, iterlim); % Storing average of f at each iteration


k = 1; % Iteration counter
while k < iterlim
    x = sort_x(x); % sort points so that f(x_1) <= f(x_2) <= ... <= f(x_{n+1})
    
    % Store best x and f at best x:
    x_iter(:,k) = x(:,1);
    f_iter(k) = f(x(:,1));
    f_avg_iter(k) = mean(f(x));
    
    % Calculate termination criteria
    % A measure of how flat the simplex is. A small number > 0 means it is flat
    flatness = max(abs(f(x(:,1))-f(x(:,2:n+1)))); 
    % A measure of the size of the simplex. Measures how far away x_2, ...,
    % x_{n+1} are from x_1.
    simplex_size = max(max(abs(x(:,2:n+1) - x(:,ones(1,n)))));
    % The algorithm terminates if the simplex is small and flat:
    if (flatness <= fun_tol) && (simplex_size <= x_tol)
        disp('Successful termination.');
        break
    end
    
    reflection_point = x_bar(x, -1);
    f_m1 = f(reflection_point); % f_{-1}
    if (f(x(:,1)) <= f_m1) && (f_m1 < f(x(:,n)))
        % reflected point is neither best nor worst in the new simplex
        x(:,n+1) = reflection_point; % replace x_{n+1} by x_bar(-1) and
        % go to next iteration.
        action = 'Reflect';
    elseif f_m1 < f(x(:,1))
        % reflected point is better than the current best; try to 
        % go farther along this direction
        expansion_point = x_bar(x, -2);
        f_m2 = f(expansion_point); % f_{-2} is f_m2
        if f_m2 < f_m1
            x(:,n+1) = expansion_point; % replace x_{n+1} by x_{-2} (the 
            % expansion point) and go to next iteration
            action = 'Expand';
        else
            x(:,n+1) = reflection_point; % replace x_{n+1} by x_{-1} (the 
            % reflection point) and go to next iteration
            action = 'Reflect';
        end
    elseif f_m1 >= f(x(:,n))
        % reflected point is still worse than x_n; contract
        contraction_acceptable = false;
        if (f(x(:,n)) <= f_m1) && (f_m1 < f(x(:,n+1)))
            % try to perform "outside" contraction
            f_mhalf = f(x_bar(x, -0.5)); % f_{-1/2} is f_mhalf [typo in textbook]
            if f_mhalf <= f_m1
                x(:,n+1) = x_bar(x, -0.5); % replace x_{n+1} by x_bar(-1/2)
                % and go to next iteration
                contraction_acceptable = true;
                action = 'Outside contract';
            end
        else
            % try to perform "inside" contraction
            f_half = f(x_bar(x, 1/2)); % f_{1/2} is f_half [typo in textbook]
            if f_half < f(x(:,end)) % f_{n+1} is f(x(:,end))
                x(:,end) = x_bar(x, 1/2); % replace x_{n+1} = x_{1/2}
                % and go to next iteration
                contraction_acceptable = true;
                action = 'Inside contract';
            end
        end
        if ~contraction_acceptable
            % neither outside nor inside contraction was acceptable;
            % shrink the simplex toward x1
            i = 2 : n+1;
            % replace x_i <- (1/2)(x_1 + x_i) for i = 2,3,...,n+1:
            x(:,i) = (1/2) * (x(:,ones(1,n)) + x(:,i));
            action = 'Shrink';
        end
    end
    
    % Display output
    if strcmpi(outp, 'report')
        report(k, x(:,1), f(x(:,1)), action);
    end
    k = k + 1;
end

if k == iterlim
    disp('Iterarion limit reached.');
end

% Function output
x = x(:,1);
fval = f(x);

% Delete unused entries in iteration data
x_iter = x_iter(:,1:k);
f_iter = f_iter(1:k);
f_avg_iter = f_avg_iter(1:k);

% Plot results
plot_f(f_avg_iter, x0);

end

function fvals = f(x)
    % Returns row vector of function values, each element corresponds to
    % a column of the matrix of points x, where each column is a point.
    fvals = 100 * ( x(2,:) - x(1,:).^2 ).^2  +  ( 1 - x(1,:) ).^2; % Rosenbrock function
end

function x_t = x_bar(x, t)
    % Returns x_bar_t, which is on the line connecting the worst vertex and
    % the centroid
    % Assumes x is sorted
    c = centroid(x);
    x_np1 = x(:,end); % x_{n+1} is the last element of the sorted set of points
    x_t = c + t*(x_np1 - c);
end

function c = centroid(x)
    % Computes the centroid of the n best points when points are passed as
    % columns in x. Assumes x is sorted.
    x_n_best = x(:,1:end-1); % The n best points. 
    c = mean(x_n_best,2); % The centroid.
end

function x_sorted = sort_x(x)
    fvals = f(x); % Row vector of function values.
    % indices is a vector containing indices of fvals in ascending order:
    [~, indices] = sort(fvals); 
    % x gets sorted when indexed with these indices:
    x_sorted = x(:,indices);
end

function x = startpoint(x0, perturb_param)
    x0 = x0(:); % Ensure column vector
    n = size(x0,1); % Problem dimension
    % Generate a full-rank matrix for to perturb x0:
    perturb_matrix = [zeros(n,1), triu(ones(n)) - tril(ones(n),-1)];
    % Add to x0 to generate a valid start point:
    x = x0(:,ones(1,n+1)) + perturb_param*perturb_matrix;
    % Check if starting point is valid
    V = x(:,2:n+1) - x(:,ones(1,n));
    if det(V) == 0
        error('Invalid starting point! Bug in start-point generator.');
    end
end

function report(k, x1, f_x1, action)
    header_freq = 10; % Write header every header_freq iteration
    if (mod((k-1)/header_freq, 1) == 0)
        fprintf('%5s %25s %29s %16s\n', 'Iter', 'Best x', 'f(best x)', 'Action');
    end
    fprintf('%5i  |', k);
    fprintf(['  [' sprintf('%15.6e, ', x1) '\b\b]''  |']);
    fprintf('%15.6e  |', f_x1);
    fprintf('  %16s  |\n', action);   
end

function plot_f(f_avg_iter, x0)
    x0_str = strcat('x0 = [', num2str(x0(1)), ', ', num2str(x0(2)), ']');
    alg_str = 'Nelder Mead, ';
    title_str = strcat(alg_str, x0_str);
    
    figure(1);
    plot(f_avg_iter);
    axis('tight');
    grid('on');
    title(title_str)
    ylabel('Average of f(x)')
    xlabel('k');
end