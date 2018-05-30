function [thisFilter] = getFilter(Analysis,trialTypeNb)
    if strcmp(Analysis.Filters.Names{1},'type_1')==false
        counter=0;
        for i=1:length(Analysis.Filters.Names)
            counter=counter+1;
            if strcmp(Analysis.Filters.Names{i},'type_1')
                newIndex = counter;
            end
        end
    else
        newIndex = 0;
    end
    
    thisFilter=logical(Analysis.Filters.Logicals(:,trialTypeNb+newIndex));

end

