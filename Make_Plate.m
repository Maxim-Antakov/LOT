function Im = Make_Plate(Block, orient,M,N)
Im = zeros(M,N);
[mb,nb] = size(Block);
switch orient
    case 2
        x=(M-mb)-1;
        y=(N-nb)-1;
    case 4
        x=(M-mb)-1;
        y=1;
    case 1
        x=1;
        y=(N-nb)-1;
    case 3
        x=1;
        y=1;
    case 5
        x=ceil((M-mb)/2);
        y=ceil((M-nb)/2);
end
Im(x+1:x+mb,y+1:y+nb)=Block; 