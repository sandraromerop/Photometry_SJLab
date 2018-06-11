%% Alligning fluorescence data to onset of locomotion initiation: regardless of reward delivery

% rough script for wheel analysis to IMPROVE


thrAccRest = 0.25;% prctile(tempAcc(:),90);%0.005;
thrAccLoco = 0.0001;% prctile(tempAcc(:),90);%0.005;
thrVelocLoco = 0.2;%prctile(tempVeloc(:),95);
thrVelocRest = 0.2;
segmCorr = ceil(0.75/(timeV(2)- timeV(1)));
tempPhoto_470 = Analysis.AllData.Photo_470.DFF(:,1:end);
tempVeloc =abs(diff( Analysis.AllData.Wheel.Distance,[],2));
tempAcc =diff( tempVeloc,[],2);
tempLick = Analysis.AllData.Licks.Rate;
trialsNb =1:Analysis.AllData.nTrials;
tempVeloc = cat(1,tempVeloc,nan.*ones(1,size(tempVeloc,2)));
tempPhoto_470 = cat(1,tempPhoto_470,nan.*ones(1,size(tempPhoto_470,2)));
tempLick = cat(1,tempLick,nan.*ones(1,size(tempLick,2)));
timeV = linspace(timeD(1),timeD(end),length(timeD)-1)

timeA = linspace(timeV(1),timeV(end),length(timeV)-1);
for tT =[1 3 4  ]%:length(idTrials)
tType = idTrials(tT);
idType = find(Analysis.Filters.Logicals(:,tType)==1);  
idKeep=[];

for tt= 1:length(idType)-1
    ti = idType(tt);
    temp = smooth(tempVeloc(ti,:),10);
    tempA = smooth(tempAcc(ti,:),10);
    idZero = find(timeV>=0);idZero=idZero(1);
    nPointsSeg = ceil(0.35./(timeV(2)- timeV(1)));
    meanV=[];
    figure
    subplot(2,1,1)
     plot(timeV, temp );hold on
    ipt = findchangepts(temp,'MaxNumChanges',4,'Statistic','linear') ;ipt2=[];
    if ~isempty(ipt)
    for ii=1:length(ipt)
        line([timeV(ipt(ii)) timeV(ipt(ii))],[0 temp(ipt(ii))],'Color','red')
        if sum(diff(temp(ipt(ii)-1:ipt(ii)+1)))>=0
            [minV idMin]=min(temp( max(1, ipt(ii)-ceil(.5/(timeV(2)- timeV(1)))):ipt(ii) ))
            ipt2(ii) = max(1,ipt(ii)-ceil(.5/(timeV(2)- timeV(1)))+idMin-1);
        else
            [minV idMin]=min(temp(ipt(ii):  min(ipt(ii)+ceil(.5/(timeV(2)- timeV(1))),length(temp) ) ))
            ipt2(ii) =min( ipt(ii)+idMin-1,length(temp));
        end
        
        line([timeV(ipt2(ii)) timeV(ipt2(ii))],[0 temp(ipt2(ii))],'Color','blue')
    end
    subplot(2,1,2)
     plot(timeA, tempA );hold on
     for ii=1:length(ipt)
        line([timeA( min(ipt2(ii),length(tempA))) timeA( min(ipt2(ii),length(tempA)))],[0 tempA( min(ipt2(ii),length(tempA)))],'Color','red')
    end
    ipt2 = [1 ipt2 ];peakAccPre=[];peakVPre=[]; peakAccPost=[]; diffMeanV=[];ipt2=unique(ipt2);peakVelocPost=[];
    for ii=2:length(ipt2)
        peakAccPre(ii-1) = max(   tempA(  max(1,ipt2(ii)-ceil(1./(timeV(2)- timeV(1))))  :  min(ipt2(ii)-1,length(tempA))  )  );
        peakVPre(ii-1) = max( temp(  max(1,ipt2(ii)-ceil(1./(timeV(2)- timeV(1)))):ipt2(ii)-1  ));
        peakAccPost(ii-1) = max(tempA(min(ipt2(ii),length(tempA)):min( ipt2(ii)+ ceil(.35./(timeV(2)- timeV(1))) ,length(tempA))));
        peakVelocPost(ii-1) = max(temp(min(ipt2(ii),length(temp)):min( ipt2(ii)+ ceil(1.5/(timeV(2)- timeV(1))) ,length(temp))));
        diffMeanV(ii-1) = nanmean(temp(ipt2(ii): min(ipt2(min(ii+1,length(ipt2))),length(temp) )))- nanmean(temp(ipt2(ii-1):ipt2(ii)));
    end
    
    % to be locomotion initiation:     
    accPreLogic = peakAccPre;accPreLogic(peakAccPre<=thrAccRest)=1;accPreLogic(peakAccPre>thrAccRest)=0;
    vPreLogic = peakVPre;vPreLogic(peakVPre<=thrVelocRest)=1;vPreLogic(peakVPre>thrVelocRest)=0;
    accPostLogic = peakAccPost;accPostLogic(peakAccPost>=thrAccLoco)=1;accPostLogic(peakAccPost<thrAccLoco)=0;
    vPostLogic = peakVelocPost;vPostLogic(peakVelocPost>=thrVelocLoco)=1;vPostLogic(peakVelocPost<thrVelocLoco)=0;
    diffMeanLogic =diffMeanV;diffMeanLogic(diffMeanLogic>=0)=1;diffMeanLogic(diffMeanLogic<0)=0;
    prodLogic = accPreLogic.*vPreLogic.*accPostLogic.*diffMeanLogic.*vPostLogic;
    
    if ~isempty(find(prodLogic==1))
        iid=find(prodLogic==1);iid=iid(end);
        idKeep(ti) = ipt2(iid+1);
    else
        idKeep(ti) =nan;
    end
    else
    idKeep(ti) =nan;
    end
    title(num2str( idKeep(ti) ));
    %pause(2)
    close 
end
%
idKeep(idKeep==0)=nan;
timePh=Analysis.AllData.Photo_470.Time(1,:);
idKT = find(~isnan(idKeep)==1)
sum( ~isnan(idKeep));
figure
subplot(2,2,1)
for ii=1:length(idKT)
plot(timeV,tempVeloc(idKT(ii),:)');
hold on
line([timeV(idKeep(idKT(ii))) timeV(idKeep(idKT(ii)))],[0  max(tempVeloc(idKT(ii),:))],'Color','black')
%pause(1)
hold off
end
subplot(2,2,2)
imagesc(tempVeloc(idKT,:))
subplot(2,2,3)
for ii=1:length(idKT)
plot(timePh,tempPhoto_470(idKT(ii),:)');
hold on
line([timePh(idKeep(idKT(ii))) timePh(idKeep(idKT(ii)))],[0  max(tempPhoto_470(idKT(ii),:))],'Color','black')
end
subplot(2,2,4)
imagesc(tempPhoto_470(idKT,:))
% Reallign
tempVelocCent=[];idAllignVeloc=[];idAllignAcc=[];
for ii=1:length(idKT)
    % Alligh to Velocity
    tempVelocCent(ii,:)=zeros(1,segmCorr*2+1) ;
    tempV = smooth(tempVeloc(idKT(ii),:),5);
    idEnd = idKeep(idKT(ii)): min(idKeep(idKT(ii))+segmCorr,length(tempVeloc(1,:)));
    idStart =max(idKeep(idKT(ii))-segmCorr,1):idKeep(idKT(ii));
    tempVelocCent(ii,segmCorr+1: segmCorr+length(idEnd))=tempV( idEnd);
    tempVelocCent(ii,segmCorr-length(idStart)+2:segmCorr+1)=tempV( idStart); 
  %  figure
    seg=tempV( max(1,idKeep(idKT(ii))-40):min(idKeep(idKT(ii))+40,length(tempVeloc(1,:))));
    seg(seg<0.05)=0;
    idT = findchangepts(seg,'MaxNumChanges',3,'Statistic','mean') ;   
   % plot(seg( max(idT(1)-ceil(.5/(timeV(2)- timeV(1))),1) :idT(1)))
    [minV idMin]=min(seg( max(idT(1)-ceil(.5/(timeV(2)- timeV(1))),1) :idT(1)));
    idO = find(seg( max(idT(1)-ceil(.5/(timeV(2)- timeV(1))),1) :idT(1))==minV);
    idODiff= [diff(idO) ;2];idF = find(idODiff~=1);idF=max(1,idF(end)-1);idMin = idO(idF);
    idAllignVeloc(ii) = idMin+max(1,idKeep(idKT(ii))-40)+max(idT(1)-ceil(.5/(timeV(2)- timeV(1))),1);
   % plot(tempV(:));hold on
    %line([  idAllignVeloc(ii)    idAllignVeloc(ii)  ],[0 max(tempVeloc(idKT(ii),:))] )
 %   close
    
    tempAccCent(ii,:)=zeros(1,segmCorr*2+1) ;
    tempV = smooth(diff(tempVeloc(idKT(ii),:)),5);
    idEnd = idKeep(idKT(ii)): min(idKeep(idKT(ii))+segmCorr,length(tempV));
    idStart =max(idKeep(idKT(ii))-segmCorr,1):idKeep(idKT(ii));
    tempAccCent(ii,segmCorr+1: segmCorr+length(idEnd))=tempV( idEnd);
    tempAccCent(ii,segmCorr-length(idStart)+2:segmCorr+1)=tempV( idStart); 
    
    
    figure
    seg=tempV( max(1,idKeep(idKT(ii))-40):min(idKeep(idKT(ii))+40,length(tempV)));
    seg(seg<0.01)=0;
    idT = findchangepts(seg,'MaxNumChanges',5,'Statistic','mean') ;   
    if ~isempty(idT)
        plot(seg( max(idT(1)-ceil(.5/(timeV(2)- timeV(1))),1) :idT(1)))
        [minV idMin]=min(seg( max(idT(1)-ceil(.5/(timeV(2)- timeV(1))),1) :idT(1)));
        idO = find(seg( max(idT(1)-ceil(.5/(timeV(2)- timeV(1))),1) :idT(1))==minV);
        idODiff= [diff(idO) ;2];idF = find(idODiff~=1);idF=max(1,idF(end)-1);idMin = idO(idF);
        idAllignAcc(ii) = idMin+max(1,idKeep(idKT(ii))-40)+max(idT(1)-ceil(.5/(timeV(2)- timeV(1))),1)-1;
        plot(tempV(:));hold on
        line([  idAllignAcc(ii)    idAllignAcc(ii)  ],[0 max(tempVeloc(idKT(ii),:))] )
    end
    close
end
%
timeCent =unique([linspace(-1,0,segmCorr+1) linspace(0,1,segmCorr+1)]);
tempPhotoCent=[];tempPhotoCentA=[];

tempVelocCent=[];tempVelocCentA=[]
%
for ii=1:length(idKT);
   tempVelocCent(ii,:)=zeros(1,segmCorr*2+1) ;
   idEnd = idAllignVeloc(ii): min(idAllignVeloc(ii)+segmCorr,length(tempVeloc(1,:)));
   idStart =max(idAllignVeloc(ii)-segmCorr,1):idAllignVeloc(ii);
   tempVelocCent(ii,segmCorr+1: segmCorr+length(idEnd))=tempVeloc(idKT(ii),idEnd);
   tempVelocCent(ii,segmCorr-length(idStart)+2:segmCorr+1)=tempVeloc(idKT(ii),idStart);
   tempPhotoCent(ii,:)=zeros(1,segmCorr*2+1) ;
   idEnd = idAllignVeloc(ii): min(idAllignVeloc(ii)+segmCorr,length(tempPhoto_470(1,:)));
   idStart =max(idAllignVeloc(ii)-segmCorr,1):idAllignVeloc(ii);
   tempPhotoCent(ii,segmCorr+1: segmCorr+length(idEnd))=tempPhoto_470(idKT(ii),idEnd);
   tempPhotoCent(ii,segmCorr-length(idStart)+2:segmCorr+1)=tempPhoto_470(idKT(ii),idStart);
end

idAllignAcc(idAllignAcc==0)=[];
for ii=1:length(idAllignAcc);
   tempVelocCentA(ii,:)=zeros(1,segmCorr*2+1) ;
   idEnd = idAllignAcc(ii): min(idAllignAcc(ii)+segmCorr,length(tempVeloc(1,:)));
   idStart =max(idAllignAcc(ii)-segmCorr,1):idAllignAcc(ii);
   tempVelocCentA(ii,segmCorr+1: segmCorr+length(idEnd))=tempVeloc(idKT(ii),idEnd);
   tempVelocCentA(ii,segmCorr-length(idStart)+2:segmCorr+1)=tempVeloc(idKT(ii),idStart);
   tempPhotoCentA(ii,:)=zeros(1,segmCorr*2+1) ;
   idEnd = idAllignAcc(ii): min(idAllignAcc(ii)+segmCorr,length(tempPhoto_470(1,:)));
   idStart =max(idAllignAcc(ii)-segmCorr,1):idAllignAcc(ii);
   tempPhotoCentA(ii,segmCorr+1: segmCorr+length(idEnd))=tempPhoto_470(idKT(ii),idEnd);
   tempPhotoCentA(ii,segmCorr-length(idStart)+2:segmCorr+1)=tempPhoto_470(idKT(ii),idStart);
end
%
figure

subplot(1,2,1)
imagesc(tempVelocCent);
subplot(1,2,2)
imagesc(diff(tempVelocCentA,[],2));
toDisc=input('Disc trials')
tempVelocCent(toDisc,:)=[];tempPhotoCent(toDisc,:)=[];
tempVelocCentA(toDisc,:)=[];tempPhotoCentA(toDisc,:)=[];

trialsNb =1:size(tempVelocCent,1);
figure('units','normalized','position',[0 0 .5 .5])
subplot(3,3,4)
plot(timeCent,tempVelocCent');xlabel('Time');ylabel('Velocity cm/s')
subplot(3,3,5)
imagesc(timeCent,trialsNb,tempVelocCent);hold on;xlabel('Time');ylabel('Trial Nb')
c=colorbar('location','eastoutside');    c.Label.String ='Velocity cm/s';
plot([0 0],[0 max(trialsNb)],'-r');   
title('Alligned to Velocity')
colormap hot
subplot(3,3,3)
shadedErrorBar(timeCent,nanmean(tempVelocCent,1),...
        nanstd(tempVelocCent,[],1)./(sqrt(length(idKT))),'-r',1)
ylabel('Velocity cm/s');xlabel('Time');
subplot(3,3,1)
plot(timeCent,tempPhotoCent');xlabel('Time');ylabel('DF/F0')
tit = strrep(DefaultParam.FileList(1:end-4),'_',' ');
tit  = strrep(tit,'CuedReward',' ');
title({[tit];eval(['Analysis.type_' num2str(tType) '.Name'])})
subplot(3,3,2)
imagesc(timeCent,trialsNb,tempPhotoCent);hold on;xlabel('Time');ylabel('Trial Nb')
c=colorbar('location','eastoutside');    c.Label.String ='DF/F0';
plot([0 0],[0 max(trialsNb)],'-r');

subplot(3,3,6)
yyaxis right
shadedErrorBar(timeCent,nanmean(tempVelocCent,1),...
    nanstd(tempVelocCent,[],1)./(sqrt(length(idKT))),'-r',1);hold on
ylabel('Velocity cm/s');xlabel('Time');
yyaxis left
shadedErrorBar(timeCent,nanmean(tempPhotoCent,1),...
    nanstd(tempPhotoCent,[],1)./(sqrt(length(idKT))),'-b',1);hold on
ylabel('DF/F0')
subplot(3,3,7)
plot(timeCent(1:end-1),diff(tempVelocCentA'));xlabel('Time');ylabel('Acceleration cm/s2')
subplot(3,3,8)
imagesc(timeCent(1:end-1),trialsNb,diff(tempVelocCentA,[],2));hold on;xlabel('Time');ylabel('Trial Nb')
c=colorbar('location','eastoutside');    c.Label.String ='Acceleration cm/s2';
plot([0 0],[0 max(trialsNb)],'-r');
title('Alligned to Acceleration')
subplot(3,3,9)
yyaxis right  
shadedErrorBar(timeCent(1:end-1),nanmean(diff(tempVelocCentA'),2)',...
    nanstd(diff(tempVelocCentA'),[],2)'./(sqrt(length(idKT))),'-r',1);hold on
ylabel('Acceleration cm/s2');xlabel('Time');
yyaxis left
shadedErrorBar(timeCent(1:end),nanmean(tempPhotoCentA,1),...
    nanstd(tempPhotoCentA,[],1)./(sqrt(length(idKT))),'-b',1);hold on
ylabel('DF/F0')

mkdir([ Analysis.Properties.DirFig  '\AllignedWheel\' ])
saveas(gcf,[Analysis.Properties.DirFig  '\AllignedWheel\'  Analysis.Properties.Name 'allignedToWheel' eval(['Analysis.type_' num2str(tType) '.Name']) '.png']);
end

%% Alligning fluorescence data to onset of locomotion initiation: outside of reward delivery
thrAccRest = 0.25;% prctile(tempAcc(:),90);%0.005;
thrAccLoco = 0.0001;% prctile(tempAcc(:),90);%0.005;
thrVelocLoco = 0.2;%prctile(tempVeloc(:),95);
thrVelocRest = 0.2;
segmCorr = ceil(0.75/(timeV(2)- timeV(1)));
tempPhoto_470 = Analysis.AllData.Photo_470.DFF(:,1:end);
tempVeloc =abs(diff( Analysis.AllData.Wheel.Distance,[],2));
tempAcc =diff( tempVeloc,[],2);
tempLick = Analysis.AllData.Licks.Rate;
trialsNb =1:Analysis.AllData.nTrials;
tempVeloc = cat(1,tempVeloc,nan.*ones(1,size(tempVeloc,2)));
tempPhoto_470 = cat(1,tempPhoto_470,nan.*ones(1,size(tempPhoto_470,2)));
tempLick = cat(1,tempLick,nan.*ones(1,size(tempLick,2)));

tT =1%:length(idTrials)
tType = idTrials(tT);
idType = 1:size(tempVeloc,1)%find(Analysis.Filters.Logicals(:,tType)==1);  
idKeep=[];

for tt=1:length(idType)-1
    
    ti = idType(tt);
    temp = smooth(tempVeloc(ti,:),10);
    tempA = smooth(tempAcc(ti,:),10);
   % end


    idZero = find(timeV>=0);idZero=idZero(1);
    nPointsSeg = ceil(0.35./(timeV(2)- timeV(1)));
    meanV=[];
    figure 
    subplot(2,1,1)
     plot(timeV, temp );hold on
    ipt = findchangepts(temp,'MaxNumChanges',4,'Statistic','linear') ;ipt2=[];
    id1=find(Analysis.Filters.Logicals(ti,1:5)==1);
    id2=find(Analysis.Filters.Logicals(ti,1:5)==1);
    if id1(1)==1 || id2(1)==4
        idZero = find(timeV>=0);idZero=idZero(1);idNan=idZero-ceil(.5/(timeV(2)- timeV(1))):idZero+ceil(1.5/(timeV(2)- timeV(1)));
        [a idDisc ]=intersect(ipt,idNan);
        ipt(idDisc)=[];
    end
    if ~isempty(ipt)
    for ii=1:length(ipt)
        line([timeV(ipt(ii)) timeV(ipt(ii))],[0 temp(ipt(ii))],'Color','red')
        if sum(diff(temp(ipt(ii)-1:ipt(ii)+1)))>=0
            [minV idMin]=min(temp( max(1, ipt(ii)-ceil(.5/(timeV(2)- timeV(1)))):ipt(ii) ));
            ipt2(ii) = max(1,ipt(ii)-ceil(.5/(timeV(2)- timeV(1)))+idMin-1);
        else
            [minV idMin]=min(temp(ipt(ii):  min(ipt(ii)+ceil(.5/(timeV(2)- timeV(1))),length(temp) ) ));
            ipt2(ii) =min( ipt(ii)+idMin-1,length(temp));
        end
        
        line([timeV(ipt2(ii)) timeV(ipt2(ii))],[0 temp(ipt2(ii))],'Color','blue')
    end
    subplot(2,1,2)
     plot(timeA, tempA );hold on
     for ii=1:length(ipt)
        line([timeA( min(ipt2(ii),length(tempA))) timeA( min(ipt2(ii),length(tempA)))],[0 tempA( min(ipt2(ii),length(tempA)))],'Color','red')
    end
    ipt2 = [1 ipt2 ];peakAccPre=[];peakVPre=[]; peakAccPost=[]; diffMeanV=[];ipt2=unique(ipt2);peakVelocPost=[];
    for ii=2:length(ipt2)
        peakAccPre(ii-1) = max(   tempA(  max(1,ipt2(ii)-ceil(1./(timeV(2)- timeV(1))))  :  min(ipt2(ii)-1,length(tempA))  )  );
        peakVPre(ii-1) = max( temp(  max(1,ipt2(ii)-ceil(1./(timeV(2)- timeV(1)))):ipt2(ii)-1  ));
        peakAccPost(ii-1) = max(tempA(min(ipt2(ii),length(tempA)):min( ipt2(ii)+ ceil(.35./(timeV(2)- timeV(1))) ,length(tempA))));
        peakVelocPost(ii-1) = max(temp(min(ipt2(ii),length(temp)):min( ipt2(ii)+ ceil(1.5/(timeV(2)- timeV(1))) ,length(temp))));
        diffMeanV(ii-1) = nanmean(temp(ipt2(ii): min(ipt2(min(ii+1,length(ipt2))),length(temp) )))- nanmean(temp(ipt2(ii-1):ipt2(ii)));
    end
    
    % to be locomotion initiation:     
    accPreLogic = peakAccPre;accPreLogic(peakAccPre<=thrAccRest)=1;accPreLogic(peakAccPre>thrAccRest)=0;
    vPreLogic = peakVPre;vPreLogic(peakVPre<=thrVelocRest)=1;vPreLogic(peakVPre>thrVelocRest)=0;
    accPostLogic = peakAccPost;accPostLogic(peakAccPost>=thrAccLoco)=1;accPostLogic(peakAccPost<thrAccLoco)=0;
    vPostLogic = peakVelocPost;vPostLogic(peakVelocPost>=thrVelocLoco)=1;vPostLogic(peakVelocPost<thrVelocLoco)=0;
    diffMeanLogic =diffMeanV;diffMeanLogic(diffMeanLogic>=0)=1;diffMeanLogic(diffMeanLogic<0)=0;
    prodLogic = accPreLogic.*vPreLogic.*accPostLogic.*diffMeanLogic.*vPostLogic;
    
    if ~isempty(find(prodLogic==1))
        iid=find(prodLogic==1);iid=iid(end);
        idKeep(ti) = ipt2(iid+1);
    else
        idKeep(ti) =nan;
    end
    else
    idKeep(ti) =nan;
    end
    title(num2str( idKeep(ti) ));
    %pause(2)
    close 
    
    
end
%
idKeep(idKeep==0)=nan;
timePh=Analysis.AllData.Photo_470.Time(1,:);
idKT = find(~isnan(idKeep)==1)
sum( ~isnan(idKeep));
figure
subplot(2,2,1)
for ii=1:length(idKT)
plot(timeV,tempVeloc(idKT(ii),:)');
hold on
line([timeV(idKeep(idKT(ii))) timeV(idKeep(idKT(ii)))],[0  max(tempVeloc(idKT(ii),:))],'Color','black')
%pause(1)
hold off
end
subplot(2,2,2)
imagesc(tempVeloc(idKT,:))
subplot(2,2,3)
for ii=1:length(idKT)
plot(timePh,tempPhoto_470(idKT(ii),:)');
hold on
line([timePh(idKeep(idKT(ii))) timePh(idKeep(idKT(ii)))],[0  max(tempPhoto_470(idKT(ii),:))],'Color','black')
end
subplot(2,2,4)
imagesc(tempPhoto_470(idKT,:))
% Reallign
tempVelocCent=[];idAllignVeloc=[];idAllignAcc=[];
for ii=1:length(idKT)
    % Alligh to Velocity
    tempVelocCent(ii,:)=zeros(1,segmCorr*2+1) ;
    tempV = smooth(tempVeloc(idKT(ii),:),5);
    idEnd = idKeep(idKT(ii)): min(idKeep(idKT(ii))+segmCorr,length(tempVeloc(1,:)));
    idStart =max(idKeep(idKT(ii))-segmCorr,1):idKeep(idKT(ii));
    tempVelocCent(ii,segmCorr+1: segmCorr+length(idEnd))=tempV( idEnd);
    tempVelocCent(ii,segmCorr-length(idStart)+2:segmCorr+1)=tempV( idStart); 
  %  figure
    seg=tempV( max(1,idKeep(idKT(ii))-40):min(idKeep(idKT(ii))+40,length(tempVeloc(1,:))));
    seg(seg<0.05)=0;
    idT = findchangepts(seg,'MaxNumChanges',3,'Statistic','mean') ;   
   % plot(seg( max(idT(1)-ceil(.5/(timeV(2)- timeV(1))),1) :idT(1)))
    [minV idMin]=min(seg( max(idT(1)-ceil(.5/(timeV(2)- timeV(1))),1) :idT(1)));
    idO = find(seg( max(idT(1)-ceil(.5/(timeV(2)- timeV(1))),1) :idT(1))==minV);
    idODiff= [diff(idO) ;2];idF = find(idODiff~=1);idF=max(1,idF(end)-1);idMin = idO(idF);
    idAllignVeloc(ii) = idMin+max(1,idKeep(idKT(ii))-40)+max(idT(1)-ceil(.5/(timeV(2)- timeV(1))),1);
   % plot(tempV(:));hold on
    %line([  idAllignVeloc(ii)    idAllignVeloc(ii)  ],[0 max(tempVeloc(idKT(ii),:))] )
 %   close
    
    tempAccCent(ii,:)=zeros(1,segmCorr*2+1) ;
    tempV = smooth(diff(tempVeloc(idKT(ii),:)),5);
    idEnd = idKeep(idKT(ii)): min(idKeep(idKT(ii))+segmCorr,length(tempV));
    idStart =max(idKeep(idKT(ii))-segmCorr,1):idKeep(idKT(ii));
    tempAccCent(ii,segmCorr+1: segmCorr+length(idEnd))=tempV( idEnd);
    tempAccCent(ii,segmCorr-length(idStart)+2:segmCorr+1)=tempV( idStart); 
    
    
    figure
    seg=tempV( max(1,idKeep(idKT(ii))-40):min(idKeep(idKT(ii))+40,length(tempV)));
    seg(seg<0.01)=0;
    idT = findchangepts(seg,'MaxNumChanges',5,'Statistic','mean') ;   
    if ~isempty(idT)
        plot(seg( max(idT(1)-ceil(.5/(timeV(2)- timeV(1))),1) :idT(1)))
        [minV idMin]=min(seg( max(idT(1)-ceil(.5/(timeV(2)- timeV(1))),1) :idT(1)));
        idO = find(seg( max(idT(1)-ceil(.5/(timeV(2)- timeV(1))),1) :idT(1))==minV);
        idODiff= [diff(idO) ;2];idF = find(idODiff~=1);idF=max(1,idF(end)-1);idMin = idO(idF);
        idAllignAcc(ii) = idMin+max(1,idKeep(idKT(ii))-40)+max(idT(1)-ceil(.5/(timeV(2)- timeV(1))),1)-1;
        plot(tempV(:));hold on
        line([  idAllignAcc(ii)    idAllignAcc(ii)  ],[0 max(tempVeloc(idKT(ii),:))] )
    end
    close
end
%
timeCent =unique([linspace(-1,0,segmCorr+1) linspace(0,1,segmCorr+1)]);
tempPhotoCent=[];tempPhotoCentA=[];

tempVelocCent=[];tempVelocCentA=[]
%
for ii=1:length(idKT);
   tempVelocCent(ii,:)=zeros(1,segmCorr*2+1) ;
   idEnd = idAllignVeloc(ii): min(idAllignVeloc(ii)+segmCorr,length(tempVeloc(1,:)));
   idStart =max(idAllignVeloc(ii)-segmCorr,1):idAllignVeloc(ii);
   tempVelocCent(ii,segmCorr+1: segmCorr+length(idEnd))=tempVeloc(idKT(ii),idEnd);
   tempVelocCent(ii,segmCorr-length(idStart)+2:segmCorr+1)=tempVeloc(idKT(ii),idStart);
   tempPhotoCent(ii,:)=zeros(1,segmCorr*2+1) ;
   idEnd = idAllignVeloc(ii): min(idAllignVeloc(ii)+segmCorr,length(tempPhoto_470(1,:)));
   idStart =max(idAllignVeloc(ii)-segmCorr,1):idAllignVeloc(ii);
   tempPhotoCent(ii,segmCorr+1: segmCorr+length(idEnd))=tempPhoto_470(idKT(ii),idEnd);
   tempPhotoCent(ii,segmCorr-length(idStart)+2:segmCorr+1)=tempPhoto_470(idKT(ii),idStart);
end

tempVelocCent(idAllignAcc==0,:)=[];
tempPhotoCent(idAllignAcc==0,:)=[];

idAllignAcc(idAllignAcc==0)=[];
for ii=1:length(idAllignAcc);
   tempVelocCentA(ii,:)=zeros(1,segmCorr*2+1) ;
   idEnd = idAllignAcc(ii): min(idAllignAcc(ii)+segmCorr,length(tempVeloc(1,:)));
   idStart =max(idAllignAcc(ii)-segmCorr,1):idAllignAcc(ii);
   tempVelocCentA(ii,segmCorr+1: segmCorr+length(idEnd))=tempVeloc(idKT(ii),idEnd);
   tempVelocCentA(ii,segmCorr-length(idStart)+2:segmCorr+1)=tempVeloc(idKT(ii),idStart);
   tempPhotoCentA(ii,:)=zeros(1,segmCorr*2+1) ;
   idEnd = idAllignAcc(ii): min(idAllignAcc(ii)+segmCorr,length(tempPhoto_470(1,:)));
   idStart =max(idAllignAcc(ii)-segmCorr,1):idAllignAcc(ii);
   tempPhotoCentA(ii,segmCorr+1: segmCorr+length(idEnd))=tempPhoto_470(idKT(ii),idEnd);
   tempPhotoCentA(ii,segmCorr-length(idStart)+2:segmCorr+1)=tempPhoto_470(idKT(ii),idStart);
end
%
figure

subplot(1,2,1)
imagesc(tempVelocCent);
subplot(1,2,2)
imagesc(diff(tempVelocCentA,[],2));
toDisc=input('Disc trials')
tempVelocCent(toDisc,:)=[];tempPhotoCent(toDisc,:)=[];
tempVelocCentA(toDisc,:)=[];tempPhotoCentA(toDisc,:)=[];

trialsNb =1:size(tempVelocCent,1);
figure('units','normalized','position',[0 0 .5 .5])
subplot(3,3,4)
plot(timeCent,tempVelocCent');xlabel('Time');ylabel('Velocity cm/s')
subplot(3,3,5)
imagesc(timeCent,trialsNb,tempVelocCent);hold on;xlabel('Time');ylabel('Trial Nb')
c=colorbar('location','eastoutside');    c.Label.String ='Velocity cm/s';
plot([0 0],[0 max(trialsNb)],'-r');   
title('Alligned to Velocity')
colormap hot
subplot(3,3,3)
shadedErrorBar(timeCent,nanmean(tempPhotoCent,1),...
    nanstd(tempPhotoCent,[],1)./(sqrt(length(idKT))),'-b',1);hold on
ylabel('DF/F0');xlabel('Time');
subplot(3,3,1)
plot(timeCent,tempPhotoCent');xlabel('Time');ylabel('DF/F0')
tit = strrep(DefaultParam.FileList(1:end-4),'_',' ');
tit  = strrep(tit,'CuedReward',' ');
title({[tit];['Discard bins around reward']})
subplot(3,3,2)
imagesc(timeCent,trialsNb,tempPhotoCent);hold on;xlabel('Time');ylabel('Trial Nb')
c=colorbar('location','eastoutside');    c.Label.String ='DF/F0';
plot([0 0],[0 max(trialsNb)],'-r');

subplot(3,3,6)
yyaxis right
shadedErrorBar(timeCent,nanmean(tempVelocCent,1),...
    nanstd(tempVelocCent,[],1)./(sqrt(length(idKT))),'-r',1);hold on
ylabel('Velocity cm/s');xlabel('Time');
yyaxis left
shadedErrorBar(timeCent,nanmean(tempPhotoCent,1),...
    nanstd(tempPhotoCent,[],1)./(sqrt(length(idKT))),'-b',1);hold on
ylabel('DF/F0')
subplot(3,3,7)
plot(timeCent(1:end-1),diff(tempVelocCentA'));xlabel('Time');ylabel('Acceleration cm/s2')
subplot(3,3,8)
imagesc(timeCent(1:end-1),trialsNb,diff(tempVelocCentA,[],2));hold on;xlabel('Time');ylabel('Trial Nb')
c=colorbar('location','eastoutside');    c.Label.String ='Acceleration cm/s2';
plot([0 0],[0 max(trialsNb)],'-r');
title('Alligned to Acceleration')
subplot(3,3,9)
yyaxis right  
shadedErrorBar(timeCent(1:end-1),nanmean(diff(tempVelocCentA'),2)',...
    nanstd(diff(tempVelocCentA'),[],2)'./(sqrt(length(idKT))),'-r',1);hold on
ylabel('Acceleration cm/s2');xlabel('Time');
yyaxis left
shadedErrorBar(timeCent(1:end),nanmean(tempPhotoCentA,1),...
    nanstd(tempPhotoCentA,[],1)./(sqrt(length(idKT))),'-b',1);hold on
ylabel('DF/F0')
saveas(gcf,[Analysis.Properties.DirFig  '\AllignedWheel\'  Analysis.Properties.Name 'allignedToWheel_allTrials' '.png']);
