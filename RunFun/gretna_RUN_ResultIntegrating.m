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
    IndiGrp=AllIndiMatList{i};
    InteGrp=AllInteMatList{i};
    
    for u=1:numel(IndiGrp)
        IndiMat=IndiGrp{u};
        InteMat=InteGrp{u};
        SCell=cellfun(@load, IndiMat, 'UniformOutput', false);
        NetNum=size(SCell, 1);
        FN=fieldnames(SCell{1});
        O=[];
        for j=1:numel(FN)
            c=cellfun(@(S) GetArray(S, FN{j}), SCell, 'UniformOutput', false);
            a=cell2mat(c);
            O.(FN{j})=a;
        end
        Path=fileparts(InteMat);
        if exist(Path, 'dir')==7
            rmdir(Path, 's');
        end
        mkdir(Path);
    
        for j=1:numel(FN)
            if numel(size(O.(FN{j})))==2
%                 if strcmpi(FN{j}, 'phi_real') || strcmpi(FN{j}, 'phi_norm')
%                     Flag='_All_K';
%                 else
%                     Flag='_All_Node';
%                 end
                save(fullfile(Path, sprintf('%s.txt', FN{j})),...
                    '-struct', 'O', FN{j},...
                    '-ASCII', '-DOUBLE', '-TABS');
            else
                a=O.(FN{j});
                if size(O.(FN{j}), 2)==1
                    Flag='_All_Thres';
                    tmp=O.(FN{j});
                    n3=size(tmp, 3);
                    tmp=squeeze(O.(FN{j}));
                    if size(tmp, 2)~=n3
                        tmp=tmp';
                    end
                    save(fullfile(Path, sprintf('%s%s.txt', FN{j}, Flag)),...
                        'tmp',...
                        '-ASCII', '-DOUBLE', '-TABS');
                else
                    for k=1:size(a, 3)
%                         if strcmpi(FN{j}, 'phi_real') || strcmpi(FN{j}, 'phi_norm')
%                             Flag='_All_K';
%                         else
%                             Flag='_All_Node';
%                         end
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
    
end

IndiGrp=AllIndiMatList{1};
IndiDir=[];
for u=1:numel(IndiGrp)
    IndiMat=IndiGrp{u};
    IndiDir=[IndiDir; cellfun(@(f) fileparts(f), IndiMat, 'UniformOutput', false)];
end
cellfun(@(d) rmdir(d, 's'), IndiDir);

function A=GetArray(S, fn)
A=S.(fn);
n1=size(A, 1);
n2=size(A, 2);
A=reshape(A, [1, n1, n2]);
