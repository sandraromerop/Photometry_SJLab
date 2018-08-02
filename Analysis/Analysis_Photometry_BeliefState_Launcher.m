generalDir = input('Please enter the path of the behaviour files','s');
behavior = 'BeliefState';
listing = dir(generalDir);cc = 1;
sessionNames=[];ii = 3;
for ii=1:length(listing)
    fileName = listing(ii).name;  
        if contains(fileName,behavior) && contains(fileName ,'.mat')
            sessionNames{cc,1} = fileName;
            cc = cc+1;
        end
end
for ii=1:length(sessionNames)
DefaultParam.FileToOpen  = sessionNames{ii}; 
DefaultParam.PathName = generalDir;
deconstructedPath = strsplit(generalDir, filesep); 
    
DefaultParam.Name = deconstructedPath{end-3};
DefaultParam.Analysis_type = 'Single';
DefaultParam.Behavior = 'BeliefState';
DefaultParam.Phase = 'BeliefState';
DefaultParam.LickPort='Port1In';
%%%%%%%%%%%%%%%%%%%%%%%%
DefaultParam.StateOfCue='SoundDelivery';
DefaultParam.StateOfOutcome='Outcome';
%%%%%%%%%%%%%%%%%%%%%%%%

%%% CHANGE
DefaultParam.StateToZero{1} = 'StateOfOutcome'; %'StateOfCue' 'StateOfOutcome'
DefaultParam.StateToZero{2} = 'StateOfCue'; %'StateOfCue' 'StateOfOutcome'
DefaultParam.ZeroAtZero = 0;

DefaultParam.WheelState = 'Outcome'; %'Baseline','Cue','Outcome'

% Licking
DefaultParam.Bin = 0.25;

% Photometry
DefaultParam.SamplingRate = 6100;  %(Hz)
DefaultParam.NewSamplingRate    =   20; %(Hz)
DefaultParam.NidaqDuration= 15;


%%%% ??? 
DefaultParam.CueTimeReset = [0 1];
DefaultParam.OutcomeTimeReset = [0 2]; %  0 -3 for GoNogo - 0 2 for CuedRew
DefaultParam.PlotX = [-5 5 ];
DefaultParam.NidaqBaseline = [1.5 2.5]; %% Absolute time 1.5 2.5

% Filters
DefaultParam.TrialToFilterOut = [];
DefaultParam.LoadIgnoredTrials = 1;

% Save
DefaultParam.Save = 1;
Analysis = Analysis_Photometry_BeliefState(DefaultParam);
%change this so that the analysis folder is made here

% Figures
if ~isempty(Analysis)
    timings ={.75,-.75,1,.75}; %{ After cue, before reward, post reawrd, baseline from trial start} WHY IS THIS HARD CODED!?!?
    AP_PlotSummary_AllSignals(Analysis,DefaultParam) % fails without photometry
    AP_PlotSummary_VariableState(Analysis,DefaultParam) % fails without photometry
    AP_PlotSummary_VariableState_Barplot(Analysis,timings ) %fails without photometry
    
    if isfield(Analysis.AllData, 'Photo_470') == 1
        AP_PlotSummary_AllSignals(Analysis,DefaultParam) % fails without photometry
        AP_PlotSummary_VariableState(Analysis,DefaultParam) % fails without photometry
        AP_PlotSummary_VariableState_Barplot(Analysis,timings ) %fails without photometry
        
    end
end
end

