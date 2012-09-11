function [ DET ] = gatherDET( filename)
global CA
IC = imread(filename);
Result = double(0.2989 * IC(:,:,1) + 0.5870 * IC(:,:,2) + 0.1140 * IC(:,:,3));
filterMatrix = [1 1 1
    1 5 1
    1 1 1];
Result =  filter2(filterMatrix,Result);
%     figure(1)
%     imagesc(IM); hold on
%     line([P.Crop.X P.Crop.X+P.Crop.W],[P.Crop.Y          P.Crop.Y],'Color','green','LineWidth',2);
%     line([P.Crop.X P.Crop.X+P.Crop.W],[P.Crop.Y+P.Crop.H P.Crop.Y+P.Crop.H],'Color','green','LineWidth',2);
%     line([P.Crop.X P.Crop.X],[P.Crop.Y P.Crop.Y+P.Crop.H],'Color','green','LineWidth',2);
%     line([P.Crop.X+P.Crop.W P.Crop.X+P.Crop.W],[P.Crop.Y P.Crop.Y+P.Crop.H],'Color','green','LineWidth',2);
% %     figure(2)
%     IC = imcrop(IM,[P.Crop.X P.Crop.Y P.Crop.W P.Crop.H]);
%     imagesc(IC)
[M, N] = size(Result);
dx = floor(M/CA.eM);
dy = floor(N/CA.eN);
DET2 = zeros(CA.eM,CA.eN);
for i=1:CA.eM
    for j=1:CA.eN
        %         line([(i-1)*dx+1 i*dx],[(j-1)*dy (j-1)*dy], 'Color', 'white'); hold on
        %         line([(i-1)*dx (i-1)*dx],[(j-1)*dy j*dy], 'Color', 'white'); hold on
        s = max(max(Result((1+dx*(i-1)):dx*i,(1+dy*(j-1)):dy*j)));
        DET2(i,j) = s;
    end
end

temp1=imresize(Result,[CA.eM,CA.eN]);
% ma = max(max(temp1));
% temp1 = round(1*temp1/ma);

temp2=DET2;
in_x = 10;
in_y = 10;
DET{1} = temp1(in_x:in_x+CA.M-1,in_y:in_y+CA.N-1);
% DET{2} = temp2(in_x:in_x+CA.M-1,in_y:in_y+CA.N-1);

end

