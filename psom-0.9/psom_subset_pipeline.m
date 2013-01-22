function pipeline2 = psom_subset_pipeline(pipeline,list_jobs)
%
% _________________________________________________________________________
% SUMMARY PSOM_SUBSET_PIPELINE
%
% Extract a subset of a pipeline
%
% SYNTAX
% PIPELINE2 = PSOM_SUBSET_PIPELINE(PIPELINE,LIST_JOBS)
% 
% _________________________________________________________________________
% INPUT
%
% PIPELINE
%       (structure) a pipeline (see PSOM_RUN_PIPELINE)
%
% LIST_JOBS   
%       (string or cell of strings) a list of job names.
%
% _________________________________________________________________________
% OUTPUT
%
% PIPELINE2
%       (structure) all the jobs whose name contains one string from
%       LIST_JOBS is included in PIPELINE2
%
% _________________________________________________________________________
% COMMENTS
% 
% Copyright (c) Pierre Bellec, Montreal Neurological Institute, 2008.
% Maintainer : pbellec@bic.mni.mcgill.ca
% See licensing information in the code.
% keywords : pipeline

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

list_jobs_all = fieldnames(pipeline);
mask_job = psom_find_str_cell(list_jobs_all,list_jobs);
list_job2 = list_jobs_all(mask_job);

for num_j = 1:length(list_job2)
    name_job = list_job2{num_j};
    pipeline2.(name_job) = pipeline.(name_job);
end