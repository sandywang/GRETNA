function [regional_thickness] = gretna_regionalthickness(M_left, vertex_label_left, M_right, vertex_label_right)

% *************************************************************************
% This function is used to calcluate average cortical thickness within
% regions for each subject based on a labelled surface file (i.e.
% vertex_label)
%
% function [regional_thickness] = ...
%               gretna_regionalthickness(M_left, vertex_label_left, M_right,
%               vertex_label_right)
%
% For example:
%       M_left, M_right: s*n matrix (cortical thickness).
%       vertex_label_left, vertex_label_right: n*1 matrix; (animal
%       parcellation)
%
% [regional_thickness] = ...
%               gretna_regionalthickness(M_left, vertex_label_left, M_right,
%               vertex_label_right)
%
% input:
%           M_left:  thickness values( s*n matrix). n: the number of nodes
%                       (vertex); s: the number of subjects.
%           vertex_label_left: the label of each vertex. (left hemisphere)
%           M_right:  thickness values( s*n matrix). n: the number of nodes
%                       (vertex); s: the number of subjects.
%           vertex_label_right: the label of each vertex. (right
%           hemisphere)
%
% output:
%           regional_thickness: averaged cortical thickness values for each
%                      region of each subject (s*N matrix).  N: the number
%                      of regions (54); s: the number of subjects.
%
%
% Yong HE, BIC, MNI, McGill 2006/09/12
% *************************************************************************

warning off;
if nargin < 1
    error('No parameters');end

if nargin > 5
    error('Error the number of input parameters (< 6).');
end

% labelpath = '/data/aces/aces1/yonghe/gretna/labels.txt';
% original_labels = load (labelpath);
original_labels = [10,70,2,50,75,15,114,9,5,80,6,90,1,85,88,52,60,41,19,159,32,56,110,74,145,61,130,64,140,164,26,62,165,119,99,196,125,18,132,251,38,98,63,154,97,37,175,54,112,69,7,27,4,108;];
nlabel = length(original_labels);

M = M_left';
nsub = size(M,2);
if size(M,1)~=size(vertex_label_left,1)
    error('Error the M and vertex_label.');
end

for i = 1:nlabel
    regionsct = M(find(vertex_label_left == original_labels(i)),:);
    for j = 1:nsub
        regional_thickness_left(i,j) = mean(regionsct(:,j));
    end
end

regional_thickness_left = regional_thickness_left';


M = M_right';
if size(M,1)~=size(vertex_label_right,1)
    error('Error the M and vertex_label.');
end

for i = 1:nlabel
    regionsct = M(find(vertex_label_right == original_labels(i)),:);
    for j = 1:nsub
        regional_thickness_right(i,j) = mean(regionsct(:,j));
    end
end

regional_thickness_right = regional_thickness_right';


regional_thickness =[];
for i=1:27
    regional_thickness = [ regional_thickness [ regional_thickness_right(:,2*i-1)  regional_thickness_left(:,2*i)]];
end

return




