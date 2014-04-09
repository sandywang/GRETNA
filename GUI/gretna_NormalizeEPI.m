function gretna_NormalizeEPI( NormalizeEPIBatch , RefPath , RefPrefix , SubjName )
    MeanFile=gretna_GetNeedFile(RefPath , RefPrefix , SubjName);
    NormalizeEPIBatch{1,1}.spm.spatial.normalise.estwrite.subj.source=MeanFile;
    spm_jobman('run' , NormalizeEPIBatch);
