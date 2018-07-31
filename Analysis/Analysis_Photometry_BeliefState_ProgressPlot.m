%% Progress plot
generalDir = 'C:\Users\Lars\Documents\Data\Photometry\SR002\BeliefState\Analysis\';
behavior = 'BeliefState';
listing = dir(generalDir);cc=1;
sessionNames=[];
for ii=1:length(listing)
    fileName =listing(ii).name;  
        if contains(fileName,behavior) && contains(fileName ,'Analysis.mat')
            sessionNames{cc,1} = fileName;
            cc = cc+1;
        end
end

close all
timings ={.75,-.75,1,.75}; %{ After cue, before reward, post reawrd, baseline from trial start} 
ProgressMat = getProgressMat(sessionNames,generalDir,timings,10) ;
 %%
stateNb = 1; % 1: alligned to outcome, 2: alligned to cue
trialNames ={'CueAReward','CueBReward'}; 
measure ='Mean'; % 'Mean'
varNames = {'Photo_470','Lick'};
ylims = {[-1 2],[0 15]};
ylabs = {'DF/F0','Lick Rate (Hz)'};
figure('units','normalized','position',[.1 .1 .8 .6])

ip=1;cc= cbrewer('qual','Set2',4);
for vv=1:2
    tt =[];tt2=[]
    for iT=1:length(trialNames)
    tempMean =[];tempStd=[];nbTrials=[];
    eval([ 'tempMat = ProgressMat.' varNames{vv} '.' measure '.' trialNames{iT}])
    tempMat =tempMat(:,stateNb);sCount=1;
    eval([ 'tempMatBase = ProgressMat.' varNames{vv} '.' 'Mean' '.' trialNames{iT}])
    tempMatBase =tempMatBase(:,stateNb);sCount=1;

    
    for iS=1:length(tempMat)   
        if ~isempty(tempMat{iS})
            tempMean(sCount,1) =(nanmean(tempMat{iS}{1})- nanmean(tempMatBase{iS}{4}))./nanstd(tempMatBase{iS}{4});
            tempMean(sCount,2) =(nanmean(tempMat{iS}{2}) - nanmean(tempMatBase{iS}{4}))./nanstd(tempMatBase{iS}{4});
            tempMean(sCount,3) =(nanmean(tempMat{iS}{3}) - nanmean(tempMatBase{iS}{4}))./nanstd(tempMatBase{iS}{4});
            tempMean(sCount,4) =nanmean(tempMat{iS}{4});
            tempMean(sCount,3)
            tempStd(sCount,1) =nanstd(tempMat{iS}{1});
            tempStd(sCount,2) =nanstd(tempMat{iS}{2});
            tempStd(sCount,3) =nanstd(tempMat{iS}{3});
            tempStd(sCount,4) =nanstd(tempMat{iS}{4});
                
            nbTrials(sCount) = length(tempMat{iS}{1});
            tt=[tt; tempMat{iS}{1}];
            tt2 =[tt2; tempMat{iS}{2}];
            sCount=sCount+1;
        else
                
        end
    end
    nbTrials(nbTrials==0)=1;
   
    subplot(2,length(trialNames),ip);ip=ip+1;
    errorbar(1:size(tempMean,1)   , tempMean(:,1),tempStd(:,1)./(sqrt(nbTrials)'),'Color',cc(1,:));hold on
    errorbar(1:size(tempMean,1)   , tempMean(:,2),tempStd(:,2)./(sqrt(nbTrials)'),'Color',cc(2,:));hold on
    errorbar(1:size(tempMean,1)   , tempMean(:,3),tempStd(:,3)./(sqrt(nbTrials)'),'Color',cc(3,:));hold on
    title([ trialNames{iT} ' ' strrep( varNames{vv},'_' ,' ')] )
    if iT==length(trialNames)
        legend('Cue','Pre Reward','Post reward');
    end
    ax=gca;%ax.YLim = ylims{vv};
    ylabel(ylabs{vv});xlabel('Session Nb');
    box off
    end
end


%%
% Cue time
% time{1} =squeeze( Analysis.AllData.CueTime(stateNb,1,:));
% time{1} =squeeze( Analysis.AllData.CueTime(stateNb,1,:));
% time{1} =squeeze( Analysis.AllData.CueTime(stateNb,1,:));
ip=1;

for vv=1%:2
    figure
    tt =[];tt2=[]
for iT=1:length(trialNames)
    tempMean =[];tempStd=[];
    [ 'tempMat = ProgressMat.' varNames{vv} '.' trialNames{iT}]
        eval([ 'tempMat = ProgressMat.' varNames{vv} '.' trialNames{iT}])
        tempMat =tempMat(:,stateNb);sCount=1;
        for iS=1:length(tempMat)   
            if ~isempty(tempMat{iS})
                tempMean(sCount,:) =(nanmean(tempMat{iS,1}));
                tempStd(sCount,:) =(nanstd(tempMat{iS,1}));
                sCount=sCount+1;

            else
                
            end
        end
        cc= cbrewer('div','Spectral',size(tempMean,1));
        subplot(2,1,ip);ip=ip+1;
%         for iS=1:size(tempMean,1)   
%             plot(tempMean(iS,:),'Color',cc(iS,:));hold on
%         end
        
        % Photometry
%         shadedErrorBar(1:size(tempMean,1)   , tempMean(:,1),tempStd(:,1),cc(1,:));hold on
%         shadedErrorBar(1:size(tempMean,1)   , tempMean(:,2),tempStd(:,2),cc(2,:));hold on
%         shadedErrorBar(1:size(tempMean,1)   , tempMean(:,3),tempStd(:,3),cc(3,:));hold on
         errorbar(1:size(tempMean,1)   , tempMean(:,1),tempStd(:,1)./(sqrt(size(tempMean,2))),'Color',cc(1,:));hold on
         errorbar(1:size(tempMean,1)   , tempMean(:,2),tempStd(:,2)./(sqrt(size(tempMean,2))),'Color',cc(2,:));hold on
         errorbar(1:size(tempMean,1)   , tempMean(:,3),tempStd(:,3)./(sqrt(size(tempMean,2))),'Color',cc(3,:));hold on
         errorbar(1:size(tempMean,1)   , tempMean(:,4),tempStd(:,4)./(sqrt(size(tempMean,2))),'Color',cc(4,:));hold on

    end
end