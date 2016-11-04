function [status,msg] = psom_clean(files_clean,opt)
% Clean up files.
%
% SYNTAX:
% [STATUS,MSG] = PSOM_CLEAN(FILES_CLEAN,OPT)
%
% _________________________________________________________________________
% INPUTS
%
% FILES_CLEAN  
%   (string, cell of string or structure) A list of files or folders that 
%   need to be  cleaned up. The files/folders names can be organized as a 
%   string, cell of strings or nested structures with string or cell of 
%   strings as terminal nodes. Strings can also be organized in an array
%   with one file name per row (padded with blanks, as implemented by the 
%   command CHAR).
%
% OPT
%   (structure) with the following field :
%
%   FLAG_VERBOSE 
%       (boolean, default 1) if the flag is 1, then the function prints 
%       some infos during the processing.
%
% _________________________________________________________________________
% OUTPUTS
%
% WARNING : This function is *very* dangerous. It deletes recursively both
% files and folders, without confirmation. Use with caution.
%
% If the files in FILES_CLEAN do not exist, the function simply issues a
% warning and quit, otherwise they are deleted.
%
% _________________________________________________________________________
% COMMENTS
%
% Copyright (c) Pierre Bellec, Centre de recherche de l'institut de
% gériatrie de Montréal, Département d'informatique et de recherche
% opérationnelle, Université de Montréal, Canada, 2010-2012
% Maintainer : pierre.bellec@criugm.qc.ca
% See licensing information in the code.

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Seting up default arguments %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('files_clean','var')
    error('Please specify FILES_CLEAN')
end

if exist('OCTAVE_VERSION','builtin')
    flag_rmdir = confirm_recursive_rmdir(false);
end
files_clean = psom_files2cell(files_clean);
 
%% Options
if nargin < 2
    opt = struct();
end
opt = psom_struct_defaults(opt,{'flag_verbose'},{true});

nb_files = length(files_clean);

for num_f = 1:nb_files
    file_name = files_clean{num_f};
    if size(file_name,1)==1
        sub_clean_file(file_name,opt.flag_verbose)
    else
        for num_f2 = 1:size(file_name,1)
            if num_f2 == 1
                sub_clean_file(deblank(file_name(num_f2,:)),opt.flag_verbose);
            else
                sub_clean_file(deblank(file_name(num_f2,:)),false);
            end
            if (num_f2 == 2)&&opt.flag_verbose
                fprintf('              (...)\n')
            end
        end    
    end
end
status = 1;
msg = '';

if exist('OCTAVE_VERSION','builtin')
    confirm_recursive_rmdir(flag_rmdir);
end

function [status,msg] = sub_clean_file(file_name,flag_verbose);

flag_exist = psom_exist(file_name);
if ~flag_exist
    warning(['I could not find the file or folder ' file_name]);
else
    if flag_exist == 1
        if flag_verbose
            fprintf('Deleting file ''%s'' \n',file_name);
        end
        delete(file_name);
    elseif flag_exist == 7
        if flag_verbose
            fprintf('Deleting folder ''%s'' \n',file_name);
        end
        rmdir(file_name,'s');
    else
        warning(['I could not find the file or folder ' file_name]);
    end
end