function opt = psom_config(path_test,opt,tests,time_wait)
% Test the configuration of PSOM
%
% SYNTAX:
% OPT = PSOM_CONFIG(PATH_TEST,OPT,TESTS,TIME_WAIT)
%
% _________________________________________________________________________
% INPUTS:
%
% PATH_TEST
%    (string, default local_path_demo defined in the file 
%    PSOM_GB_VARS) the full path to folder where the tests will run. 
%    IMPORTANT WARNING : PSOM will empty totally this folder and then 
%    build example files and logs in it.
%
% OPT
%    (structure, optional) the options normally passed to PSOM_RUN_PIPELINE. 
%    Note that the OPT.PATH_LOGS field will be set to [PATH_TEST /logs/].
%    Type "help psom_run_pipeline" for more infos. Note that the defaults 
%    options can be changed by editing the file PSOM_GB_VARS. If you do not 
%    have the permission to edit this file, just copy it under the name 
%    PSOM_GB_VARS_LOCAL and add it to the search path, it will override 
%    PSOM_GB_VARS.
%
% TESTS
%   (string, or cell of strings, default: all tests) The list of tests to be
%   performed (see also the COMMENTs section below):
%   'script_pipe' : Run a simple script       (pipeline manager test)
%   'matlab_pipe' : Start matlab in a script  (pipeline manager test)
%   'psom_pipe'   : Start PSOM in a script    (pipeline manager test)
%   'script_job'  : Run a simple script       (job manager test)
%   'matlab_job'  : Start matlab in a script  (job manager test)
%   'psom_job'    : Start PSOM in a script    (job manager test)
%
% TIME_WAIT
%    (integer, default 60) the time (in seconds) that PSOM will wait 
%    before a submission to a queue system is considered as failed.
%
% _________________________________________________________________________
% OUTPUTS:
% 
% OPT
%    (structure) an updated version of the input, populated with default 
%    values.
%
% _________________________________________________________________________
% SEE ALSO:
% PSOM_RUN_SCRIPT, PSOM_RUN_PIPELINE, PSOM_DEMO_PIPELINE
% 
% _________________________________________________________________________
% COMMENTS:
%
% NOTE 1:
%    PATH_TEST is erased and then populated with (small) test files.
%
% NOTE 2:
%    This function will test the PSOM configuration step-by-step, and will 
%    produce reasonably explicit error messages if an error occurs at any 
%    stage. PSOM_RUN_PIPELINE is assuming a correct configuration, and will 
%    fail without producing informative error messages if there is a problem.
%
% NOTE 3:
%    A "pipeline manager test" means that the test will run in the same 
%    conditions as the pipeline manager (OPT.MODE_PIPELINE_MANAGER).
%
% NOTE 4:
%    A "job manager test" means that the test will run in the same conditions
%    as the job manager: a first process will be started in
%    OPT.MODE_PIPELINE_MANAGER mode, which will itself start a process in 
%    OPT.MODE mode.
%
% Copyright (c) Pierre Bellec, 
% Departement d'informatique et de recherche operationnelle
% Centre de recherche de l'institut de Geriatrie de Montreal
% Universite de Montreal, 2011
% Maintainer : pierre.bellec@criugm.qc.ca
% See licensing information in the code.
% Keywords : pipeline, PSOM, configuration

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check syntax and default options %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

psom_gb_vars

if nargin<1||isempty(path_test)
    path_test = gb_psom_path_demo;    
end

if (nargin<3)||isempty(tests)
    tests = {'script_pipe','matlab_pipe','psom_pipe','script_job','matlab_job','psom_job'};
end

if (nargin<4)
    time_wait = 60;
end

if ischar(tests)
    tests = {tests};
end

%% Execution options
list_fields    = {'flag_clean' , 'flag_pause' , 'init_matlab'       , 'flag_update' , 'flag_debug' , 'path_search'       , 'restart' , 'shell_options'       , 'path_logs' , 'command_matlab' , 'flag_verbose' , 'mode'       , 'mode_pipeline_manager' , 'max_queued'       , 'qsub_options'       , 'time_between_checks' , 'nb_checks_per_point' , 'time_cool_down' };
list_defaults  = {true         , true         , gb_psom_init_matlab , true          , false        , gb_psom_path_search , {}        , gb_psom_shell_options , []          , ''               , true           , gb_psom_mode , gb_psom_mode_pm         , gb_psom_max_queued , gb_psom_qsub_options , []                    , []                    , []               };
if nargin > 1
    opt = psom_struct_defaults(opt,list_fields,list_defaults);
else
    opt = psom_struct_defaults(struct(),list_fields,list_defaults);
end
opt.path_logs = fullfile(path_test,filesep);

if isempty(opt.mode_pipeline_manager)
    opt.mode_pipeline_manager = opt.mode;
end

if isempty(opt.command_matlab)
    if strcmp(gb_psom_language,'matlab')
        opt.command_matlab = gb_psom_command_matlab;
    else
        opt.command_matlab = gb_psom_command_octave;
    end
end

if ~ismember(opt.mode,{'session','background','batch','qsub','msub'})
    error('%s is an unknown mode of pipeline execution. Sorry dude, I must quit ...',opt.mode);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Show the configuration to the user %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

msg = sprintf('PSOM configuration overview');
stars = repmat('*',[1 length(msg)]);
fprintf('\n%s\n%s\n%s\n\n',stars,msg,stars);
fprintf('Language ... %s\nTime ... %s\nUser ...  %s\nHost ...  %s\nSystem ...  %s\n',upper(gb_psom_language),datestr(clock),gb_psom_user,gb_psom_localhost,gb_psom_OS);

fprintf('Logs folder (OPT.PATH_LOGS) ...  %s\n',opt.path_logs);
fprintf('Execution mode of the pipeline manager (OPT.MODE_PIPELINE_MANAGER) ...  %s\n',opt.mode_pipeline_manager);
fprintf('Execution mode of the job manager (OPT.MODE) ...  %s\n',opt.mode);
fprintf('Maximal number of job(s) executed in parallel (0 means no limit) ...  %i\n',opt.max_queued);
fprintf('How to start %s (OPT.COMMAND_MATLAB) ...  %s\n',upper(gb_psom_language),opt.command_matlab);
if ~isempty(opt.init_matlab)
    fprintf('A %s session begins with (OPT.INIT_MATLAB) ...  %s\n',upper(gb_psom_language),opt.init_matlab);
end
if ~isempty(opt.shell_options)&&(~strcmp(opt.mode,'session')||~strcmp(opt.mode_pipeline_manager,'session'))
    fprintf('A shell script begins with (OPT.SHELL_OPTIONS) ...  %s\n',opt.shell_options);
end
if ~isempty(opt.qsub_options)&&(strcmp(opt.mode,'qsub')||strcmp(opt.mode_pipeline_manager,'qsub')||strcmp(opt.mode,'msub')||strcmp(opt.mode_pipeline_manager,'msub'))
    fprintf('How to start QSUB/MSUB (OPT.QSUB_OPTIONS) ...  %s\n',opt.qsub_options);
end
fprintf('Search path (OPT.PATH_SEARCH) ... ')
if isempty(opt.path_search)
    fprintf(' Search path of the current session ('''')\n')
elseif strcmp(opt.path_search,'gb_niak_omitted')||strcmp(opt.path_search,'gb_psom_omitted')
    fprintf(' Default search path at start-up (''gb_niak_omitted'')\n')
else
    fprintf(' %s\n    (the output may have been truncated, see the output OPT.PATH_SEARCH)\n',opt.path_search(1:min(100,length(opt.path_search))))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ask confirmation before proceeding %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\n%s\n',stars)
fprintf('PSOM configuration tutorial ... http://code.google.com/p/psom/wiki/ConfigurationPsom\n')
fprintf('Type "help psom_run_pipeline" for more infos.\n')

%% If the pipeline fully runs in session mode, exit
if strcmp(opt.mode,'session')&&strcmp(opt.mode_pipeline_manager,'session')
    fprintf('Both the pipeline and the job managers will be executed in the current session. There is nothing to test !\n')
    return
end

%% Erase the test folder
fprintf('\nThe following folder is going to be emptied before tests are started:\n%s\n',path_test);
fprintf('Press CTRL-C now to stop or any key to continue.\n');
fprintf('%s\n',stars)
pause
if exist(path_test,'dir')
    rmdir(path_test,'s');
end
psom_mkdir(path_test);


%% Set up the options for PSOM_RUN_SCRIPT
opt_script.path_search    = opt.path_search;
opt_script.init_matlab    = opt.init_matlab;
opt_script.flag_debug     = true;        
opt_script.shell_options  = opt.shell_options;
opt_script.command_matlab = opt.command_matlab;
opt_script.qsub_options   = opt.qsub_options;

%% Start the tests
test_failed = false;
label_failed = '';
for num_t = 1:length(tests)
    label = tests{num_t};

    if ~test_failed
        msg = sprintf('Running the "%s" test',label);
        stars = repmat('*',[1 length(msg)]);
        fprintf('\n%s\n%s\n%s\n\n',stars,msg,stars);                        
    end
        
    switch label

        case 'script_pipe'

            if test_failed
                continue
            end

            % Test description
            fprintf('Trying to execute a simple command ...\n');

            % Design and start the script
            path_xp = fullfile(path_test,label,filesep);
            psom_mkdir(path_xp);
            opt_script.mode = opt.mode_pipeline_manager;
            if ispc
                script = fullfile(path_xp,[label '.bat']);
            else
                script = fullfile(path_xp,[label '.sh']);
            end
            logs.txt   = fullfile(path_xp,[label '.log']);
            logs.eqsub = fullfile(path_xp,[label '.eqsub']);
            logs.oqsub = fullfile(path_xp,[label '.oqsub']);
            logs.exit  = fullfile(path_xp,[label '.exit']);
            [flag_failed,errmsg] = psom_run_script('',script,opt_script,logs);

            % Debriefing #1 : did the script start ?
            if flag_failed~=0
                if ~isempty(errmsg)
                    fprintf('\n    The test failed. The script could not be submitted ! \n The feedback was : %s\n',errmsg);
                else
                    fprintf('\n    The test failed. The script could not be submitted ! \n');
                end
                test_failed = true;
                label_failed = label;
                continue
            else
                if ~isempty(errmsg)
                    fprintf('\n    The script was successfully submitted ... The feedback was : %s\n',errmsg);
                else
                    fprintf('\n    The script was successfully submitted ... There was no feedback\n');
                end
            end

            % Debriefing #2 : did the script work ?
            fprintf('Now waiting to see if the script worked ... This could take a while (in qsub/msub modes) ...\nPSOM is going to wait %i seconds. You can change this time using TIME_WAIT.\n',time_wait)
            time_elapsed = 0;
            while (~psom_exist(logs.exit))&&(time_elapsed<time_wait)
                pause(1)
                fprintf('.')
                time_elapsed = time_elapsed+1;
            end

            if psom_exist(logs.exit)
                fprintf('\nThe tag file %s was successfully generated !\n',logs.exit)
                fprintf('\nThe test was successful !\n') 
            else
                fprintf('\nI could not find the file the test was supposed to generate ...\n    %s\n',logs.exit);
                fprintf('The log of the job was:\n')
                sub_print_log(logs.txt)
                sub_print_log(logs.eqsub)
                sub_print_log(logs.oqsub)
                fprintf('\nThe test has failed !\n')
                test_failed = true;
                label_failed = 'script_pipe_submission';
            end

        case 'matlab_pipe'

            if test_failed
                continue
            end

            % Test description
            fprintf('Trying to start matlab from the command line ...\n');

            % Design and start the script
            path_xp = fullfile(path_test,label,filesep);
            psom_mkdir(path_xp);
            opt_script.mode = opt.mode_pipeline_manager;
            if ispc
                script = fullfile(path_xp,[label '.bat']);
            else
                script = fullfile(path_xp,[label '.sh']);
            end
            logs.txt   = fullfile(path_xp,[label '.log']);
            logs.eqsub = fullfile(path_xp,[label '.eqsub']);
            logs.oqsub = fullfile(path_xp,[label '.oqsub']);
            logs.exit  = fullfile(path_xp,[label '.exit']);
            file_test  = fullfile(path_xp,[label '_test.mat']);
            cmd = sprintf('a = clock, save(''%s'',''a'')',file_test);
            [flag_failed,errmsg] = psom_run_script(cmd,script,opt_script,logs);

            % Debriefing #1 : did the script start ?
            if flag_failed~=0
                if ~isempty(errmsg)
                    fprintf('\n    The test failed. The script could not be submitted ! \n The feedback was : %s\n',errmsg);
                else
                    fprintf('\n    The test failed. The script could not be submitted ! \n');
                end
                test_failed = true;
                label_failed = 'script_pipe_bis';
                continue           
            end

            % Debriefing #2 : did the script work ?
            fprintf('Now waiting to see if the script worked ...\nThis could take a while (in qsub/msub modes).\nPSOM is going to wait %i seconds. You can change this time using TIME_WAIT.\n',time_wait)
            time_elapsed = 0;
            while (~psom_exist(logs.exit))&&(time_elapsed<time_wait)
                pause(1)
                fprintf('.')
                time_elapsed = time_elapsed+1;
            end
            fprintf('\nThe script has completed \n')
            if psom_exist(file_test)
                fprintf('\nThe test was successful !\n');
            else 
                fprintf('\nI could not find the file the test was supposed to generate ...\n    %s\n',file_test);
                fprintf('The log of the job was:\n')
                sub_print_log(logs.txt)
                fprintf('\nThe test has failed !\n')
                test_failed = true;
                label_failed = label;
            end

        case 'psom_pipe'

            if test_failed
                continue
            end

            % Test description
            fprintf('Trying to start the pipeline manager ...\n');

            % Design and start the script
            path_xp = fullfile(path_test,label,filesep);
            psom_mkdir(path_xp);
            opt_script.mode = opt.mode_pipeline_manager;
            if ispc
                script = fullfile(path_xp,[label '.bat']);
            else
                script = fullfile(path_xp,[label '.sh']);
            end
            logs.txt   = fullfile(path_xp,[label '.log']);
            logs.eqsub = fullfile(path_xp,[label '.eqsub']);
            logs.oqsub = fullfile(path_xp,[label '.oqsub']);
            logs.exit  = fullfile(path_xp,[label '.exit']);
            file_test  = fullfile(path_xp,[label '_test.mat']);
            file_job   = fullfile(path_xp,[label '_job.mat']);
            command = sprintf('a=clock, save(''%s'',''a'');',file_test);
            save(file_job,'command');
            cmd = sprintf('psom_run_job(''%s'')',file_job);
            [flag_failed,errmsg] = psom_run_script(cmd,script,opt_script,logs);

            % Debriefing #1 : did the script start ?
            if flag_failed~=0
                if ~isempty(errmsg)
                    fprintf('\n    The test failed. The script could not be submitted ! \n The feedback was : %s\n',errmsg);
                else
                    fprintf('\n    The test failed. The script could not be submitted ! \n');
                end
                label_failed = 'script_pipe_ter';
                test_failed = true;
                continue
            end

            % Debriefing #2 : did the script work ?
            fprintf('Now waiting to see if the script worked ...\nThis could take a while (in qsub/msub modes).\nPSOM is going to wait %i seconds. You can change this time using TIME_WAIT.\n',time_wait)
            time_elapsed = 0;
            while (~psom_exist(logs.exit))&&(time_elapsed<time_wait)
                pause(1)
                fprintf('.')
                time_elapsed = time_elapsed+1;
            end
            fprintf('\nThe script has completed \n')
            if psom_exist(file_test)
                fprintf('\nThe test was successful !\n');
            else 
                fprintf('\nI could not find the file the test was supposed to generate ...\n    %s\n',file_test);
                fprintf('The log of the job was:\n')
                sub_print_log(logs.txt)
                fprintf('\nThe test has failed !\n')
                test_failed = true;
                label_failed = label;
            end

        case 'script_job'
            
            if test_failed
                continue
            end

            % Test description
            fprintf('Trying to execute a simple command through the pipeline manager...\n');

            % Design and start the script
            path_xp = fullfile(path_test,label,filesep);
            psom_mkdir(path_xp);
            opt_pipe = opt_script;
            opt_pipe.mode = opt.mode_pipeline_manager;
            opt_pipe.flag_debug = false;
            if ispc
                script_pm = fullfile(path_xp,[label '_pm.bat']);
                script_job = fullfile(path_xp,[label '.bat']);
            else
                script_pm = fullfile(path_xp,[label '_pm.sh']);
                script_job = fullfile(path_xp,[label '.sh']);
            end
            file_pipe = fullfile(path_xp,[label '_pm_result.mat']);
            file_job = fullfile(path_xp,[label '.mat']);
            opt_job = opt_script;
            opt_job.mode = opt.mode;
            logs_pm.txt   = fullfile(path_xp,[label '_pm.log']);
            logs_pm.failed = fullfile(path_xp,[label '_pm.failed']);
            logs_pm.eqsub = fullfile(path_xp,[label '_pm.eqsub']);
            logs_pm.oqsub = fullfile(path_xp,[label '_pm.oqsub']);
            logs_pm.exit  = fullfile(path_xp,[label '_pm.exit']);            
            logs.txt   = fullfile(path_xp,[label '.log']);
            logs.eqsub = fullfile(path_xp,[label '.eqsub']);
            logs.failed = fullfile(path_xp,[label '.failed']);
            logs.oqsub = fullfile(path_xp,[label '.oqsub']);
            logs.exit  = fullfile(path_xp,[label '.exit']);
            save(file_job,'script_job','logs','opt_job');
            cmd = sprintf('load(''%s''), [flag_failed,errmsg] = psom_run_script('''',script_job,opt_job,logs); save(''%s'',''flag_failed'',''errmsg'')',file_job,file_pipe); 
            [flag_failed,errmsg] = psom_run_script(cmd,script_pm,opt_pipe,logs_pm);

            if flag_failed~=0
                if ~isempty(errmsg)
                    fprintf('\n    The test failed. The pipeline manager did not start ! \n The feedback was : %s\n',errmsg);
                else
                    fprintf('\n    The test failed. The pipeline manager did not start ! \n');
                end
                test_failed = true;
                label_failed = 'script_job_pipeline';
                continue
            end

            % Debriefing #0 : did the pipeline manager start ?
            fprintf('Now waiting on the pipeline manager to start ... This could take a while (in qsub/msub modes) ...\nPSOM is going to wait %i seconds. You can change this time using TIME_WAIT.\n',time_wait)
            time_elapsed = 0;
            while (~psom_exist(file_pipe))&&(time_elapsed<time_wait)
                pause(1)
                fprintf('.')
                time_elapsed = time_elapsed+1;
            end

            if ~psom_exist(file_pipe)
                fprintf('\nI could not find the file the pipeline manager was supposed to generate ...\n    %s\n',file_pipe);
                fprintf('\nThe test has failed !\n')
                test_failed = true;
                label_failed = 'script_job_pipeline';
                continue
            end

            % Debriefing #1 : did the script start ?
            load(file_pipe)
            if flag_failed~=0
                if ~isempty(errmsg)
                    fprintf('\n    The test failed. The job script could not be submitted ! \n The feedback was : %s\n',errmsg);
                else
                    fprintf('\n    The test failed. The script could not be submitted ! There was no feedback\n');
                end
                test_failed = true;
                label_failed = label;
                continue
            else
                if ~isempty(errmsg)
                    fprintf('\n    The script was successfully submitted ... The feedback was : %s\n',errmsg);
                else
                    fprintf('\n    The script was successfully submitted ... There was no feedback\n');
                end
            end

            % Debriefing #2 : did the script work ?
            fprintf('Now waiting to see if the script submitted by the job manager worked ... This could take a while (in qsub/msub modes) ...\nPSOM is going to wait %i seconds. You can change this time using TIME_WAIT.\n',time_wait)
            time_elapsed = 0;
            while (~psom_exist(logs.exit))&&(time_elapsed<time_wait)
                pause(1)
                fprintf('.')
                time_elapsed = time_elapsed+1;
            end

            if psom_exist(logs.exit)
                fprintf('\nThe tag file %s was successfully generated !\n',logs.exit)
                fprintf('\nThe test was successful !\n') 
            else
                fprintf('\nI could not find the file the test was supposed to generate ...\n    %s\n',logs.exit);
                fprintf('The log of the job was:\n')
                sub_print_log(logs.txt)
                sub_print_log(logs.eqsub)
                sub_print_log(logs.oqsub)
                fprintf('\nThe test has failed !\n')
                test_failed = true;
                label_failed = 'script_job_submission';
            end

        case 'matlab_job'

            if test_failed
                continue
            end

            % Test description
            fprintf('Trying to execute matlab through the pipeline manager...\n');

            % Design and start the script
            path_xp = fullfile(path_test,label,filesep);
            psom_mkdir(path_xp);
            opt_pipe = opt_script;
            opt_pipe.mode = opt.mode_pipeline_manager;
            opt_pipe.flag_debug = false;
            if ispc
                script_pm = fullfile(path_xp,[label '_pm.bat']);
                script_job = fullfile(path_xp,[label '.bat']);
            else
                script_pm = fullfile(path_xp,[label '_pm.sh']);
                script_job = fullfile(path_xp,[label '.sh']);
            end
            file_pipe = fullfile(path_xp,[label '_pm_result.mat']);
            file_job = fullfile(path_xp,[label '.mat']);
            file_test = fullfile(path_xp,[label '_test.mat']); 
            opt_job = opt_script;
            opt_job.mode = opt.mode;
            opt_job.flag_debug = true;
            logs_pm.txt   = fullfile(path_xp,[label '_pm.log']);
            logs_pm.eqsub = fullfile(path_xp,[label '_pm.eqsub']);
            logs_pm.oqsub = fullfile(path_xp,[label '_pm.oqsub']);
            logs_pm.failed = fullfile(path_xp,[label '_pm.failed']);
            logs_pm.exit  = fullfile(path_xp,[label '_pm.exit']);            
            logs.txt   = fullfile(path_xp,[label '.log']);
            logs.eqsub = fullfile(path_xp,[label '.eqsub']);
            logs.oqsub = fullfile(path_xp,[label '.oqsub']);
            logs.failed = fullfile(path_xp,[label '.failed']);
            logs.exit  = fullfile(path_xp,[label '.exit']);
            cmd_job = sprintf('a = clock, save(''%s'',''a'')',file_test);
            save(file_job,'script_job','logs','opt_job','cmd_job');
            cmd = sprintf('load(''%s''), [flag_failed,errmsg] = psom_run_script(cmd_job,script_job,opt_job,logs); save(''%s'',''flag_failed'',''errmsg'')',file_job,file_pipe); 
            [flag_failed,errmsg] = psom_run_script(cmd,script_pm,opt_pipe,logs_pm);

            if flag_failed~=0
                if ~isempty(errmsg)
                    fprintf('\n    The test failed. The pipeline manager did not start ! \n The feedback was : %s\n',errmsg);
                else
                    fprintf('\n    The test failed. The pipeline manager did not start ! \n');
                end
                test_failed = true;
                label_failed = 'matlab_job_pipeline';
                continue
            end

            % Debriefing #0 : did the pipeline manager start ?
            fprintf('Now waiting on the pipeline manager to start ... This could take a while (in qsub/msub modes) ...\nPSOM is going to wait %i seconds. You can change this time using TIME_WAIT.\n',time_wait)
            time_elapsed = 0;
            while (~psom_exist(file_pipe))&&(time_elapsed<time_wait)
                pause(1)
                fprintf('.')
                time_elapsed = time_elapsed+1;
            end

            if ~psom_exist(file_pipe)
                fprintf('\nI could not find the file the pipeline manager was supposed to generate ...\n    %s\n',file_pipe);
                fprintf('\nThe test has failed !\n')
                test_failed = true;
                label_failed = 'matlab_job_pipeline';
                continue
            end

            % Debriefing #1 : did the script start ?
            load(file_pipe)
            if flag_failed~=0
                if ~isempty(errmsg)
                    fprintf('\n    The test failed. The job script could not be submitted ! \n The feedback was : %s\n',errmsg);
                else
                    fprintf('\n    The test failed. The script could not be submitted ! There was no feedback\n');
                end
                test_failed = true;
                label_failed = 'script_job_bis';
                continue
            else
                if ~isempty(errmsg)
                    fprintf('\n    The script was successfully submitted ... The feedback was : %s\n',errmsg);
                else
                    fprintf('\n    The script was successfully submitted ... There was no feedback\n');
                end
            end

            % Debriefing #2 : did the script work ?
            fprintf('Now waiting to see if the script submitted by the job manager worked ... This could take a while (in qsub/msub modes) ...\nPSOM is going to wait %i seconds. You can change this time using TIME_WAIT.\n',time_wait)
            time_elapsed = 0;
            while (~psom_exist(file_test))&&(time_elapsed<time_wait)
                pause(1)
                fprintf('.')
                time_elapsed = time_elapsed+1;
            end

            if psom_exist(file_test)
                fprintf('\nThe test file %s was successfully generated !\n',file_test)
                fprintf('\nThe test was successful !\n') 
            else
                fprintf('\nI could not find the file the test was supposed to generate ...\n    %s\n',file_test);
                fprintf('The log of the job was:\n')
                sub_print_log(logs.txt)
                sub_print_log(logs.eqsub)
                sub_print_log(logs.oqsub)
                fprintf('\nThe test has failed !\n')
                test_failed = true;
                label_failed = label;
            end

        case 'psom_job'


            if test_failed
                continue
            end

            % Test description
            fprintf('Trying to execute a simple job through the pipeline manager...\n');

            % Design and start the script
            path_xp = fullfile(path_test,label,filesep);
            psom_mkdir(path_xp);
            opt_pipe = opt_script;
            opt_pipe.mode = opt.mode_pipeline_manager;
            opt_pipe.flag_debug = false;
            if ispc
                script_pm = fullfile(path_xp,[label '_pm.bat']);
                script_job = fullfile(path_xp,[label '.bat']);
            else
                script_pm = fullfile(path_xp,[label '_pm.sh']);
                script_job = fullfile(path_xp,[label '.sh']);
            end
            file_pipe = fullfile(path_xp,[label '_pm_result.mat']);
            file_job = fullfile(path_xp,[label '.mat']);
            file_job2 = fullfile(path_xp,[label '2.mat']);
            file_test = fullfile(path_xp,[label '_test.mat']); 
            opt_job = opt_script;
            opt_job.mode = opt.mode;
            logs_pm.txt   = fullfile(path_xp,[label '_pm.log']);
            logs_pm.eqsub = fullfile(path_xp,[label '_pm.eqsub']);
            logs_pm.oqsub = fullfile(path_xp,[label '_pm.oqsub']);
            logs_pm.failed = fullfile(path_xp,[label '_pm.failed']);
            logs_pm.exit  = fullfile(path_xp,[label '_pm.exit']);            
            logs.txt   = fullfile(path_xp,[label '.log']);
            logs.eqsub = fullfile(path_xp,[label '.eqsub']);
            logs.oqsub = fullfile(path_xp,[label '.oqsub']);
            logs.failed = fullfile(path_xp,[label '.failed']);
            logs.exit  = fullfile(path_xp,[label '.exit']);
            command = sprintf('a=clock, save(''%s'',''a'');',file_test);
            save(file_job2,'command');
            cmd_job = sprintf('psom_run_job(''%s'')',file_job2);
            save(file_job,'script_job','logs','opt_job','cmd_job');
            cmd = sprintf('load(''%s''), [flag_failed,errmsg] = psom_run_script(cmd_job,script_job,opt_job,logs); save(''%s'',''flag_failed'',''errmsg'')',file_job,file_pipe); 
            [flag_failed,errmsg] = psom_run_script(cmd,script_pm,opt_pipe,logs_pm);

            if flag_failed~=0
                if ~isempty(errmsg)
                    fprintf('\n    The test failed. The pipeline manager did not start ! \n The feedback was : %s\n',errmsg);
                else
                    fprintf('\n    The test failed. The pipeline manager did not start ! \n');
                end
                test_failed = true;
                label_failed = 'psom_job_pipeline';
                continue
            end

            % Debriefing #0 : did the pipeline manager start ?
            fprintf('Now waiting on the pipeline manager to start ... This could take a while (in qsub/msub modes) ...\nPSOM is going to wait %i seconds. You can change this time using TIME_WAIT.\n',time_wait)
            time_elapsed = 0;
            while (~psom_exist(file_pipe))&&(time_elapsed<time_wait)
                pause(1)
                fprintf('.')
                time_elapsed = time_elapsed+1;
            end

            if ~psom_exist(file_pipe)
                fprintf('\nI could not find the file the pipeline manager was supposed to generate ...\n    %s\n',file_pipe);
                fprintf('\nThe test has failed !\n')
                test_failed = true;
                label_failed = 'psom_job_pipeline';
                continue
            end

            % Debriefing #1 : did the script start ?
            load(file_pipe)
            if flag_failed~=0
                if ~isempty(errmsg)
                    fprintf('\n    The test failed. The job script could not be submitted ! \n The feedback was : %s\n',errmsg);
                else
                    fprintf('\n    The test failed. The script could not be submitted ! There was no feedback\n');
                end
                test_failed = true;
                label_failed = 'script_job_ter';
                continue
            else
                if ~isempty(errmsg)
                    fprintf('\n    The script was successfully submitted ... The feedback was : %s\n',errmsg);
                else
                    fprintf('\n    The script was successfully submitted ... There was no feedback\n');
                end
            end

            % Debriefing #2 : did the script work ?
            fprintf('Now waiting to see if the script submitted by the job manager worked ... This could take a while (in qsub/msub modes) ...\nPSOM is going to wait %i seconds. You can change this time using TIME_WAIT.\n',time_wait)
            time_elapsed = 0;
            while (~psom_exist(file_test))&&(time_elapsed<time_wait)
                pause(1)
                fprintf('.')
                time_elapsed = time_elapsed+1;
            end

            if psom_exist(file_test)
                fprintf('\nThe test file %s was successfully generated !\n',file_test)
                fprintf('\nThe test was successful !\n') 
            else
                fprintf('\nI could not find the file the test was supposed to generate ...\n    %s\n',file_test);
                fprintf('The log of the job was:\n')
                sub_print_log(logs.txt)
                sub_print_log(logs.eqsub)
                sub_print_log(logs.oqsub)
                fprintf('\nThe test has failed !\n')
                test_failed = true;
                label_failed = label;
            end

        otherwise
            error('Sorry, %s is not a known test',label)
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate an overall status (pass/failed) and some context-specific directions to solve an issue if a test has failed %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~test_failed
    msg = sprintf('All tests were successfully completed !');
    stars = repmat('*',[1 length(msg)]);
    fprintf('\n%s\n%s\n%s\n\n',stars,msg,stars);    
    fprintf('PSOM will be able to run pipelines ... enjoy !\n')
    fprintf('If some configuration options were manually specified, consider editing PSOM_GB_VARS_LOCAL to turn those changes into defaults.\n')
    fprintf('Go to http://code.google.com/p/psom/wiki/ConfigurationPsom for more info.\n')
    fprintf('Please note that a number of potential issues can still compromise the stability of PSOM:\n')
    fprintf('   * A limitation on the number of concurrent matlab sessions due to the number of available licenses.\n')
    fprintf('   * Job failure due to an interruption of service (e.g. if the execution server is turned off or crashes while the job is running).\n')
    fprintf('   * Job failure due to insufficient resources (e.g. out of memory, out of disk space).\n')
    fprintf('   * An execution server with a different configuration than the one tested here. The tests are only valid for employed execution servers.\n')

else
    msg = sprintf('The test failed !');
    stars = repmat('*',[1 length(msg)]);
    fprintf('\n%s\n%s\n%s\n\n',stars,msg,stars);
    fprintf('The test that failed was "%s":\n',label_failed);
    switch label_failed

        case {'script_pipe','script_job'}
            if strcmp(label_failed,'script_job')
                mode = opt.mode;
            else
                mode = opt.mode_pipeline_manager;
            end
            fprintf('PSOM was not able to execute a simple command in a script using a "%s" execution mode.\n',mode);
            if strcmp(label_failed,'script_job')
                fprintf('This occured as the script was submitted by the pipeline manager.\nNote that the session of the pipeline manager may be different of the current session.\n')
            end
            switch mode
                case 'background'
                   fprintf('PSOM is using the dot command (.) in a system call to execute the script.\n')
                   fprintf('This method is thought to be robust and should not fail on most systems.\n')  
                case 'batch'
                   if ispc
                       fprintf('PSOM is using the "start" command in a system call to execute the script.\n')
                   else
                       fprintf('PSOM is using the "at" command in a system call to execute the script.\n')
                   end
                   fprintf('Check that this command is available on your system.\n');
                   fprintf('If it is not, then this mode is not available.\n');
                case {'qsub','msub'}
                   fprintf('PSOM is using the "%s" command in a system call to execute the script.\n',upper(mode))
                   fprintf('Check that this command is available on your system. If it is not, then this mode is not available either.\n');       
                   fprintf('If you want to use this execution mode, please contact your system administrator.\n')            
                   fprintf('The options passed to %s may also be inappropriate. The selected options were (OPT.QSUB_OPTIONS):\n%s\n',upper(mode),opt.qsub_options)                   
            end
            fprintf('One of the possible causes of the problem may be the options used at the begining of the script. These options were (OPT.SHELL_OPTIONS):\n%s\n',opt.shell_options)
            
        case {'script_pipe_submission','script_job_submission'}

            if strcmp(label_failed,'script_job')
                mode = opt.mode;
            else
                mode = opt.mode_pipeline_manager;
            end
            fprintf('PSOM was not able to execute a simple command in a script using a "%s" execution mode.\n',mode);
            if strcmp(label_failed,'script_job_submission')
                fprintf('This occured as the script was submitted by the pipeline manager.\nNote that the session of the pipeline manager may be different of the current session.\n')
            end
            
            if ispc
                fprintf('This script is redirecting (>) an echo to a tag file to show that the script was completed.\n')
            else
                fprintf('This script is using a "touch" command on a tag file to show that the script was completed.\n')
            end       
            switch mode
                case 'background'
                   fprintf('PSOM is using the dot command (.) in a system call to execute the script.\n')
                   fprintf('This method is thought to be robust and should not fail on most systems.\n')
                case 'batch'
                   if ispc
                       fprintf('PSOM is using the "start" command in a system call to execute the script.\n')
                       fprintf('This method is thought to be robust and should not fail on most systems.\n')
                   else
                       fprintf('PSOM is using the "at" command in a system call to execute the script.\n')
                       fprintf('On some systems (MAC OSX, CentOS), the "at" command is not available to regular users, or it is available but will never actually execute the jobs\n');
                       fprintf('If you still want to use this execution mode, please contact your administration system.\n')
                   end                                      
                case {'qsub','msub'}
                   fprintf('PSOM is using the "%s" command in a system call to execute the script.\n',mode)
                   fprintf('Check that this command is available on your system. If it is not, then this mode is simply not available.\n');  
                   fprintf('If you still want to use this execution mode, please contact your administration system.\n')
                   fprintf('The options passed to %s may also be inappropriate. The selected options were (OPT.QSUB_OPTIONS):\n%s\n',upper(opt.mode_pipeline_manager),opt.qsub_options)
            end
            fprintf('One of the possible causes of the problem may be the options used at the begining of the script. These options were (OPT.SHELL_OPTIONS):\n%s\n',opt.shell_options)

        case {'matlab_pipe','matlab_job'}
            if strcmp(label_failed,'matlab_job')
                mode = opt.mode;
            else
                mode = opt.mode_pipeline_manager;
            end
            fprintf('PSOM was not able to execute a simple command in %s using a script and a "%s" execution mode.\n',upper(gb_psom_language),mode);
            if strcmp(label_failed,'matlab_job')
                fprintf('This occured as the script was submitted by the pipeline manager.\nNote that the session of the pipeline manager may be different of the current session.\n')
            end
            fprintf('The first possible cause is that the command used to invoke %s did not work.\n',upper(gb_psom_language));
            fprintf('This command was (OPT.COMMAND_MATLAB): %s\n',opt.command_matlab);            
            fprintf('Some commands can be executed at the begining of the %s session and could cause (or fix) the problem.\n',upper(gb_psom_language))
            fprintf('These commands were (OPT.INIT_MATLAB): %s\n',opt.init_matlab);
            fprintf('Another possible issue is that the specified %s search path crashed %s\n',upper(gb_psom_language),upper(gb_psom_language));
            fprintf('This will often happen if the version (or installation location) of %s as invoked by PSOM is different of the one you are currently using.\n',upper(gb_psom_language));            
            fprintf('The search path used in this test (OPT.PATH_SEARCH) was:');
            if isempty(opt.path_search)
                fprintf(' Search path of the current session (OPT.PATH_SEARCH = '''')\n')
            elseif strcmp(opt.path_search,'gb_niak_omitted')||strcmp(opt.path_search,'gb_psom_omitted')
                fprintf(' The default search path at start-up\n    (OPT.PATH_SEARCH = ''gb_psom_omitted'')\n')
            else
                fprintf(' %s\n    (the output may have been truncated, see the output OPT.PATH_SEARCH)\n',opt.path_search)
            end
            
        case {'psom_pipe','psom_job'}
            if strcmp(label_failed,'psom_job')
                mode = opt.mode;
            else
                mode = opt.mode_pipeline_manager;
            end
            fprintf('PSOM was not able to execute a PSOM job in %s using a script and a "%s" execution mode.\n',upper(gb_psom_language),mode);
            if strcmp(label_failed,'psom_job')
                fprintf('This occured as the script was submitted by the pipeline manager.\nNote that the session of the pipeline manager may be different of the current session.\n')
            end
            fprintf('Some commands can be executed at the begining of the %s session and could cause (or fix) the problem.\n',upper(gb_psom_language))
            fprintf('These commands were (OPT.INIT_MATLAB): %s\n',opt.init_matlab);            
            fprintf('A likely cause of the problem is that the specified %s search path did not include the PSOM tools\n',upper(gb_psom_language));                        
            fprintf('The search path used in this test (OPT.PATH_SEARCH) was:');
            if isempty(opt.path_search)
                fprintf(' Search path of the current session (OPT.PATH_SEARCH = '''')\n')
            elseif strcmp(opt.path_search,'gb_niak_omitted')||strcmp(opt.path_search,'gb_psom_omitted')
                fprintf(' The default search path at start-up\n    (OPT.PATH_SEARCH = ''gb_psom_omitted'')\n')
            else
                fprintf(' %s\n    (the output may have been truncated, see the output OPT.PATH_SEARCH)\n',opt.path_search)
            end

        case 'script_pipe_bis'

            fprintf('The "matlab_pipe" test failed at a point which was already (succesfully) tested by the "script_pipe" test.')
            fprintf('This should not happen. Unfortunately, there is not a common fix to this problem.')

        case 'script_job_bis'

            fprintf('The "matlab_job" test failed at a point which was already (succesfully) tested by the "script_job" test.')
            fprintf('This should not happen. Unfortunately, there is not a common fix to this problem.')

        case 'script_pipe_ter'

            fprintf('The "psom_pipe" test failed at a point which was already (succesfully) tested by the "script_pipe" test.')
            fprintf('This should not happen. Unfortunately, there is not a common fix to this problem.')

        case 'script_job_ter'

            fprintf('The "psom_job" test failed at a point which was already (succesfully) tested by the "script_pipe" test.')
            fprintf('This should not happen. Unfortunately, there is not a common fix to this problem.')

        case 'script_job_pipeline'

            fprintf('The "script_job" test failed at a point which was already (succesfully) tested by the "psom_pipe" test.\n')
            fprintf('This should not happen. Unfortunately, there is not a common fix to this problem.\n')

        case 'matlab_job_pipeline'

            fprintf('The "matlab_job" test failed at a point which was already (succesfully) tested by the "script_job" test.\n')
            fprintf('This should not happen. Unfortunately, there is not a common fix to this problem.\n')

        case 'psom_job_pipeline'

            fprintf('The "psom_job" test failed at a point which was already (succesfully) tested by the "matlab_job" test.\n')
            fprintf('This should not happen. Unfortunately, there is not a common fix to this problem.\n')
            
    end
    fprintf('Note that this text only contains general directions which usually help to solve your particular issue.\nThe detailed logs above may however point more specifically to the source of the problem.\n')
    fprintf('If you cannot find a solution, or if the directions provided by this test were not relevant to your problem,\nplease help improving PSOM by reporting this issue (along with a copy of the test) to www.nitrc.org/forum/forum.php?forum_id=1316\n')
end

%%%% SUBFUNCTIONS %%%%
function [] = sub_print_log(file_log)

if psom_exist(file_log)
    hf = fopen(file_log,'r');
    str_read = fread(hf, Inf , 'uint8=>char')';
    fclose(hf);
    fprintf(str_read)
end
