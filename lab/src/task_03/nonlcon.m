function [C,Ceq] = nonlcon(z)
N = 40;
mx = 6;
alpha = 0.2;
beta = 20;
lambda_t = 2*pi/3;

C = alpha*exp(-beta*((z(1:mx:(mx*N-5)))-lambda_t).^2) - z(5:mx:(mx*N-1));
%C = alpha*exp(-beta*(z(1:mx:(N*mx-5))-lambda_t).^2)-z(5:mx:(N*mx-1));

Ceq = [];
end