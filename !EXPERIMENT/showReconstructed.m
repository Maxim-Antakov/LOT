function showReconstructed(X2, SI, figID)
figure(figID)
global CA
NPL = length(X2);
m=max(max(SI.SD{1}));
for i=1:NPL
    m(i)=max(max(SI.SD{i}));
end
m=max(m);
clims = [0 m];

Er = getError(SI, X2);
nok = SI.NPL*CA.NPL/gcd(SI.NPL,CA.NPL);
sid = nok/SI.NPL;
sic = nok/CA.NPL;
for i = 1:SI.NPL
    h = subplot(2,nok,[((i-1)*sid+1):(i*sid)]);
    if CA.PSTT~='H'
        imagesc(SI.SD{i},clims);
    else
        drawHex(SI.SD{i}, CA.ASX, h, '')
    end
    
    axis off
    axis equal
    title(['Real plane ', num2str(i), ])
end
for i=1:CA.NPL
    h = subplot(2,nok,[((i-1)*sic+nok+1):(i*sic+nok)]);
    if CA.PSTT~='H'
%         imagesc(X2{i},clims);
        imagesc(X2{i});
    else
        drawHex(X2{i}, CA.ASX, h, '')
    end
    axis off
    axis equal
    title({['Reconstructed plane ', num2str(i)],['D = ', num2str(Er.D(i)),'; R = ', num2str(Er.R(i)),'; E = ', num2str(Er.E(i))]})
end

