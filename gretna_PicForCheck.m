function gretna_PicForCheck(DataList , PicDir , SubjName)
    P=spm_vol(DataList);
    TimePoint=size(P , 1);
    Rows = P{1}.dim(1); Columns= P{1}.dim(2); Slices = P{1}.dim(3);
    
    MeanImage=zeros(Rows , Columns , Slices);
    for k = 1:Slices
        SliceData = zeros(Rows,Columns,TimePoint);
        for t = 1:TimePoint
            SliceData(:,:,t) = spm_slice_vol(P{t},spm_matrix([0 0 k]),[Rows Columns],0);
        end
        meanSliceData = mean(SliceData,3);
        MeanImage( : , : , k ) = meanSliceData;
    end
    