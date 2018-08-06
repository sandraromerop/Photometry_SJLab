function ProgressMat = getProgressMat(sessionNames,generalDir,timings,minTrials) 
for iiS=1:length(sessionNames)  
    iiS
    load([ generalDir sessionNames{iiS}])
    for stateNb=1:size(Analysis.AllData.Photo_470.DFF,1)
        idFilt=[];nbOfTrialTypes= Analysis.Properties.nbOfTrialTypes;
        for i=1:nbOfTrialTypes
             [thisFilter] = getFilter(Analysis,i);   
             idFilt = [idFilt  thisFilter];
        end
        idTrials = 1:nbOfTrialTypes;
        trialTypes = idTrials;
        trialTypes(find(all(idFilt==0,1)))=[];
        trialTypes(trialTypes>nbOfTrialTypes)=[];        
        
        for tT = trialTypes 
            iiS;
            stateNb;
            tT;
            
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
           
            timesD = [] ; blocksPhoto = [];
            for uT=1:length(uniqueTimes)
                idT = find(outcomeTimes(:,1) == uniqueTimes(uT));
                timesD = cat(2,timesD, squeeze( tempTime(1,idT(1),1:end)));
                blocksPhoto = cat(1,blocksPhoto,tempPhoto_470(idT,:)); 
            end
            newTime = min(timesD(:)):.05:max(timesD(:));
            blocksAlligned = zeros(size(tempTime,1),length(newTime));ii=1;
            tempOutcomeTime = squeeze(Analysis.AllData.OutcomeTime(stateNb,thisFilter,:)) ;
            tempCueTime = squeeze(Analysis.AllData.CueTime(stateNb,thisFilter,:)) ;
            
            meanPhoto ={[] [] [] []};meanLick={[] [] [] []};
            maxPhoto ={[] [] [] []};maxLick={[] [] [] []};
            stdPhoto ={[] [] [] []};stdLick={[] [] [] []};
            
            
            for uT=1:length(uniqueTimes)
                 tempTimeLick =Analysis.AllData.Licks.Bin{1}(2:end);
                idT = find(outcomeTimes(:,1) == uniqueTimes(uT));
                temp = tempPhoto_470(idT,:);
                tempL= tempLick(idT,:);
                interpTemp =  interp1(squeeze( tempTime(1,idT(1),1:end)),temp',newTime);interpTemp=interpTemp';
                if size(interpTemp,2)==1
                    interpTemp=interpTemp';
                end
                blocksAlligned(ii:ii+length(idT)-1,1:length(interpTemp)) = interpTemp;
                
                
                
                id1 = [arrayfun(@(z) find(newTime>=z,1), tempCueTime(idT,1) ) arrayfun(@(z) find(newTime>=z,1), tempCueTime(idT,1)+timings{1} ) ...
                    arrayfun(@(z) find(tempTimeLick>=z,1), tempCueTime(idT,1) ) arrayfun(@(z) find(tempTimeLick>=z,1), tempCueTime(idT,1)+timings{1} )];
                id2 = [arrayfun(@(z) find(newTime>=z,1), tempOutcomeTime(idT,1) ) arrayfun(@(z) find(newTime>=z,1), tempOutcomeTime(idT,1)+timings{2} ) ...
                    arrayfun(@(z) find(tempTimeLick>=z,1), tempOutcomeTime(idT,1) ) arrayfun(@(z) find(tempTimeLick>=z,1), tempOutcomeTime(idT,1)+timings{2} )];
                     id3 = [arrayfun(@(z) find(newTime>=z,1), tempOutcomeTime(idT,1) ) arrayfun(@(z) find(newTime>=z,1), tempOutcomeTime(idT,1)+timings{3} ) ...
                    arrayfun(@(z) find(tempTimeLick>=z,1), tempOutcomeTime(idT,1) ) arrayfun(@(z) find(tempTimeLick>=z,1), tempOutcomeTime(idT,1)+timings{3} )];
                id4 = [arrayfun(@(z) find(newTime>=z,1),newTime(1) ) arrayfun(@(z) find(newTime>=z,1), newTime(1)+ timings{4} ) ...
                    arrayfun(@(z) find(tempTimeLick>=z,1), tempTimeLick(1) ) arrayfun(@(z) find(tempTimeLick>=z,1),  tempTimeLick(1) + timings{4} )];
       
                
                if uT==1 && tT==1 && stateNb==1 && size(interpTemp,1)>=minTrials
                figure; subplot(2,3,1);imagesc(tempL);title([ Analysis.Properties.TrialNames{tT}]) ;hold on
                line([id1(1,3) id1(1,3) ],[0 size(interpTemp,1)],'Color','red');line([id1(1,4) id1(1,4) ],[0 size(interpTemp,1)],'Color','red');
                line([id2(1,3) id2(1,3) ],[0 size(interpTemp,1)],'Color','blue');line([id2(1,4) id2(1,4) ],[0 size(interpTemp,1)],'Color','blue')
                line([id3(1,3) id3(1,3) ],[0 size(interpTemp,1)],'Color','black');line([id3(1,4) id3(1,4) ],[0 size(interpTemp,1)],'Color','black')
                line([id4(1,3) id4(1,3) ],[0 size(interpTemp,1)],'Color','white');line([id4(1,4) id4(1,4) ],[0 size(interpTemp,1)],'Color','white')
                end
                
                
                
                id = [arrayfun(@(z) find(newTime>=z,1), tempCueTime(idT,1) ) arrayfun(@(z) find(newTime>=z,1), tempCueTime(idT,1)+timings{1} ) ...
                    arrayfun(@(z) find(tempTimeLick>=z,1), tempCueTime(idT,1) ) arrayfun(@(z) find(tempTimeLick>=z,1), tempCueTime(idT,1)+timings{1} )];
                if uT==1 && tT==1 && stateNb==1 && size(interpTemp,1)>=minTrials
                  subplot(2,3,2);imagesc(tempL(:,id(1,3):id(1,4)));title(' Cue')
                end
                for iid=1:size(idT,1)
                    meanPhoto{1} = [ meanPhoto{1};nanmean(interpTemp(iid,id(iid,1):id(iid,2)))];
                    maxPhoto{1} = [ maxPhoto{1};nanmax(interpTemp(iid,id(iid,1):id(iid,2)))];
                    stdPhoto{1} = [ stdPhoto{1};nanmean(interpTemp(iid,id(iid,1):id(iid,2)))];
                    meanLick{1} = [ meanLick{1};nanmean(tempL(iid,id(iid,3):  id(iid,4)))  ];
                    maxLick{1} = [ maxLick{1};nanmax(tempL(iid,id(iid,3):  id(iid,4)))  ];                    
                    stdLick{1} = [ stdLick{1};nanmean(tempL(iid,id(iid,3):  id(iid,4)))  ];
                end
                id = [arrayfun(@(z) find(newTime>=z,1), tempOutcomeTime(idT,1) ) arrayfun(@(z) find(newTime>=z,1), tempOutcomeTime(idT,1)+timings{2} ) ...
                    arrayfun(@(z) find(tempTimeLick>=z,1), tempOutcomeTime(idT,1) ) arrayfun(@(z) find(tempTimeLick>=z,1), tempOutcomeTime(idT,1)+timings{2} )];
                if uT==1 && tT==1 && stateNb==1 && size(interpTemp,1)>=minTrials
                 subplot(2,3,3);imagesc(interpTemp(:,id(1,4):id(1,3)));title('Pre Reward')
                end
                for iid=1:size(idT,1)
                    meanPhoto{2} =  [ meanPhoto{2}   ;nanmean(interpTemp(iid,id(iid,2):id(iid,1)))];
                    maxPhoto{2} =   [ maxPhoto{2}     ;nanmean(interpTemp(iid,id(iid,2):id(iid,1)))];
                    stdPhoto{2} =   [ stdPhoto{2}     ;nanmean(interpTemp(iid,id(iid,2):id(iid,1)))];
                    meanLick{2} =   [ meanLick{2}     ;nanmean(tempL(iid,id(iid,4):id(iid,3)))];
                    maxLick{2} =    [ maxLick{2}       ;nanmax(tempL(iid,id(iid,4):id(iid,3)))];
                    stdLick{2} =    [ stdLick{2}       ;nanmean(tempL(iid,id(iid,4):id(iid,3)))];
                end
                id = [arrayfun(@(z) find(newTime>=z,1), tempOutcomeTime(idT,1) ) arrayfun(@(z) find(newTime>=z,1), tempOutcomeTime(idT,1)+timings{3} ) ...
                    arrayfun(@(z) find(tempTimeLick>=z,1), tempOutcomeTime(idT,1) ) arrayfun(@(z) find(tempTimeLick>=z,1), tempOutcomeTime(idT,1)+timings{3} )];
                if uT==1 && tT==1 && stateNb==1 && size(interpTemp,1)>=minTrials
                  subplot(2,3,4);imagesc(tempL(:,id(1,3):id(1,4)));title('Post Reward')
                end
                for iid=1:size(idT,1)
                    meanPhoto{3} =  [ meanPhoto{3}   ;     nanmean(interpTemp(iid,id(iid,1):id(iid,2)))];
                    maxPhoto{3} =   [ maxPhoto{3}     ;     nanmean(interpTemp(iid,id(iid,1):id(iid,2)))];
                    stdPhoto{3} =   [ stdPhoto{3}     ;     nanmean(interpTemp(iid,id(iid,1):id(iid,2)))];
                    meanLick{3} =   [ meanLick{3}     ;     nanmean(tempL(iid,id(iid,3):id(iid,4)))];
                    maxLick{3} =    [ maxLick{3}       ;     nanmax(tempL(iid,id(iid,3):id(iid,4)))];
                    stdLick{3} =    [ stdLick{3}       ;     nanmean(tempL(iid,id(iid,3):id(iid,4)))];
                end
                id = [arrayfun(@(z) find(newTime>=z,1),newTime(4) ) arrayfun(@(z) find(newTime>=z,1), newTime(4)+ timings{4} ) ...
                    arrayfun(@(z) find(tempTimeLick>=z,1), tempTimeLick(2) ) arrayfun(@(z) find(tempTimeLick>=z,1),  tempTimeLick(2) + timings{4} )];
                if uT==1 && tT==1 && stateNb==1 && size(interpTemp,1)>=minTrials
                 subplot(2,3,5);imagesc(tempL(:,id(1,3):id(1,4)));title('Baseline')
                end
                for iid=1:size(idT,1)
                    meanPhoto{4} =  [ meanPhoto{4}   ;     nanmean(interpTemp(iid,id(1,1):id(1,2)))];
                    maxPhoto{4} =   [ maxPhoto{4}     ;     nanmean(interpTemp(iid,id(1,1):id(1,2)))];
                    stdPhoto{4} =   [ stdPhoto{4}     ;     nanmean(interpTemp(iid,id(1,1):id(1,2)))];
                    meanLick{4} =   [ meanLick{4}     ;     nanmean(tempL(iid,id(1,3):id(1,4)))];
                    maxLick{4} =    [ maxLick{4}       ;     nanmax(tempL(iid,id(1,3):id(1,4)))];
                    stdLick{4} =    [ stdLick{4}       ;     nanmean(tempL(iid,id(1,3):id(1,4)))];
                end             
                ii=ii+length(idT);
            end
            idT=find(thisFilter==1);idT=idT(1);
            
            if size(blocksAlligned,1)>=minTrials
            eval([ 'ProgressMat.Photo_470.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=blocksAlligned;'])
            eval([ 'ProgressMat.Photo_470.Mean.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=meanPhoto;'])
            eval([ 'ProgressMat.Photo_470.Max.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=maxPhoto;'])
            
            
            eval([ 'ProgressMat.Wheel.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=tempWheel ;'])
            eval([ 'ProgressMat.Lick.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=tempLick;'])
            
            eval([ 'ProgressMat.Lick.Mean.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=meanLick;'])
            eval([ 'ProgressMat.Lick.Max.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=maxLick;'])
            
        
            eval([ 'ProgressMat.Timings.OutcomeTime.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}= squeeze(Analysis.AllData.OutcomeTime(stateNb,thisFilter,:)) ;'])
            eval([ 'ProgressMat.Timings.CueTime.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=squeeze(Analysis.AllData.CueTime(stateNb,thisFilter,:)) ;'])
            eval([ 'ProgressMat.Timings.PhotoTime.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=newTime ;'])
            eval([ 'ProgressMat.Timings.LickTime.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=Analysis.AllData.Licks.Bin{1} ;'])
            else
            eval([ 'ProgressMat.Photo_470.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=[];'])
            eval([ 'ProgressMat.Photo_470.Mean.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=[];'])
            eval([ 'ProgressMat.Photo_470.Max.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=[];'])
            
            
            eval([ 'ProgressMat.Wheel.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=[] ;'])
            eval([ 'ProgressMat.Lick.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=[];'])
            
            eval([ 'ProgressMat.Lick.Mean.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=[];'])
            eval([ 'ProgressMat.Lick.Max.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=[];'])
            
        
            eval([ 'ProgressMat.Timings.OutcomeTime.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}= squeeze(Analysis.AllData.OutcomeTime(stateNb,thisFilter,:)) ;'])
            eval([ 'ProgressMat.Timings.CueTime.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=squeeze(Analysis.AllData.CueTime(stateNb,thisFilter,:)) ;'])
            eval([ 'ProgressMat.Timings.PhotoTime.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=newTime ;'])
            eval([ 'ProgressMat.Timings.LickTime.'  strrep(Analysis.Properties.TrialNames{tT} ,' ', '') '{iiS,stateNb}=Analysis.AllData.Licks.Bin{1} ;'])

            end
            
        end
    end
end