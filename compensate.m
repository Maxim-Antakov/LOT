function CRI = compensate(RI, compType)
global CA SO
[NPL, Nx, Ny] = size(RI);
L = CA.SID*(CA.M-1/2);
x = linspace(0,L,Nx);

sqb = sqrt(1-SO.beta^2);
A = (1-sqb)/(1+sqb);
I1 = SO.I0/(exp(SO.MU0*sqb*L)-A*exp(-SO.MU0*sqb*L));
I = I1*(exp(SO.MU0*sqb*(L-x))-A*exp(-SO.MU0*sqb*(L-x)));

COMP_X = repmat(I,[NPL,1,Ny]);
cz = (exp(SO.MU*sqb*SO.Z)-A*exp(-SO.MU*sqb*SO.Z))/(1-A);
COMP_Z = repmat(cz',[1, Nx]);
COMP_Z = repmat(COMP_Z,[1, 1, Ny]);

CRI = RI;
    switch compType
        case 'z'
            disp('Compensate Z')
            CRI = RI.*COMP_Z/SO.I0; %FIXIT: dont sure that it is correct
        case 'x'
            disp('Compensate X')
            CRI = RI./COMP_X;
        case 'b'
            disp('Compensate Z and X')
            CRI = RI./COMP_X.*COMP_Z;
        otherwise
            disp('No compensate')
    end