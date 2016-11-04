function gretna_RUN_ResultIntegrating(AllIndiMatList, AllInteMatList)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Result Integrating
%   Input:
%   AllIndiMatList - All Individual Mat File
%   AllInteMatList - All Integrated Mat File
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

for i=1:numel(AllIndiMatList)
    IndiMat=AllIndiMatList{i};
    InteMat=AllInteMatList{i};
    SCell=cellfun(@load, IndiMat, 'UniformOutput', false);
    NetNum=size(SCell, 1);
    FN=fieldnames(SCell{1});
    O=[];
    for j=1:numel(FN)
        if strcmpi(FN{j}, 'module_property')
            O.(FN{j})=[];
            for k=1:numel(SCell)
                O.(FN{j})=[O.(FN{j}); SCell{k}.(FN{j})];
            end
        else
            c=cellfun(@(S) GetArray(S, FN{j}), SCell, 'UniformOutput', false);
            a=cell2mat(c);
            n=size(a);
            a=squeeze(a);
            if n(1)==1 && n(2)==1
                a=a';
            elseif n(1)==1 && n(2)~=1
                a=reshape(a, [1, size(a, 1), size(a, 2)]);
            end
            O.(FN{j})=a;
        end
    end
    Path=fileparts(InteMat);
    if exist(Path, 'dir')==7
        rmdir(Path, 's');
    end
    mkdir(Path);
    
    for j=1:numel(FN)
        if strcmpi(FN{j}, 'module_property')
        else
            if numel(size(O.(FN{j})))==2
                save(fullfile(Path, sprintf('%s.txt', FN{j})),...
                    '-struct', 'O', FN{j},...
                    '-ASCII', '-DOUBLE', '-TABS');
            else
                a=O.(FN{j});
                for k=1:size(a, 3)
                    tmp=a(:, :, k);
                    save(fullfile(Path, sprintf('%s_Thres%.3d.txt', FN{j}, k)),...
                        'tmp',...
                        '-ASCII', '-DOUBLE', '-TABS');
                end
            end
        end
    end
    save(InteMat, '-struct', 'O');
end

function A=GetArray(S, fn)
A=S.(fn);
n1=size(A, 1);
n2=size(A, 2);
A=reshape(A, [1, n1, n2]);
