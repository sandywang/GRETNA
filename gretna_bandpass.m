function gretna_bandpass(DataList , Prefix , Band , TR)
    P=spm_vol(DataList);
    TimePoint=size(P , 1);
    Rows = P{1}.dim(1); Columns= P{1}.dim(2); Slices = P{1}.dim(3);
    
    POut = P;
    for t = 1:TimePoint
        [Path , Name , Ext] = fileparts(P{t}.fname);
        POut{t}.fname  = [Path , filesep , Prefix , Name ,  Ext];
        POut{t}.dt(1,1)=64;
        if isfield(POut{t},'descrip'),
            POut{t}.descrip = [POut{t}.descrip blanks(1) '- filter'];
        end;
    end
    
    for i=1:size(POut , 1)
        POut{i} = spm_create_vol(POut{i});    
    end   
    
    for k = 1:Slices
        SliceData = zeros(Rows,Columns,TimePoint);
        
        for t = 1:TimePoint
            SliceData(:,:,t) = spm_slice_vol(P{t},spm_matrix([0 0 k]),[Rows Columns],0);
        end
        
        meanSliceData = mean(SliceData,3);
        %SliceData = SliceData - repmat(meanSliceData,[1 1 TimePoint]);
        
        %tmp=reshape(SliceData , [] , TimePoint);
        %tmp=rest_IdealFilter(tmp' , TR , Band);
        %tmp=tmp';
        %SliceData=reshape(tmp , [Rows , Columns , TimePoint]);
        [SliceData] = gretna_filtering(SliceData, TR , Band);
        
        SliceData = SliceData + repmat(meanSliceData,[1 1 TimePoint]);
        
        for t = 1:TimePoint
            POut{t} = spm_write_plane(POut{t},SliceData(:,:,t),k);
        end;
    end
