function OperantConditioned

% Operant + conditioned reinforcement

% SETUP
% You will need:
% - A Bpod MouseBox (or equivalent) configured with 3 ports.
% - Place masking tape over the center port (Port 2).
global BpodSystem S

%% Define parameters
S = BpodSystem.ProtocolSettings; % Load settings chosen in launch manager into current workspace as a struct called S
ParamPC=BpodParam_PCdep();

if isempty(fieldnames(S))  % If settings file was an empty struct, populate struct with default settings
    S.BpodPath = BpodSystem.BpodPath;
    OperantConditioned_TaskParameters(ParamPC)
end
% Initialize parameter GUI plugin
BpodParameterGUI('init', S);
%TotalRewardDisplay('init');
BpodSystem.Pause=1;
HandlePauseCondition;
S = BpodParameterGUI('sync', S);
%% Define trials
MaxTrials = S.GUI.MaxTrials ;
switch S.GUI.RewardSide
    case 1
        TrialTypes = ones(1,MaxTrials);
    case 2
        TrialTypes = 2*ones(1,MaxTrials);
end
BpodSystem.Data.TrialTypes = []; % The trial type of each trial completed will be added here.

%% Initialize plots
% TrialType Outcome Plot (displays each future trial type, and scores completed trials as correct/incorrect
BpodSystem.ProtocolFigures.SideOutcomePlotFig = figure('Position', [200 200 1000 200],'name','Outcome plot','numbertitle','off', 'MenuBar', 'none', 'Resize', 'off');
BpodSystem.GUIHandles.SideOutcomePlot = axes('Position', [.075 .3 .89 .6]);
SideOutcomePlot(BpodSystem.GUIHandles.SideOutcomePlot,'init',TrialTypes);
% Bpod Notebook (to record text notes about the session or individual trials)
% BpodNotebook('init');
valvePhysicalAddress = 2.^(0:7) ;
for currentTrial = 1:MaxTrials
    S = BpodParameterGUI('sync', S); % Sync parameters with BpodParameterGUI plugin
    
    
    if S.GUI.RewardSide==1
        valveTime = GetValveTimes(S.GUI.RewardAmount, [4]); %GetValveTimes(S.GUI.RewardAmount, [4]); 
        valveState = valvePhysicalAddress(4);
        portIn = 'Port4In';ledOut = 'PWM5';
        portsNot = {'Port5In','Port6In'};
        NoLickPorts = {'Port4In','Port5In'};
       
    elseif S.GUI.RewardSide==2
        valveTime = GetValveTimes(S.GUI.RewardAmount, [6]);  %GetValveTimes(S.GUI.RewardAmount, [6]); 
        valveState = valvePhysicalAddress(6);
        portIn = 'Port5In';ledOut = 'PWM5';
        portsNot = {'Port4In','Port6In'};
        NoLickPorts = {'Port5In','Port6In'};
    end
    
    switch S.GUIMeta.Phase.String
        case 'Simple Operant'
            precueDuration =0; precueOutput = {}; 
            interCueDelay=0;
            portsNot = {'Port1In','Port2In'};
            preportIn = 'Tup';
            preportsNot = {'Port1In','Port2In'};
            rewardportIn = 'Tup';
            rewardportsNot = {'Port1In','Port2In'};  
        case 'Simple Operant Test'
            precueDuration =0; precueOutput = {}; 
            interCueDelay=0;
            portsNot = {'Port1In','Port2In'};
            preportIn = 'Tup';
            preportsNot = {'Port1In','Port2In'};
            rewardportIn = 'Tup';
            rewardportsNot = {'Port1In','Port2In'};
        case 'Conditioned Reinforcement Training'
            precueDuration =S.GUI.precueDuration ;precueOutput = {'PWM4', 255}; 
            interCueDelay=S.GUI.interCueDelay;
            portsNot = {'Port1In','Port2In'};
            preportIn = 'Port4In';
            preportsNot = {'Port1In','Port2In'};
            rewardportIn = 'Port6In';
            rewardportsNot = {'Port1In','Port2In'};
        case 'Conditioned Reinforcement'
            precueDuration =S.GUI.precueDuration ;precueOutput = {'PWM4', 255}; 
            interCueDelay=S.GUI.interCueDelay;
            preportIn = 'Port4In';
            preportsNot = {'Port1In','Port2In'};
            rewardportIn = 'Port6In';
            rewardportsNot = {'Port1In','Port2In'};
        
            
    end
    
    
    sma = NewStateMatrix(); % Assemble state matrix

    sma = AddState(sma, 'Name', 'TrialStart', ...
        'Timer', 0,...
        'StateChangeConditions', {'Tup', 'Precue'},...
        'OutputActions', {}); 

        sma = AddState(sma, 'Name', 'Precue', ...
        'Timer', precueDuration ,...
        'StateChangeConditions', {preportIn, 'interCueDelay',...
        preportsNot{1}, 'RestartMiss',preportsNot{2},'RestartMiss'},...
        'OutputActions', precueOutput); 
        
    sma = AddState(sma, 'Name', 'interCueDelay', ...
        'Timer', interCueDelay ,...
        'StateChangeConditions', { 'Tup', 'WaitForResponse'},...
        'OutputActions', {});            

    sma = AddState(sma, 'Name', 'WaitForResponse', ...
        'Timer', S.GUI.CueDuration,...
        'StateChangeConditions', {portIn, 'rewardDelay', ...
        portsNot{2},'RestartMiss','Tup','exit'},...
        'OutputActions',  {ledOut, 255});       
    
    sma = AddState(sma, 'Name', 'rewardDelay', ...
        'Timer', S.GUI.RewardDelay,...
        'StateChangeConditions', {rewardportIn, 'reward',... 
        rewardportsNot{1},'RestartMiss'},...
        'OutputActions', {});

    sma = AddState(sma, 'Name', 'reward', ...
        'Timer', valveTime,...
        'StateChangeConditions', {'Tup', 'PostOutcome'},...
        'OutputActions', {'ValveState',valveState }); 

    sma = AddState(sma, 'Name', 'PostOutcome', ...
        'Timer', S.GUI.TimePostOutcome,...
        'StateChangeConditions', {'Tup', 'NoLick'},...
        'OutputActions', {});

    sma = AddState(sma,'Name', 'NoLick', ...
        'Timer', S.GUI.TimeNoLick,...
        'StateChangeConditions', {'Tup','ITI',...
        NoLickPorts{1},'RestartNoLick',NoLickPorts{2},'RestartNoLick'},...
        'OutputActions', { });

    sma = AddState(sma,'Name', 'RestartMiss', ...
        'Timer', S.GUI.IncorrectTimeOut,...
        'StateChangeConditions', {'Tup', 'exit',},...
        'OutputActions', { });  
    
    sma = AddState(sma,'Name', 'RestartNoLick', ...
        'Timer', 0,...
        'StateChangeConditions', {'Tup', 'NoLick',},...
        'OutputActions', { });  

    sma = AddState(sma,'Name', 'ITI',...
        'Timer',S.GUI.ITI,...
        'StateChangeConditions', {'Tup', 'exit'},...
        'OutputActions',{});
    
        
    SendStateMatrix(sma);
    RawEvents = RunStateMatrix;
    if ~isempty(fieldnames(RawEvents)) % If trial data was returned
        BpodSystem.Data = AddTrialEvents(BpodSystem.Data,RawEvents); 
        % Computes trial events from raw data
        BpodSystem.Data.TrialSettings(currentTrial) = S; 
        % Adds the settings used for the current trial to the Data struct (to be saved after the trial ends)
        BpodSystem.Data.TrialTypes(currentTrial) = TrialTypes(currentTrial); 
        % Adds the trial type of the current trial to data
       
        
        if ~isnan(BpodSystem.Data.RawEvents.Trial{currentTrial}.States.RestartMiss(1))
           BpodSystem.Data.Outcomes(currentTrial) = 0;
       elseif ~isnan(BpodSystem.Data.RawEvents.Trial{currentTrial}.States.reward(1))
           BpodSystem.Data.Outcomes(currentTrial) = 1;
       else
           BpodSystem.Data.Outcomes(currentTrial) = 2;
        end
       
       % Outcome:  0: incorrect/  1 : correct / 2: no response
   
               
       if ~isnan(BpodSystem.Data.RawEvents.Trial{currentTrial}.States.reward(1))
           TrialTypes(currentTrial) = S.GUI.RewardSide;
       elseif ~isnan(BpodSystem.Data.RawEvents.Trial{currentTrial}.States.RestartMiss(1))
           TrialTypes(currentTrial) = 3-S.GUI.RewardSide;
       end
       

        UpdateSideOutcomePlot(TrialTypes, BpodSystem.Data);
        SaveBpodSessionData; % Saves the field BpodSystem.Data to the current data file
    end
    HandlePauseCondition; % Checks to see if the protocol is paused. If so, waits until user resumes.
    if BpodSystem.BeingUsed == 0
        return
    end
   
end


function UpdateSideOutcomePlot(TrialTypes, Data)
global BpodSystem
Outcomes = zeros(1,Data.nTrials);
for x = 1:Data.nTrials
    if ~isnan(Data.RawEvents.Trial{x}.States.reward(1))
        Outcomes(x) = 1;
   elseif  ~isnan(Data.RawEvents.Trial{x}.States.RestartMiss(1))
        Outcomes(x) = 0;
%     elseif ~isnan(Data.RawEvents.Trial{x}.States.Punishment(1))
%         Outcomes(x) = 0;
    else
        Outcomes(x) = 2;
    end
end


SideOutcomePlot(BpodSystem.GUIHandles.SideOutcomePlot,'update',Data.nTrials+1,2-TrialTypes,Outcomes);
