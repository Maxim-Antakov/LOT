function X2 = restore(S)
global Kleshe CA
% size(S)
% size(Kleshe{1})
[m,n] = size(S);
%disp([m,n]);
%disp(size(Kleshe{1,2}));
%disp(PST)
%disp(CA.VKLR)
Y = zeros(m,n);
% for i=1:numel(Kleshe)
%     Y(i) = sum(sum(Kleshe{i}.*S));
% end
% if CA.PSTT~='H'
%     Y = reshape(Y,m,n);
% end
for i=1:m
    for j=1:n
        Y(i,j) = sum(sum(Kleshe{i,j}.*S));
    end
end

if (CA.PSTT == 'P' || CA.PSTT == 'D'),     PST = 0;
elseif CA.PSTT == 'S', PST = 2;
elseif CA.PSTT == 'H', PST = 50;
elseif CA.PSTT == '1', PST = 77;
end

if CA.PSPT == 'T',     PST = PST+6;
    if CA.VKLR(5)~=0, PST = PST+30; end
elseif CA.PSPT == 'B',
    if CA.VKLR(4)~=0, PST = PST+30; end
end
% disp(['PST: ', num2str(PST)]);

switch PST
    case {0, 50}
        A = CA.VKLR(2);
        B = CA.VKLR(3);
        C = CA.VKLR(2)*CA.VKLR(2);
        X2 = (Y-sum(sum(Y))*B/C)/(A-B);
    case {6, 36, 56, 86}
        A = CA.VKLR(2);
        X2 = Y/A;
    case {10}
        A = CA.VKLR(1);
        B = CA.VKLR(1)-4*CA.VKLR(2)+4*CA.VKLR(3);
        C = 4*CA.VKLR(2)-4*CA.VKLR(3)+CA.VKLR(1)*(CA.VKLR(1)-4*CA.VKLR(2)+4*CA.VKLR(3));
        X2 = (Y-sum(sum(Y))*B/(C))/(A-B);
    case {2,8}
        A  = CA.VKLR(2)*CA.VKLR2(2);
        Bx = CA.VKLR(2)*CA.VKLR2(3);
        Cy = CA.VKLR2(2)*CA.VKLR2(3);
        D  = CA.VKLR(3)*CA.VKLR2(3);
        Wy = sum(Y);
        Wx = sum(Y,2);
        R  = sum(sum(Y));
        S  = R/(A-Bx-Cy+D+(Bx-D)*CA.VKLR2(1)+(Cy-D)*CA.VKLR(1)+D*CA.VKLR(1)*CA.VKLR2(1));
        Sx = (Wx-(Cy-D+D*CA.VKLR2(1))*S)/(A-Bx-Cy+D+(Bx-D)*CA.VKLR2(1));
        Sy = (Wy-(Bx-D+D*CA.VKLR(1))*S)/(A-Bx-Cy+D+(Cy-D)*CA.VKLR(1));
        Sx = repmat(Sx,[1, n]);
        Sy = repmat(Sy,[m, 1]);
        X2 = (Y-(Bx-D)*Sx-(Cy-D)*Sy-D*S)/(A-Bx-Cy+D);
    case 30
        X2 = zeros(size(Y));
        R1    = 1/(CA.VKLR(2)-CA.VKLR(3));
        R2    = CA.VKLR(3)/(CA.VKLR(2)*CA.VKLR(2)*(CA.VKLR(2)-CA.VKLR(3)));
        nrpsp = CA.VKLR(4)+1;
        rpsp=zeros(1,nrpsp);
        l=m; m=n; n=l;
        for iw = 1:nrpsp
            for jw = 1:CA.VKLR(1)
                J=(jw-1)*nrpsp+iw;
                IX=mod(J-1, m)+1;
                IY=n-fix((J-1)/m);
                rpsp(iw)=rpsp(iw)+Y(IY,m-IX+1);
            end
        end
        for iw     = 1:nrpsp
            for jw = 1:CA.VKLR(1)
                J=(jw-1)*nrpsp+iw;
                IX=mod(J-1, m)+1;
                if PST==30,          IY=n-fix((J-1)/m);
                else                IY=n-mod(J-1,n);
                end
                X2(IY,m-IX+1)=R1*Y(IY,m-IX+1)-R2*rpsp(iw);
            end
        end
    case 32
        nrpsp1 = CA.VKLR(4)+1;
        nrpsp2 = CA.VKLR2(4)+1;
        NX2    = CA.VKLR(1);
        NY2    = CA.VKLR2(1);
        WIST2 = zeros(m,nrpsp2);
        for IX=1:m
            for iwy=1:nrpsp2
                WIST2(IX,iwy)=0;
                for nwy=1:NY2
                    IY = (nwy-1)*nrpsp2+iwy;
                    WIST2(IX, iwy)=WIST2(IX, iwy)+Y(IX,IY);
                end
            end
        end
        for IX=1:m
            for IY=1:n
                WIST2(IX,IY)=WIST2(IX, mod(IY-1, nrpsp2)+1);
            end
        end
        WIST1 = zeros(n,nrpsp1);
        for IY=1:n
            for iwx=1:nrpsp1
                WIST1(iwx, IY)=0;
                for nwx=1:NX2
                    IX = (nwx-1)*nrpsp1+iwx;
                    WIST1(iwx, IY)=WIST1(iwx, IY)+Y(IX,IY);
                end
            end
        end
        for IX=1:m
            for IY=1:n
                WIST1(IX,IY)=WIST1(mod(IX-1, nrpsp1)+1, IY);
            end
        end
        WIST0 = zeros(n,nrpsp1);
        for IY=1:n
            for iwx=1:nrpsp1
                WIST0(iwx, IY)=0;
                for nwx=1:NX2
                    IX = (nwx-1)*nrpsp1+iwx;
                    WIST0(iwx, IY)=WIST0(iwx, IY)+WIST2(IX,IY);
                end
            end
        end
        for IX=1:m
            for IY=1:n
                WIST0(IX,IY)=WIST0(mod(IX-1, nrpsp1)+1, IY);
            end
        end
        
        R1=1/((CA.VKLR(2)-CA.VKLR(3))*(CA.VKLR2(2)-CA.VKLR2(3)));
        R2=1*CA.VKLR(3)/(CA.VKLR(2)*CA.VKLR(2));
        R3=1*CA.VKLR2(3)/(CA.VKLR2(2)*CA.VKLR2(2));
        R=R2*R3;
        X2 = R1*(Y-R2*WIST1-R3*WIST2+R*WIST0);
    case 80
        MBF=eye(CA.VKLR(4)+1);
        for i=1:CA.VKLR(1)
            for j=1:CA.VKLR(1)
                MMBF((i-1)*(CA.VKLR(4)+1)+1:...
                     (i-1)*(CA.VKLR(4)+1)+CA.VKLR(4)+1,...
                 (j-1)*(CA.VKLR(4)+1)+1:(j-1)*(CA.VKLR(4)+1)+CA.VKLR(4)+1)=MBF;
            end
        end
        JJF=MMBF*Y';
        R1    = 1/(CA.VKLR(2)-CA.VKLR(3));
        R2    = R1*CA.VKLR(3)/CA.VKLR(2)^2;
        X2=R1*Y-R2*JJF';
    case 77
        X2 = flipud(fliplr(S));
end
if CA.PSTT~='H'
    X2 = X2*4*pi*CA.F*CA.F/(pi*CA.ASX*CA.ASY/4);
else
    X2 = X2*4*pi*CA.F*CA.F/(pi*CA.ASX^2*3/4);
end
X2(X2<0) = 0;