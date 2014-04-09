function gretna_Coregister(CoregisterBatch , RefPath , RefPrefix , SubjName , T1Image)
    MeanFile = gretna_GetNeedFile(RefPath , RefPrefix , SubjName);
    CoregisterBatch{1,1}.spm.spatial.coreg.estimate.ref    = MeanFile;
    spm_jobman('run',CoregisterBatch);
    [Path , File , Ext]=fileparts(T1Image{1});
    movefile([Path , filesep , File , Ext] ,...
        [Path , filesep , 'co' , File , Ext]);
    if strcmpi(Ext, '.img')
        movefile([Path, filesep, File, '.hdr'],...
            [Path, filesep, 'co', File, '.hdr']);
    end