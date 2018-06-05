%% Alligning fluorescence data to onset of locomotion initiation: 
%  regardless of reward delivery

%% Set
idTrials =7;
excitation = 0;
%%
if excitation==1
    factorStim=1;
else
    factorStim=-1;
end
timeD = Analysis.AllData.Photo_470.Time(1,1:end);
timeV = linspace(timeD(1),timeD(end),length(timeD)-1);
timeA = linspace(timeV(1),timeV(end),length(timeV)-1);

tempPhoto_470 = Analysis.AllData.Photo_470.DFF(:,1:end);
tempVeloc =abs(diff( Analysis.AllData.Wheel.Distance,[],2));
tempAcc =diff( tempVeloc,[],2);
tempLick = Analysis.AllData.Licks.Rate;

trialsNb =1:Analysis.AllData.nTrials;
tempVeloc = cat(1,tempVeloc,nan.*ones(1,size(tempVeloc,2)));
tempPhoto_470 = factorStim.*cat(1,tempPhoto_470,nan.*ones(1,size(tempPhoto_470,2)));
tempLick = cat(1,tempLick,nan.*ones(1,size(tempLick,2)));


optoStimOnset =-[ Analysis.AllData.States{1}.Outcome(1)-...
    Analysis.AllData.States{1}.PhotoStim(1)];
optoStimOffset =-[ Analysis.AllData.States{1}.Outcome(1)-...
    Analysis.AllData.States{1}.PhotoStim(2)];

temp = find(timeD>=optoStimOnset);optoStimOnsetId(1) = temp(1);
temp = find(timeV>=optoStimOnset);optoStimOnsetId(2) = temp(1);
temp = find(timeA>=optoStimOnset);optoStimOnsetId(3) = temp(1);

temp = find(timeD>=optoStimOffset);optoStimOffsetId(1) = temp(1);
temp = find(timeV>=optoStimOffset);optoStimOffsetId(2) = temp(1);
temp = find(timeA>=optoStimOffset);optoStimOffsetId(3) = temp(1);


% find peaks of excitation/or inhibition

for tT =1:length(idTrials)
tType = idTrials(tT);
idType = find(Analysis.Filters.Logicals(:,tType)==1);  
idKeep=[];
    for tt= 1:length(idType)
        ti = idType(tt);
        tempDF = smooth(tempPhoto_470(ti,:),2);maxDF(tt) = max(tempDF(optoStimOnsetId(1):optoStimOffsetId(1)));
        tempV = smooth(tempVeloc(ti,:),2);maxV(tt) = max(tempV(optoStimOnsetId(2):optoStimOffsetId(2)));
        tempA = smooth(tempAcc(ti,:),2);maxA(tt) = max(tempA(optoStimOnsetId(3):optoStimOffsetId(3)));
    end
end

% ------------------------------------------------------------
figure('units','normalized','position',[.1 .1 .5 .25])
subplot(1,2,1)
plot(maxDF,maxV,'+');hold on
xlabel('DF/F0'); ylabel('Velocity cm/s')
[ r p]= corr(maxDF(:), maxV(:));
text(min(maxDF), max(maxV)/2,['R2= ' num2str(r)])
mdl=fitlm(maxDF, maxV);
yy = predict(mdl,maxDF(:)); plot(maxDF,yy,'Color',[.7 .7 .7])
legend('Data','Linear Fit')

subplot(1,2,2)
plot(maxDF,maxA,'+');hold on
xlabel('DF/F0'); ylabel('Acceleration cm/s2')
[ r p]= corr(maxDF(:), maxA(:));
text(min(maxDF), max(maxA)/2,['R2= ' num2str(r)])
mdl=fitlm(maxDF, maxA);
yy = predict(mdl,maxDF(:)); plot(maxDF,yy,'Color',[.7 .7 .7])
legend('Data','Linear Fit')
% ------------------------------------------------------------