function gretna_voxel_based_eigenvec_bin(Path_Data,Temdir, Output_Path, File_filter, Data_mask, nType, R_thr)
%
%=========================================================================================
% This function is used to calculate nodal eigenvector for each voxel in the brain mask.
%
% function gretna_voxel_based_eigenvec_bin(Path_Data, Output_Path, File_filter, Data_mask)
%
% Notice: 1. Restore the adjacency matrix in the harddisk to reduce the memory space.
% When needed, we read the matrix from the harddisk.
% The correlation map is divided into n blocks,  default: nblocks = 100;
% dim: size_block - by - nvoxels. 
% 2. The eigenvector corresponds to the principal eigenvalue is calculated
% by the power iteration method. 
%
% Input:
%      Path_Data:
%            path and name of a .txt file containing the directory where the data are.
%            i.e., each line for each subject. Note that be sure the
%            directory does not contain blank space.
%            e.g., in example.txt, the contents are as following:
%            E:\Gender\OriginalData\Data\sub_01
%            E:\Gender\OriginalData\Data\sub_02
%            ...
%            ...
%      Output_Path:
%            the path where the generated mean time courses are sorted.
%
%      File_filter:
%            assign the files of interested with prefix; e.g., 'wra'.
%
%      Data_mask:
%            The path/filename of a mask that is used to define which voxel will be
%            calculated for nodal degree. In general, the brainmask_bin_xxx.img
%            can be used which is sorted in  ...\gretna\templates.
%      R_thr:
%            Positive value of R-threshold.
%      nType:
%           'positive', 'negative', or 'abs', Type of network used to
%           analyze
% Output:
%
%            pos_xxx.img/hdr--eigenvector in networks with positive correlation, i.e., R > R_thr;
%            neg_xxx.img/hdr--eigenvector in networks with negative correlation, i.e., R < -R_thr;
%            abs_xxx.img/hdr--eigenvector in networks with absolute correlation; i.e., |R| > R_thr;
%
% For example:
%
% gretna_voxel_based_eigenvec_bin('D:\Matlab\work\AD.txt', 'F:\AD\results', 'wras', 'F:\brainmask.img')
%
% Written by Jin-hui Wang, BIC BNU Beijing, 2011/09/04, wjhmjy@gmail.com
%=========================================================================================

warning off

head_mask = spm_vol(Data_mask);
[Ymask xxx] = spm_read_vols(head_mask);
head_mask.dt(1) = 16;
clear xxx
Index = find(Ymask);
[I J K] = ind2sub(size(Ymask),Index);

directory_data = textread(Path_Data,'%s');
num_data = length(directory_data);

e =10^(-6);          % error for eigen value
nblock = 100;     % number of block

tic
for i = 1:num_data
    [~, name, ~] = fileparts([directory_data{i}]);
    display(['subject' int2str(i)]);
    
    cd ([directory_data{i}])
    File_name = spm_select('List',pwd, ['^' File_filter '.*\.img$']);
    if isempty(File_name)
        File_name = spm_select('List',pwd, ['^' File_filter '.*\.nii$']);
    end
    
    V = spm_vol(File_name);
    Ydata = spm_get_data(V,[I J K]');
    clear V;
    
    numSample = size(Ydata,1);
    Ydata = Ydata - repmat(mean(Ydata), numSample, 1);        %均值为零
    Ydata = Ydata./repmat(std(Ydata, 0, 1), numSample, 1);      %方差为1
    
    cols_end = rem(size(Ydata,2), nblock);
    size_block = fix(size(Ydata,2) / nblock);         % size of each block of correlation matrix
    
    IPN_calLCAM_bin_write(Ydata, Temdir, R_thr, nblock, nType)  % nblock =100
    cd(Temdir);
    
    % Calculate the eigenvector with power multiple method
    %reference: CM.m by 野渡无人
    
    R_bin = zeros(size(Ymask));
    n=0; %记录迭代次数
    nvoxel = length(Index);
    u0 = ones(nvoxel,1);      % initial vector
    
    u1 = mat_by_bin (nvoxel, u0, Temdir, nblock, size_block, cols_end) ; %u1=A*u0;

    n=n+1;

    lamda0=0;
    
    while 1     %采用死循环模式，满足误差限要求即终止

        [m,p]=max(abs(u1));     %选择最大的分量,m为最大分量值,p为最大分量对应下标值

        if m==0

            error('各分量已全0')

        end

        uk = mat_by_bin (nvoxel, u1, Temdir, nblock, size_block, cols_end)  ;       %      uk=A*u1;

        n=n+1

        lamda=uk(p)/u1(p);

        if abs(lamda-lamda0)< e

            break

        end

        lamda0=lamda;

        u1=uk/uk(p);

    end

    uk = uk/uk(p);
    uk = uk/sqrt(sum(uk.*uk));        % normalize
    
    R_bin(Index) = uk;
    
    cd (Output_Path)
    switch nType
        case 'positive'
            head_mask.fname = ['eigenvec_pos_bin_' name '.img'];
            head_mask = spm_write_vol(head_mask, R_bin);
        case 'negative'
            head_mask.fname = ['eigenvec_neg_bin_' name '.img'];
            head_mask = spm_write_vol(head_mask, R_bin);
        case 'abs'
            head_mask.fname = ['eigenvec_abs_bin_' name '.img'];
            head_mask = spm_write_vol(head_mask, R_bin);
    end
    
    display([directory_data{i} blanks(1) 'is done'])
    
end
toc

function uk = mat_by_bin ( nvoxel, u0, Temdir, nblock, size_block, cols_end) 
% Calculate uk = A*u0, while A is adjacency matrix of non-zero elements 
% in Index
% Input: Ydata: time-series of non-zero elements
 %          Index: index of non-zero elements
 %          u0: column vector
 %          nType: threshold type of adjacency matrix
 %          R_thr: threshold of correlation R
 
 uk = zeros(nvoxel,1);
 
 cd(Temdir); 
 uk0=cell(nblock,1); matrix =cell(nblock,1);
 parfor ii = 1: nblock
     matrix{ii,1} = load(['mat_bin_' int2str(ii)]);           % variable: aa
     uk0{ii} = matrix{ii,1}.aa*u0;            %uk(start_dim:end_dim) = aa*u0; 
     matrix{ii,1}=[];
 end
 
 for ii=1:nblock
     start_dim = (ii-1)*size_block+1;
     end_dim = ii *size_block;
     uk(start_dim:end_dim) = uk0{ii};
 end
 clear uk0;
 
 if cols_end~=0
     start_dim = ii*size_block+1;
     end_dim = nvoxel;
     load(['mat_bin_' int2str(ii+1)]);           % variable: aa
     uk(start_dim:end_dim) = aa*u0; 
     aa=[];
 end
    
 return
 