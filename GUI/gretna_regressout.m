function gretna_regressout(DataList , Prefix , CovConfig)
    Cov=[];

    if strcmpi(CovConfig.HMBool , 'TRUE')
        HMFile=gretna_GetNeedFile(CovConfig.HMPath , CovConfig.HMPrefix , CovConfig.Name);
        HMMat=load(HMFile{1});
        Cov=[Cov, HMMat];
        if strcmpi(CovConfig.HMDeriv, 'TRUE')
            HMDerivTC=[zeros(1, size(HMMat, 2)); HMMat(1:end-1,:)];
            TempMat=HMMat-HMDerivTC;
            TempMat(1,:)=zeros(1, size(TempMat, 2));
            Cov=[Cov, TempMat];
        end
        
        if strcmpi(CovConfig.HMFrison24, 'TRUE')
            LagBehind=[zeros(1, size(HMMat, 2)); HMMat(1:end-1, :)];
            TempMat=[LagBehind, HMMat.^2, LagBehind.^2];
            Cov=[Cov, TempMat];
        end
    end
    CovCell=CovConfig.CovCell;

    P=spm_vol(DataList);
    TimePoint=size(P , 1);
    Rows = P{1}.dim(1); Columns= P{1}.dim(2); Slices = P{1}.dim(3);
    
    if ~isempty(CovCell)
        for i=1:size(CovCell , 1)
            [Path , Name , Ext]=fileparts(CovCell{i});
            if strcmp(Ext , '.txt')
                TempMat=load([Path , filesep , Name , Ext]);
                Cov=[Cov , TempMat];
            elseif strcmp(Ext , '.mat')
                TempStruct=load([Path , filesep , Name , Ext]);
                TempField=fieldnames(TempStruct);
                TempMat=getfield(TempStruct , TempField{1});
                Cov=[Cov , TempMat];
            else
                PMask=spm_vol(CovCell{i});
                Mask=spm_read_vols(PMask);
                Mask=logical(reshape(Mask , [] , 1));
                TC=zeros(TimePoint,1);
                for j=1:TimePoint
                    Volume=spm_read_vols(P{j});
                    Volume=reshape(Volume , [] , 1);
                    MeanTC=mean(Volume(Mask) , 1);
                    TC(j,1)=MeanTC;
                end
                Cov=[Cov , TC];
            end
        end
    end            
    
    %PMask=spm_vol(CovConfig.BrainMask);
    %Mask=spm_read_vols(PMask);

    POut = P;
    for t = 1:TimePoint
        [Path , Name , Ext] = fileparts(P{t}.fname);
        POut{t}.fname  = [Path , filesep , Prefix , Name ,  Ext];
        POut{t}.dt(1,1)=64;
        if isfield(POut{t},'descrip'),
            POut{t}.descrip = [POut{t}.descrip blanks(1) '- removal covs'];
        end;
    end
    for i=1:size(POut , 1)
        POut{i} = spm_create_vol(POut{i});    
    end   
    
    for k = 1:Slices
        SliceData = zeros(Rows,Columns,TimePoint);
        %SliceMask = Mask(:,:,k);
        %SliceMask = reshape(SliceMask , [] , 1);
        %TmpMask   = find(SliceMask~=0);
        
        %if ~isempty(TmpMask)
            for t = 1:TimePoint
                SliceData(:,:,t) = spm_slice_vol(P{t},spm_matrix([0 0 k]),[Rows Columns],0);        
            end
            SliceData=double(reshape(SliceData , [] , TimePoint));
            %Tmp=SliceData(TmpMask , :);
            Tmp=SliceData';
        
            Stat = gretna_glm(Tmp, Cov , 'r');
            Tmp=Stat.r';

            %SliceData=zeros(size(SliceData));
            %SliceData(TmpMask , :)=Tmp;
            SliceData=reshape(Tmp , [Rows , Columns , TimePoint]);
        %end
            
        for t = 1:TimePoint
            POut{t} = spm_write_plane(POut{t},SliceData(:,:,t),k);
        end
    end    
