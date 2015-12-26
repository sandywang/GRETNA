function gretna_Coregister(CoregisterBatch , RefPath , RefPrefix , SubjName , T1Image)
    MeanFile = gretna_GetNeedFile(RefPath , RefPrefix , SubjName);
    CoregisterBatch{1,1}.spm.spatial.coreg.estimate.ref    = MeanFile;
    spm_jobman('run',CoregisterBatch);
    [Path , File , Ext]=fileparts(T1Image{1});
    
    copyfile(fullfile(Path, [File, Ext]),...
        fullfile(Path, sprintf('coreg_%s%s', File, Ext)));
    if strcmpi(Ext, '.img')
        copyfile(fullfile(Path, [File, '.hdr']),...
            fullfile(Path, sprintf('coreg_%s%s', File, '.hdr')));
    end