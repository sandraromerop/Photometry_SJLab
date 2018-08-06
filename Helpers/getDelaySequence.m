
function delaySeq = getDelaySequence()
global S
cueNames = {'A','B','C','D'};
trialTypes = 1:size(S.TrialsMatrix ,1);
delaySeq = zeros(1, length(S.TrialSequence));
for cc=1:length(cueNames)
    idCues{cc}=arrayfun(@(z)(length(cell2mat(z)>0)),strfind(S.TrialsNames,['Cue' cueNames{cc}]));
    trialId = trialTypes(logical(idCues{cc}));
    nbTrials  = sum(ismember(S.TrialSequence,trialId));
    if length(eval(['S.GUI.Delay' cueNames{cc}]))==1
        delaySeq(ismember(S.TrialSequence,trialId)) = ones(1,nbTrials)*eval(['S.GUI.Delay' cueNames{cc}]);
    else
        temp =eval(['S.GUI.Delay' cueNames{cc}]);
        mu = temp(end-1); sigma=temp(end-2);
        valueSeq = gaussianDiscrete(temp(1:end-3), nbTrials, mu, sigma);
        delaySeq(ismember(S.TrialSequence,trialId)) = ones(1,nbTrials)*valueSeq(1:nbTrials);
    end
end



