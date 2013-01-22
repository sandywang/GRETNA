function pipeline2 = psom_add_clean(pipeline,name_job,files_clean)
% Add a cleaning job to a pipeline.
%
% SYNTAX :
% PIPELINE2 = PSOM_ADD_CLEAN(PIPELINE,NAME_JOB,FILES_CLEAN)
%
% _________________________________________________________________________
% INPUTS :
%
%   PIPELINE
%       (structure) a pipeline structure.
%
%   NAME_JOB
%       (string) the name of the job to add.
%
%   FILES_CLEAN
%       () the name of the files to clean up.
%
% _________________________________________________________________________
% OUTPUTS:
%
%   PIPELINE2
%       (structure) same as pipeline, with an extra cleaning job in it.
%
% _________________________________________________________________________
% SEE ALSO: 
% PSOM_CLEAN
%
% _________________________________________________________________________
% COMMENTS : 
%
% PIPELINE can be empty, in which case a structure will be created.
%
% The cleaning of the files is implemented using PSOM_CLEAN
%
% Copyright (c) Pierre Bellec, Montreal Neurological Institute, 2008.
% Maintainer : pbellec@bic.mni.mcgill.ca
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

if ~exist('files_clean','var')||~exist('name_job','var')
    error('Please specify NAME_JOB and FILES_CLEAN');
end

if ~ischar(name_job)
    error('NAME_JOB should be a string');
end

%% Adding the job to the pipeline
if ~isempty(pipeline)
    pipeline2 = pipeline;
end
pipeline2.(name_job).command     = sprintf('psom_clean(files_clean)');
pipeline2.(name_job).files_clean = psom_files2cell(files_clean);