function valueSeq = gaussianDiscrete(values, maxTrials, mu, sigma)
probTrials = normpdf(values,mu,sigma);
orderTrials = 1:length(x);
trialSeq = blockIndices(maxTrials, probTrials, orderTrials);
valueSeq = x(trialSeq(randperm(length(trialSeq))));
end