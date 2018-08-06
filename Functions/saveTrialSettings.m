function saveTrialSettings(phaseName)

global BpodSystem

%% save settings for this mouse, Protocol and trainingPhase
TrialSettings  = BpodSystem.Data.TrialSettings.GUI;
p = getSessionNames(BpodSystem.DataPath);
thisSaveDir = fullfile(p.root,'Settings Files', ...
               p.mouse,p.protocol);
% create mouse folder if it doesn't exist yet
if ~exist(thisSaveDir)
    mkdir(thisSaveDir);
end
save([thisSaveDir filesep 'trialSettings_' phaseName '.mat' ], 'TrialSettings', '-v6');


