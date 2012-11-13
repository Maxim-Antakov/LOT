% Function 2D plot UPI solution
function varargout = UPI2D(varargin) 
%% Setting geomety and medium params
W = 100;
H = 100;
X0 = 50;
Y0 = 50;
beta = 0.95;
mu = 0.1;
Nx = 200;
Ny = 200;
%% Useful params
x = linspace(0,W,Nx);
y = linspace(0,H,Ny);
% y = H/2;
Sol = zeros(Nx, Ny);
% figure(3);
% plot(X0,Y0,'*k'); hold on;
for i=1:Nx
    for j=1:Ny
%          plot(x(i), y(j),'*b');
        A = cross_border(X0, Y0, x(i), y(j), H, W); 
%         disp(A)
%          plot(A(1),A(2),'or',A(3),A(4),'og');
        Sol(i, j) = UPISolve(X0,Y0,A(1),A(2),x(i),y(j),beta,mu,x(i),y(j));
    end
end
figure (1)
surf(Sol)
figure (2)
imagesc(Sol)
end

function CR = cross_border(x0, y0, x1, y1, H, W)
omega_x = x1 - x0;
omega_y = y1 - y0;
if omega_y == 0
    if x0 > x
        CR = [W,y0,0,y0];
    else
        CR = [0,y0,W,y0];
    end
    return;
else
    tb_x = x0 + (H - y0)*omega_x/omega_y;
    bb_x = x0 - y0*omega_x/omega_y;
end
if omega_x == 0
    if y0 > y
        CR = [x0,0,x0,H];
    else
        CR = [x0,H,x0,0];
    end
    return
else
    lb_y = y0 - x0*omega_y/omega_x;
    rb_y = y0 + (W - x0)*omega_y/omega_x;
end
if tb_x > W 
    x2 = W;
    y2 = rb_y;
elseif tb_x<0
    x2 = 0;
    y2 = lb_y;
else
    x2 = tb_x;
    y2 = H;
end

if bb_x > W
    x3 = W;
    y3 = rb_y;
elseif bb_x<0
    x3 = 0;
    y3 = lb_y;
else
    x3 = bb_x;
    y3 = 0;
end

tmp_x = (x2 - x0) / abs(x2 - x0);
tmp_y = (y2 - y0) / abs(y2 - y0);
tmp_x0 = omega_x / abs(omega_x);
tmp_y0 = omega_y / abs(omega_y);
if (tmp_x == tmp_x0) && (tmp_y == tmp_y0)
    CR = [x3,y3,x2,y2];
else
    CR = [x2,y2,x3,y3];
end
end

function V = UPISolve(x0,y0,x1,y1,x2,y2,beta,mu,x,y)
k = mu*sqrt(1-beta*beta);
b = mu*(1+beta);
l2 = sqrt((x2-x1)^2+(y2-y1)^2);
l1 = 0;
l0 = sqrt((x0-x1)^2+(y0-y1)^2);
l = sqrt((x-x1)^2+(y-y1)^2);
divis = k*cosh(k*(l2-l1))+mu*sinh(k*(l2-l1));

mn1 = (b-mu)*cosh(k*(l2-l0))+(-k+b*mu/k)*sinh(k*(l2-l0));

f_m1 = mn1/divis*sinh(k*(l-l1));

f_p1 = cosh(k*(l-l0)).*(1-b/k*tanh(k*(l-l0)))*(l>l0);

V = f_m1+f_p1;

end