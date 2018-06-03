function TrialNumber=A_NameToTrialNumber(Analysis,StringToSearch)
%A_NameToTrialNumber returns the trial type numbers for which the title
%contains StringToSearch. Returns NaN if no correspondance is found.
%
%function designed by Quentin 2016 for Analysis_Photometry

TrialNumber=NaN;
k=1;
trialNames = Analysis.Properties.TrialNames;
for i=1:Analysis.Properties.nbOfTrialTypes
    if strfind(trialNames{i},'Cue')
       limit = strfind(trialNames{i},'Cue')+3;
       if strcmp(trialNames{i}(limit),' ')
       else
          trialNames{i} = [trialNames{i}(1:limit-1) ' ' trialNames{i}(limit:end)]
       end
    end
end
for i=1:Analysis.Properties.nbOfTrialTypes
    if strfind(trialNames{i},StringToSearch)
        TrialNumber(k)=i;
        k=k+1;
    end
end
end
