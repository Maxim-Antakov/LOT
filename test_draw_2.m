close all
clear all

figure
cmap = jet(32);
load test_draw.mat
LO.SD(LO.SD==0)=NaN;
hpat = PATCH_3Darray(LO.SD,1:99,1:99,1:99,cmap,'col');

subplot(1,2,2);
load test_draw2.mat
LO.SD(LO.SD==0)=NaN;
hpat = PATCH_3Darray(LO.SD,1:99,1:99,1:99,cmap,'col');

