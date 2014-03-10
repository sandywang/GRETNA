function gretna_homotopic_fc(Data_path, File_filter, Mask, Output_path)

%==========================================================================
% This function is used to calculate inter-hemisphere homotopic functional
% connectivity in a voxel-wise manner.
%
%
% Syntax: function gretna_homotopic_fc(Data_path, File_filter, Mask, Output_path)
%
% Inputs: 
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be processed (can be 
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be processed.
%       Mask:
%                   Brain mask (only hemisphere) where the homotopic 
%                   functional connectivity will be calculated.
%       Output_path:
%                   The directory where the resultant images (correlation
%                   values and fishter's transformed z values)are sorted.
%
% Reference:
% 1. Zuo et al., 2011, JN, Growing Together and Growing Apart: Regional and Sex
%    Differences in the Lifespan Developmental Trajectories of Functional Homotopy.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

Head_Info = spm_vol(Mask);
[Ymask ~] = spm_read_vols(Head_Info);
Head_Info.dt(1) = 16;

X_dim = size(Ymask, 1);

% Left Hemisphere
Ymask_L = Ymask;
Ymask_L(1:ceil(X_dim/2),:,:) = 0;

index = find(Ymask_L);
[I_L J_L K_L] = ind2sub(size(Ymask_L),index);
I_R = X_dim + 1 - I_L;

fid = fopen(Data_path);
directory_data = textscan(fid, '%s');
fclose(fid);

Num_sub = size(directory_data{1},1);

for sub = 1:Num_sub
    cd (directory_data{1}{sub})
    File_name = spm_select('List',pwd, ['^' File_filter  '.*\.img$']);
    if isempty(File_name)
        File_name = spm_select('List',pwd, ['^' File_filter  '.*\.nii$']);
    end
    
    V = spm_vol(File_name);
    
    tc_L = spm_get_data(V,[I_L J_L K_L]');
    tc_R = spm_get_data(V,[I_R J_L K_L]');
    
    fc = zeros(size(Ymask));
    
    for vox = 1:length(I_L)
        [r ~] = corrcoef([tc_L(:,vox) tc_R(:,vox)]);
        fc(I_L(vox), J_L(vox), K_L(vox)) = r(2);
    end
    
    z_fc = gretna_fishertrans(fc);
    
    cd (Output_path)
    [~, name, ~] = fileparts(directory_data{1}{sub});
    Head_Info.fname = ['r_Homotopic_fc_' name '.img'];
    Head_Info = spm_write_vol(Head_Info,fc);
    
    Head_Info.fname = ['z_Homotopic_fc_' name '.img'];
    Head_Info = spm_write_vol(Head_Info,z_fc);
    
    fprintf('%s done\n', [directory_data{1}{sub}]);
end

return