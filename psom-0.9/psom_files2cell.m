function cell_files = psom_files2cell(files)
% Convert a string, cell of strings or a structure where each field is a
% string into one single cell of strings.
%
% SYNTAX :
% CELL_FILES = PSOM_FILES2CELL(FILES)
%
% _________________________________________________________________________
% INPUTS :
%
% FILES         
%       (string, cell of strings or a structure where each terminal field 
%       is a string or a cell of strings) All those strings are file names.
%
% _________________________________________________________________________
% OUTPUTS :
%
% CELL_FILES    
%       (cell of strings) all file names in FILES stored in a cell of 
%       strings (wheter it was initially string, cell of strings or 
%       structure does not matter).
%
% _________________________________________________________________________
% COMMENTS : 
%
% Empty file names, or file names equal to 'gb_niak_omitted' are ignored.
%
% Copyright (c) Pierre Bellec, Montreal Neurological Institute, 2008.
% Maintainer : pbellec@bic.mni.mcgill.ca
% See licensing information in the code.
% Keywords : string

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

num_cell = 1;
cell_files = cell(0);

if isstruct(files)     % That's a structure
    
    cell_files = struct2cell(files);
    clear files
    cell_files = cell_files(:);
    for num_e = 1:length(cell_files);        
        cell_files{num_e} = psom_files2cell(cell_files{num_e});
    end
    cell_files = [cell_files{:}];
    if isempty(cell_files)
        cell_files = {};
    end
elseif iscellstr(files) %% That's a cell
    
    files = files(:);
    
    for num_i = 1:length(files)

        if ~strcmp(files{num_i},'gb_niak_omitted')&&~isempty(files{num_i})
            cell_files{num_cell} = regexprep(files{num_i},[filesep '+'],filesep);            
            num_cell = num_cell + 1;
        end

    end
    
elseif ischar(files) % That's a string

    for num_f = 1:size(files,1)
        if ~strcmp(files(num_f,:),'gb_niak_omitted')&&~isempty(files(num_f,:))
            cell_files{num_cell} = regexprep(files(num_f,:),[filesep '+'],filesep);            
        end
    end
    
else    
    
    if ~isempty(files)
        error('FILES should be a string or a cell of strings, or a structure with arbitrary depths whos terminal fields are strings or cell of strings');
    end
    
end
