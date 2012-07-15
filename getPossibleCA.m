function LIST = getPossibleCA(M,N,PSTtype)
global PST_list
[L,~] = size(PST_list);
tmpLIST = [];  
for i=1:L
    if PST_list(i,2) == M
        if PST_list(i,3) == N
            if PST_list(i,6) == PSTtype
                tmpLIST = [tmpLIST; PST_list(i,:)];
            end
        end
    end
end
[newL,~] = size(tmpLIST);
if ~isempty(tmpLIST) tmpLIST = sortrows(tmpLIST,[1,2]); end
LIST=[];
for i=1:newL
    LIST(i).vklr = tmpLIST(i,7:10);
    LIST(i).vklr2 = tmpLIST(i,12:15);

    if PSTtype==-10
        LIST(i).str =  [returnSTR(tmpLIST(i,11),LIST(i).vklr(4)),'(', num2str(LIST(i).vklr(1)),',',num2str(LIST(i).vklr(2)),','...
            ,num2str(LIST(i).vklr(3)),',',num2str(LIST(i).vklr(4)),')x',...
            returnSTR(tmpLIST(i,16),LIST(i).vklr2(4)),'(', ...
             num2str(LIST(i).vklr2(1)),',',num2str(LIST(i).vklr2(2)),','...
            ,num2str(LIST(i).vklr2(3)),',',num2str(LIST(i).vklr2(4)),')'];
    else
        LIST(i).str =  [returnSTR(tmpLIST(i,11),LIST(i).vklr(4)),'(', num2str(LIST(i).vklr(1)),',',num2str(LIST(i).vklr(2)),','...
            ,num2str(LIST(i).vklr(3)),',',num2str(LIST(i).vklr(4)),')'];

    end
end
end
function PSP = returnSTR(num, R)
    switch num
        case -22
            tmpPSP = 'V';
        case -1
            tmpPSP = 'S';
        case -2
                tmpPSP = 'Q';
        case -4
                tmpPSP = 'T';
        case -5
                tmpPSP = 'B';
        case -6
                tmpPSP = '---';
        case -7
                tmpPSP = 'W';
        otherwise
            tmpPSP = 'UK';
    end
    if R==0
        PSP = [tmpPSP,'k'];
    else
        PSP = [tmpPSP,'r'];
    end
end