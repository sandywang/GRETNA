function flag_failed = psom_run_job(file_job)
% Run a PSOM job. 
%
% SYNTAX:
% FLAG_FAILED = PSOM_RUN_JOB(FILE_JOB)
%_________________________________________________________________________
% INPUTS:
%
% JOB
%    (string or structure) JOB is a structure defining a PSOM job (with
%    COMMAND, FILES_IN, FILES_OUT, FILES_CLEAN, OPT fields. This job can 
%    also be specified through a mat file, where the job attributes are 
%   saved as variables.
%
%_________________________________________________________________________
% OUTPUTS:
%
% FLAG_FAILED
%    (boolean) FLAG_FAILED is true if the job has failed. This happens if 
%    the command of the job generated an error, or if one of the output 
%    files of the job was not successfully generated.
%
% _________________________________________________________________________
% COMMENTS:
%
% This function will start by deleting all the output files if they exist 
% before running the job. It will also create all the necessary output 
% folders.
%
% When running a job, this function will create a global variable named
% "gb_psom_name_job". This can be accessed by the command executed by the
% job. This may be useful for example to build unique temporary file names.
% 
% When called by the pipeline manager, this function will generate tag files 
% to code for the status of the job (running, finished or failed).
%
% Copyright (c) Pierre Bellec, Montreal Neurological Institute, 2008-2010.
% Departement d'informatique et de recherche operationnelle
% Centre de recherche de l'institut de Geriatrie de Montreal
% Universite de Montreal, 2010-2011.
% Maintainer : pierre.bellec@criugm.qc.ca
% See licensing information in the code.
% Keywords : pipeline

% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.

global gb_psom_name_job
psom_gb_vars
seed = psom_set_rand_seed();

try
    %% Generate file names
    [path_f,name_job,ext_f] = fileparts(file_job);

    if ~strcmp(ext_f,'.mat')
        error('The job file %s should be a .mat file !',file_job);
    end

    file_jobs     = [path_f filesep 'PIPE_jobs.mat'];
    file_running  = [path_f filesep name_job '.running'];
    file_failed   = [path_f filesep name_job '.failed'];
    file_finished = [path_f filesep name_job '.finished'];
    file_profile  = [path_f filesep name_job '.profile.mat'];
catch
    name_job = 'manual';
end
gb_psom_name_job = name_job;

try
    job = sub_load_job(file_jobs,name_job); % This is launched through the pipeline manager
    flag_psom = true;
catch
    if ischar(file_job)
        job = load(file_job);
    else
        job = file_job;
    end
    flag_psom = false;
end

if flag_psom
    if exist(file_running,'file')||exist(file_failed,'file')||exist(file_finished,'file')
        error('Already found a tag on that job. Sorry dude, I must quit ...');
    end
    
    %% Create a running tag for the job
    tmp = datestr(clock);
    save(file_running,'tmp')
end

%% Upload job info
gb_name_structure = 'job';
gb_list_fields    = { 'files_in' , 'files_out' , 'files_clean' , 'command','opt' , 'dep' };
gb_list_defaults  = { {}         , {}          , {}            , NaN      , {}   , {}    };
psom_set_defaults

%% Print general info about the job
start_time = clock;
msg = sprintf('Log of the (%s) job : %s\nStarted on %s\nUser: %s\nhost : %s\nsystem : %s',gb_psom_language,name_job,datestr(clock),gb_psom_user,gb_psom_localhost,gb_psom_OS);
stars = repmat('*',[1 30]);
fprintf('\n%s\n%s\n%s\n',stars,msg,stars);

%% The job starts now !
try
    msg = sprintf('The job starts now !');
    stars = repmat('*',[1 size(msg,2)]);
    fprintf('%s\n%s\n',msg,stars);

    flag_failed = false;
   
    try
        sub_eval(command,files_in,files_out,files_clean,opt)
        end_time = clock;
    catch
        end_time = clock;
        flag_failed = true;
        errmsg = lasterror;
        fprintf('\n\n%s\nSomething went bad ... the job has FAILED !\nThe last error message occured was :\n%s\n',stars,errmsg.message);
        if isfield(errmsg,'stack')
            for num_e = 1:length(errmsg.stack)
                fprintf('File %s at line %i\n',errmsg.stack(num_e).file,errmsg.stack(num_e).line);
            end
        end
    end
    
    %% Checking outputs
    msg = sprintf('Checking outputs');
    stars = repmat('*',[1 size(msg,2)]);
    fprintf('\n%s\n%s\n%s\n',stars,msg,stars);

    list_files = psom_files2cell(files_out);

    for num_f = 1:length(list_files)
        if ~psom_exist(list_files{num_f})
            if size(list_files{num_f},1)>1
                fprintf('The output file or directory %s (...) has not been generated!\n',list_files{num_f}(1,:));
            else
                fprintf('The output file or directory %s has not been generated!\n',list_files{num_f});
            end
            flag_failed = true;
        else
            if size(list_files{num_f},1)>1
                fprintf('The output file or directory %s (...) was successfully generated!\n',list_files{num_f}(1,:));
            else
                fprintf('The output file or directory %s was successfully generated!\n',list_files{num_f});
            end
        end
    end                   

    %% Verbose an epilogue
    elapsed_time = etime(end_time,start_time);
    if flag_failed
        msg1 = sprintf('%s : The job has FAILED',datestr(clock));
    else
        msg1 = sprintf('%s : The job was successfully completed',datestr(clock));
    end
    msg2 = sprintf('Total time used to process the job : %1.2f sec.',elapsed_time);
    stars = repmat('*',[1 max(size(msg1,2),size(msg2,2))]);
    fprintf('\n%s\n%s\n%s\n%s\n',stars,msg1,msg2,stars);
    
    %% Create a tag file for output status
    if flag_psom   
        %% Check for double tag files
        if exist(file_failed)
            flag_failed = true;
            fprintf('Huho the job just finished but I found a FAILED tag. There must be something weird going on with the pipeline manager. Anyway, I will let the FAILED tag just in case ...');
        end     

        %% Create a profile
        save(file_profile,'start_time','end_time','elapsed_time','seed');
        
        %% Finishing the job
        delete(file_running); 
        if flag_failed
            save(file_failed,'tmp')       
        else
            save(file_finished,'tmp')     
        end
    end
    
catch
    if flag_psom    
        delete(file_running);
        msg1 = sprintf('The job has FAILED');
        tmp = datestr(clock);
        save(file_failed,'tmp');
    end
    errmsg = lasterror;
    rethrow(errmsg)
end

%%%%%%%%%%%%%%%%%%
%% Subfunctions %%
%%%%%%%%%%%%%%%%%%

function [] = sub_eval(command,files_in,files_out,files_clean,opt)

eval(command)

function job = sub_load_job(file_jobs,name_job)

load(file_jobs,name_job);
eval(['job = ' name_job ';']);
