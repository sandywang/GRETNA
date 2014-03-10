function gretna_SEED_fc(Data_path, File_filter, ROI_mask, Brain_mask, Output_path)

%==========================================================================
% This function is used to calculate functional connectivity maps between a
% seed ROI and all the other voxels in the brain mask.
%
%
% Syntax: function gretna_Seed_fc(Data_path, File_filter, ROI_mask, Brain_mask, Output_path)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be processed (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be processed.
%       ROI_mask:
%                   The Seed-ROI mask.
%       Brain_mask:
%                   The brain mask whthin which fc will be calculated.
%       Output_path:
%                   The directory where the resultant fc maps will be
%                   sorted.
%
% Outputs:
%       For each subject, a FC (correlation coefficient) map and zFC
%       (Fisher's r2z transformation) map are generated in the directory
%       specified by "Output_path".
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

Vmask = spm_vol(Brain_mask);
[Ymask ~] = spm_read_vols(Vmask);
Ymask(isnan(Ymask)) = 0;
Ymask(logical(Ymask)) = 1;

Rows = Vmask.dim(1); Columns= Vmask.dim(2); Slices = Vmask.dim(3);

ind_mask = cell(Slices,1);
for k = 1:Vmask.dim(3)
    ind_mask{k} = find(Ymask(:,:,k)) ;
end

Vout = Vmask;
Vout.dt(1) = 16;

Vseed = spm_vol(ROI_mask);
[Yseed ~] = spm_read_vols(Vseed);
Yseed(isnan(Yseed)) = 0;
Yseed(logical(Yseed)) = 1;

ind_seed = find(Yseed);
[I_roi J_roi K_roi] = ind2sub(size(Yseed), ind_seed);

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Num_subs = size(Dir_data{1},1);

for i = 1:Num_subs
    
    fprintf('Calculating Seed-based FC for %s\n', [Dir_data{1}{i}]);
    
    cd (Dir_data{1}{i})
    File_name = spm_select('List',pwd, ['^' File_filter  '.*\.img$']);
    
    if isempty(File_name)
        File_name = spm_select('List',pwd, ['^' File_filter  '.*\.nii$']);
    end
    
    Vin = spm_vol(File_name);
    Timepoints = size(Vin,1);
    
    TC_roi = spm_get_data(Vin,[I_roi J_roi K_roi]');
    TC_roi = mean(TC_roi, 2);
    TC_roi = TC_roi - repmat(mean(TC_roi), Timepoints, 1);
    TC_roi = TC_roi./repmat(std(TC_roi, 0, 1), Timepoints, 1);
    
    fc = zeros(size(Ymask));
    z_fc = zeros(size(Ymask));
    
    for k = 1:Slices
        
        SliceData = zeros(Rows,Columns,Timepoints);
        Rtem = zeros(Rows,Columns);
        Ztem = zeros(Rows,Columns);
        
        if ~isempty(ind_mask{k})
            for t = 1:Timepoints
                SliceData(:,:,t) = spm_slice_vol(Vin(t),spm_matrix([0 0 k]),[Rows Columns],0);
            end
            
            SliceData = reshape(SliceData,Rows*Columns,Timepoints);
            TC_slice = SliceData(ind_mask{k},:)';
            TC_slice = TC_slice - repmat(mean(TC_slice), Timepoints, 1);
            TC_slice = TC_slice./repmat(std(TC_slice, 0, 1), Timepoints, 1);
            
            R = TC_roi' * TC_slice / (Timepoints - 1);
            Rtem(ind_mask{k}) = R;
            Ztem(ind_mask{k}) = gretna_fishertrans(R);
            
            fc(:,:,k) = Rtem;
            z_fc(:,:,k) = Ztem;
        end
    end
    
    cd (Output_path)
    [~, name, ~] = fileparts(Dir_data{1}{i});
    Vout.fname = ['FC_' name  '.img'];
    Vout = spm_write_vol(Vout,fc);
    
    Vout.fname = ['zFC_' name  '.img'];
    Vout = spm_write_vol(Vout,z_fc);
    
    fprintf('Calculating Seed-based FC for %s ...... is done\n', [Dir_data{1}{i}]);
end

return