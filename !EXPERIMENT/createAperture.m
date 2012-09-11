function [] = createAperture
global CA
CA.PSP  = [];
CA.PSP2 = [];
if length(CA.VKLR)==4
    CA.PSP = readSQD(CA.VKLR);
    CA.PSPT = 'B';
elseif length(CA.VKLR)==5
    CA.PSP = readSQT(CA.VKLR);
    CA.PSPT = 'T';
else
    disp('createApertue: Error! Wrong VLKR size');
end

if CA.PSTT=='S'
    if length(CA.VKLR2)==4
        CA.PSP2 = readSQD(CA.VKLR2);
    elseif length(CA.VKLR)==5
        CA.PSP2 = readSQT(CA.VKLR2);
    else
        disp('createApertue: Error! Wrong VLKR2 size');
    end
end

%% Creating basic aperture
CA.RAP = zeros(CA.M, CA.N);
CA.HAP = zeros(3*CA.R*(CA.R+1), 1);

switch CA.PSTT
    case 'P' % Line-by-line construction method
        for i=1:CA.M
            CA.RAP(i,:) = CA.PSP(CA.N*(i-1)+1:CA.N*i);
        end
    case 'D' %Diagonal construction method
        if CA.M*CA.N==length(CA.PSP)
            i=0;
            j=0;
            for k=1:length(CA.PSP)
                if i==CA.N,    i=1;
                else       i=i+1;
                end
                if j==CA.M,    j=1;
                else       j=j+1;
                end
                CA.RAP(i,j)=CA.PSP(k);
            end
        else
            disp('createApertue: Error! Wrong PSP length');
        end
    case 'S' % Self-supported construction method
        CA.RAP = CA.PSP'*CA.PSP2;
    case 'H' % Hexagonal constructed method
        %% TODO THIS!
    otherwise
        disp('createApertue: Error! Wrong PST type');
end
%% Creating mosaic aperture

switch CA.PSTT
    case 'P' % Line-by-line construction method
        lev  = [CA.RAP;CA.RAP; zeros(1,CA.N)];
        prav = [zeros(1,CA.N);CA.RAP;CA.RAP];
        Nn = [prav, lev];
        CA.MRAP = Nn(2:2*CA.M,1:2*CA.N-1);
    case {'D', 'S'} %Diagonal of self-supported construction method
        NAp = [CA.RAP,CA.RAP];
        NAp = [NAp;NAp];
        CA.MRAP = NAp(1:2*CA.M-1,1:2*CA.N-1);
    case 'H' % Hexagonal constructed method
        Centri=createHEXmosaic;
        if length(CA.VKLR)==4
            CA.MRAP=Centri.open;
            CA.MRAPmo = [];
        elseif length(CA.VKLR)==5
            CA.MRAPmo=Centri.openm;
            CA.MRAP=Centri.openp;
        end
        CA.MRAPall = Centri.all;
    otherwise
        disp('createApertue: Error! Wrong PST type');
end
% CA.MRAP = CA.MRAP';
%% Add open pinhole indexes
[m, n] = size(CA.MRAP);
CA.eN = n;
CA.eM = m;
[M, N] = size(CA.RAP);
x_k = (CA.ASX*N-CA.DX*n)/2;%
y_k = (CA.ASX*M-CA.DX*m)/2;
% CA.X_ya1 = x_k+CA.DX*(0:n-1);
% CA.X_ya2 = CA.X_ya1+CA.DX;
% CA.Y_ya1 = y_k+CA.DX*(m-1:-1:0);
% CA.Y_ya2 = CA.Y_ya1+CA.DX;

[CA.II CA.JJ] = find(CA.MRAP); % Indexes of open pinholes
%% Detector cells centers
x = (0:CA.ASX:(CA.N-1)*CA.ASX)+CA.ASX/2;
y = ((CA.M-1)*CA.ASY:-CA.ASY:0)+CA.ASY/2;
[X, Y] = meshgrid(x,y);

CA.XY_DET(1,:) = reshape(X, 1, CA.M*CA.N);
CA.XY_DET(2,:) = reshape(Y, 1, CA.M*CA.N);
%% Open pinholes cells centers
op = sum(sum(CA.MRAP~=0));
CA.XYV_AP = zeros(op,3);
index = 1;
for i=1:n
    for j=1:m
        if CA.MRAP(j,i)~=0
          CA.XYV_AP(index, 1) = x_k+CA.DX/2+CA.DX*(i-1);
          CA.XYV_AP(index, 2) = y_k+CA.DY/2+CA.DY*(m-j);  
          CA.XYV_AP(index, 3) = CA.MRAP(j,i);
          index = index+1;
        end
    end
end

%% Temporary arrays for PointSourceDetector
CA.PSA_X = repmat(CA.XY_DET(1,:)', 1, op);
CA.PSA_Y = repmat(CA.XY_DET(2,:)', 1, op);

CA.PSA_AX = repmat(CA.XYV_AP(:,1)', CA.M*CA.N, 1);
CA.PSA_AY = repmat(CA.XYV_AP(:,2)', CA.M*CA.N, 1);
CA.PSA_AV = repmat(CA.XYV_AP(:,3)', CA.M*CA.N, 1);

%% Focal properties
CA.SID = CA.ASX*CA.DX/(CA.ASX-CA.DX);
CA.F = CA.SID*CA.HL/CA.DX;
CA.DZ = (CA.F-CA.HL)/(CA.NPL+1);
%% Other
% global XY_Det X_d Y_d  X_d1 Y_d1 XY_FP
% XY_Det = createCenterHex(CA.ASX, CA.R);
% XY_FP = createCenterHex(CA.ASX, CA.R);

% d1 = 0.5*numel(CA.MRAP);
% X_d = repmat(XY_Det(:,1), 1, d1);
% Y_d = repmat(XY_Det(:,2), 1, d1);
% if length(CA.VKLR)==5
%     d2 = 0.5*numel(CA.MRAPmo);
%     X_d1 = repmat(XY_Det(:,1), 1, d2);
%     Y_d1 = repmat(XY_Det(:,2), 1, d2);
% end
