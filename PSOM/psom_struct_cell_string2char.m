function [char_array,ind_fields] = psom_struct_cell_string2char(scs)
%
% _________________________________________________________________________
% SUMMARY PSOM_STRUCT_CELL_STRING2CHAR
%
% Convert a structure where each field is a cell of strings into a char
% array and an index making the correspondance between each entry of the
% array and a field of the structure.
%
% SYNTAX :
% [CHAR_ARRAY,IND_FIELDS] = PSOM_STRUCT_CELL_STRING2CHAR(SCS)
%
% _________________________________________________________________________
% INPUTS :
%
% SCS         
%       (structure) all fields are cell of strings.
%
% _________________________________________________________________________
% OUTPUTS :
%
% CHAR_ARRAY    
%       (string array) CHAR_ARRAY(I,:) is one of the string in SCS, padded
%       with spaces to reach the length of the longest string.
%
% IND_FIELDS
%       (vector) if FIELDS is the list of field names in SCS,
%       CHAR_ARRAY(I,:) comes from the field FIELDS{IND_FIELDS(I)}.
%
% _________________________________________________________________________
% COMMENTS : 
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

list_fields = fieldnames(scs);

nb_str = 0;

for num_f = 1:length(list_fields)
    nb_str = nb_str + length(scs.(list_fields{num_f}));
end

ind_fields = zeros([nb_str 1]);
char_array = cell([nb_str 1]);
num_e = 1;

for num_f = 1:length(list_fields)
    ind_fields(num_e:(length(scs.(list_fields{num_f}))+num_e-1)) = num_f;
    
    for num_s = 1:length(scs.(list_fields{num_f}))
        char_array{num_e} = scs.(list_fields{num_f}){num_s};
        num_e = num_e + 1;
    end
    
end
char_array = char(char_array);