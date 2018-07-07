function trialSeq=weightedTrials(probTrials,maxTrials, varargin)
%
%Generates a randomized and weighted distribution "TrialSeq"or Block
%indices
%The values of the random distribution are of the size of "probTrials".
%"proTrials" defines the occurence probabilities of the different values
%"maxTrials" defines the size of the random distribution
%
%function written by Sandrea for state uncertainty

if abs(sum(probTrials))-1 > 1e-9
    disp('*** Error in defineRandomizedTrials, typeMatrix proportions do not add up to 1 ***');
    trialSeq = [];
    return
end

if nargin ==2 
    rng('shuffle')
    tempSeq=rand(1,maxTrials);
    trialSeq=arrayfun(@(z)sum(z>=cumsum([0,probTrials])),tempSeq);
else
    switch varargin{1}
        case  1 % shuffle indices
            rng('shuffle')
            tempSeq=rand(1,maxTrials);
            trialSeq=arrayfun(@(z)sum(z>=cumsum([0,probTrials])),tempSeq);            
        case 2 % indices in blocks
            orderTrials = varargin{2};
            trialSeq = blockIndices(maxTrials, probTrials, orderTrials);
    end
end
end