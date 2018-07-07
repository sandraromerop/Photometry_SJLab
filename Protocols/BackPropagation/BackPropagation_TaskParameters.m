function OperantConditioned_TaskParameters(ParamPC)
   global S
   
   
   listPhases= {'Simple Operant','Simple Operant Test','Conditioned Reinforcerment'} ;
    idx = listdlg('ListString',listPhases,...
        'PromptString','Select the phase of the experiment','SelectionMode','Single');
    phase{1}  =listPhases{idx};
    phaseName =  phase{1}; 
    S.GUIMeta.Phase.String = phaseName;

    S.Names.Rig=ParamPC.rig;
    S.GUI.RewardSide = 2; % 1, left; 2, right
    S.GUIMeta.RewardSide.Style = 'popupmenu'; 
    S.GUIMeta.RewardSide.String = {'Left', 'Right'};
    S.GUI.precueDuration  = 60 ; % sec
    S.GUI.RewardAmount = 3; %ul
    S.GUI.CueDuration =  60;   
    S.GUI.interCueDelay = .5;
    S.GUI.RewardDelay = 0.5; % How long the mouse must wait in the goal port for reward to be delivered
    S.GUI.MaxTrials = 300; 
    S.GUI.OmissionDelay = 0;
    S.GUI.TimePostOutcome = 5;
    S.GUI.TimeNoLick = 1;
    S.GUI.ITI = 5;
     
    S.GUIPanels.TaskSpecific = { 'RewardSide','CueDuration','RewardAmount',...
        'RewardDelay','OmissionDelay','MaxTrials','interCueDelay','precueDuration','TimePostOutcome','TimeNoLick',...
        'ITI'};
    S.GUITabs.TaskSpecific ={'TaskSpecific'};

    
    
end
