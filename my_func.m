function f = my_func(x)
global M b
f = [x(2); M^2*(1-b^2)*x(1)];