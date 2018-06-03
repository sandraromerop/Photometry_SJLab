function BpodPath(Name)
%%Changes the BpodUserPath, registered users are 'Ada', 'Quentin'. 
%%Use 'ini' as an input argument to use the default bpod folder.
%%New user should be add in the BpodPath function file inside the switch
%%command
%%The BpodUserPath should contain protocol, calibration and data folders
%%
%% Designed by Quentin 2017 for killerscript version of Bpod

%% User specific
try
switch Name
    case 'Fred'
        Path = 'C:\Users\SJLab\Desktop\Bpod_Sandra_room\Protocols';
%         Path='C:\Users\SJLab\Documents\Photometry_code\Protocols and Functions';
    case 'ini'
        Path = 'C:\Users\SJLab\Desktop\Bpod_Sandra_room\Protocols';
%         Path='C:\Users\SJLab\Documents\Photometry_code\Protocols and Functions';
end

%% Overwritting the txt file
cd( 'C:\Users\SJLab\Desktop\Bpod_Sandra_room');
BpodUserPathTXT=fopen('BpodUserPath.txt','w');
fprintf(BpodUserPathTXT,'%c',Path);
fclose(BpodUserPathTXT);
disp(Path)

catch
    disp('Cannot find the bpod path -- Recorded Users are - Quentin - Ada -- Use ini to use the default bpod folder');
end
end