function AP_PlotSummary_AllSignals(Analysis,DefaultParam )

figure('units','normalized','position',[.1 .1 .7 .7])
p90(1) = prctile(Analysis.AllData.Photo_470.DFF(:),90);p10(1) = prctile(Analysis.AllData.Photo_470.DFF(:),10);
velocity = abs(diff( Analysis.AllData.Wheel.Distance,[],2));
p90(2) = prctile(velocity(:),90);p10(2) = prctile(velocity(:),10);
p90(3) = max(Analysis.AllData.Licks.Rate(:));p10(3) = prctile(Analysis.AllData.Licks.Rate(:),10);
timeD = Analysis.AllData.Photo_470.Time(1,1:end);
timeV = linspace(timeD(1),timeD(end),length(timeD)-1);
optoStimOnset =-[ Analysis.AllData.States{1}.Outcome(1)-...
    Analysis.AllData.States{1}.PhotoStim(1)];
optoStimOffset =-[ Analysis.AllData.States{1}.Outcome(1)-...
    Analysis.AllData.States{1}.PhotoStim(2)];


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
matIP =reshape( 1:(5*length(trialTypes)),length(trialTypes),5)';
if size(matIP,1)==1
    matIP=matIP(:);
end
ip=1;
for tT = trialTypes
    %try 
    [thisFilter] = getFilter(Analysis,tT);    
    tempPhoto_470 = Analysis.AllData.Photo_470.DFF(thisFilter,1:end);
    tempWheel =diff( Analysis.AllData.Wheel.Distance(thisFilter,:),[],2);
    tempLick = Analysis.AllData.Licks.Rate(thisFilter,:);
    trialsNb =find(thisFilter==1);
    tempWheel = cat(1,tempWheel,nan.*ones(1,size(tempWheel,2)));
    tempPhoto_470 = cat(1,tempPhoto_470,nan.*ones(1,size(tempPhoto_470,2)));
    tempLick = cat(1,tempLick,nan.*ones(1,size(tempLick,2)));
    
    subplot(5,length(trialTypes),matIP(1,ip));%ip=ip+1;
    yyaxis right
    shadedErrorBar(timeV,nanmean(abs(tempWheel(:,1:end)),1),...
        nanstd(abs(tempWheel(:,1:end)),[],1)./(sqrt(size(tempWheel,1))),'-r',1)
    maxY = max(nanmean( (tempPhoto_470(:,1:end))))+ max(0.5*nanstd( (tempPhoto_470(:,1:end)))./(sqrt(size(tempPhoto_470,1))))+1;
    ylabel('Velocity (cm/s)')
    yyaxis left
    shadedErrorBar(timeD,nanmean(tempPhoto_470(:,1:end),1),...
        nanstd((tempPhoto_470(:,1:end)),[],1)./(sqrt(size(tempPhoto_470,1))),'-b',1)
    ylabel('DF/F0')
    maxY = max(nanmean( (tempPhoto_470(:,1:end))))+max(0.5*nanstd( (tempPhoto_470(:,1:end)))./(sqrt(size(tempPhoto_470,1))))+1;
    maxY(isnan(maxY))=0;
    hold on
    plot([0 0],[0 maxY],'Color',[.5 .5 .5]);
    plot(Analysis.AllData.CueTime(1,:),[maxY maxY],'Color',[.7 .7 .7],'LineWidth',2,'LineStyle','-');
    if optoStimOffset-optoStimOnset>1e-6
        plot([optoStimOnset optoStimOffset],[maxY*.9 maxY*.9],'Color',[1. 0.3333   0],'LineWidth',2,'LineStyle','-');
    end
    xlabel('Time (sec)')
    box off  
    title([ {strrep(DefaultParam.FileList(1:end-4),'_',' ');   Analysis.Properties.TrialNames{tT}  }]);          
    ax=gca;ax.XLim=[-5 5];
    
    subplot(5,length(trialTypes),matIP(2,ip))
    shadedErrorBar(Analysis.AllData.Licks.Bin{1}(2:end) ,nanmean(tempLick,1),...
        nanstd(tempLick,[],1)./(sqrt(size(tempWheel,1))),'-g',1)
    xlabel('Time (sec)')
    ylabel('Lick Rate (Hz)')
    maxY = max(nanmean(abs(tempLick(:,1:end))))+max(0.5*nanstd( (tempLick(:,1:end)))./(sqrt(size(tempLick,1))))+1;
    hold on
    maxY(isnan(maxY))=0;
    plot([0 0],[0 maxY],'Color',[.5 .5 .5]);
    plot(Analysis.AllData.CueTime(1,:),[maxY  maxY ],'Color',[.7 .7 .7],'LineWidth',2,'LineStyle','-');
    if optoStimOffset-optoStimOnset>1e-6
        plot([optoStimOnset optoStimOffset],[maxY*.9 maxY*.9],'Color',[1. 0.3333   0],'LineWidth',2,'LineStyle','-');
    end
    ax=gca;ax.XLim=[-5 5];

    subplot(5,length(trialTypes),matIP(3,ip))
    imagesc(timeD,trialsNb,tempPhoto_470,[p10(1) p90(1)+.1]);hold on
    pos=get(gca,'pos');
    c=colorbar('location','eastoutside',...
        'position',[pos(1)+pos(3)*1.01  pos(2) 0.01 pos(4)]);   
    c.Label.String ='DF/F0';
    plot([0 0],[0 max(trialsNb)],'-k');c.Label.FontSize =7;
    plot([Analysis.AllData.CueTime(1,1) Analysis.AllData.CueTime(1,1)],[0 max(trialsNb)],'Color',[.7 .7 .7] );
    if optoStimOffset-optoStimOnset>1e-6
        plot([optoStimOnset optoStimOnset],[0 max(trialsNb)],'Color',[1. 0.3333   0] );
    end
    if tT==1
        ylabel('Trial Nb')
    end
    ax=gca; ax.XLim=[-5 5];
    
    subplot(5,length(trialTypes),matIP(4,ip))
    imagesc(timeV,trialsNb,abs(tempWheel),[p10(2) p90(2)+.1]);hold on
    pos=get(gca,'pos');
    c=colorbar('location','eastoutside',...
        'position',[pos(1)+pos(3)*1.01  pos(2) 0.01 pos(4)]);       
    c.Label.String ='Velocity cm/s';c.Label.FontSize =7;
    plot([0 0],[0 max(trialsNb)],'-k');
    plot([Analysis.AllData.CueTime(1,1) Analysis.AllData.CueTime(1,1)],[0 max(trialsNb)],'Color',[.7 .7 .7] );
    if optoStimOffset-optoStimOnset>1e-6
        plot([optoStimOnset optoStimOnset],[0 max(trialsNb)],'Color',[1. 0.3333   0] );
    end
    if tT==1
       ylabel('Trial Nb')
    end
    ax=gca; ax.XLim=[-5 5];
    
    subplot(5,length(trialTypes),matIP(5,ip))
    imagesc(Analysis.AllData.Licks.Bin{1}(2:end) ,trialsNb,tempLick,[p10(3)  max(p90(3),1)]);hold on
    pos=get(gca,'pos');
    c=colorbar('location','eastoutside',...
        'position',[pos(1)+pos(3)*1.01  pos(2) 0.01 pos(4)]);    
    c.Label.String ='Lick Rate (Hz)';c.Label.FontSize =7;
    plot([0 0],[0 max(trialsNb)],'-k');
    plot([Analysis.AllData.CueTime(1,1) Analysis.AllData.CueTime(1,1)],[0 max(trialsNb)],'Color',[.7 .7 .7] );
    if optoStimOffset-optoStimOnset>1e-6
        plot([optoStimOnset optoStimOnset],[0 max(trialsNb)],'Color',[1. 0.3333  0] );
    end
    xlabel('Time (sec)')
    if tT==1
       ylabel('Trial Nb')
    end
    ax=gca; ax.XLim=[-5 5];
    
 %   end
ip=ip+1;
end
saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name 'summary_all' '.png']);
saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name 'summary_all' '.m']);

end
 