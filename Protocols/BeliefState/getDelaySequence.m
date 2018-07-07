
function delaySeq = getDelaySequence()
global S
cueNames = {'A','B','C','D'};
trialTypes = 1:size(S.TrialsMatrix ,1);
delaySeq = zeros(1, length(S.TrialSequence));
for cc=1:length(cueNames)
    idCues{cc}=arrayfun(@(z)(length(cell2mat(z)>0)),strfind(S.TrialsNames,['Cue' cueNames{cc}]));
    trialId = trialTypes(logical(idCues{cc}));
    nbTrials  = sum(ismember(S.TrialSequence,trialId));
    if eval(['S.GUI.DelayDistributionEnd.' cueNames{cc}])==0
        delaySeq(ismember(S.TrialSequence,trialId)) = ones(1,nbTrials)*eval(['S.GUI.Delay.Delay' cueNames{cc}]);
    else
        startValue =eval(['S.GUI.Delay.Delay' cueNames{cc}]);
        endValue =eval(['S.GUI.DelayDistributionEnd.' cueNames{cc}]);
        stepValue =eval(['S.GUI.DelayDistributionStep.' cueNames{cc}]);
        mu = eval(['S.GUI.DelayDistributionMu.' cueNames{cc}]);
        sigma=eval(['S.GUI.DelayDistributionSigma.' cueNames{cc}]);
        valueSeq = gaussianDiscrete([startValue:stepValue:endValue], nbTrials, mu, sigma);
        delaySeq(ismember(S.TrialSequence,trialId)) = ones(1,nbTrials).*valueSeq(1:nbTrials);
    end
end



