#!/usr/bin/env octave
% Executes a .mat job.
%
% SYNTAX:
% psom_run_job <job.mat>
%
% ___________________________________________________________________________
% INPUTS
%
% job.mat
%     .mat job to execute.
%
% ___________________________________________________________________________
% OUTPUTS
%
% The outputs depend on the given job.
% 
% _________________________________________________________________________
% COMMENTS:
%
% Copyright (c) Sebastien Lavoie-Courchesne, 
% Centre de recherche de l'institut de Gériatrie de Montréal
% Département d'informatique et de recherche opérationnelle
% Université de Montréal, 2011.
%
% Maintainer : pierre.bellec@criugm.qc.ca
% See licensing information in the code.
% Keywords : job, execute, run

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

if(nargin != 1 && nargin != 2)
    error("USAGE: psom_run_job <JOB.mat> or psom_run_job <JOB.mat> <PATH change>\n");
end

args = argv();
job = load(args{1});
if isfield(job,'files_out')
  files_out = job.files_out;
  path_all = psom_files2cell(files_out);
  path_all = cellfun (@fileparts,path_all,'UniformOutput',false);
  path_all = unique(path_all);
  for num_p = 1:length(path_all)
    path_f = path_all{num_p};
    [succ,messg,messgid] = psom_mkdir(path_f);
    if succ == 0
      warning(messgid,messg);
    end    
  end
end
failed = psom_run_job(args{1});
if(~failed) 
    printf('***Success***\n');
else
    printf('***Failure***\n');
end