% Plot function to draw U+, U- and Total

beta = 0.95;
x1 = 50;
x0 = 0;
mu = 0.1;

gam = sqrt(1 - beta^2);
x = linspace(x0,x1,100);

d  = (1+gam)*exp(gam*mu*(x1-x0))-(1-gam)*exp(-gam*mu*(x1-x0));
m1 = (1+gam)*exp(gam*mu*(x1-x))-(1-gam)*exp(-gam*mu*(x1-x));
m2 = (beta)*exp(gam*mu*(x1-x))-(beta)*exp(-gam*mu*(x1-x));

up = m1/d;
um = m2/d;
ut = up + um;


plot(x,up, x, um, x, ut)
legend({'U_+', 'U_-', 'U_++U_-'})