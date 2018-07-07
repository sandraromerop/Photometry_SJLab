function [trialSeq] = blockIndices(maxTrials, proportionTrials, orderTrials)
    trialsId = find(proportionTrials>0);
    orderTrials(isnan(orderTrials))=[];orderTrials(orderTrials==length(proportionTrials)+1)=[];trialsId=trialsId(orderTrials);
    nbTrials = ceil(maxTrials.*proportionTrials);nbTrials(nbTrials==0)=[];
    trialSeq = arrayfun(@(aa,bb)ones(bb,1).*aa,trialsId,nbTrials,'UniformOutput',false);
    trialSeq =cell2mat(trialSeq');
end


    

