close all
clear all
clc

bet = 0.95
m = 0.01
x1 = 0
x2 = 100

x = linspace(x1,x2,1000);
x0 = 30;


buger = exp(-m*(x-x0)).*(x>x0);
my1  = exp(m*(x+x0-2*x2));
my2 = -1*exp(m*(x0-x-2*x2+2*x1)) ;
my3 = -1*exp(m*(x0-x)).*(x>x0);
my_1 = 2*exp(m*(x1-x0)).*sinh(x1-x);
figure
plot(x,my1, x, my2)
figure
my = my1+my2+my3;
my_2 = my3+my_1;
plot(x,buger, x, my); hold on;
legend({'Buger', 'My', 'My2'},'Location','SW');
