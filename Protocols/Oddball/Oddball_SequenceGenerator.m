function [Sequence, StateNames]=Oddball_SequenceGenerator(TrialLength,Podd,ConstraintBtw,ConstraintEnd)
% Function to generate a sequence of '1' and '2' of Length TrialLength with a
% probability Podd of '2' and additional constraints on the number of '1'
% between each '2' and at the end of the sequence
%
%function designed by Quentin 2017

if nargin ==2
        ConstraintBtw=0;
        ConstraintEnd=0; 
end

%% Parameters
TotalNbOdd=Podd*TrialLength;
TotalNbStand=TrialLength-TotalNbOdd;

% Nb of 0 between each 1
RemainingStand=TotalNbStand-(TotalNbOdd*ConstraintBtw)-ConstraintEnd;

if RemainingStand<=0
    disp('Cannot generate the rexpected sequence with these parameters')
    Sequence=[];
    return
end

NbOfStandPerOdd=ones(TotalNbOdd,1)*ConstraintBtw;
for i=1:RemainingStand
    Index=randi([1 TotalNbOdd]);
    NbOfStandPerOdd(Index)=NbOfStandPerOdd(Index)+1;
end

%% Sequence
Sequence=ones(TrialLength,1)*2;
counter=1;
for i=1:length(NbOfStandPerOdd)
    NbOfStand=NbOfStandPerOdd(i);
    Sequence(counter:counter+NbOfStand-1)=1;
    counter=counter+NbOfStand+1;
end
if ConstraintEnd~=0
    Sequence(end-ConstraintEnd-1:end)=1;
end

%% Name
StateNames=cell(TrialLength,1);
counterStand=0;
counterOdd=1;

for i=1:length(Sequence)
    switch Sequence(i)
        case 1
            counterStand=counterStand+1;
            StateNames{i}=sprintf('Standard_%.0d_%.0d',counterOdd,counterStand);
        case 2
            counterStand=0;
            StateNames{i}=sprintf('Odd_%.0d',counterOdd');
            counterOdd=counterOdd+1;
    end
end
StateNames{end+1}='ITIBlock';    
end