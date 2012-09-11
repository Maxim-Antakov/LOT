function DRIST = NEW_IM(DET)
global CA
DDX = CA.SID;
DDY = DDX;
NPL   = length(DET);    %определение кол-ва плоскостей
% disp(NPL)
[M,N] = size(DET{1});   %определение размеров детектора
work = zeros(1,NPL);
for JLR=1:NPL
    work(JLR)=max(max(DET{JLR}));
end
R = 1.E-6;
work = work*R;
XX = ((1:N)-1)*DDX+DDX/2;
YY = (M-(1:M))*DDY+DDY/2;
DRIST = cell(1, NPL);
for JLR=1:NPL
    for JX=1:M
        for JY=1:N
            x = XX(JY);
            y = YY(JX);
            S=0;
            for JDL=1:NPL
                z = -1*CA.DZ*(JLR-JDL)+CA.HL; 
                DET0 = getPointSourseDetector(x,y,z,0);
                DT = DET{JDL};
                DT(DT<=work(JDL)) = work(JDL);
                a = DET0./DT;
                S = S+sum(sum(a));
            end
            DRIST{JLR}(JX,JY)=S;
        end
    end
end
% i=1:NPL;
% disp(Params.DZ*(1-i)+FL - Params.L);
% disp(Params.DZ*(2-i)+FL - Params.L);
% disp(Params.DZ*(3-i)+FL - Params.L);
