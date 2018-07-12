function BeliefState_TaskParameters(Param)
%
%
%

global S %BpodSystem
%     listPhases= {'RewardA','RewardB','RewardAPunishB','RewardBPunishA',...
%                     'RewardAPunishBValues','RewardBPunishAValues','RewardACBValues'} ;
%     idx = listdlg('ListString',listPhases,...
%         'PromptString','Select the Phase of the experiment');
%     phase{1}  =listPhases{idx};
    phaseName = 'BeliefState'; 
    S.Names.Phase =phaseName;
    S.Names.Sound={'Sweep','Tones'};
    S.Names.StateToZero={'PostReward','SoundDelivery'};
    S.Names.OutcomePlot={'Collect','GoNoGo'};
    
    answer = questdlg('Load latest trial settings?', ...
            'loadTrialSettings','yes','no','no');
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
        case 'BeliefState'
            S.Names.Symbols={'Reward','Omission', 'Punish','Reward Opto','Cue Opto'};
    
    end
 
    S.Names.Rig=Param.rig;
%% Notes
    
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
    
    
    S.GUI.Phase = 1;
    S.GUIMeta.Phase.Style='popupmenu';
    S.GUIMeta.Phase.String=phaseName;
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
    
    S.GUIPanels.General={'Phase','Wheel','Photometry','Modulation','DbleFibers'};  
    
    S.GUITabs.General ={'ExperimentNotes','General'};
%% General Parameters    
    
  
    S.GUI.PreCue=TrialSettings.PreCue;
    
    S.GUI.Delay.DelayA = TrialSettings.Delay.DelayA;
    S.GUI.Delay.DelayB = TrialSettings.Delay.DelayB;
    S.GUI.Delay.DelayC = TrialSettings.Delay.DelayC;
    S.GUI.Delay.DelayD = TrialSettings.Delay.DelayD;
    S.GUIMeta.Delay.Style ='table';
    
    S.GUI.DelayDistributionEnd.A = 0;
    S.GUI.DelayDistributionEnd.B = 0;
    S.GUI.DelayDistributionEnd.C = 0;
    S.GUI.DelayDistributionEnd.D = 0;
    S.GUIMeta.DelayDistributionEnd.Style ='table';
    
    S.GUI.DelayDistributionStep.A = 0;
    S.GUI.DelayDistributionStep.B = 0;
    S.GUI.DelayDistributionStep.C = 0;
    S.GUI.DelayDistributionStep.D = 0;
    S.GUIMeta.DelayDistributionStep.Style ='table';
    
	S.GUI.DelayDistributionMu.A = 0;
    S.GUI.DelayDistributionMu.B = 0;
    S.GUI.DelayDistributionMu.C = 0;
    S.GUI.DelayDistributionMu.D = 0;
    S.GUIMeta.DelayDistributionMu.Style ='table';
    
    S.GUI.DelayDistributionSigma.A = 0;
    S.GUI.DelayDistributionSigma.B = 0;
    S.GUI.DelayDistributionSigma.C = 0;
    S.GUI.DelayDistributionSigma.D = 0;
    S.GUIMeta.DelayDistributionSigma.Style ='table';
    
    S.GUI.PostOutcome=TrialSettings.PostOutcome;
    S.GUI.TimeNoLick=TrialSettings.TimeNoLick;
    S.GUI.ITI=TrialSettings.ITI;        
    
    S.GUIPanels.Timing={'PreCue','Delay','DelayDistributionEnd','DelayDistributionStep','DelayDistributionMu','DelayDistributionSigma','PostOutcome','TimeNoLick','ITI'};
    % -------------------


    S.GUITabs.Timing={'Timing'};


    %% Trial Arrangement
        
    % Trial arangement type 
    switch S.GUIMeta.Phase.String      
        case 'BeliefState'
        
        S.GUI.ProbA.A =   TrialSettings.ProbA.A;
        S.GUI.ProbA.AOmission =   TrialSettings.ProbA.AOmission;
        S.GUI.ProbA.AOptoCue =   TrialSettings.ProbA.AOptoCue;
        S.GUI.ProbA.AOptoOutcome =   TrialSettings.ProbA.AOptoOutcome;
        S.GUIMeta.ProbA.Style ='table';
        
        S.GUI.ProbB.B =   TrialSettings.ProbB.B;
        S.GUI.ProbB.BOmission =   TrialSettings.ProbB.BOmission ;
        S.GUI.ProbB.BOptoCue =   TrialSettings.ProbB.BOptoCue;
        S.GUI.ProbB.BOptoOutcome =   TrialSettings.ProbB.BOptoOutcome ;
        S.GUIMeta.ProbB.Style ='table';
        
        S.GUI.ProbC.C =   TrialSettings.ProbC.C;
        S.GUI.ProbC.COmission =   TrialSettings.ProbC.COmission;    
        S.GUI.ProbC.COptoCue =   TrialSettings.ProbC.COptoCue;
        S.GUI.ProbC.COptoOutcome =   TrialSettings.ProbC.COptoOutcome;
        S.GUIMeta.ProbC.Style ='table';
        
        S.GUI.ProbD.D =   TrialSettings.ProbD.D ;
        S.GUI.ProbD.DOmission =   TrialSettings.ProbD.DOmission;    
        S.GUI.ProbD.DOptoCue =   TrialSettings.ProbD.DOptoCue ;
        S.GUI.ProbD.DOptoOutcome =   TrialSettings.ProbD.DOptoOutcome;
        S.GUIMeta.ProbD.Style ='table';
        
        S.GUI.ProbUncued.UncuedRwd =   TrialSettings.ProbUncued.UncuedRwd;
        S.GUI.ProbUncued.UncuedOmission =   TrialSettings.ProbUncued.UncuedOmission;
        S.GUIMeta.ProbUncued.Style ='table';
        
        S.GUIPanels.Probabilities={'ProbA', 'ProbB',...
            'ProbC', 'ProbD' ...
            'ProbUncued'};
        
        
        S.GUI.MaxTrials=300;    
        S.GUI.TrialsOrder = 1;
        S.GUIMeta.TrialsOrder.Style='popupmenu';
        S.GUIMeta.TrialsOrder.String={'randomize','block'}; 

        S.GUI.OrderA.A =   TrialSettings.OrderA.A ;
        S.GUI.OrderA.AOmission =   TrialSettings.OrderA.AOmission;
        S.GUI.OrderA.AOptoCue =   TrialSettings.OrderA.AOptoCue;
        S.GUI.OrderA.AOptoOutcome =   TrialSettings.OrderA.AOptoOutcome ;
        S.GUIMeta.OrderA.Style ='table';
        S.GUI.OrderB.B =   TrialSettings.OrderB.B;
        S.GUI.OrderB.BOmission =   TrialSettings.OrderB.BOmission;
        S.GUI.OrderB.BOptoCue =   TrialSettings.OrderB.BOptoCue;
        S.GUI.OrderB.BOptoOutcome =   TrialSettings.OrderB.BOptoOutcome;
        S.GUIMeta.OrderB.Style ='table';
        S.GUI.OrderC.C =   TrialSettings.OrderC.C;
        S.GUI.OrderC.COmission =   TrialSettings.OrderC.COmission;
        S.GUI.OrderC.COptoCue =   TrialSettings.OrderC.COptoCue ;
        S.GUI.OrderC.COptoOutcome =   TrialSettings.OrderC.COptoOutcome;
        S.GUIMeta.OrderC.Style ='table';
        S.GUI.OrderD.D =   TrialSettings.OrderD.D ;
        S.GUI.OrderD.DOmission =   TrialSettings.OrderD.DOmission ;
        S.GUI.OrderD.DOptoCue =   TrialSettings.OrderD.DOptoCue;
        S.GUI.OrderD.DOptoOutcome =   TrialSettings.OrderD.DOptoOutcome;
        S.GUIMeta.OrderD.Style ='table';
        S.GUI.OrderUncued.UncuedRwd =   TrialSettings.OrderUncued.UncuedRwd;
        S.GUI.OrderUncued.UncuedOmission =   TrialSettings.OrderUncued.UncuedOmission;
        S.GUIMeta.OrderUncued.Style ='table';
        
                 
       S.GUIPanels.Order={'MaxTrials','TrialsOrder', 'OrderA',...
            'OrderB',...
            'OrderC',...
            'OrderD',...
            'OrderUncued'};
    end
	S.GUITabs.TrialArrangement={ 'Probabilities','Order'};
    %% Task Parameters

    S.GUI.SoundType=2;
    S.GUIMeta.SoundType.Style='popupmenu';
    S.GUIMeta.SoundType.String=S.Names.Sound;
    S.GUI.SoundDuration=1;
    S.GUI.FreqA=TrialSettings.FreqA;
    S.GUI.FreqB=TrialSettings.FreqB;
    S.GUI.FreqC=TrialSettings.FreqC;
    S.GUI.FreqD=TrialSettings.FreqD;
    S.GUI.SoundRamp=TrialSettings.SoundRamp; % in sec
    S.GUI.NbOfFreq=TrialSettings.NbOfFreq;
    S.GUI.FreqWidth=TrialSettings.FreqWidth;
	S.GUI.SoundSamplingRate=TrialSettings.SoundSamplingRate;
    S.GUIPanels.Cue={'SoundType','SoundDuration','FreqA','FreqB','FreqC','FreqD','SoundRamp','NbOfFreq','FreqWidth','SoundSamplingRate'};
    
    
    S.GUIMeta.RewardValveA.Style='popupmenu';
    S.GUIMeta.RewardValveA.String={1,2,3,4,5,6};
    S.GUIMeta.RewardValveB.Style='popupmenu';
    S.GUIMeta.RewardValveB.String={1,2,3,4,5,6};
    S.GUIMeta.RewardValveC.Style='popupmenu';
    S.GUIMeta.RewardValveC.String={1,2,3,4,5,6};
    S.GUIMeta.RewardValveD.Style='popupmenu';
    S.GUIMeta.RewardValveD.String={1,2,3,4,5,6};
	S.GUIMeta.OmissionValve.Style='popupmenu';
    S.GUIMeta.OmissionValve.String={1,2,3,4,5,6};
	S.GUIMeta.PunishValve.Style='popupmenu';
    S.GUIMeta.PunishValve.String={1,2,3,4,5,6};
    
    S.GUI.RewardA=TrialSettings.RewardA;
    S.GUI.RewardB=TrialSettings.RewardB;
    S.GUI.RewardC=TrialSettings.RewardC;
    S.GUI.RewardD=TrialSettings.RewardD;
    S.GUI.RewardValveA=TrialSettings.RewardValveA;
    S.GUI.RewardValveB=TrialSettings.RewardValveB;
    S.GUI.RewardValveC=TrialSettings.RewardValveC;
    S.GUI.RewardValveD=TrialSettings.RewardValveD;
    S.GUI.PunishValve=TrialSettings.PunishValve;
    S.GUI.PunishTime=TrialSettings.PunishTime;
    S.GUI.OmissionValve=TrialSettings.OmissionValve;

    S.GUIPanels.Outcome={'RewardValveA','RewardValveB','RewardValveC','RewardValveD','RewardA','RewardB','RewardC','RewardD','PunishValve','PunishTime','OmissionValve'};
 
    
    
    S.GUITabs.Cue={'Cue'};
    S.GUITabs.Outcome={'Outcome'};

%% Nidaq and Photometry
	S.GUI.NidaqDuration=TrialSettings.NidaqDuration;
    S.GUI.NidaqSamplingRate=TrialSettings.NidaqSamplingRate;
    S.GUI.LED1_Wavelength=TrialSettings.LED1_Wavelength;
    S.GUI.LED1_Amp=TrialSettings.LED1_Amp;
    S.GUI.LED1_Freq=TrialSettings.LED1_Freq;
    S.GUI.LED2_Wavelength=TrialSettings.LED2_Wavelength;
    S.GUI.LED2_Amp=TrialSettings.LED2_Amp;
    S.GUI.LED2_Freq=TrialSettings.LED2_Freq;
    S.GUI.LED1b_Wavelength=TrialSettings.LED1b_Wavelength;
    S.GUI.LED1b_Amp=TrialSettings.LED1b_Amp;
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
