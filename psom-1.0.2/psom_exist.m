function flag_exist = psom_exist(file_name)
% A fast version of "exist" specific of files with full path names.
%
% SYNTAX:
% FLAG_EXIST = PSOM_EXIST(FILE_NAME)
% 
% _________________________________________________________________________
% INPUTS:
%
% FILE_NAME
%   (string) a file name with full path
%
% _________________________________________________________________________
% OUTPUTS:
%
% FLAG_EXIST
%   (integer) 1 if FILE_NAME is a file, 7 if it is a folder, 0 otherwise.
%
% _________________________________________________________________________
% COMMENTS:
% 
% This is essentially the same as exist(FILE_NAME), restricted to files and 
% directories, but it is much faster when the search path is large. It will 
% only work for file names/folder names with full path though.
%
% _________________________________________________________________________
% Copyright (c) Pierre Bellec, Centre de recherche de l'institut de
% geriatrie de Montreal, Departement d'informatique et recherche 
% operationnelle, Universite de Montreal, 2010.
% Maintainer : pbellec@criugm.qc.ca
% See licensing information in the code.
% Keywords : pipeline, niak, preprocessing, fMRI, psom

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

if size(file_name,1)>1
    flag_exist = true;
    for num_f = 1:size(file_name,1)
        flag_exist = flag_exist && psom_exist(deblank(file_name(num_f,:)));
    end
    return
end

hf = fopen(file_name,'r');
if hf == -1
    flag_exist = false;
else
    fclose(hf);
    flag_exist = true;
end
if ~flag_exist
    flag_exist = exist(file_name,'dir');
end