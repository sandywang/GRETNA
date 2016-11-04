function [flag_fail,err_msg] = psom_write_dependencies(file_name,pipeline,opt)
% Write the dependency graph of a pipeline in in a pdf file.
%
% SYNTAX
% [FLAG_FAIL,ERR_MSG] = PSOM_WRITE_GRAPH(FILE_NAME,PIPELINE,OPT)
%
% _________________________________________________________________________
% INPUTS:
%
% FILE_NAME
%   (string) the file name to save the graph of dependencies.
%
% PIPELINE
%   (structure) a pipeline structure, see PSOM_RUN_PIPELINE.
%
% OPT
%   (structure) with the following fields :
%
%   TYPE_FILTER
%       (string, default 'dot') available options : 
%       'dot', 'neato', 'twopi', 'circo', 'fdp'
%       Type "man dot" in a terminal for more infos.
%
%   FORMAT
%       (string, default 'pdf') The format for output. See a list of
%       available outputs here : 
%       http://www.graphviz.org/doc/info/output.html
%
% _________________________________________________________________________
% OUTPUTS:
%
% FLAG_FAIL
%       (boolean) if FLAG_FAIL~=0, an error occured when generating the
%       file.
%
% ERR_MSG      
%       (string) if an error occured, ERR_MSG is the error message.
%
% _________________________________________________________________________
% COMMENTS:
% 
% A representation of the dependency graph is saved in the file FILE_NAME.
%
% The graphviz toolbox is used to save the graph. See:
% http://www.graphviz.org/
%
% Copyright (c) Pierre Bellec, Montreal Neurological Institute, 2008.
% Maintainer : pbellec@bic.mni.mcgill.ca
% See licensing information in the code.
% Keywords : graph, dot

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

psom_gb_vars

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setting up default values for inputs %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SYNTAX
if ~exist('pipeline','var')||~exist('file_name','var')
    error('SYNTAX: [] = PSOM_WRITE_DEPENDENCIES(FILE_NAME,PIPELINE,[OPT]). Type ''help psom_write_dependencies'' for more info.')
end

%% Options
gb_name_structure = 'opt';
gb_list_fields    = {'type_filter' , 'format'};
gb_list_defaults  = {'dot'         , 'pdf'};
psom_set_defaults

[graph_deps,list_jobs] = psom_build_dependencies(pipeline);

file_tmp = psom_file_tmp('.dot');

opt_graph.label_nodes = list_jobs;

psom_write_graph(file_tmp,graph_deps,opt_graph);

instr_dot = [type_filter ' ' file_tmp ' -o' file_name ' -T' opt.format];
[flag_fail,err_msg] = system(instr_dot);

if flag_fail
  error(err_msg)
end
delete(file_tmp);
