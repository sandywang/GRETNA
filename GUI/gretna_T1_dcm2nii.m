function gretna_T1_dcm2nii(InputFile , OutputDir , SubjName)
        Path=fileparts(which('gretna.m'));
        ProgramDir=[Path , filesep , 'DCM2NII' , filesep];
        Default_ini=[ProgramDir , 'dcm2nii.ini'];
        Option=[' -b ' , Default_ini];
        Input  =  [' ', InputFile];
        Output =  [' -o ' , OutputDir];
        if ispc
            Cmd=[ProgramDir , 'dcm2nii.exe'];
            eval(['!' , Cmd , Option , Output , Input]);
        elseif ismac
            Cmd=[ProgramDir , 'dcm2nii_mac'];
            eval(['!' , Cmd , Option , Output , Input]);
        else
            Cmd=[ProgramDir , 'dcm2nii'];
            eval(['!chmod +x ' , Cmd]); 
            eval(['!' , Cmd , Option , Output , Input]);
        end

        DataStruct=dir([OutputDir , filesep , 'co*.nii']);

        %movefile([OutputDir , filesep , DataStruct(1).name] ,...
        %    sprintf('%s%scoNifti_%s.nii' , OutputDir , filesep , SubjName));
        movefile(fullfile(OutputDir, DataStruct(1).name),...
            fullfile(OutputDir, sprintf('Nifti_%s.nii', SubjName))...
            );