function [job,cleanup] = psom_pipeline2job(pipeline,path_logs,opt)
% Convert a pipeline into a job form.
% This means that a structure ready to be incorporated as a job in a 
% pipeline will be generated. It will list all input/output files of the 
% pipeline, and will run the pipeline locally using PSOM.
% All clean-up jobs are bundled into a separate "job".
%
% SYNTAX:
% [JOB,CLEANUP] = PSOM_PIPELINE2JOB(PIPELINE,PATH_LOGS,OPT)
%
% _________________________________________________________________________
% INPUTS:
%
% PIPELINE
%   (structure) A PSOM pipeline structure.
%
% PATH_LOGS
%   (string) where to store the logs of the pipeline.
%
% OPT
%   (structure, optional) with the following fields:
%
%   FLAG_CLEANUP
%       (boolean, default true) if the flag is true, bundle all clean-up 
%       jobs in a separate job. This is mandatory if multiple 
%       inter-dependent pipelines are combined together.
%
%   FLAG_FILES
%       (boolean, default true) if the flag is true, add a description of 
%       input/output files of the pipeline. This is mandatory if multiple 
%       inter-dependent pipelines are combined together.
% 
% _________________________________________________________________________
% OUTPUTS
%
% JOB
%    (structure) a single job that recapitulates all input/output files of 
%    PIPELINE, and will run the full pipeline in a single session.
%
% CLEANUP 
%    (structure) all clean-up jobs in PIPELINE are bundled in CLEANUP. The 
%    clean-up jobs are separated such that combination of multiple pipelines
%    will run properly. 
% 
% _________________________________________________________________________
% COMMENTS
%
% Empty file names, or file names equal to 'gb_niak_omitted' are ignored.
%
% Copyright (c) Pierre Bellec, Montreal Neurological Institute, 2008-2012.
% Maintainer : pierre.bellec@criugm.qc.ca
% See licensing information in the code.
% Keywords : pipeline, dependencies

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

%% SYNTAX
if nargin<2
    error('SYNTAX: [JOB,CLEANUP] = PSOM_PIPELINE2JOB(PIPELINE,PATH_LOGS,OPT). Type ''help psom_pipeline2job'' for more info.')
end

list_fields   = { 'flag_cleanup' , 'flag_files' };
list_defaults = { true           , true         };
if nargin < 3
    opt = psom_struct_defaults(struct(),list_fields,list_defaults);
else
    opt = psom_struct_defaults(opt,list_fields,list_defaults);
end
list_jobs = fieldnames(pipeline);
nb_jobs = length(list_jobs);

%% Detect and bundle clean-up jobs
if opt.flag_cleanup
    cleanup.command = 'psom_clean(files_clean)';
    cleanup.files_clean = struct();
    for num_j = 1:nb_jobs
        if strcmp(pipeline.(list_jobs{num_j}).command,cleanup.command)
            cleanup.files_clean.(list_jobs{num_j}) = pipeline.(list_jobs{num_j}).files_clean;
        end
    end
    if ~isempty(fieldnames(cleanup.files_clean))
        pipeline = rmfield(pipeline,fieldnames(cleanup.files_clean));
    end
    list_jobs = fieldnames(pipeline);
    nb_jobs = length(list_jobs);
    cleanup.files_clean = psom_files2cell(cleanup.files_clean);
else
    cleanup = struct();
end

if opt.flag_files
    %% Build files_in
    for num_j = 1:nb_jobs
        name_job = list_jobs{num_j};
        if isfield(pipeline.(name_job),'files_in')
            files_in.(name_job) = psom_files2cell(pipeline.(name_job).files_in);
        else
            files_in.(name_job) = {};
        end
        if isfield(pipeline.(name_job),'files_out')
            files_out.(name_job) = psom_files2cell(pipeline.(name_job).files_out);
        else
            files_out.(name_job) = {};
        end
    end

    %% Build files_out
    files_out = unique(psom_files2cell(files_out));
    files_in = unique(psom_files2cell(files_in));
    files_in = files_in(~ismember(files_in,files_out));
    job.files_in = files_in;
    job.files_out = files_out;
end

%% Build the job
job.command = 'pipeline = cell2struct(opt.pipeline(:),opt.list_jobs,1); psom_run_pipeline(pipeline,opt.psom);';
job.opt.pipeline = struct2cell(pipeline);
job.opt.list_jobs = fieldnames(pipeline);
job.opt.psom.mode = 'session';
job.opt.psom.mode_pipeline_manager = 'session';
job.opt.psom.path_logs = path_logs;
job.opt.psom.flag_pause = false;
