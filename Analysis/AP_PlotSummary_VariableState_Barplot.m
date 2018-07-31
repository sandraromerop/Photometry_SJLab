function AP_PlotSummary_VariableState_Barplot(Analysis,timings )

for stateNb=1:size(Analysis.AllData.Photo_470.DFF,1)
figure('units','normalized','position',[.1 .1 .4 .4])
idFilt=[];nbOfTrialTypes= Analysis.Properties.nbOfTrialTypes;
for i=1:nbOfTrialTypes
     [thisFilter] = getFilter(Analysis,i);   
     idFilt = [idFilt  thisFilter];
end
idTrials = 1:nbOfTrialTypes;
trialTypes = idTrials;
trialTypes(find(all(idFilt==0,1)))=[];
trialTypes(trialTypes>nbOfTrialTypes)=[];
varNames = {'Photometry','Lick Rate'};
ylabs = {'DF/F0','Hz'};

cc= cbrewer('qual','Set2',4);
varType = [];timesD=[];
for tT = trialTypes
    [thisFilter] = getFilter(Analysis,tT);    
    outcomeTimes = squeeze(Analysis.AllData.OutcomeTime(2,thisFilter,:));
    if outcomeTimes(2)-outcomeTimes(1)~=0
        varType = [varType  tT]; 
    end
    uniqueTimes = unique(outcomeTimes(:,1));
    tempTime = Analysis.AllData.Photo_470.Time(stateNb,thisFilter,:);
    for uT=1:length(uniqueTimes)
        idT = find(outcomeTimes(:,1) == uniqueTimes(uT));
        timesD = cat(2,timesD, squeeze( tempTime(1,idT(1),1:end)));
    end
end          
newTime = min(timesD(:)):.05:max(timesD(:));
ip=1;
ymax={[],[]};ymin={[],[]};
for tT = varType
    [thisFilter] = getFilter(Analysis,tT);    
    tempPhoto_470 = squeeze( Analysis.AllData.Photo_470.DFF(stateNb,thisFilter,1:end));
    tempWheel =  diff( squeeze(Analysis.AllData.Wheel.Distance(stateNb,thisFilter,:)),[],2);
    tempLick = squeeze( Analysis.AllData.Licks.Rate(stateNb,thisFilter,:));
    tempTime = Analysis.AllData.Photo_470.Time(stateNb,thisFilter,:);
    tempOutcomeTime = squeeze(Analysis.AllData.OutcomeTime(stateNb,thisFilter,:)) ;
    tempCueTime = squeeze(Analysis.AllData.CueTime(stateNb,thisFilter,:)) ;
    tempTimeLick =Analysis.AllData.Licks.Bin{1}(2:end);
    outcomeTimes = squeeze(Analysis.AllData.OutcomeTime(2,thisFilter,:));
    uniqueTimes = unique(outcomeTimes(:,1));
    meanPh =[];maxPh=[];meanL=[];maxL=[];
    meanPeakPhoto = [];meanPeakLick=[];stdPeakPhoto=[];stdPeakLick=[];nbTrials=[];
    for uT=1:length(uniqueTimes)
        idT = find(outcomeTimes(:,1) == uniqueTimes(uT));
        meanPhoto = nanmean(tempPhoto_470(idT,:),1);stdPhoto =  nanstd(tempPhoto_470(idT,:),[],1);
        meanWheel = nanmean(tempWheel(idT,:),1); stdWheel =  nanstd(tempWheel(idT,:),[],1);
        meanLick = nanmean(tempLick(idT,:),1);stdLick =   nanstd(tempLick(idT,:),[],1);
        tempL= tempLick(idT,:);
        timeD = squeeze( tempTime(1,find(outcomeTimes(:,1) == uniqueTimes(uT),1),1:end));
        temp = tempPhoto_470(idT,:);
        interpTemp =  interp1(timeD,temp',newTime);interpTemp=interpTemp';

        if size(interpTemp,2)==1
            interpTemp=interpTemp';
        end

                
        id{1} = [arrayfun(@(z) find(newTime>=z,1), tempCueTime(idT,1) ) arrayfun(@(z) find(newTime>=z,1), tempCueTime(idT,1)+timings{1} ) ...
                arrayfun(@(z) find(tempTimeLick>=z,1), tempCueTime(idT,1) ) arrayfun(@(z) find(tempTimeLick>=z,1), tempCueTime(idT,1)+timings{1} )];
        id{2} = [arrayfun(@(z) find(newTime>=z,1), tempOutcomeTime(idT,1) ) arrayfun(@(z) find(newTime>=z,1), tempOutcomeTime(idT,1)+timings{2} ) ...
                arrayfun(@(z) find(tempTimeLick>=z,1), tempOutcomeTime(idT,1) ) arrayfun(@(z) find(tempTimeLick>=z,1), tempOutcomeTime(idT,1)+timings{2} )];
        id{3} = [arrayfun(@(z) find(newTime>=z,1), tempOutcomeTime(idT,1) ) arrayfun(@(z) find(newTime>=z,1), tempOutcomeTime(idT,1)+timings{3} ) ...
                arrayfun(@(z) find(tempTimeLick>=z,1), tempOutcomeTime(idT,1) ) arrayfun(@(z) find(tempTimeLick>=z,1), tempOutcomeTime(idT,1)+timings{3} )];
        id{4} = [arrayfun(@(z) find(newTime>=z,1),newTime(find(isnan(interpTemp(1,:))~=1,1)) ) arrayfun(@(z) find(newTime>=z,1), newTime(find(isnan(interpTemp(1,:))~=1,1))+ timings{4} ) ...
                arrayfun(@(z) find(tempTimeLick>=z,1), tempTimeLick(1) ) arrayfun(@(z) find(tempTimeLick>=z,1),  tempTimeLick(1) + timings{4} )];
       
        for iid=1:length(id)  
           meanPh{uT,iid}= nanmean(interpTemp(:,min( id{iid}(1,1),id{iid}(1,2)):max(id{iid}(1,2),id{iid}(1,1))),2);
           maxPh{uT,iid}= nanmax(interpTemp(:,min( id{iid}(1,1),id{iid}(1,2)):max(id{iid}(1,2),id{iid}(1,1))),[],2);
           meanL{uT,iid}= nanmean(tempL(:,min( id{iid}(1,3),id{iid}(1,4)):max(id{iid}(1,3),id{iid}(1,4))),2);
           maxL{uT,iid}= nanmax(tempL(:,min( id{iid}(1,3),id{iid}(1,4)):max(id{iid}(1,3),id{iid}(1,4))),[],2);
           
           meanPeakPhoto(uT,iid) = nanmean(maxPh{uT,iid});stdPeakPhoto(uT,iid) = nanstd(maxPh{uT,iid});nbTrials(uT,iid)= length(maxPh{uT,iid})
           meanPeakLick(uT,iid) = nanmean(maxL{uT,iid});stdPeakLick(uT,iid) = nanstd(maxL{uT,iid});
        end
    end
    
    ymax{1}=[ymax{1} max(meanPeakPhoto)];ymax{2}=[ymax{2} max(meanPeakLick)];
    ymin{1}=[ymin{1} min(meanPeakPhoto)];ymin{2}=[ymin{2} min(meanPeakLick)];
    %  Plot
    subplot(2,round(length(varType)),ip);ip=ip+1;
    
    for iid=2:3
    errorbar(uniqueTimes, meanPeakPhoto(:,iid),stdPeakPhoto(:,iid)./(nbTrials(:,1)),'Color',cc(iid,:) );hold on
    end
    legend('Cue','Pre Reward','Post Reward');
    title([ Analysis.Properties.TrialNames{tT} ' ' 'Photometry']); ylabel('Peak DF/F0');xlabel(' Cue Delay');box off
    
    subplot(2,round(length(varType)),ip);ip=ip+1;
    for iid=2:3
    errorbar(uniqueTimes, meanPeakLick(:,iid),stdPeakLick(:,iid)./(nbTrials(:,1)),'Color',cc(iid,:) );hold on
    end
    legend( 'Pre Reward','Post Reward');
    title([ Analysis.Properties.TrialNames{tT} ' ' 'Lick Rate']);ylabel('Hz');xlabel(' Cue Delay');box off
    
end
 ymax{1}(isnan( ymax{1}))=[];ymin{1}(isnan( ymin{1}))=[];ip=1;
for tT = varType
subplot(2,round(length(varType)),ip);ip=ip+1;
ax=gca;ax.YLim=[min(ymin{1}) max(ymax{1}) ];
subplot(2,round(length(varType)),ip);ip=ip+1;
ax=gca;ax.YLim=[min(ymin{2}) max(ymax{2}) ];
end
end
 