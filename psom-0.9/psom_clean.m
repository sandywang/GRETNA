function [status,msg] = psom_clean(files_clean,opt)
% Clean up files.
%
% SYNTAX:
% [STATUS,MSG] = PSOM_CLEAN(FILES_CLEAN,OPT)
%
% _________________________________________________________________________
% INPUTS
%
% CLEAN  
%   (string, cell of string or structure) A list of files or folders that 
%   need to be  cleaned up. The files/folders names can be organized as a 
%   string, cell of strings or nested structures with string or cell of 
%   strings as terminal nodes. 
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
% opérationnelle, Université de Montréal, Canada, 2010.
% Maintainer : pbellec@criugm.qc.ca
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

files_clean = niak_files2cell(files_clean);

%% Options
gb_name_structure = 'opt';
gb_list_fields    = {'flag_verbose' };
gb_list_defaults  = {true           };
niak_set_defaults

nb_files = length(files_clean);

for num_f = 1:nb_files
    file_name = files_clean{num_f};
    
    if flag_verbose
        fprintf('Deleting file ''%s'' \n',file_name);
    end
    if ~ exist (file_name,'file')
        warning(['I could not find the file ' file_name]);
    else
        instr_delete = ['rm -rf ',file_name];
        [err,msg] = system(instr_delete);
        if err~=0
            warning('There was a problem deleting file %s. Error message : %s',file_name,msg);
        end
    end
end
