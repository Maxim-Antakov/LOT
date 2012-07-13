function IST = image2matrix(SI)
global CA
IST=[];
z = CA.F - CA.HL+SI.DZ*(0:SI.NPL-1);

for i=1:SI.NPL
    PL = SI.SD{i};
    [m n] = size(PL);
    for ii=1:m
        for jj=1:n
            if PL(ii,jj)~=0
                x = (jj - 1) * CA.SID + CA.SID/2;
                y = (CA.M - ii) * CA.SID + CA.SID/2;
                a=[x y z(i) PL(ii,jj)];
                IST = [IST;a];
            end
        end
    end
end
