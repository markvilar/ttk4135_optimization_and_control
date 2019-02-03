% ********************************************************
% *                                                      *
% *      Optimalisering og regulering 					 *
% * 		?ving 3 Oppgave   V?r 2003					 *
% *                                                      *
% *      Bjarne Foss 1996                                *
% *                                                      *
% * qp_prodplan.m                                        *
% *                                                      *
% * m-file for calculating QP solution.                  *
% *                                                      *
% * Oppdated 10/1-2001 by Geir Stian Landsverk           *
% *                                                      *
% * Verified to work with MATLAB R2015a,                 *
% *    Andreas L. Fl?ten                                 *
% *                                                      *
% * Verified to work with MATLAB R2018b,                 *
% *    Joakim R. Andersen                                *
% *                                                      *
% ********************************************************


global XIT; % Storing iterations in a global variable
global IT;  % Storing number of iterations in a global variable
global x0;  % Used in qp1.m (line 216).

IT=1; XIT=[];

x0 = [0 0]'; % Initial value
vlb = [0 0]; % Lower bound on x
vub = [];    % Upper bound on x

% min 0.5*x'*G*x + x'*c
%  x 
%
% s.t. A*x <= b 

% Quadratic objective (MODIFY THESE)
G = [g11 g12 ;
     g21 g22]; % Remember the factor 1/2 in the objective
c = [c1 ; c2];

% Linear constraints (MODIFY THESE)
A = [a11 a12 ; 
     a21 a22];
b = [b1 ; b2];

options = optimset('LargeScale','Off');
[x,lambda] = quadprog1(G,c,A,b,[],[],vlb,vub,x0,options);

disp('Iteration sequence:')
disp(XIT');
disp('Solution:')
disp(x);
