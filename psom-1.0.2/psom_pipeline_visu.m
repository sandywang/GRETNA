function res = psom_pipeline_visu(path_logs,action,opt_action,flag_visu)
% Display various information from the logs of a pipeline.
%
% SYNTAX:
% RES = PSOM_PIPELINE_VISU(PATH_LOGS,ACTION,OPT,FLAG_VISU)
%
% _________________________________________________________________________
% INPUTS:
%
% PATH_LOGS
%    (string, default current folder) The path of the pipeline logs
%
% ACTION
%    (string) Possible values :
%
%    'submitted', 'running', 'failed', 'finished', 'none'
%        List the jobs that have this status.
%
%    'monitor'
%        Monitor the execution of the pipeline.
%
%    'log'
%        Display the log of one job.
%
%    'time'
%        Display the execution time of a set of jobs
%
%    'flowchart'
%        Draw the graph of dependencies of the pipeline.
%
%    'nb_jobs_running'
%        plot the number of jobs running as a function of time.
%
%    'parallel_time'
%        the execution time using parallel computing, i.e. the time elapsed 
%        between the beginning of the first job and the end of the last job.
%
% OPT
%    (string) see the following notes on action 'log' and 'time'
%
% FLAG_VISU
%    (boolean, default true) if FLAG_VISU is false, no plot or print is
%    performed, but RES is still generated. This has no effect for actions
%    'monitor' and 'flowchart'.
%
% _________________________________________________________________________
% OUTPUTS:
%
% What the function does depends on the argument ACTION :
%
% ACTION = 'submitted'
%    Display a list of the jobs of the pipeline that are scheduled in
%    the queue but not currently running. RES is a cell of strings with
%    the list of the name of these jobs.
%
% ACTION = 'running'
%    Display a list of the jobs of the pipeline that are currently
%    running. RES is a cell of strings with the list of the name of 
%    these jobs.
%
% ACTION = 'failed'
%    Display a list of the jobs of the pipeline that have failed. Note
%    that jobs with an 'exit' status are counted as failures. RES is a 
%    cell of strings with the list of the name of these jobs.
%
% ACTION = 'finished'
%    Display a list of finished jobs of the pipeline. RES is a cell of 
%    strings with the list of the name of these jobs.
%
% ACTION = 'none'
%    Display a list of jobs without tag (no attempt has been made to
%    process the job). RES is a cell of strings with the list of the name 
%    of these jobs.
%
% ACTION = 'log'
%    Print (with updates) the log files for the job OPT. RES is a string 
%    containing the log.
%
% ACTION = 'time'
%    Print the execution time for a set of jobs. For this action, OPT is
%    a regular expression (see REGEXP) and any job whose name matches
%    this expression will be included in the computation time. Use an
%    empty string to include all jobs. RES(J).TIME is the computation 
%    time of job RES(J).NAME, in seconds.
%
% ACTION = 'flowchart'
%    Print the flowchart. RES is empty.
%
% ACTION = 'monitor'
%    Print (with updates) the pipeline master log. RES is empty.
%
% ACTION = 'nb_jobs_running'
%    Plot the number of jobs running as a function of the elapsed time 
%    since the start-up of the first job. If specified, OPT will be used 
%    as an argument sent to the PLOT command. RES is a structure with 
%    three fields : 
%        NB_JOBS_RUNNING (vector), entry I is the number of submitted
%           jobs at time ALL_TIME(I)
%        ALL_TIME (vector) a (sorted) list of the times when the number
%           of submitted jobs changed.
%        TIME_START (vector) TIME_START(J) is the time when the job 
%           LIST_JOBS{I} started.
%        TIME_END (vector) TIME_END(J) is the time when the job 
%           LIST_JOBS{I} ended.
%        LIST_JOBS (cell of strings) LIST_JOBS{J} is the name of the Jth
%           job.
%     
% ACTION = 'parallel_time'
%    Print the parallel running time (from the start-up of the first job till 
%    the end of the last job, excluding jobs that have not been processed).
%    RES is the total time, expressed in seconds.   
%
% _________________________________________________________________________
% SEE ALSO:
%
% PSOM_PIPELINE_INIT, PSOM_PIPELINE_PROCESS, PSOM_RUN_PIPELINE,
% PSOM_DEMO_PIPELINE, PSOM_VISU_DEPENDENCIES
%
% _________________________________________________________________________
% COMMENTS:
%
% Copyright (c) Pierre Bellec, 
% Montreal Neurological Institute, 2008-2010
% Département d'informatique et de recherche opérationnelle
% Centre de recherche de l'institut de Gériatrie de Montréal
% Université de Montréal, 2011
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

%% SYNTAX
if ~exist('path_logs','var') || ~exist('action','var')
    error('SYNTAX: [] = PSOM_PIPELINE_VISU(PATH_LOGS,ACTION,OPT). Type ''help psom_pipeline_visu'' for more info.')
end

%% Defaults
if nargin < 4
    flag_visu = true;
end

%% Add the folder separator if it was omitted at the end of PATH_LOGS
if isempty(path_logs)
    path_logs = pwd;
end
if ~strcmp(path_logs(end),filesep)
	path_logs = [path_logs filesep];
end
	
%% Get status
name_pipeline = 'PIPE';
file_pipeline       = [path_logs 'PIPE.mat'];
file_jobs           = [path_logs 'PIPE_jobs.mat'];
file_status         = [path_logs filesep name_pipeline '_status.mat'];
file_status_backup  = [path_logs filesep name_pipeline '_status_backup.mat'];
file_logs           = [path_logs filesep name_pipeline '_logs.mat'];
file_logs_backup    = [path_logs filesep name_pipeline '_logs_backup.mat'];
file_profile        = [path_logs filesep name_pipeline '_profile.mat'];
file_profile_backup = [path_logs filesep name_pipeline '_profile_backup.mat'];

switch action

    case {'finished','failed','none','running','submitted'}
 
        %% Read status
        try
            all_status = load(file_status);
        catch
            warning('There was something wrong when loading the status file %s, I''ll try loading the backup instead',file_status)
            all_status = load(file_status_backup);
        end
        list_jobs = fieldnames(all_status);
        job_status = struct2cell(all_status);

        %% List the jobs that have a specific status

        if strcmp(action,'failed')
            mask_jobs = ismember(job_status,{action,'exit'});
        else
            mask_jobs = ismember(job_status,action);
        end
        jobs_action = list_jobs(mask_jobs);

        if isempty(jobs_action)&&flag_visu
            msg = sprintf('There is currently no %s job',action);
        elseif flag_visu
            msg = sprintf('List of %s job(s)',action);
        end

        if flag_visu
            stars = repmat('*',size(msg));
            fprintf('\n\n%s\n%s\n%s\n\n',stars,msg,stars);
        
            for num_j = 1:length(jobs_action)
                fprintf('%s\n',jobs_action{num_j});
            end
        end
        res = jobs_action;

    case 'flowchart'

        %% Read pipeline
        pipeline = load(file_jobs);
        list_jobs = fieldnames(pipeline);

        %% Display the graph of dependencies of the pipeline
        psom_visu_dependencies(pipeline);
        res = [];

    case 'monitor'

        if nargin < 3
            opt_action = 0; % By default, read the whole history
        end
        %% Prints the history of the pipeline, with updates

        file_monitor = [path_logs filesep name_pipeline '_history.txt'];
        file_pipe_running = [path_logs filesep name_pipeline '.lock'];

        if exist(file_pipe_running,'file')
            msg = 'The pipeline is currently running';
        else
            msg = 'The pipeline is NOT currently running';
        end

        stars = repmat('*',size(msg));
        fprintf('\n\n%s\n%s\n%s\n\n',stars,msg,stars);

        while ~psom_exist(file_monitor) && psom_exist(file_pipe_running) % the pipeline started but the log file has not yet been created

            fprintf('I could not find any log file. This pipeline has not been started (yet?). Press CTRL-C to cancel.\n');
            pause(1)

        end
        
        sub_tail(file_monitor,file_pipe_running,opt_action);
        res = [];
        
    case 'time'

        %% Read pipeline
        try
            profile = load(file_profile);
            flag_profile = true;
            list_jobs = fieldnames(profile);
        catch
            flag_profile = false;
            pipeline = load(file_jobs);
            list_jobs = fieldnames(pipeline);
        end
        
        %% Prints the computation time for a list of jobs
        if ~exist('opt_action','var')||isempty(opt_action)
            ind_job = 1:length(list_jobs);
        else
            mask_include = false([length(list_jobs) 1]);
            for num_j = 1:length(list_jobs)
                mask_include(num_j) = ~isempty(regexp(list_jobs{num_j},opt_action));
            end
            ind_job = find(mask_include);
            ind_job = ind_job(:)';
        end

        if isempty(ind_job)
            error('%s : there is no is no job fitting that description in the pipeline.',opt_action);
        end

        tot_time = 0;
        if flag_visu
            lmax = max(cellfun(@length,list_jobs,'UniformOutput',true));
            fprintf('\n%s\n',repmat('*',[1 lmax+1]));
        end
        for num_j = ind_job

            if ~flag_profile
                try
                    log_str = load(file_logs,list_jobs{num_j});            
                catch
                    warning('There was something wrong when loading the log file %s, I''ll try loading the backup instead',file_logs)
                    log_str = load(file_logs_backup,list_jobs{num_j});            
                end
                ind_str = findstr(log_str.(list_jobs{num_j}),tag_str);
                sub_str = log_str.(list_jobs{num_j})(ind_str+length(tag_str):end);
                ind_str_end = findstr(sub_str,' sec.');
                sub_str = sub_str(1:ind_str_end-1);
                ctime = str2num(sub_str);
            else
                try
                    ctime = profile.(list_jobs{num_j}).elapsed_time;
                catch
                    ctime = [];
                end

            end
            res(num_j).name = list_jobs{num_j};
            res(num_j).time = ctime;
            if flag_visu&&isempty(ctime)
                fprintf('Huho, I could not parse computation time for job %s, that''weird ! Sorry about that ... \n',list_jobs{num_j});
            elseif flag_visu
                name_job = [list_jobs{num_j} repmat(' ',[1 lmax-length(list_jobs{num_j})])];
                fprintf('%s : %1.2f s, %1.2f mn, %1.2f hours, %1.2f days.\n',name_job,ctime,ctime/60,ctime/3600,ctime/(24*3600));
                tot_time = tot_time + ctime;
            end

        end
        if flag_visu
            fprintf('%s\nTotal computation time :  %1.2f s, %1.2f mn, %1.2f hours, %1.2f days.\n',repmat('*',[1 lmax+1]),tot_time,tot_time/60,tot_time/3600,tot_time/(24*3600));
        end

    case 'log'

        %% Read pipeline
        all_status = load(file_status);
        list_jobs = fieldnames(all_status);

        %% Prints the log of one job
        ind_job =  find(ismember(list_jobs,opt_action));

        if isempty(ind_job)
            error('%s : is not a job of this pipeline.',opt_action);
        end

        curr_status = all_status.(opt_action);

        if flag_visu
            msg = sprintf('  Log file of job %s (status %s) ',opt_action,curr_status);
            stars = repmat('*',size(msg));
            fprintf('\n\n%s\n%s\n%s\n\n',stars,msg,stars);
        end

        if strcmp(curr_status,'running');

            if flag_visu
                file_job_log = [path_logs opt_action '.log'];
                file_job_running = [path_logs opt_action '.running'];
                sub_tail(file_job_log,file_job_running);
            else
                warning('The job is currently running. The log has not yet been fully generated')
                res = '';
            end

        else

            try
                log_job = load(file_logs,opt_action);
            catch
                warning('There was something wrong when loading the log file %s, I''ll try loading the backup instead',file_logs)
                log_job = load(file_logs_backup,opt_action);            
            end
            if flag_visu
                fprintf('%s',log_job.(opt_action));
            end
        end
        res = log_job.(opt_action);

    case 'nb_jobs_running'

        profile_jobs = load(file_profile);
        list_jobs = fieldnames(profile_jobs);
        time_start = zeros([length(list_jobs) 1]);
        time_end = zeros([length(list_jobs) 1]);
        
        for num_j = 1:length(list_jobs)
            if isfield(profile_jobs.(list_jobs{num_j}),'end_time')&&~isempty(profile_jobs.(list_jobs{num_j}).end_time)
                [tmp,time_start(num_j)] = datenum(profile_jobs.(list_jobs{num_j}).start_time);
                [tmp,time_end(num_j)] = datenum(profile_jobs.(list_jobs{num_j}).end_time);
            end
        end
        mask = time_end ~= 0; % Ignore jobs that did not complete
        time_start = time_start(mask);
        time_end = time_end(mask);
        changes = [ones([length(time_start) 1]) ; -ones([length(time_start) 1])];
        [all_time,order] = sort([time_start;time_end]);
        changes = changes(order);
        nb_jobs_running = cumsum(changes);
        if flag_visu
            if ~exist('opt_action','var')||isempty(opt_action)
                plot((all_time-all_time(1))/(60*60),nb_jobs_running);
            else
                plot((all_time-all_time(1))/(60*60),nb_jobs_running,opt_action);
            end
            ha = gca;
            set(get(ha,'xlabel'),'string','time elapsed (hrs)')
            set(get(ha,'ylabel'),'string','# jobs running')
        end
        res.nb_jobs_running = nb_jobs_running;
        res.all_time = all_time;
        res.time_end = time_end;
        res.time_start = time_start;
        res.list_jobs = list_jobs;

    case 'parallel_time'

        profile_jobs = load(file_profile);
        list_jobs = fieldnames(profile_jobs);
        time_start = zeros([length(list_jobs) 1]);
        time_end = zeros([length(list_jobs) 1]);
        
        for num_j = 1:length(list_jobs)
            if isfield(profile_jobs.(list_jobs{num_j}),'end_time')&&~isempty(profile_jobs.(list_jobs{num_j}).end_time)
                [tmp,time_start(num_j)] = datenum(profile_jobs.(list_jobs{num_j}).start_time);
                [tmp,time_end(num_j)] = datenum(profile_jobs.(list_jobs{num_j}).end_time);
            end
        end
        mask = time_end ~= 0; % Ignore jobs that did not complete
        time_start = time_start(mask);
        time_end = time_end(mask);
        total_time = max(time_end) - min(time_start);
        if flag_visu
            fprintf('Total running time: %1.2f sec, %1.2f mns, %1.2f hrs\n',total_time,total_time/60,total_time/3600);
        end
        res = total_time;

    otherwise

        error('psom:pipeline: unknown action %s',action);

end

%%%%%%%%%%%%%%%%%%%
%% sub-functions %%
%%%%%%%%%%%%%%%%%%%

function [] = sub_tail(file_read,file_running,nb_chars)

% prints out the content of the text file FILE_READ with constant updates
% as long as the file FILE_RUNNING exists. 
flag_running = true;
while flag_running
    flag_running = psom_exist(file_running);
    hf = fopen(file_read,'r');
    fseek(hf,nb_chars,'bof');
    str_read = fread(hf, Inf , 'uint8=>char')';
    nb_chars = ftell(hf);
    fclose(hf);    
    fprintf('%s',str_read);            
end

