function CuedReward_TaskParameters(Param)
%
%
%

global S %BpodSystem
    listPhases= {'RewardA','RewardB','RewardAPunishB','RewardBPunishA',...
                    'RewardAPunishBValues','RewardBPunishAValues','RewardACBValues'} ;
    idx = listdlg('ListString',listPhases,...
        'PromptString','Select the Phase of the experiment');
    phase{1}  =listPhases{idx};
    phaseName =  phase{1}; 
    S.Names.Phase =listPhases;
    S.Names.Sound={'Sweep','Tones'};
    S.Names.StateToZero={'PostReward','SoundDelivery'};
    S.Names.OutcomePlot={'Collect','GoNoGo'};
    
    answer = questdlg('Load latest trial settings?', ...
            'loadTrialSettings','yes','no','no');
    loadFile = 0;

    if ~isempty(strfind(answer,'yes'))   
        if exist([ S.BpodPath '\TrialSettings_' phaseName '.mat' ],'file')==2
            load([ S.BpodPath '\TrialSettings_' phaseName '.mat' ])
        else
            load([ S.BpodPath '\TrialSettings_' phaseName  '_Default'  '.mat' ])
            disp('Non existent file of last session for this phase')
        end
        else
            load([ S.BpodPath '\TrialSettings_' phaseName  '_Default'  '.mat' ])
    end

        
    switch phaseName
        case 'RewardAPunishB' 
            S.Names.Symbols={'Reward','Omission', 'Punish'};
        case 'RewardBPunishA'     
            S.Names.Symbols={'Reward','Omission', 'Punish'};
        case 'RewardValues' 
            S.Names.Symbols={'Large', 'Inter', 'Small', 'Omission'};
        case 'RewardAPunishBValues' 
            S.Names.Symbols={'Reward','Omission', 'Punish'};
        case 'RewardBPunishAValues' 
            S.Names.Symbols={'Reward','Omission', 'Punish'};
        case 'RewardB'
            S.Names.Symbols={'Reward','Omission', 'Punish'};
        case 'RewardACBValues'
            S.Names.Symbols={'Reward','Omission', 'Punish'};
        case 'RewardA'
            S.Names.Symbols={'Reward','Omission', 'Punish','Reward Opto','Cue Opto'};
    
    end
 
    S.Names.Rig=Param.rig;
%% General Parameters    
    
    S.GUI.Phase = 1;
    S.GUIMeta.Phase.Style='popupmenu';
    S.GUIMeta.Phase.String=phaseName;
    
    S.GUI.MaxTrials=300;
    S.GUI.eZTrials=1;
    S.GUIMeta.eZTrials.Style='checkbox';
    S.GUIMeta.eZTrials.String='Auto';
    S.GUI.Wheel=1;
    S.GUIMeta.Wheel.Style='checkbox';
    S.GUIMeta.Wheel.String='Auto';
    S.GUI.Photometry=1;
    S.GUIMeta.Photometry.Style='checkbox';
    S.GUIMeta.Photometry.String='Auto';
    S.GUI.Modulation=1;
    S.GUIMeta.Modulation.Style='checkbox';
    S.GUIMeta.Modulation.String='Auto';
    S.GUI.DbleFibers=0;
    S.GUIMeta.DbleFibers.Style='checkbox';
    S.GUIMeta.DbleFibers.String='Auto';
    S.GUIPanels.General={'Phase','MaxTrials','eZTrials','Wheel','Photometry','Modulation','DbleFibers'};    
    
    %%%%f sinish gui-- test on Setup
    switch S.GUIMeta.Phase.String
      
        case 'RewardA'
                S.GUI.ProbCueARwd = TrialSettings.ProbCueARwd ;
                S.GUI.ProbCueAOmission = TrialSettings.ProbCueAOmission;
                S.GUI.ProbCueBOmission = TrialSettings.ProbCueBOmission ;
                S.GUI.ProbUncuedRwd =TrialSettings.ProbUncuedRwd ;
                S.GUI.ProbUncuedOmission = TrialSettings.ProbUncuedOmission;
                S.GUI.ProbCueAOpto= TrialSettings.ProbCueAOpto;
                S.GUI.ProbCueBOpto= TrialSettings.ProbCueBOpto;
                S.GUI.ProbCueARwdOpto= TrialSettings.ProbCueARwdOpto;
                S.GUI.ProbCueBOmissionOpto= TrialSettings.ProbCueBOmissionOpto;
        S.GUIPanels.TaskSpecifics={'ProbCueARwd',...
            'ProbCueAOmission','ProbCueBOmission',...
            'ProbUncuedRwd',...
            'ProbUncuedOmission','ProbCueAOpto',...
            'ProbCueBOpto','ProbCueARwdOpto',...
            'ProbCueBOmissionOpto'};
        
        case 'RewardAPunishB'
                S.GUI.ProbCueARwd =  TrialSettings.ProbCueARwd ;
                S.GUI.ProbCueAOmission = TrialSettings.ProbCueAOmission ;
                S.GUI.ProbCueBPunishment =  TrialSettings.ProbCueBPunishment ;
                S.GUI.ProbCueBOmission =  TrialSettings.ProbCueBOmission ;
                S.GUI.ProbUncuedRwd =  TrialSettings.ProbUncuedRwd ;
                S.GUI.ProbUncuedPunishment =  TrialSettings.ProbUncuedPunishment;
                S.GUI.ProbUncuedOmission =  TrialSettings.ProbUncuedOmission;

        S.GUIPanels.TaskSpecifics={'ProbCueARwd','ProbCueAOmission','ProbCueBPunishment','ProbCueBOmission',...
                        'ProbUncuedRwd','ProbUncuedPunishment','ProbUncuedOmission'};
                    
        case 'RewardBPunishA'
                S.GUI.ProbCueBRwd =  TrialSettings.ProbCueBRwd;    
                S.GUI.ProbCueBOmission =  TrialSettings.ProbCueBOmission ;    
                S.GUI.ProbCueAPunishment =  TrialSettings.ProbCueAPunishment;   
                S.GUI.ProbCueAOmission =  TrialSettings.ProbCueAOmission;
                S.GUI.ProbUncuedRwd = TrialSettings.ProbUncuedRwd;
                S.GUI.ProbUncuedPunishment =  TrialSettings.ProbUncuedPunishment;
                S.GUI.ProbUncuedOmission =  TrialSettings.ProbUncuedOmission;   

        case 'RewardValues'
        S.GUI.ProbCueASmallRwd =  TrialSettings.ProbCueASmallRwd;       
        S.GUI.ProbCueAInterRwd =  TrialSettings.ProbCueAInterRwd;    
        S.GUI.ProbCueAOmission =  TrialSettings.ProbCueAOmission;    
        S.GUI.ProbCueBInterRwd =  TrialSettings.ProbCueBInterRwd;    
        S.GUI.ProbCueBLargeRwd =  TrialSettings.ProbCueBLargeRwd;      
        S.GUI.ProbCueBOmission =  TrialSettings.ProbCueBOmission;    
        S.GUI.ProbUncuedInterRwd =  TrialSettings.ProbUncuedInterRwd;    
        

        S.GUIPanels.TaskSpecifics={'ProbCueASmallRwd','ProbCueAInterRwd','ProbCueAOmission','ProbCueBLargeRwd',...
                        'ProbCueBOmission','ProbUncuedInterRwd' };
        
        case 'RewardAPunishBValues'
        S.GUI.ProbCueARwd = TrialSettings.ProbCueARwd;    
        S.GUI.ProbCueAPunishment =TrialSettings.ProbCueAPunishment;    
        S.GUI.ProbCueAOmission =TrialSettings.ProbCueAOmission;    
        S.GUI.ProbCueBRwd =TrialSettings.ProbCueBRwd;    
        S.GUI.ProbCueBPunishment =TrialSettings.ProbCueBPunishment;    
        S.GUI.ProbCueBOmission =TrialSettings.ProbCueBOmission;    
        S.GUI.ProbUncuedRwd =TrialSettings.ProbUncuedRwd;    
        S.GUI.ProbUncuedPunishment = TrialSettings.ProbUncuedPunishment;    
        S.GUI.ProbUncuedOmission = TrialSettings.ProbUncuedOmission;       
        
        S.GUIPanels.TaskSpecifics={'ProbCueARwd','ProbCueAPunishment','ProbCueAOmission','ProbCueBRwd',...
            'ProbCueBPunishment','ProbCueBOmission','ProbUncuedRwd','ProbUncuedPunishment','ProbUncuedOmission'};
        
        case 'RewardBPunishAValues'  
        S.GUI.ProbCueARwd = TrialSettings.ProbCueARwd;    
        S.GUI.ProbCueAPunishment = TrialSettings.ProbCueAPunishment;    
        S.GUI.ProbCueAOmission = TrialSettings.ProbCueAOmission;    
        S.GUI.ProbCueBRwd = TrialSettings.ProbCueBRwd;    
        S.GUI.ProbCueBPunishment = TrialSettings.ProbCueBPunishment;    
        S.GUI.ProbCueBOmission = TrialSettings.ProbCueBOmission;    
        S.GUI.ProbUncuedRwd = TrialSettings.ProbUncuedRwd;    
        S.GUI.ProbUncuedPunishment =  TrialSettings.ProbUncuedPunishment;    
        S.GUI.ProbUncuedOmission =  TrialSettings.ProbUncuedOmission;    
        
        
        S.GUIPanels.TaskSpecifics={'ProbCueARwd','ProbCueAPunishment','ProbCueAOmission','ProbCueBRwd',...
            'ProbCueBPunishment','ProbCueBOmission','ProbUncuedRwd','ProbUncuedPunishment','ProbUncuedOmission'};
        
        case 'RewardB'
        S.GUI.ProbCueAOmission =TrialSettings.ProbCueARwd;    
        S.GUI.ProbCueBRwd =TrialSettings.ProbCueARwd;     
        S.GUI.ProbCueBOmission =TrialSettings.ProbCueARwd;    
        S.GUI.ProbUncuedRwd =TrialSettings.ProbCueARwd;    
        S.GUI.ProbUncuedOmission = TrialSettings.ProbCueARwd;      
        S.GUI.ProbBlank = TrialSettings.ProbCueARwd;    
         
        S.GUIPanels.TaskSpecifics={'ProbCueAOmission','ProbCueBRwd','ProbCueBOmission','ProbUncuedRwd',...
            'ProbUncuedOmission','ProbBlank' };
            
        
        case 'RewardACBValues'    
        S.GUI.ProbCueARwd =TrialSettings.ProbCueARwd;    
        S.GUI.ProbCueAOmission =TrialSettings.ProbCueAOmission;    
        S.GUI.ProbCueBRwd =TrialSettings.ProbCueBRwd;    
        S.GUI.ProbCueBOmission =TrialSettings.ProbCueBOmission;    
        S.GUI.ProbCueCRwd =TrialSettings.ProbCueCRwd;     
        S.GUI.ProbCueCOmission =TrialSettings.ProbCueCOmission;        
        
        S.GUIPanels.TaskSpecifics={'ProbCueARwd','ProbCueAOmission','ProbCueBRwd','ProbCueBOmission',...
            'ProbCueCRwd','ProbCueCOmission' };        
        
    end
        S.GUI.PreCue=TrialSettings.PreCue;
        S.GUI.Delay=TrialSettings.Delay;
        S.GUI.DelayIncrement=TrialSettings.DelayIncrement;
        S.GUI.PostOutcome=TrialSettings.PostOutcome;
        S.GUI.TimeNoLick=TrialSettings.TimeNoLick;
        S.GUI.ITI=TrialSettings.ITI;        
        S.GUIPanels.Timing={'PreCue','Delay','DelayIncrement','PostOutcome','TimeNoLick','ITI'};
    
    % -------------------
    S.GUIMeta.FiberLocation.Style='edittext';
    S.GUIMeta.FiberLocation.String='Auto';
    S.GUI.FiberLocation =' ';
    S.GUIMeta.OptoLocation.Style='edittext';
    S.GUIMeta.OptoLocation.String='Auto';    
    S.GUI.OptoLocation =' ';
    
    S.GUI.OptoPower =' ';
    S.GUI.MouseWeight =' ';
    
    S.GUIMeta.SessionNotes.Style='edittext';
    S.GUIMeta.SessionNotes.String='Auto';    
    S.GUI.SessionNotes =' ';
    
    S.GUIPanels.ExperimentNotes ={'FiberLocation','OptoLocation','OptoPower','MouseWeight','SessionNotes'};

    %     S.GUI.Date =  date ;
%     S.GUI.StartTime = datestr(now,'HH:MM:SS');
     
    % -------------------


    S.GUITabs.General={'Timing','TaskSpecifics','General','ExperimentNotes'};

%% Task Parameters

    S.GUI.SoundType=2;
    S.GUIMeta.SoundType.Style='popupmenu';
    S.GUIMeta.SoundType.String=S.Names.Sound;
    S.GUI.SoundDuration=1;
    S.GUI.LowFreq=TrialSettings.LowFreq;
    S.GUI.HighFreq=TrialSettings.HighFreq;
    S.GUI.SoundRamp=TrialSettings.SoundRamp; % in sec
    S.GUI.NbOfFreq=TrialSettings.NbOfFreq;
    S.GUI.FreqWidth=TrialSettings.FreqWidth;
	S.GUI.SoundSamplingRate=TrialSettings.SoundSamplingRate;
    S.GUIPanels.Cue={'SoundType','SoundDuration','LowFreq','HighFreq','SoundRamp','NbOfFreq','FreqWidth','SoundSamplingRate'};
    
    S.GUI.RewardValve=TrialSettings.RewardValve;
    S.GUIMeta.RewardValve.Style='popupmenu';
    S.GUIMeta.RewardValve.String={1,2,3,4,5,6};
    S.GUI.SmallReward=TrialSettings.SmallReward;
    S.GUI.InterReward=TrialSettings.InterReward;
    S.GUI.LargeReward=TrialSettings.LargeReward;
    S.GUI.PunishValve=TrialSettings.PunishValve;
	S.GUIMeta.PunishValve.Style='popupmenu';
    S.GUIMeta.PunishValve.String={1,2,3,4,5,6};
    S.GUI.PunishTime=TrialSettings.PunishTime;
    S.GUI.OmissionValve=TrialSettings.OmissionValve;
	S.GUIMeta.OmissionValve.Style='popupmenu';
    S.GUIMeta.OmissionValve.String={1,2,3,4,5,6};
    S.GUIPanels.Outcome={'RewardValve','SmallReward','InterReward','LargeReward','PunishValve','PunishTime','OmissionValve'};
 
    
    
    S.GUITabs.Cue={'Cue'};
    S.GUITabs.Outcome={'Outcome'};

%% Nidaq and Photometry
	S.GUI.NidaqDuration=TrialSettings.NidaqDuration;
    S.GUI.NidaqSamplingRate=TrialSettings.NidaqSamplingRate;
    S.GUI.LED1_Wavelength=TrialSettings.LED1_Wavelength;
    S.GUI.LED1_Amp=Param.LED1Amp;
    S.GUI.LED1_Freq=TrialSettings.LED1_Freq;
    S.GUI.LED2_Wavelength=TrialSettings.LED2_Wavelength;
    S.GUI.LED2_Amp=Param.LED2Amp;
    S.GUI.LED2_Freq=TrialSettings.LED2_Freq;
    S.GUI.LED1b_Wavelength=TrialSettings.LED1b_Wavelength;
    S.GUI.LED1b_Amp=Param.LED1bAmp;
    S.GUI.LED1b_Freq=TrialSettings.LED1b_Freq;

    S.GUIPanels.Photometry={'NidaqDuration','NidaqSamplingRate',...
                            'LED1_Wavelength','LED1_Amp','LED1_Freq',...
                            'LED2_Wavelength','LED2_Amp','LED2_Freq',...
                            'LED1b_Wavelength','LED1b_Amp','LED1b_Freq'};
                        
    S.GUITabs.Photometry={'Photometry'};

%% Optogenetics
    S.GUI.OptoStimCueDelay = TrialSettings.OptoStimCueDelay;
    S.GUI.PulseInterval = TrialSettings.PulseInterval;
    S.GUI.Phase1Voltage = TrialSettings.Phase1Voltage;
    S.GUI.Phase2Voltage = TrialSettings.Phase2Voltage;
    S.GUI.Phase1Duration = TrialSettings.Phase1Duration;
    S.GUI.Phase2Duration = TrialSettings.Phase2Duration;
    S.GUI.InterPhaseInterval = TrialSettings.InterPhaseInterval;
    S.GUI.PulseTrainDelay = TrialSettings.PulseTrainDelay;
    S.GUI.PulseTrainDuration = TrialSettings.PulseTrainDuration;
    S.GUI.LinkedToTriggerCH1 = TrialSettings.LinkedToTriggerCH1;
    S.GUI.LinkedToTriggerCH2 = TrialSettings.LinkedToTriggerCH2;
    

    S.GUIPanels.Optogenetics={ 'OptoStimCueDelay','PulseInterval','Phase1Voltage','Phase2Voltage',...
        'Phase1Duration','Phase2Duration','InterPhaseInterval','PulseTrainDelay','PulseTrainDuration','LinkedToTriggerCH1',...
        'LinkedToTriggerCH2'};
    S.GUITabs.Optogenetics={'Optogenetics'};

    %%%% Add more options 
%% Online Plots   
    S.GUI.StateToZero=1;
	S.GUIMeta.StateToZero.Style = 'popupmenu';
    S.GUIMeta.StateToZero.String=S.Names.StateToZero;
    S.GUI.TimeMin=TrialSettings.TimeMin;
    S.GUI.TimeMax=TrialSettings.TimeMax;
    S.GUIPanels.PlotParameters = {'StateToZero','TimeMin','TimeMax'};
    
    S.GUI.Outcome=TrialSettings.Outcome;
    S.GUIMeta.Outcome.Style = 'popupmenu';
    S.GUIMeta.Outcome.String = S.Names.OutcomePlot;
    
    S.GUI.Circle=TrialSettings.Circle;
    S.GUIMeta.Circle.Style = 'popupmenu';
    S.GUIMeta.Circle.String = S.Names.Symbols;
    
	S.GUI.Square=TrialSettings.Square;
    S.GUIMeta.Square.Style = 'popupmenu';
    S.GUIMeta.Square.String = S.Names.Symbols;
    
    S.GUI.Diamond=TrialSettings.Diamond;
    S.GUIMeta.Diamond.Style = 'popupmenu';
    S.GUIMeta.Diamond.String = S.Names.Symbols;
    
    S.GUIPanels.PlotLicks={'Outcome','Circle','Square','Diamond'};
    
    S.GUI.DecimateFactor=TrialSettings.DecimateFactor;
	S.GUI.BaselineBegin=TrialSettings.BaselineBegin;
    S.GUI.BaselineEnd=TrialSettings.BaselineEnd;
    S.GUI.NidaqMin=TrialSettings.NidaqMin;
    S.GUI.NidaqMax=TrialSettings.NidaqMax;
    S.GUIPanels.PlotNidaq={'DecimateFactor','NidaqMin','NidaqMax','BaselineBegin','BaselineEnd'};
    
    S.GUITabs.OnlinePlot={'PlotNidaq','PlotLicks','PlotParameters'};
    
    
    
    
    
    
    %%%_-----------------------change symbols : probability dependent
    %%% make more subplots 
    
end
