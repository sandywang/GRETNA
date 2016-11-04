function file_name = psom_file_tmp(ext)
%
% _________________________________________________________________________
% SUMMARY PSOM_FILE_TMP
%
% Suggest a name of temporary file 
%
% SYNTAX:
% FILE_NAME = PSOM_FILE_TMP(EXT)
%
% _________________________________________________________________________
% INPUTS:
%
% EXT             (string) An extension for the file name
%
% OUTPUTS:
% 
% A (full path) name for a temporary file.
%
% _________________________________________________________________________
% COMMENTS:
%
% The temporary files live in the temporary directory. This directory is by 
% default '/tmp/', but this can be changed using the variable GB_PSOM_TMP
% in the file PSOM_GB_VARS.
%
% Copyright (c) Pierre Bellec, Montreal Neurological Institute, 2008.
% Maintainer : pbellec@bic.mni.mcgill.ca
% See licensing information in the code.
% Keywords :

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

global gb_psom_name_job
flag_gb_psom_fast_gb = 1; %% the initialization of global variables will be as fast as possible
psom_gb_vars
if nargin == 0
    ext = '.tmp';
end
flag_tmp = 1;
while flag_tmp == 1
    label = clock;
    label(end) = 10000*label(end);
    label = round(sum(label));
    if ~isempty(gb_psom_name_job)
        file_name = sprintf('%spsom_tmp_%s_%i%s',gb_psom_tmp,gb_psom_name_job,label,ext);
    else
        file_name = sprintf('%spsom_tmp_%i%s',gb_psom_tmp,label,ext);
    end
    flag_tmp = psom_exist(file_name);
end

save(file_name,'flag_tmp')