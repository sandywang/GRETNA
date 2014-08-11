function [string_removed] = psom_string_remove(string,remove_start,remove_end)
% Removes substrings from a string.
% 
% SYNTAX:
% [STRING_REMOVED] = STRREM(STRING,START,END)
%
% ___________________________________________________________________________
% INPUTS
%
% STRING
%     String to remove substrings from.
%
% START
%     Start of the substrings to remove. (ex: '<!--')
%
% END
%     End of the substrings to remove. (ex: '-->')     
% 
% ___________________________________________________________________________
% OUTPUTS
%
% STRING_REMOVED
%     String with the substrings removed.
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
% Keywords : string, remove

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


a = strfind(string,remove_start);
string_removed = string;

if(length(a) == 0)
    return
end

for num_c=1:length(a)
  b = strfind(string(a(num_c):end),remove_end);
  comment = string(a(num_c):a(num_c)+b(1));
  string_removed = strrep(string_removed,comment,'');
end
endfunction 
