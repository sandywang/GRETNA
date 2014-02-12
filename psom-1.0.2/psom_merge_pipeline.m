function struct12 = psom_merge_pipeline(struct1,struct2,prefix)
% Merge two pipelines (or any two arbitrary structures with one entry).
%
% SYNTAX:
%   PIPE12 = PSOM_MERGE_PIPELINE(PIPE1,PIPE2,PREFIX)
%
% _________________________________________________________________________
% INPUTS:
%
% PIPE1   
%    (structure) with one entry.
%
% PIPE2   
%    (structure) with one entry.
%
% PREFIX 
%    (string, default '') a prefix added to all field names in PIPE2 before
%    merging.
%
% _________________________________________________________________________
% OUTPUTS:
%
% PIPE12  
%       (structure) combines the fields of PIPE1 and PIPE2. 
%
% _________________________________________________________________________
% COMMENTS:
%
% If structures have fields in common, the fields of PIPE2 override the
% ones of PIPE1.
%
% For speed optimization, the smallest structure should be passed as
% PIPE2.
%
% Copyright (c) Pierre Bellec, Montreal Neurological Institute, 2008.
% Maintainer : pbellec@bic.mni.mcgill.ca
% See licensing information in the code.
% Keywords : structure

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

if nargin < 3
    prefix = '';
end

list_fields = fieldnames(struct2);
struct12 = struct1;

for num_f = 1:length(list_fields)
    if ~isempty(prefix)&&isfield(struct2.(list_fields{num_f}),'dep')
        struct2.(list_fields{num_f}).dep = strcat(prefix,struct2.(list_fields{num_f}).dep);
    end   
    struct12.([prefix list_fields{num_f}]) = struct2.(list_fields{num_f});        
end