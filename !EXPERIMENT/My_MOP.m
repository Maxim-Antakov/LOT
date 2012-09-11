function XK_1 = My_MOP(DET, XK, tau, R)
global CA
Dd = CA.SID;
X2 = XK.SD;
f = CA.F;

%%
%Определение необходимых параметров
% NPL   = length(DET); % Кол-во плоскостей
[M,N] = size(DET{1}); % Размерность детектора
XK=zeros(M,N,CA.NPL);
for i=1:CA.NPL
    XK(:,:,i) = X2{i};
end
%%
%Получение нового приближения
% multiWaitbar('MOP',0);
% ttt  = NPL*M*N;
for         K=1:CA.NPL
% multiWaitbar('MOP',K/CA.NPL);
    Y = DET{K};
%     disp(['MOP: ', num2str(K)])
    for     i=1:M
        for     j=1:N
%             waitbar(((K-1)*M*N+N*(i-1)+j)/ttt, h1,'MOP');
            %0) Определение координат центра ячейки детектора
            AI = New_Source(i, j, CA.NPL, K, R);
            %                 figure(22)
            %                 imagesc(AI{1})
            
            ai=0;aix=0;
            for KK=1:CA.NPL
                xkk = XK(:,:,KK);
%                 aii = AI{KK};
                %                     disp(sum(sum(aii)))
                BI=zeros(M,N);
                [II, JJ] = find(AI{KK});
                for ind = 1:length(II)
                    
                    %                     for ii = 1:M
                    %                     for jj = 1:N
                    %                          if aii(ii,jj)~=0
                    X_Ya = Dd/2+Dd*(JJ(ind)-1);
                    Y_Ya = Dd/2+Dd*(M-II(ind));
                    Z_Ya = CA.DZ*(KK-K)+CA.F-CA.HL;
                    %                            S = Take_S(X_Ya,Y_Ya,Z_Ya,P, i,j)
%                     S = Shadow_2M(X_Ya,Y_Ya,Z_Ya,1,P.L,P.AP,M,N,P.d,P.D,0);
%                     ss = S(i,j);
                    ss = Shadow_2MM_IJ(X_Ya,Y_Ya,Z_Ya,CA.HL,CA.MRAP,M,N,CA.DX0,CA.ASX,i,j);
                    BI(II(ind),JJ(ind)) = ss;
                    ai = ai+ss*ss;
                    aix = aix+ss*xkk(II(ind),JJ(ind));
                    %                             if isnan(aix) disp([X_Ya Y_Ya Z_Ya aaa xkk(ii,jj) S(i,j)]);pause; end
                    %                          end
                    %                     end
                end
                AB(:,:,KK)=BI;
            end
            
            
            %невязка
            yi = Y(i,j);
            a = (yi - aix)/(ai);
%             XK = XK + a*AB;
%             XK(XK<0) = 0;
            for ii = 1:CA.NPL
                XK(:,:,ii) = XK(:,:,ii)+((f+CA.DZ*(ii-K))^2)/f/f*tau*a*AB(:,:,ii);%.*mat;
%                 XK(:,:,ii) = XK(:,:,ii)+a*AB(:,:,ii);%.*mat;
                XK(XK<0) = 0;
            end
        end
    end
end
%  close(h1)
XK(XK<0)=0;
% XK(XK>1000000)=1000000;
for i=1:CA.NPL
    XK_1{i} = XK(:,:,i);
end
% multiWaitbar('MOP','Close');