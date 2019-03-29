%% Problem 3
clear all
clc

x_1 = [0.5, 0.5]';
x_2 = [1, 1]';

epsilon_1 = 1e-2;
epsilon_2 = 1e-4;
epsilon_3 = 1e-6;

% x0_1
analytical_grad_1 = gradient(x_1);
numerical_grad_11 = numerical_gradient(x_1, epsilon_1);
numerical_grad_12 = numerical_gradient(x_1, epsilon_2);
numerical_grad_13 = numerical_gradient(x_1, epsilon_3);

analytical_grad_2 = gradient(x_2);
numerical_grad_21 = numerical_gradient(x_2, epsilon_1);
numerical_grad_22 = numerical_gradient(x_2, epsilon_2);
numerical_grad_23 = numerical_gradient(x_2, epsilon_3);

function analytical_grad = gradient(x)

analytical_grad = ...
    [
        202*x(1)-200*x(2)-2;
        -200*x(1)+200*x(2);
    ];

end

function numerical_grad = numerical_gradient(x, epsilon)

numerical_grad = ...
    [
        202*x(1)-200*x(2)-2+101*epsilon;
        -200*x(1)+200*x(2)+100*epsilon;
    ];

end