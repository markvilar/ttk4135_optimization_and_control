%% Problem 1
clear all
close all
clc

x0_1 = [1.2, 1.2]';
[x_opt_1, fval_opt_1, x_iter_1, f_iter_1, alpha_1] = min_rosenbrock_sd(x0_1);
[x_opt_2, fval_opt_2, x_iter_2, f_iter_2, alpha_2] = min_rosenbrock_newton(x0_1);
[x_opt_3, fval_opt_3, x_iter_3, f_iter_3, alpha_3] = min_rosenbrock_bfgs(x0_1);

x0_2 = [-1.2, 1.0]';
[x_opt_4, fval_opt_4, x_iter_4, f_iter_4, alpha_4] = min_rosenbrock_sd(x0_2);
[x_opt_5, fval_opt_5, x_iter_5, f_iter_5, alpha_5] = min_rosenbrock_newton(x0_2);
[x_opt_6, fval_opt_6, x_iter_6, f_iter_6, alpha_6] = min_rosenbrock_bfgs(x0_2);

plot_iter_rosenbrock(x_iter_1, alpha_1, 'SD with x0 = [1.2, 1.2]');
plot_iter_rosenbrock(x_iter_2, alpha_2, 'N with x0 = [1.2, 1.2]');
plot_iter_rosenbrock(x_iter_3, alpha_3, 'BFGS with x0 = [1.2, 1.2]');
plot_iter_rosenbrock(x_iter_4, alpha_4, 'SD with x0 = [-1.2, 1.0]');
plot_iter_rosenbrock(x_iter_5, alpha_5, 'N with x0 = [-1.2, 1.0]');
plot_iter_rosenbrock(x_iter_6, alpha_6, 'BFGS with x0 = [-1.2, 1.0]');