clc; clear; close all;
A = rand(399,6);
[m,n] = size(A) ;
P = 0.70 ;
idx = randperm(m)  ;
Training = A(idx(1:round(P*m)),:) ; 
Testing = A(idx(round(P*m)+1:end),:) ;
