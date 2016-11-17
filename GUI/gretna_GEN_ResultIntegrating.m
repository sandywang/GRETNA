function Process=gretna_GEN_ResultIntegrating(AllIndiMatList, AllInteMatList)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Result Integrating
%   Input:
%   AllIndiMatList - All Individual Mat File
%   AllInteMatList - All Integrated Mat File
%
%   Output:
%   Process        - The output process structure used by psom
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

Process.command='gretna_RUN_ResultIntegrating(opt.AllIndiMatList, opt.AllInteMatList)';
% Option 
Process.opt.AllIndiMatList=AllIndiMatList;
Process.opt.AllInteMatList=AllInteMatList;

% Output Directory
% Input Files
InputMatList=[];
for i=1:numel(AllIndiMatList)
    Grp=AllIndiMatList{i};
    for j=1:numel(Grp)
        InputMatList=[InputMatList; Grp{j}];
    end
end
OutputMatList=[];
for i=1:numel(AllInteMatList)
    Grp=AllInteMatList{i};
    OutputMatList=[OutputMatList; Grp];
end
Process.files_in=InputMatList;
% Output Files
Process.files_out=OutputMatList;