function DET = getDetector2(PL, z0)
global CA 

DET = zeros(size(PL));
[I, J] = find(PL~=0);
N = length(I);
z = CA.F-CA.HL;
for i=1:N
    x = (J(i) - 1) * CA.SID + CA.SID/2;
    y = (CA.M - I(i)) * CA.SID + CA.SID/2;
    a = PL(I(i),J(i));
    DET = DET+a*getPointSourseDetector2(x,y,z, z0); 
end
