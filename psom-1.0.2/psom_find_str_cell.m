function mask_f = psom_find_str_cell(cell_str,cell_str2)
%
% _________________________________________________________________________
% SUMMARY PSOM_FIND_STR_CELL
%
% Test if one of many strings are substrings of another list of strings
%
% SYNTAX:
% MASK_F = PSOM_FIND_STR_CELL(CELL_STR,CELL_STR2)
% 
% _________________________________________________________________________
% INPUTS:
%
% CELL_STR      
%       (string or cell of strings)
%
% CELL_STR2     
%       (string or cell of strings)
% 
% _________________________________________________________________________
% OUTPUTS:
%
% MASK_F        
%       (vector) MASK_F(i) equals 1 if CELL_STR{i} contains CELL_STR2{j} 
%       for any j, 0 otherwise. If one argument is a simple string, it is 
%       converted into a cell of string with one element.
%
% _________________________________________________________________________
%
% SEE ALSO:
%
% PSOM_CMP_STR_CELL
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

if ischar(cell_str)
    str2{1} = cell_str;
    cell_str = str2;
    clear str2
end

if ischar(cell_str2)
    str2{1} = cell_str2;
    cell_str2 = str2;
    clear str2
end

nb_e = length(cell_str);
nb_f = length(cell_str2);
mask_f = zeros([nb_e 1]);

for num_e = 1:nb_e
    for num_f = 1:nb_f
        mask_f(num_e) = mask_f(num_e)|~isempty(findstr(cell_str{num_e},cell_str2{num_f}));
    end
end

mask_f = mask_f>0;