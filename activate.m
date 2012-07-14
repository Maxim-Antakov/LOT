function activate
global LO % Luminofor concentration
global SO % Source object
global CA
SO.NPL = LO.NPL;
SO.Z = LO.Z;
[~, Nx,Ny] = size(LO.SD);
L = CA.SID*(CA.M-1/2);
x = linspace(0,L,Nx);

global beta M I0
sqb = sqrt(1-beta^2);
A = (1-sqb)/(1+sqb);
I1 = I0/(exp(M*sqb*L)-A*exp(-M*sqb*L));
I = I1*(exp(M*sqb*(L-x))-A*exp(-M*sqb*(L-x)));
% I = I + fliplr(I);
Iyz = repmat(I,[LO.NPL,1,Ny]);
SO.SD = LO.SD.*Iyz;