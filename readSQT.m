function SQ = readSQT(VKLR)
v = VKLR(1);
k = VKLR(2);
km = VKLR(3);
kp = VKLR(4);
r = VKLR(5);

SQ = zeros(1, v);

sv = num2str(v);
sk = num2str(k);
skm = num2str(km);
skp = num2str(kp);
name = ['SQT\', sv, '-', sk, '-', skm,'-', skp,'.sq'];

fid = fopen(name, 'r');
s = fgetl(fid);
i=1;
while s ~= -1
    s = fgetl(fid);
    if s ~= -1
            for j=1:length(s)
                if (s(j)=='1' || s(j)=='2' || s(j) == '0')
                    SQ(i) = str2double(s(j));
                    i=i+1;
                end
            end
    end    
end
fclose(fid);
SQ(SQ==2)=-1;
%% Extend if its needed
if r~=0
    tsq = SQ;
    SQ = zeros(1, v*(r+1));
    for i=1:v
        SQ(1+(i-1)*(r+1)) = tsq(i);
    end
end