function AP_PlotSummary_AllSignals(Analysis,DefaultParam )
for stateNb=1:size(Analysis.AllData.Photo_470.DFF,1)
figure('units','normalized','position',[.1 .1 .7 .7])

idFilt=[];nbOfTrialTypes= Analysis.Properties.nbOfTrialTypes;
for i=1:nbOfTrialTypes
     [thisFilter] = getFilter(Analysis,i);   
     idFilt = [idFilt  thisFilter];
end
idTrials = 1:nbOfTrialTypes;
trialTypes = idTrials;
trialTypes(find(all(idFilt==0,1)))=[];
trialTypes(trialTypes>nbOfTrialTypes)=[];

minY = {[] [] []};p90 = {[] [] []};p10 = {[] [] []};maxY ={[] [] []};
for tT = trialTypes
    [thisFilter] = getFilter(Analysis,tT);    
    tempPhoto_470 = squeeze( Analysis.AllData.Photo_470.DFF(stateNb,thisFilter,1:end));
    maxY{1}= [maxY{1} max(nanmean(tempPhoto_470(:,1:end),1)+ nanstd((tempPhoto_470(:,1:end)),[],1)./(sqrt(size(tempPhoto_470,1))))];
    minY{1}= [minY{1} min(nanmean(tempPhoto_470(:,1:end),1)+ nanstd((tempPhoto_470(:,1:end)),[],1)./(sqrt(size(tempPhoto_470,1))))];
    p90{1} = [p90{1} prctile(tempPhoto_470,90)];
    p10{1} = [p10{1} prctile(tempPhoto_470,10)];
    
    tempWheel =  diff( squeeze(Analysis.AllData.Wheel.Distance(stateNb,thisFilter,:)),[],2);
    maxY{2}= [maxY{2} max(nanmean(tempWheel(:,1:end),1)+ nanstd((tempWheel(:,1:end)),[],1)./(sqrt(size(tempWheel,1))))];
    minY{2}= [minY{2} min(nanmean(tempWheel(:,1:end),1)+ nanstd((tempWheel(:,1:end)),[],1)./(sqrt(size(tempWheel,1))))];
    p90{2} = [p90{2} prctile(tempWheel,90)];
    p10{2} = [p10{2} prctile(tempWheel,10)];
    
    tempLick = squeeze( Analysis.AllData.Licks.Rate(stateNb,thisFilter,:));
    maxY{3}= [maxY{3} max(nanmean(tempLick(:,1:end),1)+ nanstd((tempLick(:,1:end)),[],1)./(sqrt(size(tempLick,1))))];
    minY{3}= [minY{3} min(nanmean(tempLick(:,1:end),1)+ nanstd((tempLick(:,1:end)),[],1)./(sqrt(size(tempLick,1))))];
    p90{3} = [p90{3} prctile(tempLick,90)];
    p10{3} = [p10{3} prctile(tempLick,10)];
    
end
maxY{1}(isnan(maxY{1}))=[];maxY{1}=max(maxY{1});maxY{2}(isnan(maxY{2}))=[];maxY{2}=max(maxY{2});maxY{3}(isnan(maxY{3}))=[];maxY{3}=max(maxY{3});
minY{1}(isnan(minY{1}))=[];minY{1}=min(minY{1});minY{2}(isnan(minY{2}))=[];minY{2}=min(minY{2});minY{3}(isnan(minY{3}))=[];minY{3}=min(minY{3});
p90{1}(isnan(p90{1}))=[];p90{1}=max(p90{1});p90{2}(isnan(p90{2}))=[];p90{2}=max(p90{2});p90{3}(isnan(p90{3}))=[];p90{3}=max(p90{3});
p10{1}(isnan(p10{1}))=[];p10{1}=min(p10{1});p10{2}(isnan(p10{2}))=[];p10{2}=min(p10{2});p10{3}(isnan(p10{3}))=[];p10{3}=min(p10{3});

matIP =reshape( 1:(6*length(trialTypes)),length(trialTypes),6)';ip=1;
if size(matIP,1)==1;    matIP=matIP(:);end
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
    outcomeTimes = squeeze(Analysis.AllData.OutcomeTime(2,thisFilter,:));
    if size(outcomeTimes,2)==2
    uniqueTimes = unique(outcomeTimes(:,1));
    else
        uniqueTimes = unique(outcomeTimes( 1));
    end
    tempPhoto_470 = squeeze( Analysis.AllData.Photo_470.DFF(stateNb,thisFilter,1:end));
           
    tempLick = squeeze( Analysis.AllData.Licks.Rate(stateNb,thisFilter,:));

    if size(tempPhoto_470,2)==1
        tempPhoto_470=tempPhoto_470';
        tempLick=tempLick';
        tempWheel =  diff( squeeze(Analysis.AllData.Wheel.Distance(stateNb,thisFilter,:)),[],1);tempWheel=tempWheel';
    else
         tempWheel =  diff( squeeze(Analysis.AllData.Wheel.Distance(stateNb,thisFilter,:)),[],2);
    end
    tempPhoto_470 = cat(1,tempPhoto_470,nan.*ones(1,size(tempPhoto_470,2)));
    tempWheel = cat(1,tempWheel,nan.*ones(1,size(tempWheel,2)));
    tempLick = cat(1,tempLick,nan.*ones(1,size(tempLick,2)));
    trialsNb =find(thisFilter==1);
    tempTime = Analysis.AllData.Photo_470.Time(stateNb,thisFilter,:);
    
    timesD = [] ; blocksPhoto = [];
    for uT=1:length(uniqueTimes)
        idT = find(outcomeTimes(:,1) == uniqueTimes(uT));
        timesD = cat(2,timesD, squeeze( tempTime(1,idT(1),1:end)));
        blocksPhoto = cat(1,blocksPhoto,tempPhoto_470(idT,:)); 
    end

    newTime = min(timesD(:)):.05:max(timesD(:));
    blocksAlligned = zeros(size(blocksPhoto,1),length(newTime));ii=1;
    for uT=1:length(uniqueTimes)
        idT = find(outcomeTimes(:,1) == uniqueTimes(uT));
        temp = tempPhoto_470(idT,:);
        interpTemp =  interp1(squeeze( tempTime(1,idT(1),1:end)),temp',newTime);
        blocksAlligned(ii:ii+length(idT)-1,1:length(interpTemp)) = interpTemp';
        ii=ii+length(idT);
    end
    idT=find(thisFilter==1);idT=idT(1);
    timeD = squeeze( Analysis.AllData.Photo_470.Time(stateNb,idT,1:end));
    timeV = linspace(timeD(1),timeD(end),length(timeD)-1);
    subplot(6,length(trialTypes),matIP(1,ip)); 
    shadedErrorBar(newTime,nanmean(blocksAlligned(:,1:end),1),...
        nanstd((blocksAlligned(:,1:end)),[],1)./(sqrt(size(blocksAlligned,1))),'-b',1)
    hold on
    plot([0 0],[0 maxY{1}],'Color',[.5 .5 .5]);
    plot(squeeze( Analysis.AllData.CueTime(stateNb,1,:)),[maxY{1} maxY{1}],'Color',[.7 .7 .7],'LineWidth',2,'LineStyle','-');

    if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
        if optoStimOffset-optoStimOnset>1e-6
            plot([optoStimOnset optoStimOffset],[maxY{1}*.9 maxY{1}*.9],'Color',[1. 0.3333   0],'LineWidth',2,'LineStyle','-');
        end
    end
    box off  
    ylabel('DF/F0')
    if tT==1
        try
            title([ {strrep(DefaultParam.FileList(1:end-4),'_',' ');   Analysis.Properties.TrialNames{tT}  }]);          
        catch
            title([ {strrep(DefaultParam.FileToOpen(1:end-4),'_',' ');   Analysis.Properties.TrialNames{tT}  }]);          
        end
    else
        title([  Analysis.Properties.TrialNames{tT}  ]);          
    end
    ax=gca;ax.XLim=[timeD(1) timeD(end)];
    ax.YLim =[minY{1} maxY{1}+.1];
     
    subplot(6,length(trialTypes),matIP(2,ip)); 
    shadedErrorBar(timeV,nanmean(abs(tempWheel(:,1:end)),1),...
        nanstd(abs(tempWheel(:,1:end)),[],1)./(sqrt(size(tempWheel,1))),'-r',1)
    hold on
    plot([0 0],[0 maxY{2}],'Color',[.5 .5 .5]);
    plot(squeeze( Analysis.AllData.CueTime(stateNb,1,:)),[maxY{2} maxY{2}].*.75,'Color',[.7 .7 .7],'LineWidth',2,'LineStyle','-');
    if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
        if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
            if optoStimOffset-optoStimOnset>1e-6
                plot([optoStimOnset optoStimOffset],[maxY{2}*.9 maxY{2}*.9],'Color',[1. 0.3333   0],'LineWidth',2,'LineStyle','-');
            end
        end
    end
    ylabel('Velocity (cm/s)')
    ax=gca;ax.XLim=[timeD(1) timeD(end)];
    ax.YLim =[minY{2} maxY{2}+.1];
   
    subplot(6,length(trialTypes),matIP(3,ip))
    shadedErrorBar(Analysis.AllData.Licks.Bin{1}(2:end) ,nanmean(tempLick,1),...
        nanstd(tempLick,[],1)./(sqrt(size(tempWheel,1))),'-g',1)
    xlabel('Time (sec)')
    ylabel('Lick Rate (Hz)')
    hold on
    plot([0 0],[0 maxY{3}],'Color',[.5 .5 .5]);
    plot(squeeze( Analysis.AllData.CueTime(stateNb,1,:)),[maxY{3} maxY{3}] ,'Color',[.7 .7 .7],'LineWidth',2,'LineStyle','-');
    if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
    if optoStimOffset-optoStimOnset>1e-6
        plot([optoStimOnset optoStimOffset],[maxY{3}*.9 maxY{3}*.9],'Color',[1. 0.3333   0],'LineWidth',2,'LineStyle','-');
    end
    end
    ax=gca;ax.XLim=[timeD(1) timeD(end)];
    
    ax.YLim =[minY{3} maxY{3}+.1];

    subplot(6,length(trialTypes),matIP(4,ip))
    imagesc(newTime,trialsNb,blocksAlligned,[p10{1} p90{1}+.1]);hold on
    pos=get(gca,'pos');
    c=colorbar('location','eastoutside',...
        'position',[pos(1)+pos(3)*1.01  pos(2) 0.01 pos(4)]);   
    c.Label.String ='DF/F0';
    plot([0 0],[0 max(trialsNb)],'-k');c.Label.FontSize =7;
    plot([Analysis.AllData.CueTime(1,1) Analysis.AllData.CueTime(1,1)],[0 max(trialsNb)],'Color',[.7 .7 .7] );
    if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
    if optoStimOffset-optoStimOnset>1e-6
        plot([optoStimOnset optoStimOnset],[0 max(trialsNb)],'Color',[1. 0.3333   0] );
    end
    end
    if tT==1
        ylabel('Trial Nb')
    end
    ax=gca; ax.XLim=[timeD(1) timeD(end)];
    
    subplot(6,length(trialTypes),matIP(5,ip))
    imagesc(timeV,trialsNb,abs(tempWheel),[p10{2} p90{2}+.1]);hold on
    pos=get(gca,'pos');
    c=colorbar('location','eastoutside',...
        'position',[pos(1)+pos(3)*1.01  pos(2) 0.01 pos(4)]);       
    c.Label.String ='Velocity cm/s';c.Label.FontSize =7;
    plot([0 0],[0 max(trialsNb)],'-k');
    plot([Analysis.AllData.CueTime(1,1) Analysis.AllData.CueTime(1,1)],[0 max(trialsNb)],'Color',[.7 .7 .7] );
    if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
    if optoStimOffset-optoStimOnset>1e-6
        plot([optoStimOnset optoStimOnset],[0 max(trialsNb)],'Color',[1. 0.3333   0] );
    end
    end
    if tT==1
       ylabel('Trial Nb')
    end
    ax=gca; ax.XLim=[timeD(1) timeD(end)];
    
    subplot(6,length(trialTypes),matIP(6,ip))
    imagesc(Analysis.AllData.Licks.Bin{1}(2:end) ,trialsNb,tempLick,[p10{3}  max(p90{3},1)]);hold on
    pos=get(gca,'pos');
    c=colorbar('location','eastoutside',...
        'position',[pos(1)+pos(3)*1.01  pos(2) 0.01 pos(4)]);    
    c.Label.String ='Lick Rate (Hz)';c.Label.FontSize =7;
    plot([0 0],[0 max(trialsNb)],'-k');
    plot([Analysis.AllData.CueTime(1,1) Analysis.AllData.CueTime(1,1)],[0 max(trialsNb)],'Color',[.7 .7 .7] );
    if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
    if optoStimOffset-optoStimOnset>1e-6
        plot([optoStimOnset optoStimOnset],[0 max(trialsNb)],'Color',[1. 0.3333  0] );
    end
    end
    xlabel('Time (sec)')
    if tT==1
       ylabel('Trial Nb')
    end
    ax=gca; ax.XLim=[timeD(1) timeD(end)];
    ip=ip+1;    
end
saveas(gcf,[Analysis.Properties.DirFig '\' Analysis.Properties.Name '_' Analysis.Properties.StateToZero{stateNb} '_' 'summary_all' '.png']);
saveas(gcf,[Analysis.Properties.DirFig '\' Analysis.Properties.Name '_' Analysis.Properties.StateToZero{stateNb} '_' 'summary_all' '.m']);
end
end
=======
function AP_PlotSummary_AllSignals(Analysis,DefaultParam )
for stateNb=1:size(Analysis.AllData.Photo_470.DFF,1)
figure('units','normalized','position',[.1 .1 .7 .7])

idFilt=[];nbOfTrialTypes= Analysis.Properties.nbOfTrialTypes;
for i=1:nbOfTrialTypes
     [thisFilter] = getFilter(Analysis,i);   
     idFilt = [idFilt  thisFilter];
end
idTrials = 1:nbOfTrialTypes;
trialTypes = idTrials;
trialTypes(find(all(idFilt==0,1)))=[];
trialTypes(trialTypes>nbOfTrialTypes)=[];

minY = {[] [] []};p90 = {[] [] []};p10 = {[] [] []};maxY ={[] [] []};
for tT = trialTypes
    [thisFilter] = getFilter(Analysis,tT);    
    tempPhoto_470 = squeeze( Analysis.AllData.Photo_470.DFF(stateNb,thisFilter,1:end));
    maxY{1}= [maxY{1} max(nanmean(tempPhoto_470(:,1:end),1)+ nanstd((tempPhoto_470(:,1:end)),[],1)./(sqrt(size(tempPhoto_470,1))))];
    minY{1}= [minY{1} min(nanmean(tempPhoto_470(:,1:end),1)+ nanstd((tempPhoto_470(:,1:end)),[],1)./(sqrt(size(tempPhoto_470,1))))];
    p90{1} = [p90{1} prctile(tempPhoto_470,90)];
    p10{1} = [p10{1} prctile(tempPhoto_470,10)];
    
    tempWheel =  diff( squeeze(Analysis.AllData.Wheel.Distance(stateNb,thisFilter,:)),[],2);
    maxY{2}= [maxY{2} max(nanmean(tempWheel(:,1:end),1)+ nanstd((tempWheel(:,1:end)),[],1)./(sqrt(size(tempWheel,1))))];
    minY{2}= [minY{2} min(nanmean(tempWheel(:,1:end),1)+ nanstd((tempWheel(:,1:end)),[],1)./(sqrt(size(tempWheel,1))))];
    p90{2} = [p90{2} prctile(tempWheel,90)];
    p10{2} = [p10{2} prctile(tempWheel,10)];
    
    tempLick = squeeze( Analysis.AllData.Licks.Rate(stateNb,thisFilter,:));
    maxY{3}= [maxY{3} max(nanmean(tempLick(:,1:end),1)+ nanstd((tempLick(:,1:end)),[],1)./(sqrt(size(tempLick,1))))];
    minY{3}= [minY{3} min(nanmean(tempLick(:,1:end),1)+ nanstd((tempLick(:,1:end)),[],1)./(sqrt(size(tempLick,1))))];
    p90{3} = [p90{3} prctile(tempLick,90)];
    p10{3} = [p10{3} prctile(tempLick,10)];
    
end
maxY{1}(isnan(maxY{1}))=[];maxY{1}=max(maxY{1});maxY{2}(isnan(maxY{2}))=[];maxY{2}=max(maxY{2});maxY{3}(isnan(maxY{3}))=[];maxY{3}=max(maxY{3});
minY{1}(isnan(minY{1}))=[];minY{1}=min(minY{1});minY{2}(isnan(minY{2}))=[];minY{2}=min(minY{2});minY{3}(isnan(minY{3}))=[];minY{3}=min(minY{3});
p90{1}(isnan(p90{1}))=[];p90{1}=max(p90{1});p90{2}(isnan(p90{2}))=[];p90{2}=max(p90{2});p90{3}(isnan(p90{3}))=[];p90{3}=max(p90{3});
p10{1}(isnan(p10{1}))=[];p10{1}=min(p10{1});p10{2}(isnan(p10{2}))=[];p10{2}=min(p10{2});p10{3}(isnan(p10{3}))=[];p10{3}=min(p10{3});

matIP =reshape( 1:(6*length(trialTypes)),length(trialTypes),6)';ip=1;
if size(matIP,1)==1;    matIP=matIP(:);end
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
    outcomeTimes = squeeze(Analysis.AllData.OutcomeTime(2,thisFilter,:));
    if size(outcomeTimes,2)==2
    uniqueTimes = unique(outcomeTimes(:,1));
    else
        uniqueTimes = unique(outcomeTimes( 1));
    end
    tempPhoto_470 = squeeze( Analysis.AllData.Photo_470.DFF(stateNb,thisFilter,1:end));
           
    tempLick = squeeze( Analysis.AllData.Licks.Rate(stateNb,thisFilter,:));

    if size(tempPhoto_470,2)==1
        tempPhoto_470=tempPhoto_470';
        tempLick=tempLick';
        tempWheel =  diff( squeeze(Analysis.AllData.Wheel.Distance(stateNb,thisFilter,:)),[],1);tempWheel=tempWheel';
    else
         tempWheel =  diff( squeeze(Analysis.AllData.Wheel.Distance(stateNb,thisFilter,:)),[],2);
    end
    tempPhoto_470 = cat(1,tempPhoto_470,nan.*ones(1,size(tempPhoto_470,2)));
    tempWheel = cat(1,tempWheel,nan.*ones(1,size(tempWheel,2)));
    tempLick = cat(1,tempLick,nan.*ones(1,size(tempLick,2)));
    trialsNb =find(thisFilter==1);
    tempTime = Analysis.AllData.Photo_470.Time(stateNb,thisFilter,:);
    
    timesD = [] ; blocksPhoto = [];
    for uT=1:length(uniqueTimes)
        idT = find(outcomeTimes(:,1) == uniqueTimes(uT));
        timesD = cat(2,timesD, squeeze( tempTime(1,idT(1),1:end)));
        blocksPhoto = cat(1,blocksPhoto,tempPhoto_470(idT,:)); 
    end

    newTime = min(timesD(:)):.05:max(timesD(:));
    blocksAlligned = zeros(size(blocksPhoto,1),length(newTime));ii=1;
    for uT=1:length(uniqueTimes)
        idT = find(outcomeTimes(:,1) == uniqueTimes(uT));
        temp = tempPhoto_470(idT,:);
        interpTemp =  interp1(squeeze( tempTime(1,idT(1),1:end)),temp',newTime);
        blocksAlligned(ii:ii+length(idT)-1,1:length(interpTemp)) = interpTemp';
        ii=ii+length(idT);
    end
    idT=find(thisFilter==1);idT=idT(1);
    timeD = squeeze( Analysis.AllData.Photo_470.Time(stateNb,idT,1:end));
    timeV = linspace(timeD(1),timeD(end),length(timeD)-1);
    subplot(6,length(trialTypes),matIP(1,ip)); 
    shadedErrorBar(newTime,nanmean(blocksAlligned(:,1:end),1),...
        nanstd((blocksAlligned(:,1:end)),[],1)./(sqrt(size(blocksAlligned,1))),'-b',1)
    hold on
    plot([0 0],[0 maxY{1}],'Color',[.5 .5 .5]);
    plot(squeeze( Analysis.AllData.CueTime(stateNb,1,:)),[maxY{1} maxY{1}],'Color',[.7 .7 .7],'LineWidth',2,'LineStyle','-');

    if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
        if optoStimOffset-optoStimOnset>1e-6
            plot([optoStimOnset optoStimOffset],[maxY{1}*.9 maxY{1}*.9],'Color',[1. 0.3333   0],'LineWidth',2,'LineStyle','-');
        end
    end
    box off  
    ylabel('DF/F0')
    if tT==1
        try
            title([ {strrep(DefaultParam.FileList(1:end-4),'_',' ');   Analysis.Properties.TrialNames{tT}  }]);          
        catch
            title([ {strrep(DefaultParam.FileToOpen(1:end-4),'_',' ');   Analysis.Properties.TrialNames{tT}  }]);          
        end
    else
        title([  Analysis.Properties.TrialNames{tT}  ]);          
    end
    ax=gca;ax.XLim=[timeD(1) timeD(end)];
    ax.YLim =[minY{1} maxY{1}+.1];
     
    subplot(6,length(trialTypes),matIP(2,ip)); 
    shadedErrorBar(timeV,nanmean(abs(tempWheel(:,1:end)),1),...
        nanstd(abs(tempWheel(:,1:end)),[],1)./(sqrt(size(tempWheel,1))),'-r',1)
    hold on
    plot([0 0],[0 maxY{2}],'Color',[.5 .5 .5]);
    plot(squeeze( Analysis.AllData.CueTime(stateNb,1,:)),[maxY{2} maxY{2}].*.75,'Color',[.7 .7 .7],'LineWidth',2,'LineStyle','-');
    if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
        if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
            if optoStimOffset-optoStimOnset>1e-6
                plot([optoStimOnset optoStimOffset],[maxY{2}*.9 maxY{2}*.9],'Color',[1. 0.3333   0],'LineWidth',2,'LineStyle','-');
            end
        end
    end
    ylabel('Velocity (cm/s)')
    ax=gca;ax.XLim=[timeD(1) timeD(end)];
    ax.YLim =[minY{2} maxY{2}+.1];
   
    subplot(6,length(trialTypes),matIP(3,ip))
    shadedErrorBar(Analysis.AllData.Licks.Bin{1}(2:end) ,nanmean(tempLick,1),...
        nanstd(tempLick,[],1)./(sqrt(size(tempWheel,1))),'-g',1)
    xlabel('Time (sec)')
    ylabel('Lick Rate (Hz)')
    hold on
    plot([0 0],[0 maxY{3}],'Color',[.5 .5 .5]);
    plot(squeeze( Analysis.AllData.CueTime(stateNb,1,:)),[maxY{3} maxY{3}] ,'Color',[.7 .7 .7],'LineWidth',2,'LineStyle','-');
    if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
    if optoStimOffset-optoStimOnset>1e-6
        plot([optoStimOnset optoStimOffset],[maxY{3}*.9 maxY{3}*.9],'Color',[1. 0.3333   0],'LineWidth',2,'LineStyle','-');
    end
    end
    ax=gca;ax.XLim=[timeD(1) timeD(end)];
    
    ax.YLim =[minY{3} maxY{3}+.1];

    subplot(6,length(trialTypes),matIP(4,ip))
    imagesc(newTime,trialsNb,blocksAlligned,[p10{1} p90{1}+.1]);hold on
    pos=get(gca,'pos');
    c=colorbar('location','eastoutside',...
        'position',[pos(1)+pos(3)*1.01  pos(2) 0.01 pos(4)]);   
    c.Label.String ='DF/F0';
    plot([0 0],[0 max(trialsNb)],'-k');c.Label.FontSize =7;
    plot([Analysis.AllData.CueTime(1,1) Analysis.AllData.CueTime(1,1)],[0 max(trialsNb)],'Color',[.7 .7 .7] );
    if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
    if optoStimOffset-optoStimOnset>1e-6
        plot([optoStimOnset optoStimOnset],[0 max(trialsNb)],'Color',[1. 0.3333   0] );
    end
    end
    if tT==1
        ylabel('Trial Nb')
    end
    ax=gca; ax.XLim=[timeD(1) timeD(end)];
    
    subplot(6,length(trialTypes),matIP(5,ip))
    imagesc(timeV,trialsNb,abs(tempWheel),[p10{2} p90{2}+.1]);hold on
    pos=get(gca,'pos');
    c=colorbar('location','eastoutside',...
        'position',[pos(1)+pos(3)*1.01  pos(2) 0.01 pos(4)]);       
    c.Label.String ='Velocity cm/s';c.Label.FontSize =7;
    plot([0 0],[0 max(trialsNb)],'-k');
    plot([Analysis.AllData.CueTime(1,1) Analysis.AllData.CueTime(1,1)],[0 max(trialsNb)],'Color',[.7 .7 .7] );
    if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
    if optoStimOffset-optoStimOnset>1e-6
        plot([optoStimOnset optoStimOnset],[0 max(trialsNb)],'Color',[1. 0.3333   0] );
    end
    end
    if tT==1
       ylabel('Trial Nb')
    end
    ax=gca; ax.XLim=[timeD(1) timeD(end)];
    
    subplot(6,length(trialTypes),matIP(6,ip))
    imagesc(Analysis.AllData.Licks.Bin{1}(2:end) ,trialsNb,tempLick,[p10{3}  max(p90{3},1)]);hold on
    pos=get(gca,'pos');
    c=colorbar('location','eastoutside',...
        'position',[pos(1)+pos(3)*1.01  pos(2) 0.01 pos(4)]);    
    c.Label.String ='Lick Rate (Hz)';c.Label.FontSize =7;
    plot([0 0],[0 max(trialsNb)],'-k');
    plot([Analysis.AllData.CueTime(1,1) Analysis.AllData.CueTime(1,1)],[0 max(trialsNb)],'Color',[.7 .7 .7] );
    if ~isempty(strfind( Analysis.Properties.TrialNames{tT},'Opto'))
    if optoStimOffset-optoStimOnset>1e-6
        plot([optoStimOnset optoStimOnset],[0 max(trialsNb)],'Color',[1. 0.3333  0] );
    end
    end
    xlabel('Time (sec)')
    if tT==1
       ylabel('Trial Nb')
    end
    ax=gca; ax.XLim=[timeD(1) timeD(end)];
    ip=ip+1;    
end
saveas(gcf,[Analysis.Properties.DirFig '\' Analysis.Properties.Name '_' Analysis.Properties.StateToZero{stateNb} '_' 'summary_all' '.png']);
saveas(gcf,[Analysis.Properties.DirFig '\' Analysis.Properties.Name '_' Analysis.Properties.StateToZero{stateNb} '_' 'summary_all' '.m']);
end
end
>>>>>>> 9216c3fa548d9fd3c5bc671904761c959f3a562b
 