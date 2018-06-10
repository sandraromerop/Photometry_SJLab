function [P, TrialNames]=Oddball_Phase(PhaseName)

TrialNames={'Oddball','OddballInv'};

switch PhaseName
	case 'OddBall' 
        P.BlocksNb=10;
        P.ProbaOdd=0.1;
        P.ConstraitBtw=6;
        P.ConstraintEnd=2;

    case 'Ctl-0.3' 
        P.BlocksNb=4;
        P.ProbaOdd=0.3;
        P.ConstraitBtw=0;
        P.ConstraintEnd=0;
        
    case 'Ctl-0.5' 
        P.BlocksNb=2;
        P.ProbaOdd=0.5;
        P.ConstraitBtw=0;
        P.ConstraintEnd=0;
        
end   
end

  
