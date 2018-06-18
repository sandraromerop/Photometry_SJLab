function AP_PlotMeans(Analysis,DefaultParam )
velocity = abs(diff( Analysis.AllData.Wheel.Distance,[],2));

figure('units','normalized','position',[.1 .1 .5 .5])
p90(1) = prctile(Analysis.AllData.Photo_470.DFF(:),90);
p10(1) = prctile(Analysis.AllData.Photo_470.DFF(:),10);
maxYY(1) = max(Analysis.AllData.Photo_470.DFF(:));
maxYY(2) = max(velocity(:));
maxYY(3) = max(Analysis.AllData.Licks.Rate(:));
minY(1) = min(Analysis.AllData.Photo_470.DFF(:));
minY(2) = min(velocity(:));
minY(3) = min(Analysis.AllData.Licks.Rate(:));
p90(2) = prctile(velocity(:),90);
p10(2) = prctile(velocity(:),10);
p90(3) = max(Analysis.AllData.Licks.Rate(:));
p10(3) = prctile(Analysis.AllData.Licks.Rate(:),10);
timeD = Analysis.AllData.Photo_470.Time(1,1:end);
timeV = linspace(timeD(1),timeD(end),length(timeD)-1);


temp = find(timeD>=Analysis.AllData.CueTime(1,1));cueOnsetId(1) = temp(1);
temp = find(timeV>=Analysis.AllData.CueTime(1,1));cueOnsetId(2) = temp(1);
temp = find(Analysis.AllData.Licks.Bin{1}(2:end)>=Analysis.AllData.CueTime(1,1));cueOnsetId(3) = temp(1);
temp = find(timeD>=Analysis.AllData.CueTime(1,2));cueOffsetId(1) = temp(1);
temp = find(timeV>=Analysis.AllData.CueTime(1,2));cueOffsetId(2) = temp(1);
temp = find(Analysis.AllData.Licks.Bin{1}(2:end)>=Analysis.AllData.CueTime(1,2));cueOffsetId(3) = temp(1);


idFilt=[];nbOfTrialTypes= Analysis.Properties.nbOfTrialTypes;
for i=1:nbOfTrialTypes
     [thisFilter] = getFilter(Analysis,i);   
     idFilt = [idFilt  thisFilter];
end
idTrials = 1:nbOfTrialTypes;
idDisc = find(all(idFilt==0,1));  
trialTypes = idTrials;
trialTypes(idDisc)=[];
trialTypes(trialTypes>nbOfTrialTypes)=[];
it=1;
for tT = trialTypes
    trialNames{it} = Analysis.Properties.TrialNames{tT}
    it=it+1;
end

cc = cbrewer('qual','Set1',length(trialTypes));

it=1;
for tT = trialTypes  
    if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
        if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'OptoStim at Cue'))
            optoStimOnset =-[ Analysis.AllData.States{1}.Outcome(1)-...
                            Analysis.AllData.States{1}.PhotoStim(1)];
            optoStimOffset =-[ Analysis.AllData.States{1}.Outcome(1)-...
                            Analysis.AllData.States{1}.PhotoStim(1)- ...
                            nanmean([Analysis.Properties.GUISettings.PulseTrainDuration])];
        else
            optoStimOnset = 0 ;
            optoStimOffset =[nanmean([Analysis.Properties.GUISettings.PulseTrainDuration])];
        end
    end

    
    [thisFilter] = getFilter(Analysis,tT);    
    tempPhoto_470 = Analysis.AllData.Photo_470.DFF(thisFilter,1:end);
    tempWheel =diff( Analysis.AllData.Wheel.Distance(thisFilter,:),[],2);
    tempLick = Analysis.AllData.Licks.Rate(thisFilter,:);
    trialsNb =find(thisFilter==1);
    tempWheel = cat(1,tempWheel,nan.*ones(1,size(tempWheel,2)));
    tempPhoto_470 = cat(1,tempPhoto_470,nan.*ones(1,size(tempPhoto_470,2)));
    tempLick = cat(1,tempLick,nan.*ones(1,size(tempLick,2)));
    
    
    
    tempCue = max(tempPhoto_470(:,cueOnsetId(1):cueOffsetId(1)),[],2);
    meanCue(1,it) = nanmean(tempCue);stdCue(1,it) = nanstd(tempCue);
    tempCue = max(tempWheel(:,cueOnsetId(2):cueOffsetId(2)),[],2);
    meanCue(2,it) = nanmean(tempCue);stdCue(2,it) = nanstd(tempCue);
    tempCue = max(tempLick(:,cueOnsetId(3):cueOffsetId(3)),[],2);
    meanCue(3,it) = nanmean(tempCue);stdCue(3,it) = nanstd(tempCue);
   
    
    
    ip  = 1; 
    
    subplot(3,2,ip)
    shadedErrorBar(timeD,nanmean(tempPhoto_470(:,1:end),1),...
        nanstd((tempPhoto_470(:,1:end)),[],1)./(sqrt(size(tempPhoto_470,1))),cc(it,:),1)
    ip  = ip +1 ;hold on
      plot(Analysis.AllData.CueTime(1,:),[maxYY(1) maxYY(1)].*.75,'Color',[.7 .7 .7],'LineWidth',2,'LineStyle','-');
  
     if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
        if optoStimOffset-optoStimOnset>1e-6
            plot([optoStimOnset optoStimOffset],[maxYY(1)*.9   maxYY(1)*.9  ],'Color',[1. 0.3333   0],'LineWidth',2,'LineStyle','-');
        end
     end
    ax=gca;ax.XLim=[-5 5];title([ strrep(DefaultParam.FileList(1:end-4),'_',' ')]);     
    xlabel('Time (sec)');ylabel('DF/F0');
    subplot(3,2,ip)
    bar(it , meanCue(1,it),'FaceColor',cc(it,:),'EdgeColor',cc(it,:));hold on
    errorbar(it , meanCue(1,it),stdCue(1,it)./(sqrt(size(tempPhoto_470,1))) ,'+','Color','black' )
    ip  = ip +1 ;
    ax=gca;ax.XTick = [1  2  3]; ax.XTickLabel =trialNames;
    title('Peak DF/F0 at Cue')
    ylabel(' mean+/-SEM ');

         

    subplot(3,2,ip)
    shadedErrorBar(timeV,nanmean(tempWheel(:,1:end),1),...
        nanstd((tempWheel(:,1:end)),[],1)./(sqrt(size(tempPhoto_470,1))),cc(it,:),1)
    ip  = ip +1 ;hold on
    ax=gca;ax.XLim=[-5 5];
    plot(Analysis.AllData.CueTime(1,:),[maxYY(2) maxYY(2)].*.75,'Color',[.7 .7 .7],'LineWidth',2,'LineStyle','-');
    xlabel('Time (sec)');ylabel('Velocity cm/s');
     if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
        if optoStimOffset-optoStimOnset>1e-6
            plot([optoStimOnset optoStimOffset],[maxYY(2)*.9   maxYY(2)*.9 ],'Color',[1. 0.3333   0],'LineWidth',2,'LineStyle','-');
        end
    end
   
    subplot(3,2,ip)
    bar(it , meanCue(2,it),'FaceColor',cc(it,:),'EdgeColor',cc(it,:));hold on
    errorbar(it , meanCue(2,it),stdCue(2,it)./(sqrt(size(tempPhoto_470,1))) ,'+','Color','black' )
    ip  = ip +1 ;
    ax=gca;ax.XTick = [1  2  3]; ax.XTickLabel = trialNames;
    title('Peak Velocity at Cue' )
    ylabel(' mean+/-SEM ');
    subplot(3,2,ip)
    shadedErrorBar(Analysis.AllData.Licks.Bin{1}(2:end),nanmean(tempLick(:,1:end),1),...
        nanstd((tempLick(:,1:end)),[],1)./(sqrt(size(tempPhoto_470,1))),cc(it,:),1)
    ip  = ip +1 ;hold on
    ax=gca;ax.XLim=[-5 5];
    xlabel('Time (sec)');ylabel('Lick Rate (Hz)');
	plot(Analysis.AllData.CueTime(1,:),[maxYY(3) maxYY(3)].*.75,'Color',[.7 .7 .7],'LineWidth',2,'LineStyle','-');

    if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
        if optoStimOffset-optoStimOnset>1e-6
            plot([optoStimOnset optoStimOffset],[maxYY(3)*.9   maxYY(3)*.9],'Color',[1. 0.3333   0],'LineWidth',2,'LineStyle','-');
        end
    end
    
    subplot(3,2,ip)
    bar(it , meanCue(3,it),'FaceColor',cc(it,:),'EdgeColor',cc(it,:));hold on
    errorbar(it , meanCue(3,it),stdCue(3,it)./(sqrt(size(tempPhoto_470,1))) ,'+','Color','black' )
    ip  = ip +1 ;
    ax=gca;ax.XTick = [1  2  3]; ax.XTickLabel =trialNames;
    title('Peak Lick Rate at Cue') 
        ylabel(' mean+/-SEM ');

    it = it+1;
end
saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name 'meanAmplitudes' '.png']);
saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name 'meanAmplitudes' '.m']);
