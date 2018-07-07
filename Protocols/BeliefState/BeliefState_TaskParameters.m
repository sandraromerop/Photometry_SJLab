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
%% General Parameters    
    
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

    S.GUI.PreCue=TrialSettings.PreCue;
    S.GUI.DelayA=TrialSettings.DelayA;
    S.GUI.DelayB=TrialSettings.DelayB;
    S.GUI.DelayC=TrialSettings.DelayC;
    S.GUI.DelayD=TrialSettings.DelayD;
    S.GUI.DelayIncrement=TrialSettings.DelayIncrement;
    S.GUI.PostOutcome=TrialSettings.PostOutcome;
    S.GUI.TimeNoLick=TrialSettings.TimeNoLick;
    S.GUI.ITI=TrialSettings.ITI;        
    S.GUIPanels.Timing={'PreCue','DelayA','DelayB','DelayC','DelayD','DelayIncrement','PostOutcome','TimeNoLick','ITI'};
    
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
    
    % -------------------


    S.GUITabs.General={'Timing','General','ExperimentNotes'};


    %% Trial Arrangement
        %%%%f sinish gui-- test on Setup
        
    % Trial arangement type 
    S.GUI.MaxTrials=300;    
    S.GUI.TrialsOrder = 1;
    S.GUIMeta.TrialsOrder.Style='popupmenu';
    S.GUIMeta.TrialsOrder.String={'randomize','block'}; 
    
    S.GUIPanels.TrialSettings={ 'MaxTrials','TrialsOrder'};
        
    switch S.GUIMeta.Phase.String
      
        case 'BeliefState'
        
        S.GUI.ProbA =   TrialSettings.ProbA;
        S.GUI.ProbA =   TrialSettings.ProbA;
        S.GUI.ProbAOmission =   TrialSettings.ProbAOmission;
        S.GUI.ProbB =   TrialSettings.ProbB;
        S.GUI.ProbBOmission =   TrialSettings.ProbBOmission;
        S.GUI.ProbC =   TrialSettings.ProbC;
        S.GUI.ProbCOmission =   TrialSettings.ProbCOmission;    
        S.GUI.ProbD =   TrialSettings.ProbD;
        S.GUI.ProbDOmission =   TrialSettings.ProbDOmission;    
        S.GUI.ProbUncuedRwd =   TrialSettings.ProbUncuedRwd;
        S.GUI.ProbUncuedOmission =   TrialSettings.ProbUncuedOmission;
        S.GUI.ProbAOptoCue =   TrialSettings.ProbAOptoCue;
        S.GUI.ProbBOptoCue =   TrialSettings.ProbBOptoCue;
        S.GUI.ProbCOptoCue =   TrialSettings.ProbCOptoCue;
        S.GUI.ProbDOptoCue =   TrialSettings.ProbDOptoCue;
        S.GUI.ProbAOptoOutcome =   TrialSettings.ProbAOptoOutcome;
        S.GUI.ProbBOptoOutcome =   TrialSettings.ProbBOptoOutcome;
        S.GUI.ProbCOptoOutcome =   TrialSettings.ProbCOptoOutcome;
        S.GUI.ProbDOptoOutcome =   TrialSettings.ProbDOptoOutcome;
                
        S.GUIPanels.Probabilities={'ProbA','ProbAOmission',...
            'ProbB','ProbBOmission',...
            'ProbC','ProbCOmission',...
            'ProbD','ProbDOmission',...
            'ProbUncuedRwd','ProbUncuedOmission',...
            'ProbAOptoCue','ProbBOptoCue','ProbCOptoCue','ProbDOptoCue',...
            'ProbAOptoOutcome','ProbBOptoOutcome','ProbCOptoOutcome','ProbDOptoOutcome'};
        
        
        S.GUI.OrderA =   TrialSettings.OrderA;
        S.GUI.OrderAOmission =   TrialSettings.OrderAOmission;
        S.GUI.OrderB =   TrialSettings.OrderB;
        S.GUI.OrderBOmission =   TrialSettings.OrderBOmission;
        S.GUI.OrderC =   TrialSettings.OrderC;
        S.GUI.OrderCOmission =   TrialSettings.OrderCOmission;
        S.GUI.OrderD =   TrialSettings.OrderD;
        S.GUI.OrderDOmission =   TrialSettings.OrderDOmission;
        S.GUI.OrderUncuedRwd =   TrialSettings.OrderUncuedRwd;
        S.GUI.OrderUncuedOmission =   TrialSettings.OrderUncuedOmission;
        S.GUI.OrderAOptoCue =   TrialSettings.OrderAOptoCue;
        S.GUI.OrderBOptoCue =   TrialSettings.OrderBOptoCue;
        S.GUI.OrderCOptoCue =   TrialSettings.OrderCOptoCue;
        S.GUI.OrderDOptoCue =   TrialSettings.OrderDOptoCue;
        S.GUI.OrderAOptoOutcome =   TrialSettings.OrderAOptoOutcome;
        S.GUI.OrderBOptoOutcome =   TrialSettings.OrderBOptoOutcome;
        S.GUI.OrderCOptoOutcome =   TrialSettings.OrderCOptoOutcome;
        S.GUI.OrderDOptoOutcome =   TrialSettings.OrderDOptoOutcome;
                
                S.GUIMeta.OrderA.Style='popupmenu';
                S.GUIMeta.OrderA.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};
                S.GUIMeta.OrderAOmission.Style='popupmenu';
                S.GUIMeta.OrderAOmission.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};
                S.GUIMeta.OrderB.Style='popupmenu';
                S.GUIMeta.OrderB.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};
                S.GUIMeta.OrderBOmission.Style='popupmenu';
                S.GUIMeta.OrderBOmission.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};
                S.GUIMeta.OrderC.Style='popupmenu';
                S.GUIMeta.OrderC.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};
                S.GUIMeta.OrderCOmission.Style='popupmenu';
                S.GUIMeta.OrderCOmission.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};
                S.GUIMeta.OrderD.Style='popupmenu';
                S.GUIMeta.OrderD.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};
                S.GUIMeta.OrderDOmission.Style='popupmenu';
                S.GUIMeta.OrderDOmission.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};
                S.GUIMeta.OrderUncuedRwd.Style='popupmenu';
                S.GUIMeta.OrderUncuedRwd.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};
                S.GUIMeta.OrderUncuedOmission.Style='popupmenu';
                S.GUIMeta.OrderUncuedOmission.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};            
                S.GUIMeta.OrderAOptoCue.Style='popupmenu';
                S.GUIMeta.OrderAOptoCue.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};
                S.GUIMeta.OrderBOptoCue.Style='popupmenu';
                S.GUIMeta.OrderBOptoCue.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};
                S.GUIMeta.OrderCOptoCue.Style='popupmenu';
                S.GUIMeta.OrderCOptoCue.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};
                S.GUIMeta.OrderDOptoCue.Style='popupmenu';
                S.GUIMeta.OrderDOptoCue.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};
                S.GUIMeta.OrderAOptoOutcome.Style='popupmenu';
                S.GUIMeta.OrderAOptoOutcome.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};
                S.GUIMeta.OrderBOptoOutcome.Style='popupmenu';
                S.GUIMeta.OrderBOptoOutcome.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};
                S.GUIMeta.OrderCOptoOutcome.Style='popupmenu';
                S.GUIMeta.OrderCOptoOutcome.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};
                S.GUIMeta.OrderDOptoOutcome.Style='popupmenu';
                S.GUIMeta.OrderDOptoOutcome.String={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,nan};
                
                
       S.GUIPanels.Order={ 'OrderA','OrderAOmission',...
            'OrderB','OrderBOmission',...
            'OrderC','OrderCOmission',...
            'OrderD','OrderDOmission',...
            'OrderUncuedRwd','OrderUncuedOmission',...
            'OrderAOptoCue','OrderBOptoCue','OrderCOptoCue','OrderDOptoCue',...
            'OrderAOptoOutcome','OrderBOptoOutcome','OrderCOptoOutcome','OrderDOptoOutcome'};
    end
        S.GUITabs.TrialArrangement={ 'TrialSettings','Probabilities','Order'};

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
