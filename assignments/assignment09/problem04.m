%% Problem 4

x0_1 = [2, -2]';
x0_2 = [1.2, 1.2]';
x0_3 = [-1.2, 1]';

[x_1, fval_1, f_avg_iter_1, x_iter_1] = nelder_mead(x0_1, '');
[x_2, fval_2, f_avg_iter_2, x_iter_2] = nelder_mead(x0_2, '');
[x_3, fval_3, f_avg_iter_3, x_iter_3] = nelder_mead(x0_3, '');

plot_iter_rosenbrock_NM(x_iter_1, f_avg_iter_1, 'Nelder mead with x0 = [2, -2]');
plot_iter_rosenbrock_NM(x_iter_2, f_avg_iter_2, 'Nelder mead with x0 = [1.2, 1.2]');
plot_iter_rosenbrock_NM(x_iter_3, f_avg_iter_3, 'Nelder mead with x0 = [-1.2, 1]');