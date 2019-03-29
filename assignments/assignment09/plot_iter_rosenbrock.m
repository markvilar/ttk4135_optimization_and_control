function plot_iter_rosenbrock(x_iter, alpha, title_str)
    % Plots isocurves for the Rosenbrock function on [-2, 2]x[-1 ,2] as
    % well as the the iterates x_k in the input x_iter. x_iter must be an
    % 2xN matrix where N is the number of iterations performed (column k
    % contains x_k).

    x1_l = -2; x1_h = 2;
    x2_l = -1; x2_h = 2;
    res = 0.01;
    [x1, x2] = meshgrid(x1_l:res:x2_h, x1_l:res:x2_h);
    f = 100*(x2-x1.^2).^2 + (1-x1).^2;
    levels = (0:5:50)';
    
    figure();
    clf;
    
    subplot(1,2,1);
    hold('on');
    box('on');
    grid('on');
    axis('square');
    contour(x1, x2, f, levels, 'Color', .7*[1 1 1]);
    plot(x_iter(1,:), x_iter(2,:));
    plot(1,1,'o');
    axis([x1_l, x1_h, x2_l, x2_h]);
    set(gca,'XTick', x1_l:1:x1_h, 'YTick', x1_l:1:x1_h);
    xlabel('x_1');
    ylabel('x_2');
    title(title_str);
    hold('off');
    
    subplot(1,2,2);
    hold('on');
    box('on');
    grid('on');
    axis('square');
    plot(alpha);
    ylim([0, 1]);
    xlabel('Iterations');
    ylabel('alpha');
    hold('off');
    
end