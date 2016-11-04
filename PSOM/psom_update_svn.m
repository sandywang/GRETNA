function []=psom_update_svn()
% Update all SVN libraries in the search path
%
% SYNTAX :
% PSOM_UPDATE_SVN()
%
% Copyright (c) Christian L. Dansereau, 
% Centre de recherche de l'Institut universitaire de gériatrie de Montréal, 2011.
% Maintainer : pierre.bellec@criugm.qc.ca
% See licensing information in the code.
% Keywords : svn,version,update

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


    vers = psom_version_svn();

    for k=1:size(vers,2)
        disp(cat(2,'Check for "',vers(k).name,'" updates ...'))
        [status, output]=system(fullfile('svn update ',vers(k).path,' 2>&1'));
        disp(output)
    end
end