function gretna_EPI_dcm2nii(InputFile , OutputDir , SubjName , TimePoint)
        Path=fileparts(which('PreprocessInterface.m'));
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

        DataStruct=dir([OutputDir , filesep , '*.nii']);
        for i=1:TimePoint
            movefile([OutputDir , filesep , DataStruct(i).name] ,...
                sprintf('%s%s%s_%.4d.nii' , OutputDir , filesep , SubjName , i));
        end
