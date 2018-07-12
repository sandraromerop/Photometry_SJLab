function TrialSettings = loadPreviousSettings(phaseName)

global BpodSystem

%% load previous trialSettings
% for this Mouse / Protocol / trainingPhase

% answer = questdlg('Load latest trial settings?', ...
%     'loadTrialSettings','yes','no','no');

% get name of mouse / protocol
p = getSessionNames(BpodSystem.DataPath);

% if ~isempty(strfind(answer,'yes'))
settingsPath = fullfile(p.root,'Settings Files',p.mouse);
if exist([ settingsPath filesep p.protocol '\trialSettings_' phaseName '.mat' ],'file')==2
    tmp = load([ settingsPath filesep p.protocol '\trialSettings_' phaseName '.mat' ]);
    disp('loaded previous settings')
elseif exist([ p.root '\TrialSettings_' phaseName '_Default.mat' ],'file')==2
    tmp = load([ p.root '\TrialSettings_' phaseName '_Default.mat' ]);
    disp('loaded default settings')
else
    disp('!!failed to load any trial settings - make sure default file exists')
end
TrialSettings = tmp.TrialSettings;