clc
clear all

%% Parameters

T = 0.5;

%% Model
A = [ 1   T;
      0   1];

b = [T T^2/2; 0 T] * [0 1]';

%% Weighting matrices

Q = diag([1 1]);

R = 1;

%% Riccati

[K, P] = dlqr(A, b, Q, R);