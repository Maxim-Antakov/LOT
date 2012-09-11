function SQ = readSQD(VKLR)
v = VKLR(1);
k = VKLR(2);
l = VKLR(3);
r = VKLR(4);

SQ = zeros(1, v);
if (v==k+1)
    SQ = ones(1, v*(r+1));
    SQ(1) = 0;
elseif (k==1)
    SQ = zeros(1, v*(r+1));
    SQ(1) = 1;
else
    flag=0;
    if k > v/2
        k1 = v - k;
        l1 = k1*(k1-1)/(v-1);
        flag=1;
    else
        k1=k;
        l1=l;
    end
    sv = num2str(v);
    sk = num2str(k1);
    sl = num2str(l1);
    name = ['SQD\', sv, '-', sk, '-', sl,'.sq'];
    
    fid = fopen(name, 'r');
    s = fgetl(fid);
    i=1;
    while s ~= -1
        s = fgetl(fid);
        if s ~= -1
            for j=1:length(s)
                if (s(j)=='1' || s(j) == '0')
                    SQ(i) = str2double(s(j));
                    i=i+1;
                end
            end
        end
        
    end
    fclose(fid);
    %% Assosiate if its needed
    if flag
        SQ = double(~SQ);
    end
end
%% Extend if its needed
if r~=0
    tsq = SQ;
    SQ = zeros(1, v*(r+1));
    for i=1:v
        SQ(1+(i-1)*(r+1)) = tsq(i);
    end
end