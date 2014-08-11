function [graph_deps,list_jobs,files_in,files_out,files_clean] = psom_build_dependencies(pipeline,flag_verbose)
% Generate the dependency graph of a pipeline.
%
% SYNTAX:
% [GRAPH_DEPS,LIST_JOBS,FILES_IN,FILES_OUT,FILES_CLEAN] = NIAK_BUILD_DEPENDENCIES(PIPELINE)
%
% _________________________________________________________________________
% INPUTS
%
% PIPELINE
%   (structure) Each field of PIPELINE is a job with an arbitrary name
%   <JOB_NAME> and the following subfields:
%
%   FILES_IN 
%      (string, cell of strings or structure whos terminal fields are 
%      strings or cell of strings) a list of the input files of the job
%
%   FILES_OUT 
%      (string, cell of strings or structure whos terminal fields are 
%      strings or cell of strings) a list of the output files of the job
%
%   FILES_CLEAN
%      (string, cell of strings or structure whos terminal fields are 
%      strings or cell of strings) a list of the files deleted by the job.
%
%   DEP
%      (cell of strings) a list of job names. This will force the 
%      dependency of the job <JOB_NAME> on these other jobs.
%
% FLAG_VERBOSE
%       (boolean, default true) if the flag is true, then the function
%       prints some infos during the processing.
%
% _________________________________________________________________________
% OUTPUTS:
%
% GRAPH_DEPS
%   (sparse matrix) GRAPH_DEPS(I,J) == 1 if and only if the job LIST_JOBS{J} 
%   depends on the job LIST_JOBS{I}
%
% LIST_JOBS
%   (cell of strings) The list of all job names
%
% FILES_IN.<JOB_NAME>
%   (cell of strings) the list of input files for the job
%
% FILES_OUT.<JOB_NAME>
%   (cell of strings) the list of output files for the job
%
% FILES_CLEAN.<JOB_NAME>
%   (cell of strings) the list of files deleted by JOB_NAME.
%
% _________________________________________________________________________
% SEE ALSO:
% PSOM_MANAGE_PIPELINE
%
% _________________________________________________________________________
% COMMENTS
%
% Empty file names, or file names equal to 'gb_niak_omitted' are ignored.
%
% Copyright (c) Pierre Bellec, Montreal Neurological Institute, 2008-2010.
% Centre de recherche de l'institut de gériatrie de Montréal, département
% d'informatique et de recherche opérationnelle, Université de Montréal,
% Canada, 2010-2012.
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
if ~exist('pipeline','var')
    error('SYNTAX: DEPS = PSOM_BUILD_DEPENDENCIES(PIPELINE[,FLAG_VERBOSE]). Type ''help psom_build_dependencies'' for more info.')
end

if nargin < 2
    flag_verbose = true;
end
list_jobs = fieldnames(pipeline);
nb_jobs = length(list_jobs);

%% Reorganizing inputs/outputs (for every job, convert input/output/clean
%% into cell of strings)
if flag_verbose
    fprintf('       Reorganizing inputs/outputs ... ')
    tic
end

for num_j = 1:nb_jobs
    name_job = list_jobs{num_j};
    try
        if isfield(pipeline.(name_job),'files_in')
            files_in.(name_job) = unique(psom_files2cell(pipeline.(name_job).files_in));
        else
            files_in.(name_job) = {};
        end
    catch
        fprintf('There was a problem with the input files of job %s\n',name_job)
        errmsg = lasterror;
        rethrow(errmsg);
    end
    try
        if isfield(pipeline.(name_job),'files_out')
            files_out.(name_job) = unique(psom_files2cell(pipeline.(name_job).files_out));
        else
            files_out.(name_job) = {};
        end
    catch
        fprintf('There was a problem with the output files of the job %s\n',name_job)
        errmsg = lasterror;
        rethrow(errmsg);
    end
    try
        if isfield(pipeline.(name_job),'files_clean')
            files_clean.(name_job) = unique(psom_files2cell(pipeline.(name_job).files_clean));
        else
            files_clean.(name_job) = {};
        end
    catch
        fprintf('There was a problem with the clean files of the job %s\n',name_job)
        errmsg = lasterror;
        rethrow(errmsg);
    end
    if isfield(pipeline.(name_job),'dep')
        dep.(name_job) = pipeline.(name_job).dep;
    else
        dep.(name_job) = {};
    end
end

if flag_verbose
    fprintf('%1.2f sec\n       Analyzing job inputs/outputs, percentage completed : ',toc)
    curr_perc = -1;
    tic;
end

%% Convert the structure+cellstr to a cell of strings with a numerical
%% index to keep track of jobs
[cell_in,ind_in]        = sub_struct2cell(files_in);
[cell_out,ind_out]      = sub_struct2cell(files_out);
[cell_clean,ind_clean]  = sub_struct2cell(files_clean);
graph_deps = sparse(nb_jobs,nb_jobs);

[val_tmp,ind_tmp,num_all] = unique([cell_in ; cell_out ; cell_clean]);
num_in  = num_all(1:length(cell_in));
num_out = num_all(length(cell_in)+1:length(cell_in)+length(cell_out));
num_clean = num_all(length(cell_in)+length(cell_out)+1:length(num_all));
clear num_all val_tmp ind_tmp

for num_j = 1:nb_jobs
    if flag_verbose
        new_perc = 5*floor(20*num_j/nb_jobs);
        if curr_perc~=new_perc
            fprintf(' %1.0f',new_perc);
            curr_perc = new_perc;
        end
    end

    % Files_in/Files_out
    name_job1 = list_jobs{num_j};
    mask_dep = ismember(num_out,num_in(ind_in==num_j));
    graph_deps(ind_out(mask_dep),num_j) = true;
    
    % Files_clean
    mask_dep = ismember(num_in,num_clean(ind_clean==num_j));
    graph_deps(ind_in(mask_dep),num_j) = true;
    mask_dep = ismember(num_out,num_clean(ind_clean==num_j));
    graph_deps(ind_out(mask_dep),num_j) = true;
    
    % User-specified dependencies
    if ~isempty(dep.(name_job1))
        mask_dep = ismember(list_jobs,dep.(name_job1));
        graph_deps(mask_dep,num_j) = true;
    end
end

if flag_verbose
    fprintf('- %1.2f sec\n',toc)
end
            
function [cell_struct,ind_struct] = sub_struct2cell(my_struct)

cell_struct = struct2cell(my_struct);
size_fields = cellfun('length',cell_struct);
nb_f = length(size_fields);
ind_struct = ones([sum(size_fields) 1]);
if nb_f>1
   pos_end = cumsum(size_fields);
   pos_start = [1 ; (pos_end(1:end-1)+1)];
   for num_f = 1:nb_f
       ind_struct(pos_start(num_f):pos_end(num_f)) = num_f;
   end
end
cell_struct = [cell_struct{:}]';
    
function files_in = sub_get_files_in(struct_test);
if isfield(struct_test,'files_in')
    files_in = struct_test.files_in;
else
    files_in = {};
end
