function s = Shadow_2MM_IJ(x,y,z,L,Kol,M,N,d,D,iii,jjj)
%x, y, z - координаты источника (0,0) - координата начала детектора
%z=0 - соответствует плоскости коллиматора
% s = 0;
[m,n] = size(Kol);
x_k = (D*N-d*n)/2;%
y_k = (D*M-d*m)/2;
% f=D*L/(D-d);
z=z+L;
I_4pi = 1/pi/4;
X_ya1 = x_k+d*(0:n-1);
X_ya2 = X_ya1+d;
Y_ya1 = y_k+d*(m-1:-1:0);
Y_ya2 = Y_ya1+d;
d_1 = 1/D;
z2_1 = 1/(z*z);
ZL = z*d_1/(z-L);
X1 = (X_ya1-x)*ZL+x*d_1;
X2 = (X_ya2-x)*ZL+x*d_1;
Y1 = (Y_ya1-y)*ZL+y*d_1;
Y2 = (Y_ya2-y)*ZL+y*d_1;

%disp(['Координаты источника: ', num2str([x, y])])
%disp(['Координаты начала коллиматора: ', num2str([x_k, y_k])]);

xx = (X1<=jjj).*(X2>=jjj-1);
yy = (Y2>=M-iii).*(Y1<=M-iii+1);
X1(X1<jjj-1)=jjj-1;
X2(X2>jjj)=jjj;
Y1(Y1<M-iii)=M-iii;
Y2(Y2>M-iii+1)=M-iii+1;
xx12 = (X2-X1).*xx;
yy12 = (Y2-Y1).*yy;
f1 = yy12'*xx12;
s = sum(sum(f1.*Kol))*D*D*I_4pi*z2_1;
