function [vertex_label_left, vertex_label_right] = gretna_surfaceseg(subjects_filename_ANIMAL_left, subjects_filename_ANIMAL_right)

% *************************************************************************
% This function is used to segment cortical surface (ANIMAL + INSECT)
%
%
% function [vertex_label_left, vertex_label_right] =
% gretna_surfaceseg(subjects_filename_ANIMAL_left, subjects_filename_ANIMAL_right)
%
%
% For example:
%
% ......
%
% input:
%
%
% output:
%           vertex_label_left: a labelled surface file of left hemisphere (.txt)
%           vertex_label_right: a labelled surface file of right hemisphere (.txt)
%
% Yong HE, BIC, MNI, McGill 2007/05/01
% *************************************************************************



warning off

input_file_left = textread(subjects_filename_ANIMAL_left,'%s','delimiter','\n');
input_file_right = textread(subjects_filename_ANIMAL_right,'%s','delimiter','\n');

Nsub_left = size(input_file_left,1);
Nsub_right = size(input_file_right,1);

if Nsub_left~=Nsub_right
    error('There are different number of subjects between the two files (left and right)!!');
end

for i = 1:Nsub_left
    fprintf('.')
    vertex_animalmidsurf_left(i,:) = load(input_file_left{i})';
end

for i = 1:Nsub_right
    fprintf('.')
    vertex_animalmidsurf_right(i,:) = load(input_file_right{i})';
end

vertex_label_matrix_left = vertex_animalmidsurf_left';
vertex_label_matrix_right = vertex_animalmidsurf_right';

[LeftMax, vertex_label_left] = max(hist(vertex_label_matrix_left', 0:255));
[RightMax, vertex_label_right] = max(hist(vertex_label_matrix_right', 0:255));

vertex_label_left = vertex_label_left - ones(1,length(vertex_label_left));
vertex_label_right = vertex_label_right - ones(1,length(vertex_label_right));

load labels.txt

tleft = ismember(vertex_label_left, labels);
tright = ismember(vertex_label_right, labels);

vertex_label_left = (vertex_label_left .* tleft)';
vertex_label_right = (vertex_label_right .* tright)';

%test
%S = size(vertex_animalmidsurf_left,1);
%LeftMaxC = LeftMax / S;
%RightMaxC = RightMax / S;

%vertex_label_left(find(LeftMaxC<0.6)) = 0;
%vertex_label_right(find(RightMaxC<0.6)) = 0;

fprintf('Finished.\n')

return;
