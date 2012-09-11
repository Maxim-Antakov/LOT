function AI = New_Source(x, y, NPL, K, R)
%P      - ��������� �� �����:
    %.AP - ��������� �����������
    %.DZ - ���������� ����� ����������� � ���������
    %.D  - ������ ������ ��������
    %.d  - ������ ������ �����������
    %.L  - ���������� �� ��������� �� �����������
    
%x, y    - ������� ������ �����������
%NPL     - ���������� ���������� � ���������
%K       - ����� ���������
%R      - (0 - � ����� ������)(1 - �� ��� ������)

%AI      - ����� ������ AI
global CA
%%
%0) ����������
AI = cell(NPL,1);
AP = CA.MRAP;
DZ = CA.DZ;
D = CA.ASX;
d = CA.DX0;
L = CA.HL;
[M,N] = size(AP);  % ����������� ���������.
m=(M+1)/2;n=(N+1)/2; % ����������� ���������.
for i=1:NPL 
    AI{i} = zeros(m,n);
end
dk_x = (D*n-d*N)/2;  % ���������
dk_y = (D*m-d*M)/2;
Dd = D*d/(D-d); % ������ ������ ���������

%���������� ����� ������ ���������
x_ya1 = (y-1)*D+(1-R)*D/2;
x_ya2 = y*D-(1-R)*D/2;
y_ya1 = (m-x+1)*D-(1-R)*D/2;
y_ya2 = (m-x)*D+(1-R)*D/2;
% disp(['Detektor: ',num2str([x_ya1, x_ya2,y_ya1,y_ya2])])
%������� ��������� ������� ����� ����������
X_D = Dd/2+Dd*[0:n-1];
Y_D = Dd/2+Dd*[m-1:-1:0];
% disp(['�������� �: ', num2str(X_D)])
% disp(['�������� Y: ', num2str(Y_D)])
%������ ��������� ���������� ���������� � �-� ���������
%Z=D*L/(D-d)+DZ*[(1-K):(NPL-K)];
% X_K1 = dk_x+d*[0:N-1];%(j-1)
% X_K2 = dk_x+d*[1:N];%(j-1)
% Y_K1 = dk_y+d*[M:-1:1];%(j-1)
% Y_K2 = dk_y+d*[M-1:-1:0];%(j-1)

X1 = (D*L/(D-d)+DZ*((1-K):(NPL-K)))'*(dk_x+d*(0:N-1)-x_ya2)/L+x_ya2;
Y1 = (D*L/(D-d)+DZ*((1-K):(NPL-K)))'*(dk_y+d*(M:-1:1)-y_ya2)/L+y_ya2;
X2 = (D*L/(D-d)+DZ*((1-K):(NPL-K)))'*(dk_x+d*(1:N)-x_ya1)/L+x_ya1;
Y2 = (D*L/(D-d)+DZ*((1-K):(NPL-K)))'*(dk_y+d*(M-1:-1:0)-y_ya1)/L+y_ya1;

%%
%1) ������ �� ���������

[II,JJ] = find(AP);
for ind = 1:length(II)
i = II(ind);
j = JJ(ind);

% for i=1:M
% for j=1:N
% if AP(i,j)==1 %�������� ������
    %����������� ��������� ��������� �������
%          x_K1 = dk_x+d*(j-1);
%          x_K2 = dk_x+d*j;
%          y_K1 = dk_y+d*(M-i+1);
%          y_K2 = dk_y+d*(M-i);
%           disp(['������: ',num2str([x_K1, x_K2,y_K1,y_K2])])
    %������ �� ���������� ����������
    for k=1:NPL
        %��������� ������ �� ������� (i,j)
%                 x1 = Z(k)*(X_K2(j)-x_ya2)/(L)+x_ya2;
%                 y1 = Z(k)*(Y_K1(i)-y_ya2)/(L)+y_ya2;
%                 x2 = Z(k)*(X_K2(j+1)-x_ya1)/(L)+x_ya1;
%                 y2 = Z(k)*(Y_K1(i+1)-y_ya1)/(L)+y_ya1;


        %��������� �������� ������� �����
            ix = (X_D>X1(k,j)).*(X_D<X2(k,j));
            iy = (Y_D>Y2(k,i)).*(Y_D<Y1(k,i));
            xy = (ix'*iy);

            AI{k} = AI{k}+xy';
%             apap = zeros(M,N);apap(i,j)=1;
%             S = Shadow_2M(y_ya1,x_ya1,L,1,Z(k)-L,apap,m,n,d,D,0);
%             AI{k} = AI{k}+S;
%      end
%  end
     end
end