close all
clear all
clc

bet = 0.95
m = 0.1
x1 = 0
x2 = 100

x = linspace(x1,x2,1000);
x0 = linspace(x1,x2,100);

ap = sqrt((1+bet)/(1-bet))+1;
am = sqrt((1+bet)/(1-bet))-1;
% k = sqrt((1+b)/(1-b));

k = m*sqrt(1-bet*bet)
b = m*(1+bet)


divis = k*cosh(k*(x2-x1))+m*sinh(k*(x2-x1));
numer = k*cosh(k*(x2-x))+m*sinh(k*(x2-x));
f0=numer/divis;

for n=1:length(x0)
    
    x00=x0(n);

    mn1 = (b-m)*cosh(k*(x2-x00))+(-k+b*m/k)*sinh(k*(x2-x00));

    f_m1 = mn1/divis*sinh(k*(x-x1));

    f_p1 = cosh(k*(x-x00)).*(1-b/k*tanh(k*(x-x00))).*(x>x00);

    f1 = f_m1+f_p1;
    
    mf1(n)=max(f1);



    % plot(x,f1, x,f_p1, x, f_m1, x, f0); hold on;
    % legend({'Total', 'Heaviside part', 'Another part', 'Transmission formula'},'Location','SW');
    % line([x0,x0],[min(f1), max(f1)], 'Color', 'black')
    % axis([min(x) max(x) min(f) max(f)])


    if n==70,

        figure

        plot(x,f1,'r', x, f0,'b'); 
%         grid on;
        xlabel('Глубина, мм');
        title('Плотность потока фотонов');
        legend({'Emission', 'Transmission'},'Location','Best');
        line([x00,x00],[min(f1), max(f1)], 'Color', 'black')
        axis([min(x) max(x) min(f1) max(f1)])

    end; % if

end
        figure
        plot(x0,mf1,'b');
%         grid on;
        xlabel('Глубина, мм');
        title('Максимум плотности потока фотонов');
