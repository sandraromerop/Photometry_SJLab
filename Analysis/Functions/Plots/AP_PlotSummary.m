function AP_PlotSummary(Analysis,channelnb,varargin)

thisChStruct=sprintf('Photo_%s',char(Analysis.Properties.PhotoCh{channelnb}));
FigTitle=sprintf('Analysis-Plot Summary %s',char(Analysis.Properties.PhotoCh{channelnb}));

% get empty trials Nb
idFilt=[];nbOfTrialTypes= Analysis.Properties.nbOfTrialTypes;
for i=1:nbOfTrialTypes
     [thisFilter] = getFilter(Analysis,i);   
     idFilt = [idFilt  thisFilter];
end
idDisc = find(all(idFilt==0,1)); trialTypes = 1:nbOfTrialTypes;trialTypes(idDisc)=[];

%% Plot Parameters

nbofgroups=nargin-2;
color4plot={'-k';'-b';'-r';'-g';'-c';'-c';'-k'};
AVGPosition=Analysis.Properties.NidaqRange(1)/2;
for i=1:nbofgroups
    
    thisgroup=sprintf('thisgroup_%.0d',i);
	GP.(thisgroup).types=cell2mat(varargin(i));
    if ischar(GP.(thisgroup).types)
        GP.(thisgroup).types=A_NameToTrialNumber(Analysis,GP.(thisgroup).types);
    end
    GP.(thisgroup).types(isnan(GP.(thisgroup).types))=[];
    if ~isempty( GP.(thisgroup).types)
        k=1;
        for j=GP.(thisgroup).types 
            GP.(thisgroup).title(k)=Analysis.Properties.TrialNames(j);
            k=k+1;
        end
        [trialDisc idMetaDisc]= intersect(GP.(thisgroup).types,idDisc);
        GP.(thisgroup).title(idMetaDisc)=[];GP.(thisgroup).types(idMetaDisc)=[];
    else
        GP = rmfield(GP,thisgroup);
    end
    if ~isempty( GP.(thisgroup).types)
    else
        GP = rmfield(GP,thisgroup);
    end
end

nbofgroups = length(GP);
labelx='Time (sec)';   
xTime=[Analysis.Properties.PlotEdges(1) Analysis.Properties.PlotEdges(2)];
transparency=Analysis.Properties.Transparency;
xtickvalues=linspace(xTime(1),xTime(2),5);
labely1='Licks Rate (Hz)';
maxrate=30;
labely2='DF/F (%)';
NidaqRange=Analysis.Properties.NidaqRange;

%% Table Parameters
TableTitles={'Trial Type','Cue Max DF/F(%)','Cue AVG DF/F(%)','SEM','Outcome Max DF/F(%)','Outcome AVG DF/F(%)','SEM','nb of trials','ignored trials'};

TableData = [];k=1;
for i= (trialTypes)
    
    % -------------------------------
    trialTypeNb = i;
    [thisFilter] = getFilter(Analysis,trialTypeNb);
    time                = Analysis.AllData.Photo_470.Time(1,:);    
    cueTimes            = Analysis.AllData.CueTime(thisFilter,:);
    cueTimes = cueTimes(1,:)+Analysis.Properties.CueTimeReset;
    outcomeTimes        = Analysis.AllData.OutcomeTime(thisFilter,:);
    outcomeTimes = outcomeTimes(1,:)+Analysis.Properties.CueTimeReset;
    DFF                 = Analysis.AllData.(thisChStruct).DFF(thisFilter,:);
    cueDFF              = Analysis.AllData.(thisChStruct).Cue(thisFilter);
    outcomeDFF          = Analysis.AllData.(thisChStruct).Outcome(thisFilter);
    outcomeZ            = Analysis.AllData.(thisChStruct).OutcomeZ(thisFilter);
    nTrials             = sum(thisFilter);
    ignoredTrials       = Analysis.AllData.nTrials-nTrials;    
    avgDFF              = nanmean(DFF,1);
    
    TableData{k,1}	=   Analysis.Properties.TrialNames{1,i};
    TableData{k,2}	=   max(avgDFF(time >cueTimes(1) & time(1,:)<cueTimes(2))); % cueMax
    TableData{k,3}	=   nanmean(cueDFF,2); % cueAVG
    TableData{k,4}	=   nanstd(cueDFF,0,2)/sqrt(nTrials); %cueSEM
    TableData{k,5}	=   max(avgDFF(time >outcomeTimes(1) & time <outcomeTimes(2))); % outcomeMax
    TableData{k,6}  =   nanmean(outcomeDFF,2); % outcomeAVG
    TableData{k,7}  =   nanstd(outcomeDFF,0,2)/sqrt( nTrials); %outcomeSEM
    TableData{k,8}  =   nTrials;
    TableData{k,9}  =   ignoredTrials;
    k=k+1;
end

%% Figure
FigureLegend=sprintf('%s_%s',Analysis.Properties.Name,Analysis.Properties.Rig);
figData.figure=figure('Name',FigTitle,'Position', [200 100 1200 700], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

%% Table
spt=subplot(3,4,[9 11]);
pos=get(spt,'position');
delete(spt);

TypeWidth=100;
NbWidth=(pos(3)-TypeWidth)/(length(TableTitles)-1);
TableColumnWidth{1}=TypeWidth;
for i=2:length(TableTitles)
    TableColumnWidth{i}=70;
end

t=uitable('ColumnWidth',TableColumnWidth,'Data',TableData,'ColumnName',TableTitles);
set(t,'units','normalized');
set(t,'position',pos);

%% Bleach plot
subplot(3,4,12);
plot(Analysis.AllData.(thisChStruct).Bleach,'-k');
title('Bleaching')
xlabel('Trial Nb');
ylabel('Normalized Fluo');

%% Group plot
namesF = fieldnames(GP);
for i=1:length(namesF)
	thisgroup=namesF{i};
% Population of the plots
    k=1;
    for j=GP.(thisgroup).types
        trialTypeNb = j;[thisFilter] = getFilter(Analysis,trialTypeNb);
        subplot(3,4,i); hold on;
        lickBin=Analysis.AllData.Licks.Bin{thisFilter};
        hs=shadedErrorBar(lickBin,[ 0 mean(Analysis.AllData.Licks.Rate(thisFilter,:))],...
            [0 std(Analysis.AllData.Licks.Rate(thisFilter,:),0,1)/sqrt( nTrials)],color4plot{k},transparency); 
        hp(k)=hs.mainLine;
        subplot(3,4,i+4); hold on;
        shadedErrorBar(time,nanmean(Analysis.AllData.(thisChStruct).DFF(thisFilter,:)),...
            nanstd(Analysis.AllData.(thisChStruct).DFF(thisFilter,:),0,1)./sqrt(nTrials),color4plot{k},transparency);
        k=k+1;
        
    end
    % Makes Plot pretty
    subplot(3,4,i); hold on;
	if i==1
        ylabel(labely1);
    end
    plot([0 0],[0 maxrate],'-r');
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxrate]);
    title(num2str(GP.(thisgroup).types));
	legend(hp,GP.(thisgroup).title,'Location','northwest','FontSize',8);
    legend('boxoff');
    clear hp hs;

    subplot(3,4,i+4); hold on;
    if i==1
        ylabel(labely2);
    end
    xlabel(labelx);
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',NidaqRange);
    plot([0 0],NidaqRange,'-r');
    
    
	plot(Analysis.AllData.CueTime(1,:)+Analysis.Properties.CueTimeReset,[AVGPosition AVGPosition],'-b','LineWidth',2);
	plot(Analysis.AllData.OutcomeTime(1,:)+Analysis.Properties.OutcomeTimeReset,[AVGPosition AVGPosition],'-b','LineWidth',2);
end
end