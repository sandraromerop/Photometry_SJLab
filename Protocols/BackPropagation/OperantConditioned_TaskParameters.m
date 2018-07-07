function OperantConditioned_TaskParameters(ParamPC)
   global S
   
   
   listPhases= {'Simple Operant','Simple Operant Test','Conditioned Reinforcement Training','Conditioned Reinforcement'} ;
    idx = listdlg('ListString',listPhases,...
        'PromptString','Select the phase of the experiment','SelectionMode','Single');
    phase{1}  =listPhases{idx};
    phaseName =  phase{1}; 
    S.GUIMeta.Phase.String = phaseName;

    S.Names.Rig=ParamPC.rig;
    S.GUI.RewardSide = 2; % 1, left; 2, right
    S.GUIMeta.RewardSide.Style = 'popupmenu'; 
    S.GUIMeta.RewardSide.String = {'Left', 'Right'};
    
    S.GUI.precueDuration  = 3; % sec
    S.GUI.RewardAmount = 3; %ul
    S.GUI.CueDuration =  500; 
    S.GUI.interCueDelay = 0.5;
    S.GUI.RewardDelay = 0; % How long the mouse must wait in the goal port for reward to be delivered
    S.GUI.MaxTrials = 300; 
    S.GUI.OmissionDelay = 0;
    S.GUI.TimePostOutcome = 2;
    S.GUI.TimeNoLick = 2;
    S.GUI.ITI = 2;
    S.GUI.IncorrectTimeOut = 3;
    
     
    S.GUIPanels.TaskSpecific = { 'RewardSide','CueDuration','RewardAmount',...
        'RewardDelay','OmissionDelay','MaxTrials','interCueDelay','precueDuration','TimePostOutcome','TimeNoLick',...
        'ITI','IncorrectTimeOut'};
    S.GUITabs.TaskSpecific ={'TaskSpecific'};

    
    
end

