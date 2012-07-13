close all
clear all
clc

U0 = 1000;

L = 100;
beta = 0.95;
M = 0.15;
sqb = sqrt(1-beta^2);
A = (1-sqb)/(1+sqb);

x = 0:1:L;

U0 = U0/(exp(M*sqb*L)-A*exp(-M*sqb*L));
U = U0*(exp(M*sqb*(L-x))-A*exp(-M*sqb*(L-x)));
U1 = U+fliplr(U);
plot(x,U,'r',x,U1,'g');