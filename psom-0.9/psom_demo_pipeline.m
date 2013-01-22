function [pipeline,opt] = psom_demo_pipeline(path_demo,opt)
% Short tutorial on the pipeline system for Octave and Matlab (PSOM).
%
% SYNTAX:
% [PIPELINE,OPT_PIPE] = PSOM_DEMO_PIPELINE(PATH_DEMO,OPT)
%
% _________________________________________________________________________
% INPUTS:
%
% PATH_DEMO
%    (string, default local_path_demo defined in the file 
%    PSOM_GB_VARS) 
%    the full path to the PSOM demo folder. IMPORTANT WARNING : PSOM 
%    will empty totally this folder and then build example files and 
%    logs in it.
%
% OPT
%    (structure, optional) the option structure passed on to 
%    PSOM_RUN_PIPELINE. If not specified, the default values will be
%    used. Note that the default for the demo are different from
%    NIAK_RUN_PIPELINE. Specifically :
%
%    MODE
%        default 'background'
%
%    MODE_PIPELINE_MANAGER
%        default 'session'
%
%    MAX_QUEUED
%        default 2
%
%    TIME_BETWEEN_CHECKS
%        default 0.5
%
%    FLAG_PAUSE
%        default true
%
%    This default configuration was selected for fast execution of the
%    demo. Note that these defaults cannot be changed through editing 
%    PSOM_GB_VARS.
%
% _________________________________________________________________________
% OUTPUTS:
% 
% PIPELINE
%    (structure) the toy pipeline.
%
% OPT_PIPE
%    (structure) the options used to execute the pipeline using PSOM.
%
% _________________________________________________________________________
% COMMENTS:
%
% The blocks of code follow the tutorial that can be found at the following 
% address : 
% http://code.google.com/p/psom/w/edit/HowToUsePsom
%
% You can run a specific block of code by selecting it and press F9, or by
% putting the cursor anywhere in the block and press CTRL+ENTER.
%
% If FLAG_PAUSE is set to false, both the demo and the pipeline manager
% will not require confirmations to proceed.
% _________________________________________________________________________
% COMMENTS:
%
% This demo will create some files and one folder in PATH_DEMO
%
% Copyright (c) Pierre Bellec, Montreal Neurological Institute, 2008-2010.
% Maintainer : pbellec@bic.mni.mcgill.ca
% See licensing information in the code.
% Keywords : pipeline, PSOM, demo

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setting up the default execution mode %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

psom_gb_vars

if nargin<1||isempty(path_demo)
    local_path_demo = gb_psom_path_demo;    
else
    local_path_demo = path_demo;
end

% Set up the options to run the pipeline
opt.path_logs = [local_path_demo 'logs' filesep];  % where to store the log files

if ~isfield(opt,'flag_test')
    flag_test = false;
else
    flag_test = opt.flag_test;
    opt = rmfield(opt,'flag_test');
end

if ~isfield(opt,'mode')
    opt.mode = 'background';
end

if ~isfield(opt,'mode_pipeline_manager')
    opt.mode_pipeline_manager = 'session';
end

if ~isfield(opt,'max_queued')
    opt.max_queued = 2;
end

if ~isfield(opt,'time_between_checks')
    opt.time_between_checks = 0.5;
end

if ~isfield(opt,'flag_pause')
    opt.flag_pause = true;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% What is a pipeline ? %%
%%%%%%%%%%%%%%%%%%%%%%%%%%    
if ~flag_test
    msg = 'The demo is about to generate a toy pipeline and plot the dependency graph.';
    msg2 = 'Press CTRL-C to stop here or any key to continue.';
    stars = repmat('*',[1 max(length(msg),length(msg2))]);
    fprintf('\n%s\n%s\n%s\n%s\n\n',stars,msg,msg2,stars);
    if opt.flag_pause
        pause
    end
end

% Job "sample" :    No input, generate a random vector a
command = 'a = randn([opt.nb_samps 1]); save(files_out,''a'')';
pipeline.sample.command      = command;
pipeline.sample.files_out    = [local_path_demo 'sample.mat'];
pipeline.sample.opt.nb_samps = 10;

% Job "quadratic" : Compute a.^2 and save the results
command = 'load(files_in); b = a.^2; save(files_out,''b'')';
pipeline.quadratic.command   = command;
pipeline.quadratic.files_in  = pipeline.sample.files_out;
pipeline.quadratic.files_out = [local_path_demo 'quadratic.mat']; 

% Adding a job "cubic" : Compute a.^3 and save the results
command = 'load(files_in); c = a.^3; save(files_out,''c'')';
pipeline.cubic.command       = command;
pipeline.cubic.files_in      = pipeline.sample.files_out;
pipeline.cubic.files_out     = [local_path_demo 'cubic.mat']; 

% Adding a job "sum" : Compute a.^2+a.^3 and save the results
command = 'load(files_in{1}); load(files_in{2}); d = b+c, save(files_out,''d'')';
pipeline.sum.command       = command;
pipeline.sum.files_in{1}   = pipeline.quadratic.files_out;
pipeline.sum.files_in{2}   = pipeline.cubic.files_out;
pipeline.sum.files_out     = [local_path_demo 'sum.mat'];

if flag_test
    return
end

if opt.flag_pause
    psom_visu_dependencies(pipeline);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Prepare the demo folder %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

msg = 'The demo is about to remove the content of the following folder and save the demo results there:';
msg2 = local_path_demo;
msg3 = 'Press CTRL-C to stop here or any key to continue.';
stars = repmat('*',[1 max([length(msg),length(msg2),length(msg3)])]);
fprintf('\n%s\n%s\n%s\n%s\n%s\n\n',stars,msg,msg2,msg3,stars);
if opt.flag_pause
    pause
end

if exist(local_path_demo,'dir')
    rmdir(local_path_demo,'s');
end
psom_mkdir(local_path_demo);

%%%%%%%%%%%%%%%%%%%%
%% Run a pipeline %%
%%%%%%%%%%%%%%%%%%%%
msg   = 'The demo is about to execute the toy pipeline.';
msg2  = 'Press CTRL-C to stop here or any key to continue.';
stars = repmat('*',[1 max(length(msg),length(msg2))]);
fprintf('\n%s\n%s\n%s\n%s\n\n',stars,msg,msg2,stars);
if opt.flag_pause
    pause
end

% The following line is running the pipeline manager on the toy pipeline
psom_run_pipeline(pipeline,opt);

%%%%%%%%%%%%%%%%%%%%%%%%
%% Restart a pipeline %%
%%%%%%%%%%%%%%%%%%%%%%%%

%% Test 1 : change the options
msg = 'The demo is about to change an option of the job ''sum'' and restart the pipeline.';
msg2 = 'Press CTRL-C to stop here or any key to continue.';
stars = repmat('*',[1 max(length(msg),length(msg2))]);
fprintf('\n%s\n%s\n%s\n%s\n\n',stars,msg,msg2,stars);
if opt.flag_pause
    pause
end

pipeline.sum.opt = 'let''s change something...';
psom_run_pipeline(pipeline,opt);

%% Test 2 : failed jobs
msg = 'The demo is about to change the job ''quadratic'' to create a bug, and then restart the pipeline.';
msg2 = 'Press CTRL-C to stop here or any key to continue.';
stars = repmat('*',[1 max(length(msg),length(msg2))]);
fprintf('\n%s\n%s\n%s\n%s\n\n',stars,msg,msg2,stars);
if opt.flag_pause
    pause
end

pipeline.quadratic.command = 'BUG!';
psom_run_pipeline(pipeline,opt);

% Visualize the log file of the failed job
msg = 'The demo is about to display the log file of the failed job ''quadratic''.';
msg2 = 'Press CTRL-C to stop here or any key to continue.';
stars = repmat('*',[1 max(length(msg),length(msg2))]);
fprintf('\n%s\n%s\n%s\n%s\n\n',stars,msg,msg2,stars);
if opt.flag_pause
    pause
end
psom_pipeline_visu(opt.path_logs,'log','quadratic');

% fix the bug, restart the pipeline
msg = 'The demo is about to fix the bug in the job ''quadratic'' and restart the pipeline.';
msg2 = 'Press CTRL-C to stop here or any key to continue.';
stars = repmat('*',[1 max(length(msg),length(msg2))]);
fprintf('\n%s\n%s\n%s\n%s\n\n',stars,msg,msg2,stars);
if opt.flag_pause
    pause
end

command = 'load(files_in); b = a.^2; save(files_out,''b'')';
pipeline.quadratic.command   = command;
psom_run_pipeline(pipeline,opt);

%% Test 3 : Add a new job
msg = 'The demo is about to add new job ''cleanup'', plot the updated dependency graph and restart the pipeline.';
msg2 = 'Press CTRL-C to stop here or any key to continue.';
stars = repmat('*',[1 max(length(msg),length(msg2))]);
fprintf('\n%s\n%s\n%s\n%s\n\n',stars,msg,msg2,stars);
if opt.flag_pause
    pause
end

pipeline.cleanup.command     = 'delete(files_clean)';
pipeline.cleanup.files_clean = pipeline.sample.files_out;
if opt.flag_pause
    psom_visu_dependencies(pipeline);
end
psom_run_pipeline(pipeline,opt);

%% Test 4 : Restart jobs
msg = 'The demo is about to explicitely restart the ''quadratic'' job and then restart the pipeline.';
msg2 = 'Press CTRL-C to stop here or any key to continue.';
stars = repmat('*',[1 max(length(msg),length(msg2))]);
fprintf('\n%s\n%s\n%s\n%s\n\n',stars,msg,msg2,stars);
if opt.flag_pause
    pause
end

opt.restart = {'quadratic'};
psom_run_pipeline(pipeline,opt);
opt = rmfield(opt,'restart');

%%%%%%%%%%%%%%%%%%%%%%%%
%% Monitor a pipeline %%
%%%%%%%%%%%%%%%%%%%%%%%%

if opt.flag_pause
    %% Display flowchart
    msg = 'The demo is about to display the flowchart of the pipeline';
    msg2 = 'Press CTRL-C to stop here or any key to continue.';
    stars = repmat('*',[1 max(length(msg),length(msg2))]);
    fprintf('\n%s\n%s\n%s\n%s\n\n',stars,msg,msg2,stars);
    if opt.flag_pause
        pause
    end
    psom_pipeline_visu(opt.path_logs,'flowchart')
end

%% List the jobs
msg = 'The demo is about to display a list of the finished jobs';
msg2 = 'Press CTRL-C to stop here or any key to continue.';
stars = repmat('*',[1 max(length(msg),length(msg2))]);
fprintf('\n%s\n%s\n%s\n%s\n\n',stars,msg,msg2,stars);
if opt.flag_pause
    pause
end

psom_pipeline_visu(opt.path_logs,'finished')

%% Display log
msg = 'The demo is about to display the log of the ''sum'' job';
msg2 = 'Press CTRL-C to stop here or any key to continue.';
stars = repmat('*',[1 max(length(msg),length(msg2))]);
fprintf('\n%s\n%s\n%s\n%s\n\n',stars,msg,msg2,stars);
if opt.flag_pause
    pause
end

psom_pipeline_visu(opt.path_logs,'log','sum')

%% Display Computation time
msg = 'The demo is about to display the computation time for all jobs of the pipeline';
msg2 = 'Press CTRL-C to stop here or any key to continue.';
stars = repmat('*',[1 max(length(msg),length(msg2))]);
fprintf('\n%s\n%s\n%s\n%s\n\n',stars,msg,msg2,stars);
if opt.flag_pause
    pause
end

psom_pipeline_visu(opt.path_logs,'time','')

%% Monitor history
msg = 'The demo is about to monitor the history of the pipeline';
msg2 = 'Press CTRL-C to stop here or any key to continue.';
stars = repmat('*',[1 max(length(msg),length(msg2))]);
fprintf('\n%s\n%s\n%s\n%s\n\n',stars,msg,msg2,stars);
if opt.flag_pause
    pause
end

psom_pipeline_visu(opt.path_logs,'monitor')

