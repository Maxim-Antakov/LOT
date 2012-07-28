close all
clear all
clc

b = 0.95;
m = 0.1;
x0 = 20;
x1 = -50;
x2 = 50;

x = linspace(x1,x2,200);

ap = sqrt((1+b)/(1-b))+1;
am = sqrt((1+b)/(1-b))-1;

msq = m*sqrt(1-b*b);
chm = cosh(msq*(x1-x2));

mn = am*exp(-(x2-x0)*msq)+ap*exp((x2-x0)*msq);

f_1 = mn/chm*sinh(msq*(x-x1));

f_01 = exp(msq*(x-x0))*ap.*(x>=x0);
f_02 = exp(-msq*(x-x0))*am.*(x>=x0);

f = f_1+f_01+f_02;

% plot(x,f_1)
% figure
plot(x,f);