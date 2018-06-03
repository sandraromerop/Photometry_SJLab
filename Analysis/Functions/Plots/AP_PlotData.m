function Analysis=AP_PlotData(Analysis,channelnb)
%AP_PlotData generates a figure from the licks and 405 photometry data
%contained in the structure 'Analysis'. The figure shows for each trial types: 
%1) a raster plot of the licks events 
%2) the average lick rate
%3) a pseudocolored raster plot of the individual photometry traces
%4) the average photometry signal
%To plot the different graph, this function is using the parameters
%specified in Analysis.Properties
%
%function designed by Quentin 2016 for Analysis_Photometry

%% test for channels
if Analysis.Properties.Photometry==1
    if nargin==1
        channelnb=1;
    end
        thisChStruct=sprintf('Photo_%s',char(Analysis.Properties.PhotoCh{channelnb}));
        FigTitle=sprintf('Analysis-Plot %s',char(Analysis.Properties.PhotoCh{channelnb}));
    else
    FigTitle='Analysis-Plot';
end

%% Plot Parameters
labelx='Time (sec)';   
xTime=[Analysis.Properties.PlotEdges(1) Analysis.Properties.PlotEdges(2)];
xtickvalues=linspace(xTime(1),xTime(2),5);
labely1='Trial Number (licks)';
labely2='Licks Rate (Hz)';
if Analysis.Properties.Photometry==1
    labely3='Trial Number (DF/F)';
    labely4='DF/F (%)';
end
nbOfTrialTypes=Analysis.Properties.nbOfTrialTypes;
if nbOfTrialTypes>6
    nbOfPlots=nbOfTrialTypes;
else
    nbOfPlots=6;
end

% Automatic definition of axes
maxtrial=0; maxrate=10;
for i=1:nbOfTrialTypes
    
    if strcmp(Analysis.Filters.Names{1},'type_1')==false
        counter=0;
        for i=1:length(Analysis.Filters.Names)
            counter=counter+1;
            if strcmp(Analysis.Filters.Names{i},'type_1')
                newIndex=counter;
            end
        end
    else
        newIndex=0;
    end
    thisFilter=logical(Analysis.Filters.Logicals(:,i+newIndex));

    try
        %Raster plots y axes
        if sum(Analysis.Filters.Logicals(:,i)) > maxtrial %if Analysis.(thistype).nTrials > maxtrial
            maxtrial=sum(Analysis.Filters.Logicals(:,i)) ;% Analysis.(thistype).nTrials;
        end
        %Lick AVG y axes
        if max(mean(Analysis.AllData.Licks.Rate(thisFilter,:),1))>maxrate
            maxrate=max(mean(Analysis.AllData.Licks.Rate(thisFilter,:),1));
        end
    catch
        [];
    end
end


if Analysis.Properties.Photometry==1
    %Nidaq y axes
    if isempty(Analysis.Properties.NidaqRange)
            NidaqRange=[0-6*Analysis.Properties.NidaqSTD 6*Analysis.Properties.NidaqSTD];
            Analysis.Properties.NidaqRange=NidaqRange;
    else
        NidaqRange=Analysis.Properties.NidaqRange;
    end
end

%% Plot
    FigureLegend=sprintf('%s_%s',Analysis.Properties.Name,Analysis.Properties.Rig);
    figData.figure=figure('Name',FigTitle,'Position', [200 100 1200 700], 'numbertitle','off');
    Legend=uicontrol('style','text');
    set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

    idFilt=[];
    for i=1:nbOfTrialTypes
         [thisFilter] = getFilter(Analysis,i);   
         idFilt = [idFilt  thisFilter];
    end
    idDisc = find(all(idFilt==0,1)); trialTypes = 1:nbOfTrialTypes;trialTypes(idDisc)=[];
    
    thisplot=1;
    for i=1:length(trialTypes)
        
        [thisFilter] = getFilter(Analysis,trialTypes(i));   
        cueTimes = Analysis.AllData.CueTime(thisFilter,:);        
        cueTimes = cueTimes(1,:);
        time = Analysis.AllData.Photo_470.Time(1,:);
        nTrials= sum(thisFilter);
        
        % Lick Raster
        
        % -----------get data
        thisEvents                                      = Analysis.AllData.Licks.Events;
        thisEvents(thisFilter~=1) = '';   licksEvents   = cell2mat(thisEvents);
        thisTrials=cell(size(thisEvents));
        for j=1:length(thisTrials)
            thisTrials{1,j}=j*ones(length(thisEvents{1,j}),1)';
        end
        lickTrials                = cell2mat(thisTrials);        
        
        % ----------- plot
        subplot(6,nbOfPlots,[thisplot thisplot+nbOfPlots]); hold on;
        title(Analysis.Properties.TrialNames{1,i});%;title(Analysis.(thistype).Name);
        if thisplot==1
            ylabel(labely1);
        end
        set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial+1],'YDir','reverse');
        
        plot(licksEvents,lickTrials,'sk',...
            'MarkerSize',2,'MarkerFaceColor','k');
        plot([0 0],[0 maxtrial],'-r');
        plot(cueTimes,[0 0],'-b','LineWidth',2);
    
        % Lick AVG
        subplot(6,nbOfPlots,thisplot+(2*nbOfPlots)); hold on;
        if thisplot==1
            ylabel(labely2);
        end
        xlabel(labelx);
        set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxrate+1]);
        
        shadedErrorBar(Analysis.AllData.Licks.Bin{1}, [ mean(Analysis.AllData.Licks.Rate(thisFilter,:),1) 0 ],...
            [  std(Analysis.AllData.Licks.Rate(thisFilter,:),0,1)/sqrt( nTrials) 0],'-k',0);
        plot([0 0],[0 maxrate+1],'-r');
        plot(cueTimes,[maxrate maxrate],'-b','LineWidth',2);

        if Analysis.Properties.Photometry==1    

            % Nidaq Raster
            subplot(6,nbOfPlots,[thisplot+(3*nbOfPlots) thisplot+(4*nbOfPlots)]); hold on;
            if thisplot==1
                ylabel(labely3);
            end
            set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');
            imagesc(time ,0:nTrials,Analysis.AllData.(thisChStruct).DFF(thisFilter,:),NidaqRange);
            plot([0 0],[0 maxtrial],'-r');
            plot(cueTimes,[0 0],'-b','LineWidth',2);
            if thisplot==nbOfTrialTypes
                pos=get(gca,'pos');
                c=colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.01 pos(4)]);
                c.Label.String = labely4;
            end
            % Nidaq AVG
            subplot(6,nbOfPlots,thisplot+(5*nbOfPlots)); hold on;
            if thisplot==1
                ylabel(labely4);
            end
            xlabel(labelx);
            set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',NidaqRange);
            shadedErrorBar(time ,nanmean(Analysis.AllData.(thisChStruct).DFF(thisFilter,:),1),...
                nanstd(Analysis.AllData.(thisChStruct).DFF(thisFilter,:),0,1)/sqrt(nTrials),'-k',0);
            plot([0 0],NidaqRange,'-r');
            plot(cueTimes,[NidaqRange(2) NidaqRange(2)],'-b','LineWidth',2);
        end    
        thisplot=thisplot+1;
    end
end