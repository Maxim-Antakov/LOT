function Xk_1 = makeNextIteration(DET, Xk, IA)
global CA
tempSI.N = CA.N;
tempSI.M = CA.M;
tempSI.NPL = CA.NPL;
tempSI.DZ = CA.HL/(CA.NPL);
tempSI.SD = Xk;

switch IA.Type
    case 'mss'
        Xk_1 = My_MSS(DET, tempSI);
    case 'mnr'
        Xk_1 = My_MNR(DET, tempSI);
    case 'mop'
%         Xk_1 = My_MOP(DET, tempSI, IA.tau, IA.R);
        Xk_1 = My_ART2(DET, Xk, IA.tau, IA.R);
    otherwise
end