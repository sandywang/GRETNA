function pipeline2 = psom_add_job(pipeline,name_job,name_brick,files_in,files_out,opt,flag_default)
% Add a job to a pipeline, assuming a brick command.
%
% SYNTAX :
% PIPELINE =
% PSOM_ADD_JOB(PIPELINE,NAME_JOB,NAME_BRICK,FILES_IN,FILES_OUT,OPT,FLAG_DEFAULT)
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
%   NAME_BRICK
%       (string) the name of the brick that will executed as a command.
%
%   FILES_IN
%       () the input files of the job.
%
%   FILES_OUT
%       () the output files of the job.
%
%   OPT
%       () the option of the job.
%
%   FLAG_DEFAULT
%       (boolean, default true) if the flag is true, a test call will be
%       made to the brick to set the default of files_in/files_out/opt.
%
% _________________________________________________________________________
% OUTPUTS:
%
%   PIPELINE2
%       (structure) same as pipeline, with an extra job in it.
%
% _________________________________________________________________________
% COMMENTS : 
%
% PIPELINE can be empty, in which case a structure will be created.
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

if ~exist('flag_default','var')
    flag_default = true;
end

%% Set defaults
if flag_default
    opt.flag_test = true;
    eval(sprintf('[files_in,files_out,opt] = %s(files_in,files_out,opt);',name_brick));
    opt.flag_test = false;
end

%% Adding the job to the pipeline
if ~isempty(pipeline)
    pipeline2 = pipeline;
end
pipeline2.(name_job).command   = sprintf('%s(files_in,files_out,opt);',name_brick);
pipeline2.(name_job).files_in  = files_in;
pipeline2.(name_job).files_out = files_out;
pipeline2.(name_job).opt       = opt;
