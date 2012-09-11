function Errs = getError(Ist, Pr)
global CA
N1 = CA.NPL;
D = zeros(1,N1);
R = zeros(1,N1);
E = zeros(1,N1);
for i=1:N1
    size(Ist.SD{i})
    size(Pr{i})
    A=Ist.SD{i}-Pr{i};
    D(i) = (sum(sum(A.*A))/(CA.M*CA.N))^0.5;
    R(i) = sum(sum(abs(A)))/(CA.M*CA.N);
    E(i) = max(max(abs(A)));
end
Errs.D = D;
Errs.R = R;
Errs.E = E;

Errs.mD = mean(D);
Errs.mR = mean(R);
Errs.mE = mean(E);