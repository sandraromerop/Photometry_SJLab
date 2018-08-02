function Analysis = Analysis_Photometry_BeliefState(DefaultParam)
%% Loads File, Extracts and Organizes all the data
DirName = fullfile(DefaultParam.PathName, DefaultParam.FileToOpen );
load([DefaultParam.PathName  DefaultParam.FileToOpen ]);
[~,FileNameNoExt] = fileparts(DirName);
if exist([FileNameNoExt '_Pupil.mat'],'file') == 2 
    load([FileNameNoExt '_Pupil.mat']);
else
    disp('Could not find the pupillometry data');
    Pupillometry=[];
end
% try
    Analysis.Properties = AP_Parameters_BeliefState(SessionData,Pupillometry,DefaultParam,FileNameNoExt); %gets parameters from training
    Analysis = A_FilterIgnoredTrials(Analysis,DefaultParam.TrialToFilterOut,DefaultParam.LoadIgnoredTrials); %I think DefaultParam.TrialToFilterOut is hard coded []
    tic
    Analysis = AP_DataOrganize(Analysis,SessionData,Pupillometry); %looks like original Quentin code so leave alone
    toc
    
    % Sorts data by trial types and generates plots
    sortedAnalysis = Analysis; %preallocation bullshit
    Analysis = A_FilterTrialType(Analysis);
    [Analysis sortedAnalysis ] = AP_DataSort(Analysis, sortedAnalysis);
    
    if isfield(Analysis.AllData, 'Photo_470') == 1
        Analysis = allignTraces(Analysis);
    else
        Analysis = allignTraces_noPhotometry(Analysis); 
        disp('No photometry data found')
    end
    
    % Makes folder for figures BUT NO FIGURES SAVED
    delimiter = filesep;
    Analysis.Properties.DirFig = [DefaultParam.PathName delimiter Analysis.Properties.Phase delimiter 'Figures'];
    if isdir(Analysis.Properties.DirFig) == 0 
            mkdir(Analysis.Properties.DirFig);
    end
  
    % Save Analysis
    if DefaultParam.Save
        Analysis.Properties.Files = DefaultParam.FileToOpen;
        DirAnalysis = [DefaultParam.PathName  delimiter DefaultParam.Phase delimiter 'Analysis'];
        if isdir(DirAnalysis) == 0 
            mkdir(DirAnalysis);
        end
    FileName = [Analysis.Properties.Name '_Analysis' ];
    %DirFile = [DirAnalysis delimiter FileName delimiter];
    cd(DirAnalysis)
    save(FileName,'Analysis');
    end
% catch
%     disp([DefaultParam.FileToOpen ' NOT ANALYZED - Error in Parameters extraction or Data organization']);
%     Analysis=[];

end
