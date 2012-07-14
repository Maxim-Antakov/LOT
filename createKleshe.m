function Y1 = createKleshe
global CA XY_FP
delX=CA.DX*CA.ASX/(CA.ASX - CA.DX);
delY=CA.DY*CA.ASY/(CA.ASY - CA.DY);
if CA.PSTT~='H'
    Y1 = cell(CA.M,CA.N);
    multiWaitbar('Convolution array',0, 'Color', [0.2 0.6 0.2]);
    for i=1:CA.M
        multiWaitbar('Convolution array',i/CA.M);
        for j=1:CA.N
%             Y1{i,j}=Shadow_2M((j-1)*delX+delX/2, (CA.M-i)*delY+delY/2, CA.F-CA.HL, 1, CA.M, CA.N);
            Y1{i,j}=getPointSourseDetector2((j-1)*delX+delX/2,(CA.M-i)*delY+delY/2,CA.F-CA.HL, 0);
            u=max(max(Y1{i,j}));
            Y1{i,j}=Y1{i,j}./u;
            %        disp(['Макс - ',num2str(max(max(Y1{i,j}))), '; Мин - ', num2str(min(min(Y1{i,j})))]);
            %subplot(n,m,(i-1)*n+j);imagesc(Y1{i,j}); colormap copper;axis off
        end
    end
    multiWaitbar( 'Convolution array', 'Close' )
else
    V = 3*CA.R*(CA.R+1)+1;
    Y1 = cell(1,V);
    h = waitbar(0,'Convolution array: ');
    for i=1:V
        waitbar(i/V,h,'Convolution array');
        
        ist.Z = CA.F;
        ist.X = XY_FP(i,1);
        ist.Y = XY_FP(i,2);
        
        s = Shadow_Hex_New_Cir(ist);
        s = s./max(s);
        Y1{i} = s;

    end
    close(h)
end
end