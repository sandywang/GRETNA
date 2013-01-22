function [files_out,files_in,list_jobs] = psom_pipeline2job(pipeline)
%
% _________________________________________________________________________
% SUMMARY PSOM_PIPELINE2JOB
%
% Extract the grand total lists of inputs and outputs from a pipeline
% descrition.
%
% SYNTAX:
% [FILES_IN,FILES_OUT,LIST_JOBS] = NIAK_PIPELINE2JOB(PIPELINE)
%
% _________________________________________________________________________
% INPUTS
%
% PIPELINE
%       (structure) Each field of PIPELINE is a job with an arbitrary name:
%
%       <JOB_NAME> a structure with the following fields:
%
%               FILES_IN
%                   (string, cell of strings or structure whos terminal 
%                   fields are strings or cell of strings)
%                   a list of the input files of the job
%
%               FILES_OUT
%                   (string, cell of strings or structure whos terminal 
%                   fields are strings or cell of strings)
%                   a list of the output files of the job
%
% _________________________________________________________________________
% OUTPUTS
%
% FILES_OUT
%       (structure) the field names are identical to PIPELINE
%
%       <JOB_NAME> 
%           (cell of strings) the list of output files for the job
%
% FILES_IN
%       (structure) the field names are identical to PIPELINE
%
%       <JOB_NAME> 
%           (cell of strings) the list of input files for the job
%
%
% LIST_JOBS
%       (cell of strings)
%       The list of all job names
% 
% _________________________________________________________________________
% SEE ALSO
%
% PSOM_BUILD_DEPENDENCIES
%
% _________________________________________________________________________
% COMMENTS
%
% Empty file names, or file names equal to 'gb_niak_omitted' are ignored.
%
% Copyright (c) Pierre Bellec, Montreal Neurological Institute, 2008.
% Maintainer : pbellec@bic.mni.mcgill.ca
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
    error('SYNTAX: [FILES_IN,FILES_OUT,LIST_JOBS] = PSOM_PIPELINE2JOB(PIPELINE). Type ''help psom_pipeline2job'' for more info.')
end

list_jobs = fieldnames(pipeline);
nb_jobs = length(list_jobs);

for num_j = 1:nb_jobs
    name_job = list_jobs{num_j};
    if nargout > 1
        if isfield(pipeline.(name_job),'files_in')
            files_in.(name_job) = psom_files2cell(pipeline.(name_job).files_in);
        else
            files_in.(name_job) = {};
        end
    end
    if isfield(pipeline.(name_job),'files_out')
        files_out.(name_job) = psom_files2cell(pipeline.(name_job).files_out);
    else
        files_out.(name_job) = {};
    end
end

files_out = unique(psom_files2cell(files_out));
if nargout > 2
    files_in = unique(psom_files2cell(files_in));
    files_in = files_in(~ismember(files_in,files_out));
end