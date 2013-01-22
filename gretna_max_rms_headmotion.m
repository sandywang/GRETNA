function gretna_max_rms_headmotion(Data_path, Criterion)

%==========================================================================
% This function is used to extract the max (translation and rotation) and
% root mean square (rms, mean across three translation and rotation directions,
% respectively) head motion of each subject. Of note, a max_rms_headmotion.mat
% file is generated that contains individual max/rms head motion parameters
% and a .txt file is also generated that contains subject indices whose head
% motion exceed the criterion specified.
%
%
% Syntax: function gretna_max_rms_headmotion(Data_path, Criterion)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory & filename of those head motion files
%                   (can be obtained by gretna_gen_cov_path.m).
%       Criterion:
%                   The 2*1 array specifying the criterion of max translation
%                   (mm, the first element) and rotation (degree, the second
%                   element) that can be born.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

fid = fopen(Data_path);
directory = textscan(fid, '%s');
fclose(fid);

Nsub = size(directory{1},1);

max_head = zeros(Nsub,2);
rms_head = zeros(Nsub,2);

for i = 1:Nsub
    [pathstr, name, ext] = fileparts(directory{1}{i});
    cd (pathstr)
    ind_hp = load([name ext]);%load the head motion file
    
    % max hd
    HP1 = max(abs(ind_hp));
    max_head(i,:) = [max(HP1(1:3)) max(HP1(4:6))];
    
    % rms hd
    HP2 = (mean(ind_hp.^2)).^0.5;
    rms_head(i,:) = [mean(HP2(1:3)) mean(HP2(4:6))];
end

max_head(:,2) = max_head(:,2)/pi*180;
rms_head(:,2) = rms_head(:,2)/pi*180;

[pathstr, ~, ~] = fileparts(Data_path);
cd (pathstr)
save max_rms_headmotion max_head rms_head

% generate .txt file
index_trans = find(max_head(:,1) > Criterion(1));
index_rot   = find(max_head(:,2) > Criterion(2));
index = unique([index_trans; index_rot]);

fid = fopen('subjects_with_larger_headmotion.txt','wt');
fprintf(fid, 'Subjects with head motion larger than %d mm in translation and/or %d degree in rotation: \n', Criterion(1), Criterion(2));
fprintf(fid, '\n');

if isempty(index)
    fprintf(fid, 'There are no subjects with larger translation or/and rotation than be specified');
else
    for i = 1:length(index)
        [pathstr, ~, ~] = fileparts(directory{1}{index(i)});
        fprintf(fid, '%s', ['#' num2str(index(i)) ':' blanks(1) pathstr]);
        if i ~= length(index)
            fprintf(fid, '\n');
        end
    end
end

fclose(fid);

return