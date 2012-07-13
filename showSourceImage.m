function [] = showSourceImage(SI, figID)
global CA
figure(figID)
for i = 1:SI.NPL
    h = subplot(1,SI.NPL,i);
    if CA.PSTT~='H'
        imagesc(SI.SD{i});
    else
        drawHex(SI.SD{i}, CA.SID, h, '')
    end
    axis off
    axis equal
    title(['Plate ', num2str(i)])
end

