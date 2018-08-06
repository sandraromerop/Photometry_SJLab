function AP_PlotSelfStim(Analysis)

% ---------------------------------------------------------------- Plots
% Responses in time
timeFromPoke = Analysis.DefaultParam.timeFromPoke;
protocol =Analysis.DefaultParam.protocol;
subject =Analysis.DefaultParam.subject;
date =Analysis.DefaultParam.date;
session =Analysis.DefaultParam.session;
startPoke = Analysis.startPoke ;

% startId = find(Analysis.ResponseTimeFromPoke1/20>=0);startId=startId(1);
% endId = find(Analysis.ResponseTimeFromPoke1/20<=timeFromPoke);endId=endId(end);

startId = find(Analysis.ResponseTimeFromPoke1/60>=0);startId=startId(1);
endId = find(Analysis.ResponseTimeFromPoke1/60<=timeFromPoke);endId=endId(end);



temp = Analysis.ResponseTimeFromPoke1/60;temp = temp(startId:endId);
% startBin = find((Analysis.Bins-startPoke)/20>=0);startBin=startBin(1);
% endBin = find((Analysis.Bins-startPoke)/20<=timeFromPoke);endBin=endBin(end);
% temp = Analysis.ResponseTimeFromPoke1/60;temp = temp(startId:endId);
startBin = find((Analysis.Bins-startPoke)/60>=0);startBin=startBin(1);
endBin = find((Analysis.Bins-startPoke)/60<=timeFromPoke);endBin=endBin(end);


figure('units','normalized','position',[.2 .2 .5 .5])
subplot(2,2,1)
plot(temp(find(Analysis.Logicals(startId:endId,1)==1)),ones(1,length(find(Analysis.Logicals(startId:endId,1)==1))),'o','Color','blue');
hold on
plot(temp(find(Analysis.Logicals(startId:endId,2)==1)),2*ones(1,length(find(Analysis.Logicals(startId:endId,2)==1))),'o','Color','red');
ax=gca;ax.YLim=[0 3];
xlabel('Time from  First Poke  (min)');ylabel('Trial Type');
ax.YTick = [ 1 2];ax.YTickLabels = {'Laser','Sham Laser'};
title([protocol ' ' subject  ' ' strrep(date ,'_',' ') ' -Session ' num2str(session )]);

% Percentages
subplot(2,2,2)
bar(1,Analysis.PercentagesFromPoke1(1),'FaceColor','blue','EdgeColor','blue');hold on
bar(2,Analysis.PercentagesFromPoke1(2),'FaceColor','red','EdgeColor','red');
ylabel('Percentage of Trials from First Poke')
ax=gca;ax.YLim=[0 100];
ax.XTick = [ 1 2];ax.XTickLabels = {[  'Laser (' num2str( ceil( Analysis.PercentagesFromPoke1(1)*10 )/10   ) '%)' ],...
    ['Sham Laser (' num2str( ceil( Analysis.PercentagesFromPoke1(2)*10 )/10   ) '%)']};

subplot(2,2,3)
bar((Analysis.Bins(startBin:endBin-1)-Analysis.startPoke )/60, Analysis.PokeRates(1,startBin:endBin-1),'FaceColor','blue');hold on
bar((Analysis.Bins(startBin:endBin-1)-Analysis.startPoke )/60, Analysis.PokeRates(2,startBin:endBin-1),'FaceColor','red');
xlabel('Time from  First Poke (min)');ylabel('Poke Rate (Hz)');
legend('Laser','Sham Laser')
