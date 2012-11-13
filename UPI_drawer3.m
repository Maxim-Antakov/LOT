close all
clear all
clc

bet = 0.95
m = 0.1
x1 = 0
x2 = 100

x = linspace(x1,x2,1000);
x00 = 30;

ap = sqrt((1+bet)/(1-bet))+1;
am = sqrt((1+bet)/(1-bet))-1;
% k = sqrt((1+b)/(1-b));

k = m*sqrt(1-bet*bet)
b = m*(1+bet)


divis = k*cosh(k*(x2-x1))+m*sinh(k*(x2-x1));
numer = k*cosh(k*(x2-x))+m*sinh(k*(x2-x));
f0=numer/divis;
mn1 = (b-m)*cosh(k*(x2-x00))+(-k+b*m/k)*sinh(k*(x2-x00));

f_m1 = mn1/divis*sinh(k*(x-x1));

f_p1 = cosh(k*(x-x00)).*(1-b/k*tanh(k*(x-x00))).*(x>x00);

f1 = f_m1+f_p1;



f_m2 = exp(-k*(x2 - x)).*mn1/(k+m);
f2 = f_m2 + f_p1;
plot(x,f1, x, f2); hold on;
legend({'Limited', 'Semi-Inf'},'Location','SW');
