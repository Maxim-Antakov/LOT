close all
clear all
clc
profile on
multiWaitbar('CLOSEALL');
multiWaitbar('Total progress', 0);
%% create aperture
global CA
CA.M = 41;
CA.N = 41;
CA.R = 5; % Rank for hexs
CA.ASX = 2;
CA.ASY = 2;
CA.DX = 1;
CA.DY = 1;
CA.DX0 = 1; % Real open size of pinhole
CA.DY0 = 1;
CA.HL = 10;
CA.NPL = 26;
CA.RASP = 1;
% CA.VKLR = [121 40 13 0];
% CA.VKLR = [121 81 13 0];
CA.VKLR = [400 57 8 CA.M*CA.N/400-1];
% CA.VKLR = [3 2 1 22*21/3-1];
% CA.VKLR = [15 7 3 0];
%  CA.VKLR = [7 4 3 1 6];
% CA.VKLR = [7 3 1 7];
% CA.VKLR = [91 10 1 0];
% CA.VKLR = [4 3 2 CA.M*CA.N/4-1];

CA.VKLR2 = [4 3 2 1];
% CA.VKLR2 = [7 4 3 1 0];
CA.PSTT = '1'; % "H" for hexs; "1" - for one-pinhole
CA.JMU = 1;
CA.IC3 = 0;
createAperture;
%
%% create Luminofor object
global LO

LO.ID = 3;
LO.NPL = CA.NPL;
j=1;
for i=1:LO.NPL
    n = ceil(10*rand(1));
    for k = 1:n
        LO.PSC(j).z = i;
        LO.PSC(j).x = ceil((CA.M-1)*rand(1));
        LO.PSC(j).y = ceil((CA.M-1)*rand(1));
        j = j+1;
    end
end
createSourceImage;
save('test_draw.mat','LO')

%% create Activated object
global SO
SO.I0 = 1000;
SO.beta = 0.95;
SO.MU = 0.615;
SO.MU0 = 0.15;
SO.Act_Type = 1;
activate;
multiWaitbar('Total progress', 1/3);
%
%% make convolution matrix's array
%todo : make separate convolution matrixes for each focal plane position
%       inside object

global Kleshe
CA.JMU = 0;
Kleshe = createKleshe;
CA.JMU  = 1;
%% simulate Reconstruction
multiWaitbar('Total progress', 2/3);
multiWaitbar('Z scan',0, 'Color', [0.6 0.2 0.2])
RI = zeros(CA.NPL,CA.N,CA.M);
for i = 1:SO.NPL
    multiWaitbar('Z scan',i/SO.NPL)
    multiWaitbar('Y scan',0, 'Color', [0.2 0.2 0.6])
    for m = 1:CA.M
        multiWaitbar('Y scan',m/CA.M);
        tempSO = zeros(size(squeeze(SO.SD(i,:,:))));
        tempSO((CA.RASP*(m-1)+1):CA.RASP*m,:) = SO.SD(i,(CA.RASP*(m-1)+1):CA.RASP*m,:);
        tempDET = getDetector2(tempSO,SO.Z(i));
        tempRI = restore(tempDET);
        RI(i,m,:) = tempRI(m,:);
    end
    multiWaitbar( 'Y scan', 'Close' )
end
multiWaitbar( 'Z scan', 'Close' )
multiWaitbar('Total progress', 1);
profile off
profile viewer
%% compensation
CRI = compensate(RI,'b');
multiWaitbar('CLOSEALL');

%% count error
% ER = sqrt((RI - SO.SD).^2);

%% draw all
showAperture(1,'Aperture')
% showSourceImage(LO, 2,'Luminophore concentration');
% showSourceImage(SO,3,'Luminophore activity');
% showReconstructed(RI, SO, 5, 'Luminophore activity');
% showReconstructed(CRI, LO, 6, 'Luminophore activity compensated');
SliceBrowser(LO.SD,'Luminophore concentration');
SliceBrowser(SO.SD,'Luminophore activity');
SliceBrowser(RI, 'Luminophore activity reconstructed');
SliceBrowser(CRI, 'Luminophore activity compensated');
% SliceBrowser(ER, 'Deviation');
save('test_draw2.mat','RI')
