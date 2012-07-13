function DET = getDetector(SI)
global CA XY_FP 
% DDX = CA.ASX*CA.DX/(CA.ASX-CA.DX);
% DDY = DDX;
% Z = CA.HL+(0:SI.NPL-1)*SI.DZ;
% disp(['Detector Z: ', mat2str(Z)])
DET = cell(1,CA.NPL);
if CA.PSTT~='H'
    for K=1:CA.NPL
        DET{K} = zeros(CA.M, CA.N);
    end
    multiWaitbar('Detector',0, 'Color', [0.2 0.6 0.2]);
    IST = image2matrix(SI);
    [NIST, ~] = size(IST);
    for i = 1:NIST
       multiWaitbar('Detector',i/NIST)
       x = IST(i, 1);
       y = IST(i, 2);
       a = IST(i, 4);
       for DET_K = 1:CA.NPL
          z = IST(i, 3) - CA.DZ * (DET_K-1);
%           DET{DET_K} = DET{DET_K}+Shadow_2M(x,y,z,a,CA.M,CA.N,CA.DZ * (DET_K-1)); 
          DET{DET_K} = DET{DET_K}+a*getPointSourseDetector(x,y,z, CA.DZ * (DET_K-1)); 
       end
    end
else
    for K=1:CA.NPL
        DET{K} = zeros(1, 3*CA.R*(CA.R+1)+1);
    end
    for SOURCE_K = 1:SI.NPL
        SP = SI.SD{SOURCE_K};
        JJ = find(SP);
        for DET_K=1:SI.NPL
            ist.Z = CA.HL+SI.DZ*(SOURCE_K-DET_K);
            for i=1:length(JJ)
                ist.X = XY_FP(JJ(i),1);
                ist.Y = XY_FP(JJ(i),2);
                a = SP(JJ(i));
                %                     disp(['i=',num2str(i),'; IST x: ',num2str(ist.X),'; IST y: ',num2str(ist.Y),'; IST z: ',num2str(ist.Z),'; S = ', mat2str(Shadow_Hex_New_Cir(ist))])
                DET{DET_K} = DET{DET_K}+a*Shadow_Hex_New_Cir(ist);
            end
        end
    end
    
end

multiWaitbar('Detector','Close');