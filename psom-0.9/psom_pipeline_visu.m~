function [] = psom_pipeline_visu(path_logs,action,opt_action)
% Display various information from the logs of a pipeline.
%
% SYNTAX:
% [] = PSOM_PIPELINE_VISU(PATH_LOGS,ACTION,OPT)
%
% _________________________________________________________________________
% INPUTS:
%
% PATH_LOGS
%    (string) The path of the pipeline logs
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
%
% OPT
%    (string) see the following notes on action 'log' and 'time'
%
% _________________________________________________________________________
% OUTPUTS:
%
% What the function does depends on the argument ACTION :
%
% ACTION = 'submitted'
%    Display a list of the jobs of the pipeline that are scheduled in
%    the queue but not currently running.
%
% ACTION = 'running'
%    Display a list of the jobs of the pipeline that are currently
%    running
%
% ACTION = 'failed'
%    Display a list of the jobs of the pipeline that have failed. Note
%    that jobs with an 'exit' status are counted as failures.
%
% ACTION = 'finished'
%    Display a list of finished jobs of the pipeline.
%
% ACTION = 'none'
%    Display a list of jobs without tag (no attempt has been made to
%    process the job).
%
% ACTION = 'log'
%    Print (with updates) the log files for the job OPT.
%
% ACTION = 'time'
%    Print the execution time for a set of jobs. For this action, OPT is
%    a regular expression (see REGEXP) and any job whose name matches
%    this expression will be included in the computation time. Use an
%    empty string to include all jobs.
%
% ACTION = 'monitor'
%    Print (with updates) the pipeline master log.
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

%% Add the folder separator if it was omitted at the end of PATH_LOGS
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
pipeline = load(file_jobs);
list_jobs = fieldnames(pipeline);

try
    all_status = load(file_status);
catch
    warning('There was something wrong when loading the status file %s, I''ll try loading the backup instead',file_status)
    all_status = load(file_status_backup);
end

for num_j = 1:length(list_jobs)
    name_job = list_jobs{num_j};
    if isfield(all_status,name_job)
        job_status{num_j} = all_status.(name_job);
    else
        job_status{num_j} = 'none';
    end
end
clear all_status


switch action

    case {'finished','failed','none','running','submitted'}

        %% List the jobs that have a specific status

        if strcmp(action,'failed')
            mask_jobs = ismember(job_status,{action,'exit'});
        else
            mask_jobs = ismember(job_status,action);
        end
        jobs_action = list_jobs(mask_jobs);

        if isempty(jobs_action)
            msg = sprintf('There is currently no %s job',action);
        else
            msg = sprintf('List of %s job(s)',action);
        end

        stars = repmat('*',size(msg));
        fprintf('\n\n%s\n%s\n%s\n\n',stars,msg,stars);

        for num_j = 1:length(jobs_action)
            fprintf('%s\n',jobs_action{num_j});
        end

    case 'flowchart'

        %% Display the graph of dependencies of the pipeline
        pipeline = load(file_jobs);        
        psom_visu_dependencies(pipeline);

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
        
    case 'time'

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
        try
            profile = load(file_profile);
            flag_profile = true;
        catch
            flag_profile = false;
        end
        lmax = max(cellfun(@length,list_jobs,'UniformOutput',true));
        fprintf('\n%s\n',repmat('*',[1 lmax+1]));
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
            if isempty(ctime)
                fprintf('Huho, I could not parse computation time for job %s, that''weird ! Sorry about that ... \n',list_jobs{num_j});
            else
                name_job = [list_jobs{num_j} repmat(' ',[1 lmax-length(list_jobs{num_j})])];
                fprintf('%s : %1.2f s, %1.2f mn, %1.2f hours, %1.2f days.\n',name_job,ctime,ctime/60,ctime/3600,ctime/(24*3600));
                tot_time = tot_time + ctime;
            end

        end
        fprintf('%s\nTotal computation time :  %1.2f s, %1.2f mn, %1.2f hours, %1.2f days.\n',repmat('*',[1 lmax+1]),tot_time,tot_time/60,tot_time/3600,tot_time/(24*3600));

    case 'log'

        %% Prints the log of one job

        ind_job =  find(ismember(list_jobs,opt_action));

        if isempty(ind_job)
            error('%s : is not a job of this pipeline.',opt_action);
        end

        curr_status = job_status{ind_job};

        msg = sprintf('  Log file of job %s (status %s) ',opt_action,curr_status);
        stars = repmat('*',size(msg));
        fprintf('\n\n%s\n%s\n%s\n\n',stars,msg,stars);


        if strcmp(curr_status,'running');

            file_job_log = [path_logs opt_action '.log'];
            file_job_running = [path_logs opt_action '.running'];
            sub_tail(file_job_log,file_job_running);

        else

            try
                load(file_logs,opt_action);
            catch
                warning('There was something wrong when loading the log file %s, I''ll try loading the backup instead',file_logs)
                load(file_logs_backup,opt_action);            
            end
            eval(['fprintf(''%s'',',opt_action,');']);

        end

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

