function [] = psom_pipeline_process(file_pipeline,opt)
% Process a pipeline that has previously been initialized.
%
% SYNTAX:
% [] = PSOM_PIPELINE_PROCESS(FILE_PIPELINE,OPT)
%
% _________________________________________________________________________
% INPUTS:
%
% FILE_PIPELINE
%    (string) The file name of a .MAT file generated using
%    PSOM_PIPELINE_INIT.
%
% OPT
%    (structure) with the following fields :
%
%    MODE
%        (string, default 'session') how to execute the jobs :
%        'session'    : current Matlab session.
%        'background' : background execution, non-unlogin-proofed 
%                       (asynchronous system call).
%        'batch'      : background execution, unlogin-proofed ('at' in 
%                       UNIX, start in WINDOWS.
%        'qsub'       : remote execution using qsub (torque, SGE, PBS).
%        'msub'       : remote execution using msub (MOAB)
%        'condor'     : remote execution using condor
%
%    MODE_PIPELINE_MANAGER
%        (string, default same as OPT.MODE) same as OPT.MODE, but
%        applies to the pipeline manager itself rather than the jobs.
%
%    MAX_QUEUED
%        (integer, default 1 'batch' modes, Inf in 'session', 'qsub',
%        'msub' and 'condor' modes)
%        The maximum number of jobs that can be processed
%        simultaneously. Some qsub systems actually put restrictions
%        on that. Contact your local system administrator for more info.
%
%    NB_RESUB
%        (integer, default 0 in 'session', 'batch' and 'background' modes,
%        1 otherwise) The number of times a job will be resubmitted if it 
%        fails.
%
%    SHELL_OPTIONS
%        (string, default GB_PSOM_SHELL_OPTIONS defined in PSOM_GB_VARS)
%        some commands that will be added at the begining of the shell
%        script submitted to batch or qsub. This can be used to set
%        important variables, or source an initialization script.
%
%    QSUB_OPTIONS
%        (string, GB_PSOM_QSUB_OPTIONS defined in PSOM_GB_VARS)
%        This field can be used to pass any argument when submitting a
%        job with qsub/msub. For example, '-q all.q@yeatman,all.q@zeus'
%        will force qsub/msub to only use the yeatman and zeus
%        workstations in the all.q queue. It can also be used to put
%        restrictions on the minimum avalaible memory, etc.
%
%    COMMAND_MATLAB
%        (string, default GB_PSOM_COMMAND_MATLAB or
%        GB_PSOM_COMMAND_OCTAVE depending on the current environment)
%        how to invoke matlab (or OCTAVE).
%        You may want to update that to add the full path of the command.
%        The defaut for this field can be set using the variable
%        GB_PSOM_COMMAND_MATLAB/OCTAVE in the file PSOM_GB_VARS.
%
%    INIT_MATLAB
%        (string, default '') a matlab command (multiple commands can
%        actually be passed using comma separation) that will be
%        executed at the begining of any matlab job. That mechanism can
%        be used, e.g., to set up the state of the random generation
%        number.
%
%    TIME_BETWEEN_CHECKS
%        (real value, default 0 in 'session' mode, 10 otherwise)
%        The time (in seconds) where the pipeline processing remains
%        inactive to wait for jobs to complete before attempting to
%        submit new jobs.
%
%    TIME_COOL_DOWN
%        (real value, default 2 in 'qsub', 'msub' and 'condor' modes, 
%        0 otherwise)
%        A small pause time between evaluation of status and flushing of
%        tags. This is to let qsub the time to write the output/error
%        log files.
%
%    NB_CHECKS_PER_POINT
%        (integer,default 6) After NB_CHECKS_PER_POINT successive checks
%        where the pipeline processor did not find anything to do, it
%        will issue a '.' verbose to show it is not dead.
%
%    FLAG_DEBUG
%        (boolean, default false) if FLAG_DEBUG is true, the program
%        prints additional information for debugging purposes.
%
%    FLAG_SHORT_JOB_NAMES
%        (boolean, default true) only the 8 first characters of a job 
%        name are used to submit to qsub/msub. Most qsub systems truncate
%        the name of the job anyway, and some systems even refuse to
%        submit jobs with long names.
%
%    FLAG_VERBOSE
%        (boolean, default true) if the flag is true, then the function 
%        prints some infos during the processing.
%
% _________________________________________________________________________
% OUTPUTS:
%
% _________________________________________________________________________
% SEE ALSO:
% PSOM_PIPELINE_INIT, PSOM_PIPELINE_VISU, PSOM_DEMO_PIPELINE,
% PSOM_RUN_PIPELINE.
%
% _________________________________________________________________________
% COMMENTS:
%
% Empty file names, or file names equal to 'gb_niak_omitted' are ignored
% when building the dependency graph between jobs.
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

psom_gb_vars

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setting up default values for inputs %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SYNTAX
if ~exist('file_pipeline','var')
    error('SYNTAX: [] = PSOM_PIPELINE_PROCESS(FILE_PIPELINE,OPT). Type ''help psom_pipeline_manage'' for more info.')
end

%% Options
gb_name_structure = 'opt';
gb_list_fields    = { 'flag_short_job_names' , 'nb_resub'       , 'flag_verbose' , 'init_matlab'       , 'flag_debug' , 'shell_options'       , 'command_matlab' , 'mode'    , 'mode_pipeline_manager' , 'max_queued' , 'qsub_options'       , 'time_between_checks' , 'nb_checks_per_point' , 'time_cool_down' };
gb_list_defaults  = { true                   , gb_psom_nb_resub , true           , gb_psom_init_matlab , true         , gb_psom_shell_options , ''               , 'session' , ''                      , 0            , gb_psom_qsub_options , []                    , []                    , []               };
psom_set_defaults

flag_verbose = flag_verbose || flag_debug;

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

if isempty(opt.nb_resub)
    switch opt.mode
        case {'session','batch','background'}
            opt.nb_resub = 0;
            nb_resub = 0;
        otherwise
            opt.nb_resub = 1;
            nb_resub = 1;
    end % switch action
end % default of max_queued

if max_queued == 0
    switch opt.mode
        case {'batch','background'}
            opt.max_queued = 1;
            max_queued = 1;
        case {'session','qsub','msub','condor'}
            opt.max_queued = Inf;
            max_queued = Inf;
    end % switch action
end % default of max_queued

%% Test the the requested mode of execution of jobs exists
if ~ismember(opt.mode,{'session','batch','background','qsub','msub','condor'})
    error('%s is an unknown mode of pipeline execution. Sorry dude, I must quit ...',opt.mode);
end

switch opt.mode
    case 'session'
        if isempty(time_between_checks)
            opt.time_between_checks = 0;
            time_between_checks = 0;
        end
        if isempty(nb_checks_per_point)
            opt.nb_checks_per_point = Inf;
            nb_checks_per_point = Inf;
        end
        if isempty(time_cool_down)
            opt.time_cool_down = 0;
            time_cool_down = 0;
        end
    case {'batch','background'}
        if isempty(time_between_checks)
            opt.time_between_checks = 10;
            time_between_checks = 10;
        end
        if isempty(nb_checks_per_point)
            opt.nb_checks_per_point = 6;
            nb_checks_per_point = 6;
        end
        if isempty(time_cool_down)
            opt.time_cool_down = 0;
            time_cool_down = 0;
        end
    case {'qsub','msub','condor'}
        if isempty(time_between_checks)
            opt.time_between_checks = 10;
            time_between_checks = 10;
        end
        if isempty(nb_checks_per_point)
            opt.nb_checks_per_point = 6;
            nb_checks_per_point = 6;
        end
        if isempty(time_cool_down)
            opt.time_cool_down = 2;
            time_cool_down = 2;
        end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize variables  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Generic messages
hat_qsub_o = sprintf('\n\n*****************\nOUTPUT QSUB\n*****************\n');
hat_qsub_e = sprintf('\n\n*****************\nERROR QSUB\n*****************\n');

%% Generating file names
[path_logs,name_pipeline,ext_pl] = fileparts(file_pipeline);
file_pipe_running   = [ path_logs filesep name_pipeline '.lock'               ];
file_pipe_log       = [ path_logs filesep name_pipeline '_history.txt'        ];
file_news_feed      = [ path_logs filesep name_pipeline '_news_feed.csv'        ];
file_manager_opt    = [ path_logs filesep name_pipeline '_manager_opt.mat'    ];
file_logs           = [ path_logs filesep name_pipeline '_logs.mat'           ];
file_logs_backup    = [ path_logs filesep name_pipeline '_logs_backup.mat'    ];
file_status         = [ path_logs filesep name_pipeline '_status.mat'         ];
file_status_backup  = [ path_logs filesep name_pipeline '_status_backup.mat'  ];
file_jobs           = [ path_logs filesep name_pipeline '_jobs.mat'           ];
file_profile        = [ path_logs filesep name_pipeline '_profile.mat'        ];
file_profile_backup = [ path_logs filesep name_pipeline '_profile_status.mat' ];

logs    = load( file_logs    );
status  = load( file_status  );
profile = load( file_profile );

%% If necessary, create a temporary subfolder in the "logs" folder
path_tmp = [path_logs filesep 'tmp'];
if exist(path_tmp,'dir')
    delete([path_tmp '*']);
else
    mkdir(path_tmp);
end

%% Check for the existence of the pipeline
if ~exist(file_pipeline,'file') % Does the pipeline exist ?
    error('Could not find the pipeline file %s. You first need to initialize the pipeline using PSOM_PIPELINE_INIT !',file_pipeline);
end

%% Create a running tag on the pipeline (if not done during the initialization phase)
if ~psom_exist(file_pipe_running)
    str_now = datestr(clock);
    save(file_pipe_running,'str_now');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% If specified, start the pipeline manager in the background %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ismember(opt.mode_pipeline_manager,{'batch','background','qsub','msub','condor'})
    
    % save the options of the pipeline manager
    opt.mode_pipeline_manager = 'session';
    save(file_manager_opt,'opt');
    
    if flag_verbose
        fprintf('Starting the pipeline manager (%s mode) ...\n',mode_pipeline_manager)
    end
           
    cmd = sprintf('load(''%s''), psom_pipeline_process(''%s'',opt)',file_manager_opt,file_pipeline);
    opt_script.name_job       = 'PSOM_manager';
    opt_script.mode           = mode_pipeline_manager;
    opt_script.init_matlab    = opt.init_matlab;
    opt_script.flag_debug     = opt.flag_debug;        
    opt_script.shell_options  = opt.shell_options;
    opt_script.command_matlab = opt.command_matlab;
    opt_script.qsub_options   = opt.qsub_options;
    opt_script.path_search    = file_pipeline;
    if ispc
        file_shell = [path_tmp filesep 'pipeline_manager.bat'];
    else
        file_shell = [path_tmp filesep 'pipeline_manager.sh'];
    end
    [flag_failed,errmsg] = psom_run_script(cmd,file_shell,opt_script);
    if flag_failed~=0
        if ispc
            % This is windows
            error('Something went bad when sending the pipeline in the background. The error message was : %s',errmsg)
        else
            error('Something went bad when sending the pipeline in the background. The error message was : %s',errmsg)
        end
    end        
    return
    
end

% a try/catch block is used to clean temporary file if the user is
% interrupting the pipeline of if an error occurs
try    
    
    %% open the log file
    if strcmp(gb_psom_language,'matlab');
        hfpl = fopen(file_pipe_log,'a');
    else
        hfpl = file_pipe_log;
    end
    
    %% Open the news feed file
    if strcmp(gb_psom_language,'matlab');
        hfnf = fopen(file_news_feed,'w');
    else
        hfnf = file_news_feed;
    end
   
    %% Print general info about the pipeline
    msg_line1 = sprintf('The pipeline %s is now being processed.',name_pipeline);
    msg_line2 = sprintf('Started on %s',datestr(clock));
    msg_line3 = sprintf('user: %s, host: %s, system: %s',gb_psom_user,gb_psom_localhost,gb_psom_OS);
    size_msg = max([size(msg_line1,2),size(msg_line2,2),size(msg_line3,2)]);
    msg = sprintf('%s\n%s\n%s',msg_line1,msg_line2,msg_line3);
    stars = repmat('*',[1 size_msg]);    
    sub_add_line_log(hfpl,sprintf('\n%s\n%s\n%s\n',stars,msg,stars),flag_verbose);
    
    %% Load the pipeline
    load(file_pipeline,'list_jobs','graph_deps','files_in');                
    
    %% Update dependencies
    mask_finished = false([length(list_jobs) 1]);
    for num_j = 1:length(list_jobs)
        mask_finished(num_j) = strcmp(status.(list_jobs{num_j}),'finished');
    end
    graph_deps(mask_finished,:) = 0;
    mask_deps = max(graph_deps,[],1)>0;
    mask_deps = mask_deps(:);
    
    %% Track number of submissions
    nb_sub = zeros([length(list_jobs) 1]);

    %% Initialize the to-do list
    mask_todo = false([length(list_jobs) 1]);
    for num_j = 1:length(list_jobs)
        mask_todo(num_j) = strcmp(status.(list_jobs{num_j}),'none');
        if ~mask_todo(num_j)
            sub_add_line_log(hfnf,sprintf('%s , finished\n',list_jobs{num_j}),false);
        end
    end    
    mask_done = ~mask_todo;
    
    mask_failed = false([length(list_jobs) 1]);
    for num_j = 1:length(list_jobs)
        mask_failed(num_j) = strcmp(status.(list_jobs{num_j}),'failed');
        if mask_failed(num_j)
            sub_add_line_log(hfnf,sprintf('%s , failed\n',list_jobs{num_j}),false);
        end
    end    
    list_num_failed = find(mask_failed);
    list_num_failed = list_num_failed(:)';
    for num_j = list_num_failed
        mask_child = false([1 length(mask_todo)]);
        mask_child(num_j) = true;
        mask_child = sub_find_children(mask_child,graph_deps);
        mask_todo(mask_child) = false; % Remove the children of the failed job from the to-do list
    end
    
    mask_running = false(size(mask_done));
    
    %% Initialize miscallenaous variables
    nb_queued   = 0;                   % Number of queued jobs
    nb_todo     = sum(mask_todo);      % Number of to-do jobs
    nb_finished = sum(mask_finished);  % Number of finished jobs
    nb_failed   = sum(mask_failed);    % Number of failed jobs
    nb_checks   = 0;                   % Number of checks to print a points
    nb_points   = 0;                   % Number of printed points
    
    lmax = 0;
    for num_j = 1:length(list_jobs)
        lmax = max(lmax,length(list_jobs{num_j}));
    end   
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% The pipeline manager really starts here %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    while (any(mask_todo) || any(mask_running)) && psom_exist(file_pipe_running)

        %% Update logs & status
        save(file_logs           ,'-struct','logs');
        copyfile(file_logs,file_logs_backup,'f');        
        save(file_status         ,'-struct','status');
        copyfile(file_status,file_status_backup,'f');
        save(file_profile        ,'-struct','profile');
        copyfile(file_profile,file_profile_backup,'f');
        flag_nothing_happened = true;
        
        %% Update the status of running jobs
        list_num_running = find(mask_running);
        list_num_running = list_num_running(:)';
        list_jobs_running = list_jobs(list_num_running);
        new_status_running_jobs = psom_job_status(path_logs,list_jobs_running,opt.mode);        
        pause(time_cool_down); % pause for a while to let the system finish to write eqsub and oqsub files (useful in 'qsub' mode).
        
        %% Loop over running jobs to check the new status
        num_l = 0;
        for num_j = list_num_running
            num_l = num_l+1;
            name_job = list_jobs{num_j};
            flag_changed = ~strcmp(status.(name_job),new_status_running_jobs{num_l});
            
            if flag_changed
                
                if flag_nothing_happened % if nothing happened before...
                    %% Reset the 'dot counter'
                    flag_nothing_happened = false;
                    nb_checks = 0;
                    if nb_points>0
                        sub_add_line_log(hfpl,sprintf('\n'),flag_verbose);
                    end
                    nb_points = 0;
                end
                
                % update status of the job in the status file                
                status.(name_job) = new_status_running_jobs{num_l};
                
                if strcmp(status.(name_job),'exit') % the script crashed ('exit' tag)
                    sub_add_line_log(hfpl,sprintf('%s - The script of job %s terminated without generating any tag, I guess we will count that one as failed.\n',datestr(clock),name_job),flag_verbose);;
                    status.(name_job) = 'failed';
                    nb_failed = nb_failed + 1;
                end
                
                if strcmp(status.(name_job),'failed')||strcmp(status.(name_job),'finished')
                    %% for finished or failed jobs, transfer the individual
                    %% test log files to the matlab global logs structure
                    nb_queued = nb_queued - 1;
                    text_log    = sub_read_txt([path_logs filesep name_job '.log']);
                    text_qsub_o = sub_read_txt([path_logs filesep name_job '.oqsub']);
                    text_qsub_e = sub_read_txt([path_logs filesep name_job '.eqsub']);                    
                    if isempty(text_qsub_o)&&isempty(text_qsub_e)
                        logs.(name_job) = text_log;                        
                    else
                        logs.(name_job) = [text_log hat_qsub_o text_qsub_o hat_qsub_e text_qsub_e];
                    end
                    %% Update profile for the jobs
                    file_profile_job = [path_logs filesep name_job '.profile.mat'];
                    if psom_exist(file_profile_job)
                        profile.(name_job) = load(file_profile_job);
                    end
                    profile.(name_job).nb_submit = nb_sub(num_j);
                    sub_clean_job(path_logs,name_job); % clean up all tags & log                    
                end
                
                switch status.(name_job)
                    
                    case 'failed' % the job has failed, too bad !

                        if nb_sub(num_j) > nb_resub % Enough attempts to submit the jobs have been made, it failed !
                            nb_failed = nb_failed + 1;   
                            msg = sprintf('%s %s%s failed   ',datestr(clock),name_job,repmat(' ',[1 lmax-length(name_job)]));
                            sub_add_line_log(hfpl,sprintf('%s (%i run / %i fail / %i done / %i left)\n',msg,nb_queued,nb_failed,nb_finished,nb_todo),flag_verbose);
                            sub_add_line_log(hfnf,sprintf('%s , failed\n',name_job),false);
                            mask_child = false([1 length(mask_todo)]);
                            mask_child(num_j) = true;
                            mask_child = sub_find_children(mask_child,graph_deps);
                            mask_todo(mask_child) = false; % Remove the children of the failed job from the to-do list
                        else % Try to submit the job one more time (at least)
                            mask_todo(num_j) = true;
                            status.(name_job) = 'none';
                            new_status_running_jobs{num_l} = 'none';
                            nb_todo = nb_todo+1;
                            msg = sprintf('%s %s%s reset    ',datestr(clock),name_job,repmat(' ',[1 lmax-length(name_job)]));
                            sub_add_line_log(hfpl,sprintf('%s (%i run / %i fail / %i done / %i left)\n',msg,nb_queued,nb_failed,nb_finished,nb_todo),flag_verbose);
                        end

                    case 'finished'

                        nb_finished = nb_finished + 1;                        
                        msg = sprintf('%s %s%s completed',datestr(clock),name_job,repmat(' ',[1 lmax-length(name_job)]));
                        sub_add_line_log(hfpl,sprintf('%s (%i run / %i fail / %i done / %i left)\n',msg,nb_queued,nb_failed,nb_finished,nb_todo),flag_verbose);
                        sub_add_line_log(hfnf,sprintf('%s , finished\n',name_job),false);
                        graph_deps(num_j,:) = 0; % update dependencies

                end
                
            end % if flag changed
        end % loop over running jobs
        
        if ~flag_nothing_happened % if something happened ...
            
            %% update the to-do list
            mask_done(mask_running) = ismember(new_status_running_jobs,{'finished','failed','exit'});
            mask_todo(mask_running) = mask_todo(mask_running)&~mask_done(mask_running);
            
            %% Update the dependency mask
            mask_deps = max(graph_deps,[],1)>0;
            mask_deps = mask_deps(:);
            
            %% Finally update the list of currently running jobs
            mask_running(mask_running) = mask_running(mask_running)&~mask_done(mask_running);
            
        end
        
        %% Time to (try to) submit jobs !!
        list_num_to_run = find(mask_todo&~mask_deps);
        num_jr = 1;
        
        while (nb_queued < max_queued) && (num_jr <= length(list_num_to_run))
            
            if flag_nothing_happened % if nothing happened before...
                %% Reset the 'dot counter'
                flag_nothing_happened = false;
                nb_checks = 0;
                if nb_points>0                    
                    sub_add_line_log(hfpl,sprintf('\n'),flag_verbose);
                end
                nb_points = 0;
            end
            
            %% Pick up a job to run
            num_job = list_num_to_run(num_jr);
            num_jr = num_jr + 1;
            name_job = list_jobs{num_job};
            
            mask_todo(num_job) = false;
            mask_running(num_job) = true;
            nb_queued = nb_queued + 1;
            nb_todo = nb_todo - 1;
            nb_sub(num_job) = nb_sub(num_job)+1;
            status.(name_job) = 'submitted';
            msg = sprintf('%s %s%s submitted',datestr(clock),name_job,repmat(' ',[1 lmax-length(name_job)]));            
            sub_add_line_log(hfpl,sprintf('%s (%i run / %i fail / %i done / %i left)\n',msg,nb_queued,nb_failed,nb_finished,nb_todo),flag_verbose);
            sub_add_line_log(hfnf,sprintf('%s , submitted\n',name_job),false);
            
            %% Execute the job in a "shelled" environment
            file_job        = [path_logs filesep name_job '.mat'];
            opt_logs.txt    = [path_logs filesep name_job '.log'];
            opt_logs.eqsub  = [path_logs filesep name_job '.eqsub'];
            opt_logs.oqsub  = [path_logs filesep name_job '.oqsub'];
            opt_logs.failed = [path_logs filesep name_job '.failed'];
            opt_logs.exit   = [path_logs filesep name_job '.exit'];
            opt_script.path_search    = file_pipeline;
            opt_script.name_job       = name_job;
            opt_script.mode           = opt.mode;
            opt_script.init_matlab    = opt.init_matlab;
            opt_script.flag_debug     = opt.flag_debug;        
            opt_script.shell_options  = opt.shell_options;
            opt_script.command_matlab = opt.command_matlab;
            opt_script.qsub_options   = opt.qsub_options;
            opt_script.flag_short_job_names = opt.flag_short_job_names;
            opt_script.file_handle    = hfpl;
            cmd = sprintf('psom_run_job(''%s'')',file_job);
                
            if ispc % this is windows
                script = [path_tmp filesep name_job '.bat'];
            else
                script = [path_tmp filesep name_job '.sh'];
            end
                
            [flag_failed,errmsg] = psom_run_script(cmd,script,opt_script,opt_logs);
            if flag_failed~=0
                msg = fprintf('\n    The execution of the job %s failed.\n The feedback was : %s\n',name_job,errmsg);
                sub_add_line_log(hfpl,msg,true);
                error('Something went bad with the execution of the job.')
            elseif flag_debug
                msg = fprintf('\n    The feedback from the execution of job %s was : %s\n',name_job,errmsg);
                sub_add_line_log(hfpl,msg,true);
            end            
        end % submit jobs
        
        if (any(mask_todo) || any(mask_running)) && psom_exist(file_pipe_running)
            pause(time_between_checks); % To avoid wasting resources, wait a bit before re-trying to submit jobs
        end
        
        if strcmp(gb_psom_language,'octave') && ismember(opt.mode,{'qsub','msub','condor'})
            % In octave, due to the way asynchronous processes work, it is necessary to listen to children to kill 
            % zombies
            tmp = 1;
            while tmp ~= -1
                tmp = waitpid(-1);
            end
        end
        
        if nb_checks >= nb_checks_per_point
            nb_checks = 0;
            if flag_verbose
                fprintf('.');
            end
            sub_add_line_log(hfpl,sprintf('.'),flag_verbose);
            nb_points = nb_points+1;
        else
            nb_checks = nb_checks+1;
        end
        
    end % While there are jobs to do
    
catch
    
    errmsg = lasterror;        
    sub_add_line_log(hfpl,sprintf('\n\n******************\nSomething went bad ... the pipeline has FAILED !\nThe last error message occured was :\n%s\n',errmsg.message),flag_verbose);
    if isfield(errmsg,'stack')
        for num_e = 1:length(errmsg.stack)
            sub_add_line_log(hfpl,sprintf('File %s at line %i\n',errmsg.stack(num_e).file,errmsg.stack(num_e).line),flag_verbose);
        end
    end
    if exist('file_pipe_running','var')
        if exist(file_pipe_running,'file')
            delete(file_pipe_running); % remove the 'running' tag
        end
    end
    
    %% Close the log file
    if strcmp(gb_psom_language,'matlab')
        fclose(hfpl);
        fclose(hfnf);
    end
    return
end

%% Update the final status
save(file_logs           ,'-struct','logs');
copyfile(file_logs,file_logs_backup,'f');
save(file_status         ,'-struct','status');
copyfile(file_status,file_status_backup,'f');
save(file_profile        ,'-struct','profile');
copyfile(file_profile,file_profile_backup,'f');

%% Print general info about the pipeline
msg_line1 = sprintf('The processing of the pipeline is terminated.');
msg_line2 = sprintf('See report below for job completion status.');
msg_line3 = sprintf('%s',datestr(now));
size_msg = max([size(msg_line1,2),size(msg_line2,2)]);
msg = sprintf('%s\n%s\n%s',msg_line1,msg_line2,msg_line3);
stars = repmat('*',[1 size_msg]);
sub_add_line_log(hfpl,sprintf('\n%s\n%s\n%s\n',stars,msg,stars),flag_verbose);

%% Report if the lock file was manually removed
if exist('file_pipe_running','var')
    if ~exist(file_pipe_running,'file')        
        sub_add_line_log(hfpl,sprintf('The pipeline manager was interrupted because the .lock file was manually deleted.\n'),flag_verbose);
    end    
end

%% Print a list of failed jobs
mask_failed = false([length(list_jobs) 1]);
for num_j = 1:length(list_jobs)
    mask_failed(num_j) = strcmp(status.(list_jobs{num_j}),'failed');
end
mask_todo = false([length(list_jobs) 1]);
for num_j = 1:length(list_jobs)
    mask_todo(num_j) = strcmp(status.(list_jobs{num_j}),'none');
end
list_num_failed = find(mask_failed);
list_num_failed = list_num_failed(:)';
list_num_none = find(mask_todo);
list_num_none = list_num_none(:)';
flag_any_fail = ~isempty(list_num_failed);

if flag_any_fail
    if length(list_num_failed) == 1
        sub_add_line_log(hfpl,sprintf('The execution of the following job has failed :\n\n    '),flag_verbose);
    else
        sub_add_line_log(hfpl,sprintf('The execution of the following jobs have failed :\n\n    '),flag_verbose);
    end
    for num_j = list_num_failed
        name_job = list_jobs{num_j};        
        sub_add_line_log(hfpl,sprintf('%s ; ',name_job),flag_verbose);
    end    
    sub_add_line_log(hfpl,sprintf('\n\n'),flag_verbose);
    sub_add_line_log(hfpl,sprintf('More infos can be found in the individual log files. Use the following command to display these logs :\n\n    psom_pipeline_visu(''%s'',''log'',JOB_NAME)\n\n',path_logs),flag_verbose);
end

%% Print a list of jobs that could not be processed
if ~isempty(list_num_none)
    if length(list_num_none) == 1
        sub_add_line_log(hfpl,sprintf('The following job has not been processed due to a dependence on a failed job or the interruption of the pipeline manager :\n\n    '),flag_verbose);
    else
        sub_add_line_log(hfpl,sprintf('The following jobs have not been processed due to a dependence on a failed job or the interruption of the pipeline manager :\n\n    '),flag_verbose);
    end
    for num_j = list_num_none
        name_job = list_jobs{num_j};
        sub_add_line_log(hfpl,sprintf('%s ; ',name_job),flag_verbose);
    end    
    sub_add_line_log(hfpl,sprintf('\n\n'),flag_verbose);
end

%% Give a final one-line summary of the processing
if flag_any_fail    
    sub_add_line_log(hfpl,sprintf('All jobs have been processed, but some jobs have failed.\nYou may want to restart the pipeline latter if you managed to fix the problems.\n'),flag_verbose);
else
    if isempty(list_num_none)
        sub_add_line_log(hfpl,sprintf('All jobs have been successfully completed.\n'),flag_verbose);
    end
end

if ~strcmp(opt.mode_pipeline_manager,'session')&& strcmp(gb_psom_language,'octave')   
    sub_add_line_log(hfpl,sprintf('Press CTRL-C to go back to Octave.\n'),flag_verbose);
end

%% Close the log file
if strcmp(gb_psom_language,'matlab')
    fclose(hfpl);
    fclose(hfnf);
end

if exist('file_pipe_running','var')
    if exist(file_pipe_running,'file')
        delete(file_pipe_running); % remove the 'running' tag
    end
end

if strcmp(opt.mode,'session')&&strcmp(opt.mode_pipeline_manager,'session')&&flag_any_fail
    error('All jobs have been processed, but some jobs have failed. You may want to restart the pipeline latter if you managed to fix the problems.')
end

%%%%%%%%%%%%%%%%%%
%% subfunctions %%
%%%%%%%%%%%%%%%%%%

%% Find the children of a job
function mask_child = sub_find_children(mask,graph_deps)
% GRAPH_DEPS(J,K) == 1 if and only if JOB K depends on JOB J. GRAPH_DEPS =
% 0 otherwise. This (ugly but reasonably fast) recursive code will work
% only if the directed graph defined by GRAPH_DEPS is acyclic.
% MASK_CHILD(NUM_J) == 1 if the job NUM_J is a children of one of the job
% in the boolean mask MASK and the job is in MASK_TODO.
% This last restriction is used to speed up computation.

if max(double(mask))>0
    mask_child = max(graph_deps(mask,:),[],1)>0;    
    mask_child_strict = mask_child & ~mask;
else
    mask_child = false(size(mask));
end

if any(mask_child)
    mask_child = mask_child | sub_find_children(mask_child_strict,graph_deps);
end

%% Read a text file
function str_txt = sub_read_txt(file_name)

hf = fopen(file_name,'r');
if hf == -1
    str_txt = '';
else
    str_txt = fread(hf,Inf,'uint8=>char')';
    fclose(hf);    
end

%% Clean up the tags and logs associated with a job
function [] = sub_clean_job(path_logs,name_job)

files{1} = [path_logs filesep name_job '.log'];
files{2} = [path_logs filesep name_job '.finished'];
files{3} = [path_logs filesep name_job '.failed'];
files{4} = [path_logs filesep name_job '.running'];
files{5} = [path_logs filesep name_job '.exit'];
files{6} = [path_logs filesep name_job '.eqsub'];
files{7} = [path_logs filesep name_job '.oqsub'];
files{8} = [path_logs filesep name_job '.profile.mat'];
files{9} = [path_logs filesep 'tmp' filesep name_job '.sh'];

for num_f = 1:length(files)
    if psom_exist(files{num_f});
        delete(files{num_f});
    end
end

function [] = sub_add_line_log(file_write,str_write,flag_verbose);

if flag_verbose
    fprintf('%s',str_write)
end

if ischar(file_write)
    hf = fopen(file_write,'a');
    fprintf(hf,'%s',str_write);
    fclose(hf);
else
    fprintf(file_write,'%s',str_write);
end
