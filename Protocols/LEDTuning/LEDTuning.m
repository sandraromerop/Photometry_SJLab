function LEDTuning

global BpodSystem nidaq S

%% Define parameters

S = BpodSystem.ProtocolSettings; % Load settings chosen in launch manager into current workspace as a struct called S
ParamPC=BpodParam_PCdep();
if isempty(fieldnames(S))  % If settings file was an empty struct, populate struct with default settings
    LEDTuning_TaskParameters(ParamPC);
end

% Initialize parameter GUI plugin and Pause
BpodParameterGUI('init', S);
BpodSystem.Pause=1;
HandlePauseCondition;
S = BpodParameterGUI('sync', S);

%% Define stimuli and send to sound server
WhiteNoise=WhiteNoiseGenerator(S.GUI.SoundSamplingRate,S.GUI.SoundDuration,S.GUI.SoundRamp);
PsychToolboxSoundServer('init')
PsychToolboxSoundServer('Load',1,WhiteNoise);
BpodSystem.SoftCodeHandlerFunction = 'SoftCodeHandler_PlaySound';

%% Define trial types parameters, trial sequence
PowerValuesVolt=round(linspace(S.GUI.LED1_Amp_Low,S.GUI.LED1_Amp_High,S.GUI.NbOfPower),2);
PowerValuesWatt=linspace(S.GUI.LED1_Amp_LowWatt,S.GUI.LED1_Amp_HighWatt,S.GUI.NbOfPower);
for i=1:S.GUI.NbOfPower
    S.TrialsNames{i}=sprintf('%.0f W %.2f V',PowerValuesWatt(i),PowerValuesVolt(i));
end

TrialSequence=1:1:S.GUI.NbOfPower;
TrialSequence=TrialSequence(randperm(length(TrialSequence)));
TrialSequence=repmat(TrialSequence',S.GUI.Repetition,1);

S.NumTrialTypes=max(TrialSequence);
S.MaxTrials=length(TrialSequence);

%% NIDAQ Initialization
if S.GUI.Photometry
    Nidaq_photometry('ini',ParamPC);
    FigNidaq=Online_LEDTuningPlot('ini',TrialSequence);
end 
BpodSystem.Data.TrialTypes = []; % The trial type of each trial completed will be added here.
%% Main trial loop
for currentTrial = 1:S.MaxTrials
%% Initialize current trial parameters
    S = BpodParameterGUI('sync', S); % Sync parameters with BpodParameterGUI plugin
    S.GUI.LED1_Amp=PowerValuesVolt(TrialSequence(currentTrial));
    
%% Assemble State matrix
 	sma = NewStateMatrix();
    %Pre Cue Delivery
    sma = AddState(sma, 'Name','PreCueState',...
        'Timer',S.GUI.TimePreCue,...
        'StateChangeConditions',{'Tup','CueDelivery'},...
        'OutputActions',{'BNCState',1});
    %Cue Delivery
    sma=AddState(sma,'Name', 'CueDelivery',...
        'Timer',S.GUI.TimeCue,...
        'StateChangeConditions',{'Tup', 'PostCueState'},...
        'OutputActions', {'SoftCode',1});
    %Post Cue Delivery
    sma=AddState(sma,'Name', 'PostCueState',...
        'Timer',S.GUI.TimePostCue,...
        'StateChangeConditions', {'Tup', 'exit'},...
        'OutputActions', {});
    
    SendStateMatrix(sma);
 
%% NIDAQ Get nidaq ready to start
if S.GUI.Photometry
     Nidaq_photometry('WaitToStart');
end
     RawEvents = RunStateMatrix;
    
%% NIDAQ Stop acquisition and save data in bpod structure
if S.GUI.Photometry
    Nidaq_photometry('Stop');
        [PhotoData,WheelData,Photo2Data]=Nidaq_photometry('Save');
    if S.GUI.Photometry
        BpodSystem.Data.NidaqData{currentTrial}=PhotoData;
        if S.GUI.DbleFibers == 1
            BpodSystem.Data.Nidaq2Data{currentTrial}=Photo2Data;
        end
    end
    if S.GUI.Wheel
        BpodSystem.Data.NidaqWheelData{currentTrial}=WheelData;
    end
end

%% Save
if ~isempty(fieldnames(RawEvents))                                          % If trial data was returned
    BpodSystem.Data = AddTrialEvents(BpodSystem.Data,RawEvents);            % Computes trial events from raw data
    BpodSystem.Data.TrialSettings(currentTrial) = S;                        % Adds the settings used for the current trial to the Data struct (to be saved after the trial ends)
    BpodSystem.Data.TrialTypes(currentTrial) = TrialSequence(currentTrial); % Adds the trial type of the current trial to data
    SaveBpodSessionData;                                                    % Saves the field BpodSystem.Data to the current data file
end

%% PLOT - extract events from BpodSystem.data and update figures
if S.GUI.Photometry
    [currentNidaq470]=Online_NidaqDemod(PhotoData(:,1),nidaq.LED1,S.GUI.LED1_Freq,S.GUI.LED1_Amp,S.Names.StateToZero{S.GUI.StateToZero},currentTrial);
    FigNidaq=Online_LEDTuningPlot('update',TrialSequence,FigNidaq,currentTrial,currentNidaq470);
end
HandlePauseCondition; % Checks to see if the protocol is paused. If so, waits until user resumes.

if BpodSystem.BeingUsed == 0
    return
end
end
end
