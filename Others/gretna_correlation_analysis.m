function gretna_correlation_analysis(Data_path, File_filter, VarOfInterest, Output_path_name, Brain_mask, Covariate)

%==========================================================================
% This function is used to perform brain-behavior correlation analysis in a
% voxelwise manner.
%
%
% Syntax: function gretna_correlation_analysis(Data_path, File_filter, VarOfInterest, Output_path_name, Brain_mask, Covariate)
%
% Inputs: 
%       Data_path:
%                   The directory where those files to be processed are 
%                   sorted.
%       File_filter:
%                   The prefix of those files to be processed.
%       VarOfInterest:
%                   The directory & filename of a .txt file that contains
%                   the varaible (one colume). NOTE, the order of values in
%                   VarOfInterest should be the same as brain volumes
%                   listed in "Data_path".
%       Output_path_name:
%                   The directory & filename of the resultant correlation
%                   map.
%       Brain_mask:
%                   The brain mask within which the correlation analysis
%                   will be performed.
%       Covariate (optional):
%                   The directory & filename of a .txt file that contains
%                   the covariates during the correlation analysis.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

if nargin == 6
    Cova = load(Covariate);
else
    Cova = [];
end

Vmask = spm_vol(Brain_mask);
[Ymask, ~] = spm_read_vols(Vmask);
Ymask(isnan(Ymask)) = 0;
Ymask(logical(Ymask)) = 1;

Rows = Vmask.dim(1); Columns= Vmask.dim(2); Slices = Vmask.dim(3);

ind_mask = cell(Slices,1);
for k = 1:Vmask.dim(3)
    ind_mask{k} = find(Ymask(:,:,k)) ;
end

Voi = load(VarOfInterest);

cd (Data_path)
File_name = spm_select('List',pwd, ['^' File_filter  '.*\.img$']);
if isempty(File_name)
    File_name = spm_select('List',pwd, ['^' File_filter  '.*\.nii$']);
end

Vin = spm_vol(File_name);
Timepoints = size(Vin,1);

Tmap = zeros(Rows*Columns,Slices);

for k = 1:Slices
    
    SliceData = zeros(Rows,Columns,Timepoints);
    
    if ~isempty(ind_mask{k})
        for t = 1:Timepoints
            SliceData(:,:,t) = spm_slice_vol(Vin(t),spm_matrix([0 0 k]),[Rows Columns],0);
        end
        
        SliceData = reshape(SliceData,Rows*Columns,Timepoints);
        stat = gretna_glm(SliceData(ind_mask{k},:)', [Voi Cova], 't',1);
        
        Tmap(ind_mask{k},k) = stat.t;
    end
end

Tmap = reshape(Tmap,[Rows Columns Slices]);

[pathstr, name, ext] = fileparts(Output_path_name);
cd (pathstr)

Vout = Vmask;
Vout.fname = [name ext];
Vout.dt(1) = 16;
Vout.descrip = ['SPM{T_[' num2str(stat.df(1)) ']}'];
Vout = spm_create_vol(Vout);
Vout = spm_write_vol(Vout, Tmap);

return


        