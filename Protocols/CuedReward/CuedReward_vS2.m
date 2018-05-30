function CuedReward
%Functions used in this protocol:
%"CuedReward_Phase": specify the phase of the training
%"WeightedRandomTrials" : generate random trials sequence

%"Online_LickPlot"      : initialize and update online lick and outcome plot
%"Online_LickEvents"    : extract the data for the online lick plot
%"Online_NidaqPlot"     : initialize and update online nidaq plot
%"Online_NidaqEvents"   : extract the data for the online nidaq plot

global BpodSystem nidaq S

%% Define parameters
S = BpodSystem.ProtocolSettings; % Load settings chosen in launch manager into current workspace as a struct called S
ParamPC=BpodParam_PCdep();
if isempty(fieldnames(S))  % If settings file was an empty struct, populate struct with default settings
    CuedReward_TaskParameters(ParamPC);
end

% Initialize parameter GUI plugin and Pause
BpodParameterGUI('init', S);
BpodSystem.Pause=1;
HandlePauseCondition;
S = BpodParameterGUI('sync', S);

S.SmallRew  =   GetValveTimes(S.GUI.SmallReward, S.GUI.RewardValve);
S.InterRew  =   GetValveTimes(S.GUI.InterReward, S.GUI.RewardValve);
S.LargeRew  =   GetValveTimes(S.GUI.LargeReward, S.GUI.RewardValve);

%% Define stimuli and send to sound server
TimeSound=0:1/S.GUI.SoundSamplingRate:S.GUI.SoundDuration;
HalfTimeSound=0:1/S.GUI.SoundSamplingRate:S.GUI.SoundDuration/2;
switch S.GUI.SoundType
    case 1
        CueA=chirp(TimeSound,S.GUI.LowFreq,S.GUI.SoundDuration,S.GUI.HighFreq);
        CueB=chirp(TimeSound,S.GUI.HighFreq,S.GUI.SoundDuration,S.GUI.LowFreq);
        NoCue=zeros(1,S.GUI.SoundDuration*S.GUI.SoundSamplingRate);
        CueC=[chirp(HalfTimeSound,S.GUI.LowFreq,S.GUI.SoundDuration/2,S.GUI.HighFreq) chirp(HalfTimeSound,S.GUI.HighFreq,S.GUI.SoundDuration/2,S.GUI.LowFreq)];

    case 2
        CueA=SoundGenerator(S.GUI.SoundSamplingRate,S.GUI.LowFreq,S.GUI.FreqWidth,S.GUI.NbOfFreq,S.GUI.SoundDuration,S.GUI.SoundRamp);
        CueB=SoundGenerator(S.GUI.SoundSamplingRate,S.GUI.HighFreq,S.GUI.FreqWidth,S.GUI.NbOfFreq,S.GUI.SoundDuration,S.GUI.SoundRamp);
        NoCue=zeros(1,S.GUI.SoundDuration*S.GUI.SoundSamplingRate);
        CueC=SoundGenerator(S.GUI.SoundSamplingRate,(S.GUI.LowFreq+S.GUI.HighFreq)/2,S.GUI.FreqWidth,S.GUI.NbOfFreq,S.GUI.SoundDuration,S.GUI.SoundRamp);
end

PsychToolboxSoundServer('init');
PsychToolboxSoundServer('Load', 1, CueA);
PsychToolboxSoundServer('Load', 2, CueB);
PsychToolboxSoundServer('Load', 3, NoCue);
PsychToolboxSoundServer('Load', 4, CueC);
BpodSystem.SoftCodeHandlerFunction = 'SoftCodeHandler_PlaySound';

%% Define trial types parameters, trial sequence and Initialize plots
[S.TrialsNames, S.TrialsMatrix,ezTrialsSeq]=CuedReward_Phase(S,S.Names.Phase{S.GUI.Phase});
TrialSequence=WeightedRandomTrials(S.TrialsMatrix(:,2)', S.GUI.MaxTrials);
if S.GUI.eZTrials
    TrialSequence(1:length(ezTrialsSeq))=ezTrialsSeq;
end
S.NumTrialTypes=max(TrialSequence);
FigLick=Online_LickPlot('ini',TrialSequence,S.TrialsMatrix,S.TrialsNames,S.Names.Phase{S.GUI.Phase});

%% NIDAQ Initialization
if S.GUI.Photometry || S.GUI.Wheel
    Nidaq_photometry('ini',ParamPC);
end
if S.GUI.Photometry
    FigNidaq=Online_NidaqPlot('ini',S.TrialsNames,S.Names.Phase{S.GUI.Phase});
    if S.GUI.DbleFibers==1
        FigNidaqB=Online_NidaqPlot('ini',S.TrialsNames,S.Names.Phase{S.GUI.Phase});
    end
end
if S.GUI.Wheel
    FigWheel=Online_WheelPlot('ini');
end
BpodSystem.Data.TrialTypes = []; % The trial type of each trial completed will be added here.
%% Main trial loop
for currentTrial = 1:S.GUI.MaxTrials
    S = BpodParameterGUI('sync', S); % Sync parameters with BpodParameterGUI plugin 
    
%% Initialize current trial parameters
	S.Sound             =	S.TrialsMatrix(TrialSequence(currentTrial),3);
	S.Delay             =	S.TrialsMatrix(TrialSequence(currentTrial),4)+(S.GUI.DelayIncrement*(currentTrial-1));
	S.Valve             =	S.TrialsMatrix(TrialSequence(currentTrial),5);
	S.Outcome           =   S.TrialsMatrix(TrialSequence(currentTrial),6);
    S.PhotoStimCue      =   S.TrialsMatrix(TrialSequence(currentTrial),8);
    S.OptoStimCueDelay  =   S.TrialsMatrix(TrialSequence(currentTrial),9);
    S.PhotoStimRwd      =   S.TrialsMatrix(TrialSequence(currentTrial),10);

    S.ITI = 100;
    while S.ITI > 3 * S.GUI.ITI
        S.ITI = exprnd(S.GUI.ITI);
    end
    
%% photo stim (added by fred)
% trainingPhase = S.Names.Phase{S.GUI.Phase};
% photoStimOut = 0;
% photoStimOutCue = 0;
% photoStimDelay = 0.0001;
% switch trainingPhase
%     case 'RewardA_photo' % in rwd A Photo ---stmulate at rwd , independently of valve and cue
%         if S.Valve == 1
%             photoStimOut = 2;
%         end
%     case 'RewardA_jaws'  % in rwd A jaws ---stmulate at any cue( in CueA+rwd, and CueB+omission) 
%         if S.Sound > 10
%             S.Sound = S.Sound - 10;
%             photoStimOutCue  = 2; % new columnd
%             photoStimDelay   = 2; % gui: option there 
%         end
% end
  
%% Assemble State matrix
 	sma = NewStateMatrix();
    %Pre task states
    sma = AddState(sma, 'Name','PreState',...
        'Timer',S.GUI.PreCue,...
        'StateChangeConditions',{'Tup','PhotoStim'},...
        'OutputActions',{'BNCState',1});
    
    sma = AddState(sma, 'Name','PhotoStim',...
        'Timer',S.OptoStimCueDelay,...
        'StateChangeConditions',{'Tup','SoundDelivery'},...
        'OutputActions',{'BNCState',S.PhotoStimCue});
    %Stimulus delivery
    sma=AddState(sma,'Name', 'SoundDelivery',...
        'Timer',S.GUI.SoundDuration,...
        'StateChangeConditions',{'Tup', 'Delay'},...
        'OutputActions', {'SoftCode',S.Sound});
    %Delay
    sma=AddState(sma,'Name', 'Delay',...
        'Timer',S.Delay,...
        'StateChangeConditions', {'Tup', 'Outcome'},...
        'OutputActions', {});
    %Reward
    sma=AddState(sma,'Name', 'Outcome',...
        'Timer',S.Outcome,...
        'StateChangeConditions', {'Tup', 'PostReward'},...
        'OutputActions', {'ValveState',S.Valve,'BNCState',S.PhotoStimRwd});  % 2 if stimulatoin, 0: if not stimulation
    %Post task states
    sma=AddState(sma,'Name', 'PostReward',...
        'Timer',S.GUI.PostOutcome,...
        'StateChangeConditions',{'Tup', 'NoLick'},...
        'OutputActions',{});
    %ITI + noLick period
    sma = AddState(sma,'Name', 'NoLick', ...
        'Timer', S.GUI.TimeNoLick,...
        'StateChangeConditions', {'Tup','PostlightExit','Port1In','RestartNoLick'},...
        'OutputActions', {'PWM1', 255});  
    sma = AddState(sma,'Name', 'RestartNoLick', ...
        'Timer', 0,...
        'StateChangeConditions', {'Tup', 'NoLick',},...
        'OutputActions', {'PWM1', 255}); 
    sma = AddState(sma,'Name', 'PostlightExit', ...
        'Timer', 0.5,...
        'StateChangeConditions', {'Tup', 'ITI',},...
        'OutputActions', {});
    sma = AddState(sma,'Name', 'ITI',...
        'Timer',S.ITI,...
        'StateChangeConditions', {'Tup', 'exit'},...
        'OutputActions',{});
    SendStateMatrix(sma);
 
%% NIDAQ Get nidaq ready to start
if S.GUI.Photometry || S.GUI.Wheel
    Nidaq_photometry('WaitToStart');
end
     RawEvents = RunStateMatrix;
    
%% NIDAQ Stop acquisition and save data in bpod structure
if S.GUI.Photometry || S.GUI.Wheel
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
[currentOutcome, currentLickEvents]=Online_LickEvents(S.TrialsMatrix,currentTrial,TrialSequence(currentTrial),S.Names.StateToZero{S.GUI.StateToZero});
FigLick=Online_LickPlot('update',[],[],[],[],FigLick,currentTrial,currentOutcome,TrialSequence(currentTrial),currentLickEvents);
if S.GUI.Photometry
    [currentNidaq470, nidaqRaw]=Online_NidaqDemod(PhotoData(:,1),nidaq.LED1,S.GUI.LED1_Freq,S.GUI.LED1_Amp,S.Names.StateToZero{S.GUI.StateToZero},currentTrial);
    if S.GUI.LED2_Amp~=0
    currentNidaq405=Online_NidaqDemod(PhotoData(:,1),nidaq.LED2,S.GUI.LED2_Freq,S.GUI.LED2_Amp,S.Names.StateToZero{S.GUI.StateToZero},currentTrial);
    else
        currentNidaq405=[0 0];
    end
    FigNidaq=Online_NidaqPlot('update',[],[],FigNidaq,currentNidaq470,currentNidaq405,nidaqRaw,TrialSequence(currentTrial));
    if S.GUI.DbleFibers == 1
        [currentNidaq470b,nidaqRawb]=Online_NidaqDemod(Photo2Data(:,1),nidaq.LED2,S.GUI.LED1b_Freq,S.GUI.LED1b_Amp,S.Names.StateToZero{S.GUI.StateToZero},currentTrial);
        FigNidaqB=Online_NidaqPlot('update',[],[],FigNidaqB,currentNidaq470b,currentNidaq405,nidaqRawb,TrialSequence(currentTrial));
    end
end

if S.GUI.Wheel
    FigWheel=Online_WheelPlot('update',FigWheel,WheelData,S.Names.StateToZero{S.GUI.StateToZero},currentTrial,currentLickEvents);
end
HandlePauseCondition; % Checks to see if the protocol is paused. If so, waits until user resumes.

if BpodSystem.BeingUsed == 0
    return
end
end
end
