% Code analysis Self stimulation
close all
generalDir = 'F:\Data\';
subject ='mar025' ;
session = 1;
date = 'Jul10_2018';
protocol = 'Self-Stimulation';
n=1;
clear Analysis

DefaultParam.binRate =1;
DefaultParam.timeFromPoke  = 20 ; %minutes
DefaultParam.generalDir = generalDir;
DefaultParam.protocol  = protocol ;
DefaultParam.subject = subject ;
DefaultParam.date = date;
DefaultParam.session = session;

load([ generalDir  subject  '\' protocol '\Session Data\' ...
    subject   '_' strrep(protocol,'-','') '_' date   '_Session' num2str(session) '.mat'])


%% Get rate of poking across entire session for each port


% Do logic depending on if it was rewarded or not
binRate = DefaultParam.binRate ;
timeFromPoke = DefaultParam.timeFromPoke ;
Analysis.DefaultParam=DefaultParam;
nTrials = SessionData.nTrials;

logicals = zeros(nTrials,2);trialTypes = cell(nTrials,1);
trialStarts = SessionData.TrialStartTimestamp;


for n=nTrials:-1:1
    states(n) = SessionData.RawEvents.Trial{1,n}.States;
    if ~isnan(SessionData.RawEvents.Trial{1,n}.States.Laser(1))
        logicals(n,1) = 1;trialTypes{n} = 'Laser';
        trialPoke = n;
    else
        logicals(n,2) = 1;trialTypes{n} = 'ShamLaser';
    end
    responseTime(n) = SessionData.RawEvents.Trial{1,n}.States.WaitForResponse(end);
    responseTimeStamp(n)= trialStarts(n)+responseTime(n) ;
end
%startPoke = trialStarts(trialPoke);
startPoke = responseTimeStamp(trialPoke);

Analysis.startPoke = startPoke;
Analysis.Logicals = logicals;
Analysis.TrialTypes = trialTypes;
Analysis.TrialStarts = trialStarts(:);
Analysis.ResponseTimeStamp = responseTimeStamp(:);
Analysis.ResponseTimePerTrial = responseTime(:);% plot
Analysis.ResponseTimeFromStart = responseTimeStamp -trialStarts(1);% plot
Analysis.ResponseTimeFromPoke1 = responseTimeStamp -startPoke;% plot
%startId = find(Analysis.ResponseTimeFromPoke1/20>=0);startId=startId(1);
startId = find(Analysis.ResponseTimeFromPoke1/60>=0,1);startId=startId(1);

endId = find(Analysis.ResponseTimeFromPoke1/60<=timeFromPoke);endId=endId(end);

Analysis.PercentagesFromStart = sum(logicals)./(length(logicals))*100;
Analysis.PercentagesFromPoke1 = sum(logicals(startId:endId,:))./(length(logicals(startId:endId,:)))*100;


% Rate across Session  from first poke time
Analysis.Bins = Analysis.TrialStarts(1):binRate :Analysis.TrialStarts(end);
Analysis.PokeRates(1,:) = histcounts(responseTimeStamp(find(logicals(:,1)==1)),...
   Analysis.Bins)/binRate;
Analysis.PokeRates(2,:) = histcounts(responseTimeStamp(find(logicals(:,2)==1)),...
   Analysis.Bins)/binRate;



Analysis.Properties.Files=[subject  '_' strrep(protocol,'-','') '_' date  '_Session' num2str(session) '.mat'];
DirAnalysis=[ generalDir  subject  '\' protocol '\Session Data\Analysis\'];
if ~isdir(DirAnalysis)
    mkdir(DirAnalysis);
end
FileName=[subject  '_' strrep(protocol,'-','') '_' date  '_Session' num2str(session ) '_Analysis.mat'];
DirFile=[DirAnalysis FileName];
save(DirFile,'Analysis');


AP_PlotSelfStim(Analysis)


