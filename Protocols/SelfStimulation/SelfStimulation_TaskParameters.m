function SelfStimulation_TaskParameters(ParamPC)
global S

    % Task Specific
    S.Names.Rig=ParamPC.rig;
    S.GUI.LaserSide = 2; % 1, left; 2, right
    S.GUIMeta.LaserSide.Style = 'popupmenu'; 
    S.GUIMeta.LaserSide.String = {'Left', 'Right'};
    S.GUIMeta.Phase.String = 'SelfStim';
    
    % Timings : 
    S.GUI.WaitForResponse = 30;
    S.GUI.StimDelay = 0;
    S.GUI.MaxTrials = 300;
    
    % Phase selection
    S.GUI.TrainingLevel = 1;
    S.GUIMeta.TrainingLevel.Style = 'popupmenu'; 
    S.GUIMeta.TrainingLevel.String = {  'SelfStimulation' };
    S.GUIMeta.Phase.String = 'SelfStimulation';
    
    S.GUIPanels.TaskSpecific = {'TrainingLevel','LaserSide','WaitForResponse','StimDelay','MaxTrials'};
    S.GUITabs.TaskSpecific ={'TaskSpecific'};
    
    
    % Optogenetics
    S.GUI.OptoStimStateDuration = 0;
    S.GUI.PulseInterval = 0;
    S.GUI.Phase1Voltage = 5;
    S.GUI.Phase2Voltage = -5;
    S.GUI.Phase1Duration = .005;
    S.GUI.Phase2Duration = .005;
    S.GUI.InterPhaseInterval = .001 ;
    S.GUI.PulseTrainDelay = 0;
    S.GUI.PulseTrainDuration = .5;
    S.GUI.LinkedToTriggerCH1 = 1;
    S.GUI.LinkedToTriggerCH2 = 0;
    
    S.GUIPanels.Optogenetics={ 'OptoStimStateDuration','PulseInterval','Phase1Voltage','Phase2Voltage',...
        'Phase1Duration','Phase2Duration','InterPhaseInterval','PulseTrainDelay','PulseTrainDuration','LinkedToTriggerCH1',...
        'LinkedToTriggerCH2'};
    S.GUITabs.Optogenetics ={'Optogenetics'};

end
