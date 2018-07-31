%% Bpod Photometry Launcher
clear SessionData Analysis DefaultParam; close all;clear
%% Analysis type Single/Group
DefaultParam.Analysis_type='Group';
DefaultParam.Save=0;
DefaultParam.Load=0;
% Figures
DefaultParam.PlotSummary1=1;
DefaultParam.PlotSummary2=1;
DefaultParam.PlotFiltersSingle=0; %AP_Filter_GroupToPlot #1 Output
DefaultParam.PlotFiltersSummary=1;
DefaultParam.PlotFiltersBehavior=0; %AP_Filter_GroupToPlot #2 Ouput -- not really working properly
DefaultParam.Illustrator=0;
DefaultParam.Transparency=1;
% Axis
DefaultParam.PlotYNidaq=[-2 5];
DefaultParam.PlotYNidaq=[]; %;[-1 5];
DefaultParam.PlotX=[-4 4];
% States

%%%% 
DefaultParam.CueTimeReset=[0 1];
DefaultParam.OutcomeTimeReset=[0 2]; %  0 -3 for GoNogo - 0 2 for CuedRew
%%%% 


DefaultParam.StateToZero='StateOfOutcome'; %'StateOfCue' 'StateOfOutcome'
DefaultParam.ZeroAtZero=0;

%%%%%%%%%%%%%%%%%
DefaultParam.WheelState='Outcome'; %'Baseline','Cue','Outcome'
DefaultParam.PupilState='Outcome';
%%%%%%%%%%%%%%%%%%


% Filters
DefaultParam.PupilThreshold=2;
DefaultParam.WheelThreshold =2; %Speed cm/s
DefaultParam.LicksCue=2; 
DefaultParam.LicksOutcome=2;
DefaultParam.TrialToFilterOut=[];
DefaultParam.LoadIgnoredTrials=1;


%%%%%%%%%%%%%%%%% Overwrite Parameters found in AP_Parameters
DefaultParam.Name='VIP';
DefaultParam.Rig='Unknown';
DefaultParam.Behavior='CuedReward';
DefaultParam.Phase='RewardA';
DefaultParam.TrialNames={'T1','T2','T3','T4','T5','T6','T7','T8','T9','T10'};
DefaultParam.LickPort='Port1In';
DefaultParam.StateOfCue='Cue';
DefaultParam.StateOfOutcome='Outcome';
DefaultParam.NidaqBaseline=[1.5 2.5]; %% Absolute time 1.5 2.5
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Photometry
DefaultParam.SamplingRate = 6100;  %(Hz)
DefaultParam.NewSamplingRate    =   20; %(Hz)
%DefaultParam.DecimateFactor=305;

%%%%%%%%%%%%%
DefaultParam.NidaqDuration=15;
%%%%%%%%%%%%%
%% Run Analysis_Photometry
%[DefaultParam.FileList,DefaultParam.PathName]=uigetfile('*.mat','Select the BPod file(s)','MultiSelect', 'on');
close all

generalDir = 'F:\Data\FM\';
subjects = {'mar027' ,'mar027'  ,'mar027','mar027','mar027'};
sessions = [2,2,3,4 ];
dates = {'Jun05_2018','Jun14_2018','Jun14_2018','Jun14_2018','Jun14_2018'};
protocol = 'CuedReward';

DirAnalysis
% not: 1 6 7 10 13  17 18
for ss =  1:length(sessions);
    dir = [generalDir subjects{ss} '\' protocol '\Session Data' ];
    DefaultParam.PathName = dir;
    DefaultParam.FileList = [subjects{ss} '_' protocol '_' dates{ss} '_Session' num2str(sessions(ss)) '.mat'];
    if iscell(DefaultParam.FileList)==0
        DefaultParam.FileToOpen=cellstr(DefaultParam.FileList);
        DefaultParam.Analysis_type='Single';
        Analysis=Analysis_Photometry(DefaultParam); 
    else
        switch DefaultParam.Analysis_type
            case 'Single'
                 for i=1:length(DefaultParam.FileList)
                    DefaultParam.FileToOpen=DefaultParam.FileList(i);
                    try
                    Analysis=Analysis_Photometry(DefaultParam);
                    catch
                    disp([DefaultParam.FileToOpen ' NOT ANALYZED']);
                    end
                    close all;
                 end    
            case 'Group'
                DefaultParam.FileToOpen=DefaultParam.FileList;
                Analysis=Analysis_Photometry(DefaultParam);
        end
    end
AP_PlotSummary_AllSignals(Analysis,DefaultParam)
AP_PlotMeans(Analysis,DefaultParam )
%%% Plot of mean amplitudes for trial types + time overlapped


end






%%
for  ii=1:size(Analysis.AllData.Photo_405.Raw,1);
    try
        options = fitoptions('Method', 'LinearLeastSquares')
    curve = fit(time(:),Analysis.AllData.Photo_405.Raw(ii,:)','smoothingspline',options);
    yFitted(ii,:) = feval(curve,time);
    dff0Fitted(ii,:) = (Analysis.AllData.Photo_470.Raw(ii,:)-yFitted(ii,:))./yFitted(ii,:);
    dff0Corrected(ii,:) = (Analysis.AllData.Photo_470.Raw(ii,:)-Analysis.AllData.Photo_405.Raw(ii,:)) ...
        ./(Analysis.AllData.Photo_405.Raw(ii,:));
    catch
    yFitted(ii,:) = ones(1,length(time)).*nan;
    dff0Fitted(ii,:) = ones(1,length(time)).*nan;
    dff0Corrected(ii,:) =  ones(1,length(time)).*nan;
    end
end
figure
plot(Analysis.AllData.Photo_405.Raw(1,:)');hold on
plot(y);

figure 
subplot(1,2,1)
imagesc(dff0Corrected,[0 50] )
colorbar
subplot(1,2,2)
imagesc(dff0Fitted,[0 50] )
colorbar

figure
subplot(1,2,1)
imagesc(yFitted)
colorbar
subplot(1,2,2)
imagesc(Analysis.AllData.Photo_470.Raw)
colorbar
%%
Fs =1/(time(2)-time(1));
 
 
 
 for  ii=1:size(Analysis.AllData.Photo_405.Raw,1)
    try
    data=locdetrend(Analysis.AllData.Photo_405.Raw(ii,:)',Fs,[5 2.5]);
     f0(ii,:)  = Analysis.AllData.Photo_405.Raw(ii,:)'-data;

    dff0Fitted(ii,:) = (Analysis.AllData.Photo_470.Raw(ii,:)-f0(ii,:))./f0(ii,:);
    dff0Corrected(ii,:) = (Analysis.AllData.Photo_470.Raw(ii,:)-Analysis.AllData.Photo_405.Raw(ii,:)) ...
        ./(Analysis.AllData.Photo_405.Raw(ii,:));
    catch
    f0(ii,:) = ones(1,length(time)).*nan;
    dff0Fitted(ii,:) = ones(1,length(time)).*nan;
    dff0Corrected(ii,:) =  ones(1,length(time)).*nan;
    end
end
figure 
subplot(1,2,1)
imagesc(dff0Corrected,[0 35] )
colorbar
subplot(1,2,2)
imagesc(dff0Fitted,[0 35] )
colorbar

figure
subplot(1,2,1)
imagesc(f0)
colorbar
subplot(1,2,2)
imagesc(Analysis.AllData.Photo_470.Raw)
colorbar
%%

figure
plot(f0')
 

%%%

% tried:
% fitting cubic spline, smothing spline, linear fit to the 405 nm
% % fitting with the dtrend function on several window time
% still dont get the response transients i would have expected
% - when i only substract is fine
% but dividing it by the f0 doenst work