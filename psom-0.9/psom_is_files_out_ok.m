function [flag_ok,list_files_failed,list_jobs_failed] = psom_is_files_out_ok(files_out)
%
% _________________________________________________________________________
% SUMMARY PSOM_IS_FILES_OUT_OK
%
% Check if some files are not generated twice in a pipeline
%
% SYNTAX:
% [FLAG_OK,LIST_FILES_FAILED,LIST_JOBS_FAILED] = PSOM_IS_FILES_OUT_OK(FILES_OUT)
%
% _________________________________________________________________________
% INPUTS
%
% FILES_OUT
%       (structure) the field names are identical to PIPELINE
%
%       <JOB_NAME> 
%           (cell of strings) the list of output files for the job
%
% _________________________________________________________________________
% OUTPUTS
%
% FLAG_OK
%       (boolean) FLAG_OK == 1 only if every file is created only by one
%       job.
%
% LIST_FILES_FAILED
%       (cell of strings) a list of the files that are being generated
%       twice.
%
% LIST_JOBS_FAILED
%       (cell of strings) a list of job names involved in multiple
%       generation of the same file name.
%
% _________________________________________________________________________
% SEE ALSO
%
% PSOM_IS_DAG
%
% _________________________________________________________________________
% COMMENTS
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
if ~exist('files_out','var')
    error('SYNTAX: [FLAG_OK,LIST_FILES_FAILED,LIST_JOBS_FAILED] = PSOM_IS_FILES_OUT_OK(FILES_OUT). Type ''help psom_is_files_out_ok'' for more info.')
end

list_jobs = fieldnames(files_out);
nb_jobs = length(list_jobs);
list_files_failed = {};
list_jobs_failed = {};

list_files = psom_files2cell(files_out);
nb_files = length(list_files);
[list_files2,I,J] = unique(list_files);
nb_files2 = length(list_files2);
flag_ok = length(list_files2)==length(list_files);

if ~flag_ok
    
	mask_files_failed = false([nb_files2 1]);
    for num_f = 1:nb_files2
        mask_files_failed(num_f) = sum(J==num_f)>1;
    end
    
    list_files_failed = list_files2(mask_files_failed);
    
    mask_jobs_failed = false([nb_jobs 1]);
    
    for num_j = 1:nb_jobs
        if ~isempty(files_out.(list_jobs{num_j}))
            mask_jobs_failed(num_j) = max(ismember(files_out.(list_jobs{num_j}),list_files_failed));
        end
    end
    
    list_jobs_failed = list_jobs(mask_jobs_failed);
end