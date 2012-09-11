function SI = createSourceImage(SI)
global CA
%TODO: parse varargins throw SI params
SI.N = CA.N;
SI.M = CA.M;
SI.DZ = (CA.F-CA.HL)/(SI.NPL+1);
for i=1:SI.NPL
    SI.SD{i} = zeros(SI.M, SI.N);
end
switch SI.ID
    case 0 % dummy image
        for i=1:length(SI.NPL)
            SI.SD{i}=zeros(CA.M, CA.N);
        end
    case 1 % central point source
        plateID = ceil(SI.NPL/2);
        temp = zeros(SI.M, SI.N);
        temp(ceil(SI.M/2),ceil(SI.N/2))=1;
        SI.SD{plateID} = temp;
    case 2 % multi-point source
        for i=1:length(SI.PSC)
            SI.SD{SI.PSC(i).z}(SI.PSC(i).x,SI.PSC(i).y)=1;
        end
    case 3 % shepp
        E= [0      0        0      0.69   0.92    0.90     0     0     1;
            0      0        0      0.66   0.87    0.88     0     0    -.8;
            -0.22  0       -0.25   0.16   0.41    0.22    18     0    -.2;
            0.22   0       -0.25   0.11   0.31    0.21   -18     0    -.2;
            0      0.35    -0.25   0.21   0.25    0.24     0     0    .1;
            0      0.1      0      0.046  0.046   0.16     0     0    .1;
            0     -0.1      0      0.046  0.0460  0.046    0     0    .1;
            -0.08  -0.605   0.25   0.046  0.023   0.10     0     0    .1;
            0     -0.606    0.25   0.023  0.023   0.10     0     0    .1;
            0.06  -0.605    0.25   0.023  0.046   0.10     0     0    .1];
        
        xax =  ( (0:SI.N-1)-(SI.N-1)/2 ) / ((SI.N-1)/2);
        xg = repmat(xax, SI.M, 1);
        xax =  (( (0:SI.M-1)-(SI.M-1)/2 ) / ((SI.M-1)/2))';
        yg = flipud(repmat(xax, 1, SI.N));
        for k = 1:1:size(E,1)
            a =   E(k,4);
            b =   E(k,5);
            c =   E(k,6);
            phi  = E(k,7)*pi/180;
            x0 =  E(k,1);
            y0 =  E(k,2);
            z0 =  E(k,3);
            A =   1000000*E(k,9);
            x=xg-x0; y=yg-y0;
            cost = cos(phi);
            sint = sin(phi);
            for i=1:SI.NPL
                z1=z0+0.75-(i-1)*1.5/SI.NPL;
                fun1=((x.*cost + y.*sint).^2)./a^2 + ((y.*cost - x.*sint).^2)./b^2 + z1.^2./c^2;
                idx=find( fun1<= 1);
                p = SI.SD{i};
                p(idx) = p(idx) + A;
                SI.SD{i} = p;
            end
        end
    case 4 %Цифры по центру
        load Real_Image_DB.mat;
        
        for i=1:SI.NPL
            Block = RI{rem(i,11)};
            T_IM = Make_Plate(Block,5,20,20);
            SI.SD{i} = imresize(T_IM,[SI.M SI.N],'nearest');
        end
        %         global TEMP_IM
        %         Temp_IM
    case 5 %Алфавит
        [alphabet, ~] = prprob;
        for i = 1:NPL
            ti = alphabet(:, i);
            L = reshape(ti, 5, 7)';
            T_IM = Make_Plate(L,5,20,20);
            SI.SD{i} = imresize(T_IM,[SI.M SI.N],'nearest');
        end
    case 6 %Слово (без цифр)
        W = varargin{4};
        ALF = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
        if (NPL>length(W))
            disp('Incorrect word''s length');
        else
            [alphabet, ~] = prprob;
            for i = 1:NPL
                L = W(i);
                for j=1:26
                    if L==ALF{j}
                        ind_l = j; break;
                    end
                end
                ti = alphabet(:, ind_l);
                LA = reshape(ti, 5, 7)';
                T_IM = Make_Plate(LA,5,20,20);
                SI.SD{i} = imresize(T_IM,[V V],'nearest');
            end
        end
    case 7 %Непрерывный источник
        z= (1:NPL);
        z= z- (NPL+1)/2;
        [xx,yy] = meshgrid(-V/2:V/2,-V/2:V/2);
        V2 = V*V/16;
        NPL2 = (NPL)*(NPL)/16;
        v = exp(-(xx.^2)/V2-(yy.^2)/V2);
        
        v = v/max(max(v));
        for i=1:NPL
            SI.SD{i} = v*exp(-(z(i)^2)/NPL2/NPL2);
        end
    case 8 %Холодный очаг
        OP_raz = varargin{4};
        OP_act = varargin{5};
        z = (1:NPL);
        z = z- (NPL+1)/2;
        [X,Y,Z] = meshgrid(-V/2:V/2,-V/2:V/2,z);
        VV  = ones(size(X));
        Raz = OP_raz*(V)/4;
        IN  = ((X).^2+(Y).^2+4*(NPL+1)*(NPL+1)*(Z).^2)<=Raz^2;
        VV(IN) = OP_act;
        for i=1:NPL
            SI.SD{i} = VV(:,:,i);
        end
    case 9
        SI.SD = Make_Shepp_Logan(SI.M, SI.N, SI.NPL);
        for i=1:SI.NPL
            SI.SD{i} = 1000000*SI.SD{i};
        end
    otherwise
end

if CA.PSTT=='H'
    for i=1:SI.NPL
        SI.SD{i} = rediscretizy(SI.SD{i}, CA.R);
    end
    m = zeros(1,SI.NPL);
    for i=1:SI.NPL
        m(i) = max(SI.SD{i});
    end
    totalM = max(m);
    for i=1:SI.NPL
        SI.SD{i} = SI.SD{i}/totalM*1000000;
    end
end

