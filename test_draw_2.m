close all
clear all

figure
cmap = bone(32);
load test_draw.mat
subplot(1,2,1);
LO.SD(LO.SD==0)=NaN;
hpat = PATCH_3Darray(LO.SD,1:20,1:40,1:40,cmap,'col');

subplot(1,2,2);
load test_draw2.mat
LO.SD(LO.SD==0)=NaN;
hpat = PATCH_3Darray(LO.SD,1:20,1:40,1:40,cmap,'col');
