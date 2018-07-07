% distribution of events 
%%
generalDir = 'F:\Photometry_SJLab\Data\';
subjects = {'mar021' ,'mar027'  ,'mar027','mar027','mar027'};
sessions = [1,2,3,4 ];
dates = {'Jun14_2018','Jun14_2018','Jun14_2018','Jun14_2018','Jun14_2018'};
protocol = 'CuedReward';
n=1;
dir = [  generalDir subjects{n} '\' protocol '\Session Data\'];
fileName = [ subjects{n} '_' protocol '_' dates{n} '_Session' num2str(sessions(n)) '.mat'];
load([dir fileName]);
%%
eventsTrials = [ SessionData.RawEvents.Trial];
targetValue = SessionData.RawEvents.Trial{1,nn}.States.SoundDelivery(1);

eventFields = fieldnames(SessionData.RawEvents.Trial{1,nn}.Events);

figure('units','normalized','position',[.1 .1 .25 .25])

for ff=2:length(eventFields)-1
    nameField = eventFields{ff};
    for nn=1:length(eventsTrials)
       eventTime(nn) =  eval([ 'SessionData.RawEvents.Trial{1,nn}.Events.' nameField ]);
    end
    subplot(2,ceil((length(eventFields)-1)/2),ff-1)
    histogram(eventTime, 200, 'Normalization','probability')
    hold on
    text(prctile(eventTime(:),90),.1,['Target Value: '  num2str(targetValue)])
    text(prctile(eventTime(:),90),.07,['Mean: '  num2str(mean(bnc2low))])
    text(prctile(eventTime(:),90),.05,['Std: '  num2str(std(bnc2low))])
    ylabel('Sound delivery')
    xlabel('Time (secs)')
end
