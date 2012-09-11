function [] = showAperture(figID)
global CA
figure(figID)
if CA.PSPT=='B'
    cmap = [0 0 0
        1 1 1];
else
    cmap = [1 0 0
        0 0 0
        0 1 0];
end
if CA.PSTT~='H'
    subplot(1,2,1);
    imagesc(CA.RAP);
    axis off
    axis equal
    title('Basic rectangular aperture')
    subplot(1,2,2);
    imagesc(CA.MRAP);
    axis off
    axis equal
    
    title('Mosaic rectangular aperture')
else
    h = subplot(1,2,1);
    drawHex(CA.PSP, CA.DX0, h, 'Basic hexagonal aperture');
    axis off
    axis equal
    subplot(1,2,2);
   
    for i=1:length(CA.MRAPall)
        putHex(CA.MRAPall(i,1), CA.MRAPall(i,2), CA.DX0, 0);
    end
    for i=1:length(CA.MRAP)
        putHex(CA.MRAP(i,1), CA.MRAP(i,2), CA.DX0, 1);
    end
    for i=1:length(CA.MRAPmo)
        putHex(CA.MRAPmo(i,1), CA.MRAPmo(i,2), CA.DX0, -1);
    end
     title('Mosaic hexagonal aperture')
    axis off
    axis equal
    
end
colormap(cmap)