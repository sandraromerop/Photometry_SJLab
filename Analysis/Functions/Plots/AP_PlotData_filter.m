function Analysis=AP_PlotData_filter(Analysis,sortedAnalysis,thistype,channelnb)
%AP_PlotData generates a figure
%function designed by Quentin 2017 for Analysis_Photometry
if nargin==2
    channelnb=1;
end
thisChStruct=sprintf('Photo_%s',char(Analysis.Properties.PhotoCh{channelnb}));
FigTitle=sprintf('Analysis-PlotSingle %s',char(Analysis.Properties.PhotoCh{channelnb}));

%% Close figures
try
    close FigTitle;
end

%% Plot Parameters
Title=sprintf('%s (%.0d)',strrep(sortedAnalysis.(thistype).Name,'_',' '),sortedAnalysis.(thistype).nTrials);
labelx='Time (sec)';   
xTime=[Analysis.Properties.PlotEdges(1) Analysis.Properties.PlotEdges(2)];
xtickvalues=linspace(xTime(1),xTime(2),5);
labely1='Trial Number (licks)';
labely2='Licks Rate (Hz)';
if Analysis.Properties.Photometry==1
    labely3='Trial Number (DF/F)';
    labely4='DF/F (%)';
end
transparency=0;
% Automatic definition of axes
maxtrial=sortedAnalysis.(thistype).nTrials;
if maxtrial<20
    maxtrial=20;
end
%Lick AVG y axes
maxrate=max(sortedAnalysis.(thistype).Licks.AVG);
if maxrate<10
    maxrate=10;
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
scrsz = get(groot,'ScreenSize');
FigureLegend=sprintf('%s_%s',Analysis.Properties.Name,Analysis.Properties.Rig);
figData.figure=figure('Name',FigTitle,'Position', [25 25 scrsz(3)/4 scrsz(4)-150], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

% Lick Raster
subplot(6,1,[1 2]); hold on;
title(Title);
ylabel(labely1);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial+1],'YDir','reverse');
plot(sortedAnalysis.(thistype).Licks.Events,sortedAnalysis.(thistype).Licks.Trials,'sk',...
    'MarkerSize',2,'MarkerFaceColor','k');
plot([0 0],[0 maxtrial],'-r');
plot(sortedAnalysis.(thistype).CueTime,[0 0],'-b','LineWidth',2);
% Lick AVG
subplot(6,1,3); hold on;
ylabel(labely2);
xlabel(labelx);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxrate+1]);
shadedErrorBar(sortedAnalysis.(thistype).Licks.Bin, sortedAnalysis.(thistype).Licks.AVG, sortedAnalysis.(thistype).Licks.SEM,'-k',transparency);
plot([0 0],[0 maxrate+1],'-r');
plot(sortedAnalysis.(thistype).CueTime,[maxrate maxrate],'-b','LineWidth',2);

if Analysis.Properties.Photometry==1    
% Nidaq Raster
subplot(6,1,[4 5]); hold on;
ylabel(labely3);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');
yrasternidaq=1:sortedAnalysis.(thistype).nTrials;
imagesc(sortedAnalysis.(thistype).(thisChStruct).Time(1,:),yrasternidaq,sortedAnalysis.(thistype).(thisChStruct).DFF,NidaqRange);
plot([0 0],[0 maxtrial],'-r');
plot(sortedAnalysis.(thistype).CueTime,[0 0],'-b','LineWidth',2);
pos=get(gca,'pos');
c=colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.01 pos(4)]);
c.Label.String = labely4;

% Nidaq AVG
subplot(6,1,6); hold on;
ylabel(labely4);
xlabel(labelx);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',NidaqRange);
shadedErrorBar(sortedAnalysis.(thistype).(thisChStruct).Time(1,:),sortedAnalysis.(thistype).(thisChStruct).DFFAVG,sortedAnalysis.(thistype).(thisChStruct).DFFSEM,'-k',transparency);
plot([0 0],NidaqRange,'-r');
plot(sortedAnalysis.(thistype).CueTime,[NidaqRange(2) NidaqRange(2)],'-b','LineWidth',2);
end    

end