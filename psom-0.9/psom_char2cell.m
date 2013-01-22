function cellstr = psom_char2cell(char_array)
%
% _________________________________________________________________________
% SUMMARY PSOM_CHAR2CELL
%
% Convert a char array into a cell of strings
%
% SYNTAX :
% CELLSTR = PSOM_CHAR2CELL(CHAR_ARRAY)
%
% _________________________________________________________________________
% INPUTS :
%
% CHAR_ARRAY
%       (string array) the rows of CHAR_ARRAY are the strings of interest
%
% _________________________________________________________________________
% OUTPUTS :
%
% CELLSTR
%       (cell of strings) CELLSTR{I} is a deblanked version of
%       CHAR_ARRAY(I,:).
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

cellstr = cell([size(char_array,1) 1]);

for num_e = 1:length(cellstr)
    cellstr{num_e} = deblank(char_array(num_e,:));
end