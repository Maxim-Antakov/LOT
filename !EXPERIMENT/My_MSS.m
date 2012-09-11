function II = My_MSS(DET, RIST0)
%Params - структура из полей:
    %AP - аппертура коллиматора
    %DZ - рассояние между плоскостями в источнике
    %D  - размер ячейки Дететора
    %d  - размер ячейки коллиматора
    %L  - расстояние от детектора до коллиматора
%DET    - показания детектора
%Rist0  - первое приближение
NPL   = length(DET);    %определение кол-ва плоскостей
[M,N] = size(DET{1});   %определение размеров детектора
%%
global CA;
%Поиск невязки
A_X = getDetector(RIST0);

for i=1:CA.NPL
%    disp([i,size(A_X{i})])
%    disp([i,size(DET{i})])
    R_M{i} = -DET{i}+A_X{i};
end
%%
%Поиск АTR
DDX = CA.SID;
DDY = DDX;
h1 = waitbar(0);
ttt  = CA.NPL*CA.M*CA.N;
ATR = cell(1,CA.NPL);
for k =         1:CA.NPL %По плоскостям
    ATR_M = zeros(M,N);
    for i =     1:M
        for j = 1:N
            waitbar(((k-1)*CA.M*CA.N+CA.N*(i-1)+j)/ttt, h1,'MSS');
            %Получение тени на детекторе от источника в положении (i, j, k)
            a=0;
            for kk = 1:NPL
                x = (j-1)*DDX+DDX/2;
                y = (M-i)*DDY+DDY/2;
                z = RIST0.DZ*(k-kk)+CA.HL; 
                Inten = 1;
                DET0 = Shadow_2M(x,y,z,Inten,M,N);
                a = a+sum(sum(DET0.*R_M{kk}));
            end
            ATR_M(i,j) = a;
        end
    end
    ATR{k} = ATR_M;
end
close(h1)
%%
%Нахождение AATR
tempSI.N = CA.N;
tempSI.M = CA.M;
tempSI.NPL = CA.NPL;
tempSI.DZ = CA.HL/(CA.NPL);
tempSI.SD = ATR;
AATR = getDetector(tempSI);
%%
%Поиск норм 
norm_atr  = 0;
norm_aatr = 0;
for i=1:CA.NPL
%    disp([i,size(ATR{i})]);
%    disp([i,size(AATR{i})]);
    norm_atr = norm_atr + sum(sum(ATR{i}.*ATR{i}));
    norm_aatr = norm_aatr + sum(sum(AATR{i}.*AATR{i}));
end
%%
%Вычисление добавки и нового приближения
a = norm_atr/norm_aatr;
II = cell(1,CA.NPL);
for i=1:CA.NPL
    II{i} = RIST0.SD{i}-a*ATR{i};
    II{i}(II{i}<0) = 0;
end