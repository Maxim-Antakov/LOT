function activate
global LO % Luminofor concentration
global SO % Source object
global CA
SO.NPL = LO.NPL;
SO.Z = LO.Z;
[~, Nx,Ny] = size(LO.SD);
L = CA.SID*(CA.M-1/2);
x = linspace(0,L,Nx);

sqb = sqrt(1-SO.beta^2);
A = (1-sqb)/(1+sqb);
I1 = SO.I0/(exp(SO.MU*sqb*L)-A*exp(-SO.MU*sqb*L));
I = I1*(exp(SO.MU*sqb*(L-x))-A*exp(-SO.MU*sqb*(L-x)));

if SO.Act_Type == 2
    I = I + fliplr(I);
end
Iyz = repmat(I,[LO.NPL,1,Ny]);
SO.SD = LO.SD.*Iyz;