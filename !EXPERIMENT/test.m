close all
clear all
clc

global CA
global XY_Det X_d Y_d  X_d1 Y_d1 XY_FP
% if use hex's make M=N=40
CA.M = 20;
CA.N = 20;
CA.R = 5; % Rank for hexs
CA.ASX = 2;
CA.ASY = 2;
CA.DX = 1;
CA.DY = 1;
CA.DX0 = 1; % Real open size of pinhole
CA.DY0 = 1;
CA.HL = 5;
CA.NPL = 1;
CA.VKLR = [121 40 13 0];
 CA.VKLR = [400 57 8 0];

CA.VKLR2 = [4 3 2 1];
% CA.VKLR2 = [7 4 3 1 0];
CA.PSTT = 'P'; % "H" for hexs
CA.JMU = 0;
CA.IC3 = 0;
createAperture;
showAperture(1)
SI.ID = 1;
SI.NPL = CA.NPL;
SI = createSourceImage(SI);
%% Read detector
DET = gatherDET('DATA\out.jpg');
% imagesc(nR)
showDetector(DET, 3)
global Kleshe
CA.JMU = 0;
Kleshe = createKleshe;

X2 = cell(1,CA.NPL);
for i=1:CA.NPL
    X2{i} = restore(DET{i});
end
showReconstructed(X2, SI, 4)

%% Start iterations
IA.Type = 'mop';
IA.NITER = 10;
IA.R = 1;
tau = 1+1./(1:IA.NITER);

    ee = getError(SI, X2);
    disp(['E0 = ', num2str(ee.mE), '; D0 = ', num2str(ee.mD), '; R0 = ', num2str(ee.mR)])

% if strcmp(IA.Type,'mnr')
%     for i=1:SI.NPL
%        x2 = X2{i};
%        x2(x2==0) = 0.1*sum(sum(x2))/numel(x2);
%        X2{i} = x2;
%     end
%     ee = getError(SI, X2);
%     disp(['E00 = ', num2str(ee.mE), '; D00 = ', num2str(ee.mD), '; R00 = ', num2str(ee.mR)])
% end
% profile on
% multiWaitbar('Iterations',0, 'Color', [0.2 0.6 0.2]);
for k=1:IA.NITER
%     multiWaitbar('Iterations',k/IA.NITER);
    IA.tau = tau(k);
    X2  = makeNextIteration(DET, X2, IA);
    showReconstructed(X2, SI, 23);
    ee = getError(SI, X2);
    disp(['E = ', num2str(ee.mE), '; D = ', num2str(ee.mD), '; R = ', num2str(ee.mR)])
    pause(1)
end
