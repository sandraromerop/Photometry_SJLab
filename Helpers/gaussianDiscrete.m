function valueSeq = gaussianDiscrete(values, maxTrials, mu, sigma)
probTrials = normpdf(values,mu,sigma);
orderTrials = 1:length(values);
trialSeq = blockIndices(maxTrials, probTrials, orderTrials);
valueSeq = values(trialSeq(randperm(length(trialSeq))));
end