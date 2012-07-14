function CRI = compensate(RI, compType)
global CA SO
[NPL, Nx, Ny] = size(RI);
L = CA.SID*(CA.M-1/2);
x = linspace(0,L,Nx);

global beta M I0
sqb = sqrt(1-beta^2);
A = (1-sqb)/(1+sqb);
I1 = I0/(exp(M*sqb*L)-A*exp(-M*sqb*L));
I = I1*(exp(M*sqb*(L-x))-A*exp(-M*sqb*(L-x)));

COMP_X = repmat(I,[NPL,1,Ny]);
cz = (exp(M*sqb*SO.Z)-A*exp(-M*sqb*SO.Z))/(1-A);
COMP_Z = repmat(cz',[1, Nx]);
COMP_Z = repmat(COMP_Z,[1, 1, Ny]);

CRI = RI;
    switch compType
        case 'z'
            disp('Compensate Z')
            CRI = RI.*COMP_Z/I0; %FIXIT: dont sure that it is correct
        case 'x'
            disp('Compensate X')
            CRI = RI./COMP_X;
        case 'b'
            disp('Compensate Z and X')
            CRI = RI./COMP_X.*COMP_Z;
        otherwise
            disp('No compensate')
    end