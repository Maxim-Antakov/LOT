function [DET2, Result] = prepare(DET)
global CA
Result = double(0.2989 * DET(:,:,1) + 0.5870 * DET(:,:,2) + 0.1140 * DET(:,:,3));
%     figure
     imagesc(Result); hold on

[M, N] = size(Result);
dx = floor(M/CA.M);
dy = floor(N/CA.N);
DET2 = zeros(CA.M,CA.N);
for i=1:CA.M
    for j=1:CA.N
        line([(i-1)*dx+1 i*dx],[(j-1)*dy (j-1)*dy], 'Color', 'white'); hold on
        line([(i-1)*dx (i-1)*dx],[(j-1)*dy j*dy], 'Color', 'white'); hold on
        s = max(max(Result((1+dx*(i-1)):dx*i,(1+dy*(j-1)):dy*j)));
        DET2(i,j) = s;
    end
end
figure(22)
subplot(1,2,1); imagesc(Result)

% DET = imresize(DET, [11, 11]);
ma = max(max(DET2));
DET2 = round(100*DET2/ma);
% DET2 = round(DET2);
% figure(23)
% DET2(DET2<33) = 0;
% DET2(DET2==100) = 2;
% DET2(DET2>33) = 1;
% imagesc(DET2)
% subplot(1,2,2); imagesc(DET2)