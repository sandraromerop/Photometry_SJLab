function Analysis = allignTraces(Analysis)

idFilt=[];nbOfTrialTypes= Analysis.Properties.nbOfTrialTypes;
for i=1:nbOfTrialTypes
     [thisFilter] = getFilter(Analysis,i);   
     idFilt = [idFilt  thisFilter];
end
idTrials = 1:nbOfTrialTypes;
trialTypes = idTrials;
trialTypes(find(all(idFilt==0,1)))=[];
trialTypes(trialTypes>nbOfTrialTypes)=[];
varType = [];
for tT = trialTypes
    [thisFilter] = getFilter(Analysis,tT);    
    outcomeTimes = squeeze(Analysis.AllData.OutcomeTime(2,thisFilter,:));
    if outcomeTimes(2)-outcomeTimes(1)~=0
        varType = [varType  tT]; 
    end
end


for stateNb=1:length(Analysis.Properties.StateToZero)
    for tT = varType
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
            tempTime = Analysis.AllData.Photo_470.Time(stateNb,thisFilter,:);

            blocksPhoto = []; meanPhoto = [];stdPhoto = [];
            blocksWheel = []; meanWheel = [];stdWheel = [];
            blocksLick = []; meanLick = [];stdLick = [];
            timesD = [] ; 
            for uT=1:length(uniqueTimes)
                idT = find(outcomeTimes(:,1) == uniqueTimes(uT));
                timeD = squeeze( tempTime(1,idT(1),1:end));
                timesD = cat(2,timesD,timeD);
                blocksPhoto = cat(1,blocksPhoto,tempPhoto_470(idT,:)); 
                meanPhoto = cat(1,meanPhoto,nanmean(tempPhoto_470(idT,:),1));stdPhoto = cat(1,stdPhoto,nanstd(tempPhoto_470(idT,:),[],1));
                blocksWheel = cat(1,blocksWheel,tempWheel(idT,:)); 
                meanWheel = cat(1,meanWheel,nanmean(tempWheel(idT,:),1)); stdWheel = cat(1,stdWheel,nanstd(tempWheel(idT,:),[],1));
                blocksLick = cat(1,blocksLick,tempLick(idT,:)); 
                meanLick = cat(1,meanLick,nanmean(tempLick(idT,:),1));stdLick = cat(1,stdLick,nanstd(tempLick(idT,:),[],1));
            end

          newTime = min(timesD(:)):.05:max(timesD(:));
          blocksAlligned = zeros(size(blocksPhoto,1),length(newTime));ii=1;
          meanPhotoAlligned=[];stdPhotoAlligned=[];
          for uT=1:length(uniqueTimes)
              idT = find(outcomeTimes(:,1) == uniqueTimes(uT));
              timeD = squeeze( tempTime(1,idT(1),1:end));
              temp = tempPhoto_470(idT,:);
              interpTemp =  interp1(timeD,temp',newTime);
              blocksAlligned(ii:ii+length(idT)-1,1:length(interpTemp)) = interpTemp';
              meanPhotoAlligned(uT,:) = nanmean(interpTemp',find(size(interpTemp')==length(idT)));
              stdPhotoAlligned(uT,:) = nanstd(interpTemp',[],find(size(interpTemp')==length(idT)));
              ii=ii+length(idT);
              eval(['Analysis.AllData.Photo_470.Alligned.DFF.' strrep(Analysis.Properties.TrialNames{tT}   ,' ' ,'') '{' num2str(uT) '}'  '= interpTemp;'])
          end
        eval(['Analysis.AllData.Photo_470.Alligned.meanDFF.' strrep(Analysis.Properties.TrialNames{tT},' ' ,'')  '= meanPhotoAlligned;'])
        eval(['Analysis.AllData.Photo_470.Alligned.outcomeTimes.' strrep(Analysis.Properties.TrialNames{tT},' ' ,'') '= uniqueTimes;'])
        
    end
end