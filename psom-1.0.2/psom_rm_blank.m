function str_b = psom_rm_blank(str,list_blanks)
% Remove leading and trailing blanks from str, and suppress blanks
% following a blank.
%
% SYNTAX
% STR_B = NIAK_RM_BLANK(STR,LIST_BLANKS)
% 
% INPUT
% STR           (vector of strings)
% LIST_BLANKS   (cell of string, default {}) a list of characters that
%                will be considered as blanks
%
% OUTPUT
% STR_B         (vector of strings) a "deblanked" version of str
%
% COMMENTS
% 
% Copyright (c) Pierre Bellec 01/2008
%
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

% Setting up default
if nargin < 2
    list_blanks = {};
end

str_b = str;
for num_e = 1:length(list_blanks)
    str_b = strrep(str_b,list_blanks{num_e},' ');
end

ind = 1:length(str);

pos = findstr(str_b,' ');
if length(pos)>1
    to_trash = find(pos(2:end)-pos(1:end-1)==1);
    if ~isempty(to_trash)    
        str_b = str_b(~ismember(ind,pos(to_trash)));    
    end
end

if ~isempty(str_b)
    if strcmp(str_b(1),' ')
        str_b = str_b(2:end);
    end
end

if ~isempty(str_b)
    if strcmp(str_b(end),' ')
        str_b = str_b(1:end-1);
    end
end