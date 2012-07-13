function CRI = compensate(RI)
global CA SO
[Nx,Ny] = size(RI{1});
L = CA.SID*(CA.M-1/2);
x = linspace(0,L,Nx);

global beta M I0
sqb = sqrt(1-beta^2);
A = (1-sqb)/(1+sqb);
I1 = I0/(exp(M*sqb*L)-A*exp(-M*sqb*L));
I = I1*(exp(M*sqb*(L-x))-A*exp(-M*sqb*(L-x)));

COMP_X = repmat(I,[Ny,1]);
COMP_Z = (exp(M*sqb*SO.Z)-A*exp(-M*sqb*SO.Z))/(1-A);

for i=1:SO.NPL
    CRI{i} = RI{i}*COMP_Z(i);
    CRI{i} = CRI{i}./COMP_X;
end