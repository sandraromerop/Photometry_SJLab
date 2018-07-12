%% this function takes BpodSystem.DataPath as input
% and extracts several hard-coded strings from it

function [p] = getSessionNames(dataPath)

[tmp1,tmp2] = fileparts(dataPath);
[tmp1,tmp2] = fileparts(tmp1);
[tmp1,p.protocol] = fileparts(tmp1);
[tmp1,p.mouse] = fileparts(tmp1);
[p.root,tmp2] = fileparts(tmp1);