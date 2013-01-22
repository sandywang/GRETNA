function [reg_volume, tissue_volume] = gretna_readvolume(subjects_filename_volume, subjects_filename_tissue)

% *************************************************************************
% This function is used to read regional gray matter volumes (70 cortical +
% subcortical) and total tissue volume (Gray matter + White matter)
% typically obtained from the ANIMAL+INSECT method.
%
% function [reg_volume, tissue] = ...
% gretna_readthickness(subjects_filename_volume, subjects_filename_tissue)
%
% input:
%   subjects_filename_volume.txt
%       /data/aces/scratch7b/zchen3/oasis/pipeline/0001/segment/OAS1_0001_masked.dat
%       /data/aces/scratch7b/zchen3/oasis/pipeline/0002/segment/OAS1_0002_masked.dat
%       /data/aces/scratch7b/zchen3/oasis/pipeline/0004/segment/OAS1_0004_masked.dat
%       /data/aces/scratch7b/zchen3/oasis/pipeline/0005/segment/OAS1_0005_masked.dat
%       ....
%   subjects_filename_tissue.txt
%       /data/aces/scratch7b/zchen3/oasis/pipeline/0001/segment/OAS1_0001_cls_volumes.dat
%       /data/aces/scratch7b/zchen3/oasis/pipeline/0002/segment/OAS1_0002_cls_volumes.dat
%       /data/aces/scratch7b/zchen3/oasis/pipeline/0004/segment/OAS1_0004_cls_volumes.dat
%       /data/aces/scratch7b/zchen3/oasis/pipeline/0005/segment/OAS1_0005_cls_volumes.dat
%       ....
%
% output:
%           reg_volume:
%                           an s*n matrix with cortical thickness values
%                           for each region for each subject (n: the number of regions (e.g.
%                           70); s: the number of subjects.
%           tissue:
%                           an s*1 matrix with tissue volume values
%                           for each subject. s: the number of subjects.
%
% For example:
%
%  input_Group1_volume = 'Group1_subject_filename_ANIMAL_volume_masked.txt';
%  input_Group1_tissue = 'Group1_subject_filename_tissue.txt';
%
% [reg_volume, tissue] = gretna_readvolume(subjects_filename_volume, subjects_filename_tissue)
%
% Yong HE, BIC, MNI, McGill 2007/09/12
% ************************************************************************



warning off

input_file_volume = textread(subjects_filename_volume,'%s','delimiter','\n');
input_file_tissue = textread(subjects_filename_tissue,'%s','delimiter','\n');

Nsub_1 = size(input_file_volume,1);
Nsub_2 = size(input_file_tissue,1);

if Nsub_1~=Nsub_2
    error('There are different number of subjects between the two files (regional volume and tissue)!!');
end

load labels70.txt;
M = length(labels70);

for i = 1:Nsub_1
    fprintf('.')
    tmp = load(input_file_volume{i});
    volume1 = tmp(:,2);
    index = tmp(:,1);
    for j = 1: M
        reg_volume(i,j) = volume1(find(index==labels70(j)));
    end
end

for i = 1:Nsub_2
    fprintf('.')
    tmp2 = load(input_file_tissue{i});
    tissue_volume(i,1) = sum(tmp2(2:3,2));
end

fprintf('Finished.\n')

