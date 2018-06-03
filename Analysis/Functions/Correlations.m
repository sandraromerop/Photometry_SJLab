% Correlate all time points within each standard trial type
figure
pearsonR_velocity=[];
idTrials =1:5
for tT = 1:length(idTrials)
    tType = idTrials(tT);
    tempPhoto_470 = Analysis.AllData.Photo_470.DFF(:,1:end-1);
    tempPhoto_470(Analysis.Filters.Logicals(:,tType)==0,:)=[];
    tempWheel =diff( Analysis.AllData.Wheel.Distance,[],2);
    tempWheel(Analysis.Filters.Logicals(:,tType)==0,:)=[];
    subplot(2,3,tT)
    cx = parula(size(tempWheel,1));
    for tt=1:size(tempWheel,1)
        plot(abs(tempWheel(tt,1:5:end)),tempPhoto_470(tt,1:5:end),'.','Color', cx(tt,:));hold on
        pearsonR_velocity(tt,tT)=corr(abs(tempWheel(tt,:))',tempPhoto_470(tt,:)')
    end
    if tT==1 && tType>5
        title([ { strrep(DefaultParam.FileList(1:end-4),'_',' '); Analysis.Filters.Names{tType}}]);       
    elseif tType>5
        title(Analysis.Filters.Names{tType});
    elseif tT==1 && tType<=5
        title([ {strrep(DefaultParam.FileList(1:end-4),'_',' '); ['Analysis.type_' num2str(tType) '.Name']}]);       
    else
        
        title(eval(['Analysis.type_' num2str(tType) '.Name']));
    end
    xlabel('Velocity (cm/s)')
    ylabel('DF/F0')
    
end

figure
subplot(1,2,1)
lg=[];
imagesc(pearsonR_velocity);colorbar
title(strrep(DefaultParam.FileList(1:end-4),'_',' '))
subplot(1,2,2)
pearsonR_velocity(pearsonR_velocity==0)=nan;
cj = hsv(length(idTrials))
for tT = 1:length(idTrials)
    tType = idTrials(tT);
    plot(pearsonR_velocity(:,tT),'o','Color', cj(tT,:));hold on
    if tType>5
        lg{tT} = Analysis.Filters.Names{tType};
    else
    lg{tT} = eval(['Analysis.type_' num2str(tT) '.Name']);
    end
end
legend(lg)
%%
figure
pearsonR_velocity=[];
idTrials =1:5
for tT = 1:length(idTrials)
    tType = idTrials(tT);
    tempPhoto_470 = Analysis.AllData.Photo_470.DFF(:,1:end-1);
    tempPhoto_470(Analysis.Filters.Logicals(:,tType)==0,:)=[];
    tempWheel =diff( Analysis.AllData.Wheel.Distance,[],2);
    tempWheel(Analysis.Filters.Logicals(:,tType)==0,:)=[];
    subplot(2,3,tT)
    cx = parula(size(tempWheel,1));
    for tt=1:size(tempWheel,1)
        plot(abs(tempWheel(tt,1:5:end)),tempPhoto_470(tt,1:5:end),'.','Color', cx(tt,:));hold on
        pearsonR_velocity(tt,tT)=corr(abs(tempWheel(tt,:))',tempPhoto_470(tt,:)')
    end
    if tT==1 && tType>5
        title([ { strrep(DefaultParam.FileList(1:end-4),'_',' '); Analysis.Filters.Names{tType}}]);       
    elseif tType>5
        title(Analysis.Filters.Names{tType});
    elseif tT==1 && tType<=5
        title([ {strrep(DefaultParam.FileList(1:end-4),'_',' '); ['Analysis.type_' num2str(tType) '.Name']}]);       
    else
        
        title(eval(['Analysis.type_' num2str(tType) '.Name']));
    end
    xlabel('Velocity (cm/s)')
    ylabel('DF/F0')
    
end

figure
subplot(1,2,1)
lg=[];
imagesc(pearsonR_velocity);colorbar
title(strrep(DefaultParam.FileList(1:end-4),'_',' '))
subplot(1,2,2)
pearsonR_velocity(pearsonR_velocity==0)=nan;
cj = hsv(length(idTrials))
for tT = 1:length(idTrials)
    tType = idTrials(tT);
    plot(pearsonR_velocity(:,tT),'o','Color', cj(tT,:));hold on
    if tType>5
        lg{tT} = Analysis.Filters.Names{tType};
    else
    lg{tT} = eval(['Analysis.type_' num2str(tT) '.Name']);
    end
end
legend(lg)
%%
figure
for tT = 1:length(idTrials)
    tType = idTrials(tT);
    tempPhoto_470 = Analysis.AllData.Photo_470.DFF(:,1:end-1);
    tempPhoto_470(Analysis.Filters.Logicals(:,tType)==0,:)=[];
    tempWheel =diff( Analysis.AllData.Wheel.Deg,[],2);
    tempWheel(Analysis.Filters.Logicals(:,tType)==0,:)=[];
%     tempWheel = Analysis.AllData.Wheel.Distance;
%     tempWheel(Analysis.Filters.Logicals(:,tType)==0,:)=[];    
    subplot(2,3,tType)
    cx = parula(size(tempWheel,1));
    for tt=1:size(tempWheel,1)
        plot(abs(tempWheel(tt,1:5:end)),tempPhoto_470(tt,1:5:end),'.','Color', cx(tt,:));hold on
        pearsonR_angVelocity(tt,tT)=corr(abs(tempWheel(tt,:))',tempPhoto_470(tt,:)')
    end    

    
    if tT==1 && tType>5
        title([ { strrep(DefaultParam.FileList(1:end-4),'_',' '); Analysis.Filters.Names{tType}}]);       
    elseif tType>5
        title(Analysis.Filters.Names{tType});
    elseif tT==1 && tType<=5
        title([ {strrep(DefaultParam.FileList(1:end-4),'_',' '); ['Analysis.type_' num2str(tType) '.Name']}]);       
    else
        
        title(eval(['Analysis.type_' num2str(tType) '.Name']));
    end
    xlabel('Angular Velocity (deg/s)')
    ylabel('DF/F0')
end
figure
subplot(1,2,1)
imagesc(pearsonR_angVelocity)
title(strrep(DefaultParam.FileList(1:end-4),'_',' '))

subplot(1,2,2)
pearsonR_angVelocity(pearsonR_angVelocity==0)=nan;
cj = hsv(length(idTrials))
for tT = 1:length(idTrials)
    tType = idTrials(tT);
    plot(pearsonR_angVelocity(:,tT),'Color', cj(tT,:));hold on
    if tType>5
        lg{tT} = Analysis.Filters.Names{tType};
    else
    lg{tT} = eval(['Analysis.type_' num2str(tT) '.Name']);
    end
end
legend(lg)


%%
figure
for tType = 1:5
    tempPhoto_470 = Analysis.AllData.Photo_470.DFF(:,1:end-1);
    tempPhoto_470(Analysis.Filters.Logicals(:,tType)==0,:)=[];
    tempWheel =diff( Analysis.AllData.Wheel.Deg,[],2);
    tempWheel(Analysis.Filters.Logicals(:,tType)==0,:)=[];
%     tempWheel = Analysis.AllData.Wheel.Distance;
%     tempWheel(Analysis.Filters.Logicals(:,tType)==0,:)=[];    
    subplot(2,3,tType)
    cx = parula(size(tempWheel,1));
    for tt=1:size(tempWheel,1)
        plot(abs(tempWheel(tt,1:5:end)),tempPhoto_470(tt,1:5:end),'.','Color', cx(tt,:));hold on
        pearsonR_angVelocity(tt,tType)=corr(abs(tempWheel(tt,:))',tempPhoto_470(tt,:)')
    end
    
    title(eval(['Analysis.type_' num2str(tType) '.Name']));
    xlabel('Angular Velocity (deg/s)')
    ylabel('DF/F0')
end
figure
imagesc(pearsonR_angVelocity)
figure
subplot(1,2,1)
imagesc(pearsonR_angVelocity)
subplot(1,2,2)
pearsonR_angVelocity(pearsonR_angVelocity==0)=nan;
cj = hsv(5)
for  tType = 1:5
    plot(pearsonR_angVelocity(:,tType),'Color', cj(tType,:));hold on
    lg{tType} = eval(['Analysis.type_' num2str(tType) '.Name']);
end
legend(lg)

%%
