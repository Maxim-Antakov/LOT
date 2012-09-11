function II = My_MNR(DET, RIST0)
NPL   = length(DET);    %определение кол-ва плоскостей
[M,N] = size(DET{1});   %определение размеров детектора
%%
DET1 = getDetector(RIST0);

%%
%Вычисление вспомогательного изображения DET4 для DET1

DET3 = NEW_IM(DET);
DET4 = NEW_IM(DET1);

%%
%Вычисление нового приближения
II = cell(1,NPL);
for i=1:NPL
    D3 = DET3{i};
    D4 = DET4{i};
    II_i = RIST0.SD{i};
    for IX = 1:M
        for IY = 1:N
            if D3(IX,IY)>1.0E-20,
                II_i(IX,IY) = II_i(IX,IY)*D4(IX,IY)/D3(IX,IY);
            end
        end
    end
    II{i} = II_i;
end