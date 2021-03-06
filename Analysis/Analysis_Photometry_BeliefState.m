function Analysis = Analysis_Photometry_BeliefState(DefaultParam)
%% Loads File, Extracts and Organizes all the data
DirName=fullfile(DefaultParam.PathName, DefaultParam.FileToOpen );
load([DefaultParam.PathName  DefaultParam.FileToOpen ]);
[~,FileNameNoExt]=fileparts(DirName);
if exist([FileNameNoExt '_Pupil.mat'],'file')==2 
    load([FileNameNoExt '_Pupil.mat']);
else
    disp('Could not find the pupillometry data');
    Pupillometry=[];
end
try
    Analysis.Properties = AP_Parameters_BeliefState(SessionData,Pupillometry,DefaultParam,FileNameNoExt);
    Analysis=A_FilterIgnoredTrials(Analysis,DefaultParam.TrialToFilterOut,DefaultParam.LoadIgnoredTrials);
    tic
    Analysis=AP_DataOrganize(Analysis,SessionData,Pupillometry);
    toc
    
    % Sorts data by trial types and generates plots
    sortedAnalysis = Analysis;
    Analysis=A_FilterTrialType(Analysis);
    [Analysis sortedAnalysis ]=AP_DataSort(Analysis,sortedAnalysis);
<<<<<<< HEAD
    if Analysis.Properties.Photometry
        Analysis = allignTraces(Analysis);
    end
=======
    Analysis = allignTraces(Analysis);
>>>>>>> 804147605b139b4b400485584bbf6ba7f66f6dc2
    
    Analysis.Properties.DirFig = [DefaultParam.PathName '\' Analysis.Properties.Phase '\' 'Figures'];
    mkdir(Analysis.Properties.DirFig )

    % Save Analysis
    if DefaultParam.Save
        Analysis.Properties.Files=DefaultParam.FileToOpen;
        DirAnalysis=[DefaultParam.PathName  filesep DefaultParam.Phase filesep 'Analysis'];
        if isdir(DirAnalysis)==0
            mkdir(DirAnalysis);
        end
    FileName=[Analysis.Properties.Name '_Analysis' ];
    DirFile=[DirAnalysis '\' FileName '\'];
    save(DirFile,'Analysis');
    end
catch
    disp([DefaultParam.FileToOpen ' NOT ANALYZED - Error in Parameters extraction or Data organization']);
    Analysis=[];

end
