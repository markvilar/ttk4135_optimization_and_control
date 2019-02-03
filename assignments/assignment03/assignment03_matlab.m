%% Task 2 - LP-problem

A = [   2   1   1   0;
        1   3   0   1   ];
b = [   8   15  ]';
c = [   -3  -2  0   0   ]';

x0 = [0 0 8 15]';

x1 = linspace(0,10);
x2 = linspace(0,10);
[X1, X2] = meshgrid(x1,x2);
F = c(1)*X1 + c(2)*X2;
contour(X1, X2, F)

[x, fval, iterates] = simplex(c,A,b,x0,'report');