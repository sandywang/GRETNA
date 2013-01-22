function [M_left, M_right] = gretna_readthickness(subjects_filename_left, subjects_filename_right)

% *************************************************************************
% This function is used to read individual cortical thickness values
% typically obtained from the CIVET pipeline procedure (Claude's version).
%
% function [M_left, M_right] = gretna_readthickness(subjects_filename_left,
% subjects_filename_right)
% input:
%   Group1_subject_filename_ct_left.txt
%       /data/aces/scratch7b/zchen3/oasis/pipeline/0001/thickness/OAS1_0001_native_rms_rsl_tlink_5mm_left.txt
%       /data/aces/scratch7b/zchen3/oasis/pipeline/0002/thickness/OAS1_0002_native_rms_rsl_tlink_5mm_left.txt
%       /data/aces/scratch7b/zchen3/oasis/pipeline/0004/thickness/OAS1_0004_native_rms_rsl_tlink_5mm_left.txt
%       /data/aces/scratch7b/zchen3/oasis/pipeline/0005/thickness/OAS1_0005_native_rms_rsl_tlink_5mm_left.txt
%       ....
%   Group1_subject_filename_ct_right.txt
%       /data/aces/scratch7b/zchen3/oasis/pipeline/0001/thickness/OAS1_0001_native_rms_rsl_tlink_5mm_right.txt
%       /data/aces/scratch7b/zchen3/oasis/pipeline/0002/thickness/OAS1_0002_native_rms_rsl_tlink_5mm_right.txt
%       /data/aces/scratch7b/zchen3/oasis/pipeline/0004/thickness/OAS1_0004_native_rms_rsl_tlink_5mm_right.txt
%       /data/aces/scratch7b/zchen3/oasis/pipeline/0005/thickness/OAS1_0005_native_rms_rsl_tlink_5mm_right.txt
%       ....
%
% output:
%           M_left:
%                           an s*n matrix with cortical thickness values
%                           for each node for each subject (left
%                           hemisphere). n: the number of nodes (e.g.
%                           81920); s: the number of subjects.
%           M_right:
%                           an s*n matrix with cortical thickness values
%                           for each node for each subject (right
%                           hemisphere). n: the number of nodes (e.g.
%                           81920); s: the number of subjects.
%
% For example:
%
%  input_Group1_ct_left = ' Group1_subject_filename_ct_left.txt';
%  input_Group1_ct_right = ' Group1_subject_filename_ct_right.txt';
%
% [M_left, M_right] = gretna_readthickness(input_Group1_ct_left,
% input_Group1_ct_right)
%
% Yong HE, BIC, MNI, McGill 2006/09/12
% ************************************************************************



warning off

input_file_left = textread(subjects_filename_left,'%s','delimiter','\n');
input_file_right = textread(subjects_filename_right,'%s','delimiter','\n');

Nsub_left = size(input_file_left,1);
Nsub_right = size(input_file_right,1);

if Nsub_left~=Nsub_right
    error('There are different number of subjects between the two files (left and right)!!');
end

for i = 1:Nsub_left
    fprintf('.')
    M_left(:,i) = load(input_file_left{i});
end
M_left = M_left';

for i = 1:Nsub_right
    fprintf('.')
    M_right(:,i) = load(input_file_right{i});
end
M_right = M_right';

fprintf('Finished.\n')

