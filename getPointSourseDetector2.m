function S = getPointSourseDetector2(x,y,z,z0)

global CA SO;
sqb = sqrt(1-SO.beta^2);
A = (1-sqb)/(1+sqb);

r = CA.ASX/2;
vL = CA.HL;
az = (z+vL)/(z);

R = CA.DX0*az/2;

X_SH = (x+(CA.PSA_AX-x)*az);
Y_SH = (y+(CA.PSA_AY-y)*az);

DDD = (X_SH-CA.PSA_X).^2+(Y_SH-CA.PSA_Y).^2;

[I, J] =  find(DDD<(R+r)^2);
op = length(I);

R = max(R,r);
r = min(R,r);
r2 = r*r;
R2 = R*R;
S = zeros(1, CA.M*CA.N);

for index = 1:op
    j = J(index);
    k = I(index);
    d = sqrt(DDD(k,j));
    if R>=(r+d)
        add = r2*pi;
    else
        x1=(d*d-r2+R2)/2/d;
        ug1=2*acos(x1/R);
        ug2=2*acos((d-x1)/r);
        y1 = x1*tan(ug1/2);
        S1=R2*ug1/2-x1*y1;
        S2=r2*ug2/2-(d-x1)*y1;
        add = S1+S2;
    end;
    if CA.JMU,
        xm0 = CA.XY_DET(1,k);
        ym0 = CA.XY_DET(2,k);
        xv = z0*(xm0-x)/z+x;
        yv = z0*(ym0-y)/z+y;
        if z0==0
            ll = 0;
        else
%             ll=z0;
            ll = sqrt((x-xv)^2+(y-yv)^2+z0^2); % FIXIT
        end
        mu = (1-A)/(exp(SO.MU*sqb*ll)-A*exp(-SO.MU*sqb*ll));
    else       mu = 1;
    end
    S(k)=S(k)+CA.PSA_AV(k,j)*add*mu;
end
S = reshape(S, CA.M, CA.N);
S = S/4/pi/(z+vL)/(z+vL);