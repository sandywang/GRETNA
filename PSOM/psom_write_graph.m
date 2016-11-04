function [flag_fail,err_msg] = psom_write_graph(file_name,graph,opt)
%
% _________________________________________________________________________
% SUMMARY PSOM_WRITE_GRAPH
%
% Write a graph in the graphviz .dot format
%
% SYNTAX
% [FLAG_FAIL,ERR_MSG] = PSOM_WRITE_GRAPH(FILE_NAME,GRAPH,LABEL_NODES)
%
% _________________________________________________________________________
% INPUTS:
%
% FILE_NAME
%       (string) the file name to save the graph (should end with .dot)
%
% GRAPH
%       (sparse matrix) GRAPH(I,J) == 1 if there is an arrow from node I to
%       node J.
%
% OPT
%       (structure) with the following fields :
%
%       LABEL_NODES
%           (cell of string, default {'NODE1',...}) LABEL_NODES{I} is the 
%           label of node number I.
%                       description of the graph will be saved.
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
% A .dot description of the graph is saved in the file FILE_NAME.
%
% The graphviz toolbox can be used to visualize the graph. See:
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
if ~exist('file_name','var')||~exist('graph','var')
    error('SYNTAX: [] = PSOM_WRITE_GRAPH(FILE_NAME,GRAPH,[OPT]). Type ''help psom_write_graph'' for more info.')
end

%% Options
gb_name_structure = 'opt';
gb_list_fields    = {'label_nodes'};
gb_list_defaults  = {{}};
psom_set_defaults

nb_nodes = size(graph,1);

if isempty(label_nodes)
    for num_n = 1:nb_nodes
        label_nodes{num_n} = sprintf('node%i',num_n);
    end
end

%% Hard-coded parameters

% Color of nodes
list_colors = {'"#58a4ff"','"#ffffd0"','"#98ff58"','"#ff9f58f"','"#d0fffa"','#ffd0e7'};
%list_colors = {'"#ffffd0"'};

% Shape of nodes
%list_shapes = {'box','circle','diamond','ellipse','triangle','egg'};
list_shapes = {'box'};

%% Writing the nodes
hf = fopen(file_name,'w');
fprintf(hf,'digraph database {\n');

for num_n = 1:nb_nodes

    lab_node = label_nodes{num_n};
    if (length(lab_node)>5)&&strcmp(lab_node(1:6),'clean_')
      fprintf(hf,'NameNode%i[label="%s",fillcolor=%s,shape=%s,style = filled]\n',num_n,lab_node,list_colors{1},list_shapes{1});
    else
      fprintf(hf,'NameNode%i[label="%s",fillcolor=%s,shape=%s,style = filled]\n',num_n,lab_node,list_colors{2},list_shapes{1});
    end
    
end

%% Write edges
for num_n = 1:nb_nodes

    list_child = find(graph(num_n,:));

    for num_c = list_child
        fprintf(hf,'NameNode%i->NameNode%i\n',num_n,num_c);
    end
    
end
fprintf(hf,'}\n');
fclose(hf);
