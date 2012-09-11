function XK_1 = My_ART2(DET, XK, R, tau)
%P      - ��������� �� �����:
%.AP - ��������� �����������
%.DZ - ���������� ����� ����������� � ���������
%.D  - ������ ������ ��������
%.d  - ������ ������ �����������
%.L  - ���������� �� ��������� �� �����������
%DET    - ��������� ���������
%R      - (0 - � ����� ������)(1 - �� ��� ������)
%
%XK     - �-� �����������
%XK_1   - �+1-� �����������

global CA
%%
%0) ����������

P.AP = CA.MRAP;
P.DZ = CA.DZ;
P.D = CA.ASX;
P.d = CA.DX0;
P.L = CA.HL;

Dd = CA.SID;
X2 = XK;
f = CA.F;
%%
%����������� ����������� ����������
NPL   = length(DET); % ���-�� ����������
[M,N] = size(XK{1}); % ����������� ���������
XK=zeros(M,N,NPL);
for i=1:NPL
    XK(:,:,i) = X2{i};
end
%%
%��������� ������ �����������
%  h1 = waitbar(0,'Calculation');
% ttt  = NPL*M*N;
for         K=1:NPL
%             waitbar(K/NPL,h,['Plane: ', num2str(K), ' of ', num2str(NPL)]);
    Y = DET{K};
    disp(['MOP: ', num2str(K)])
    for     i=1:M
        for     j=1:N
%             waitbar(((K-1)*M*N+N*(i-1)+j)/ttt, h1,'MOP');
            %0) ����������� ��������� ������ ������ ���������
            AI = New_Source(i, j, NPL, K, R);
            %                 figure(22)
            %                 imagesc(AI{1})
            
            ai=0;aix=0;
            for KK=1:NPL
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
                    Z_Ya = P.DZ*(KK-K)+P.D*P.L/(P.D-P.d)-P.L;
                    %                            S = Take_S(X_Ya,Y_Ya,Z_Ya,P, i,j)
%                     S = Shadow_2M(X_Ya,Y_Ya,Z_Ya,1,P.L,P.AP,M,N,P.d,P.D,0);
%                     ss = S(i,j);
                    ss = Shadow_2MM_IJ(X_Ya,Y_Ya,Z_Ya,P.L,P.AP,M,N,P.d,P.D,i,j);
                    BI(II(ind),JJ(ind)) = ss;
                    ai = ai+ss*ss;
                    aix = aix+ss*xkk(II(ind),JJ(ind));
                    %                             if isnan(aix) disp([X_Ya Y_Ya Z_Ya aaa xkk(ii,jj) S(i,j)]);pause; end
                    %                          end
                    %                     end
                end
                AB(:,:,KK)=BI;
            end
            
            
            %�������
            yi = Y(i,j);
            a = (yi - aix)/(ai);
            
            for ii = 1:NPL
                XK(:,:,ii) = XK(:,:,ii)+((f-P.DZ*(ii-K))^2)/f/f*tau*a*AB(:,:,ii);%.*mat;
                XK(XK<0) = 0;
            end
        end
    end
end
%  close(h1)
XK(XK<0)=0;
XK(XK>1000000)=1000000;
for i=1:NPL
    XK_1{i} = XK(:,:,i);
end