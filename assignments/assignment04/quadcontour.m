%% Script for making contour plots of quadratic objective functions

x1_llim = 0;
x1_ulim = 8;
x2_llim = 0;
x2_ulim = 8;
n = 1000;

G = [0.8   0;
     0   0.4];
c = [-3  -2]';

x1 = linspace(x1_llim, x1_ulim, n);
x2 = linspace(x2_llim, x2_ulim, n);
[X1, X2] = meshgrid(x1, x2);

dims = [length(x1)  length(x2)];

q = zeros(dims);

for i = 1:dims(1)
    for j = 1:dims(2)
        x = [x1(i)    x2(j)]';
        q(i,j) = (1/2)*x'*G*x + c'*x; 
    end
end

contour(X1, X2, q)