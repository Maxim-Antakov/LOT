function [] = showDetector(DET, figID)
global CA
figure(figID)
NPL = length(DET);
for i = 1:NPL
    h = subplot(1,NPL,i);
    if CA.PSTT~='H'
        imagesc(DET{i});
    else
        drawHex(DET{i}, CA.ASX, h, '')
    end
    axis off
    axis equal
    title(['Measurement ', num2str(i)])
end

