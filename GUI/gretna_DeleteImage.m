function gretna_DeleteImage(DataList , DeleteNum , Prefix)
    if ischar(DataList)
        NiiHead=nifti(DataList);
        Data=NiiHead.dat(:,:,:,DeleteNum+1:end);
        
        NewNii=NiiHead;
        NewNii.dat.dim(1,4)=NiiHead.dat.dim(1,4)-DeleteNum;
        [Path , Name , Ext]=fileparts(NiiHead.dat.fname);
        NewNii.dat.fname=[Path , filesep , Prefix , Name , Ext];
        create(NewNii);
        NewNii.dat(:,:,:,:)=Data;
    end
