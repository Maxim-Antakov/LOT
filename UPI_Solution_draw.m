close all
clear all
clc

bet = 0.95
m = 0.012
x0 = 50
x1 = 0
x2 = 100

x = linspace(x1,x2,2000);

ap = sqrt((1+bet)/(1-bet))+1;
am = sqrt((1+bet)/(1-bet))-1;
% k = sqrt((1+b)/(1-b));

k = m*sqrt(1-bet*bet)
b = m*(1+bet)

divis = k*cosh(k*(x2-x1))+m*sinh(k*(x2-x1));

mn = (m-b)*(cosh(k*(x2-x0))+(k-b*m/k)*sinh(k*(x2-x0)));

f_m = mn/divis*sinh(k*(x1-x));

f_p = cosh(k*(x-x0)).*(1-b/k*tanh(k*(x-x0))).*(x>x0);

f = f_m+f_p;

numer = k*cosh(k*(x2-x))+m*sinh(k*(x2-x));
f0=numer/divis;

 plot(x,f); hold on;
%  plot(x,f); hold on;
%  legend({'Total', 'Heaviside part', 'Another part', 'Transmission formula'},'Location','SW');
% line([x0,x0],[min(f), max(f)], 'Color', 'black')
% axis([min(x) max(x) min(f) max(f)])

mn1 = (b-m)*cosh(k*(x2-x0))+(-k+b*m/k)*sinh(k*(x2-x0));

f_m1 = mn1/divis*sinh(k*(x-x1));

f_p1 = cosh(k*(x-x0)).*(1-b/k*tanh(k*(x-x0))).*(x>x0);

f1 = f_m1+f_p1;

a = (m-k)/(m+k);
f2 = (exp(k*(x2-x))-a*exp(-k*(x2-x)))./(exp(k*(x2-x0))-a*exp(-k*(x2-x0)));


figure

plot(x,f, x,f2); grid on;
% legend({'Total1', 'Transmission formula'},'Location','SW');
% line([x0,x0],[min(f), max(f)], 'Color', 'black')
% axis([min(x) max(x) min(f) max(f)])