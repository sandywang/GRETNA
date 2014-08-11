function [] = psom_visu_dependencies(pipeline,opt)
% Visualize the graph of dependencies of a pipeline
%
% SYNTAX:
% [FILE_TMP] = PSOM_VISU_DEPENDENCIES(PIPELINE)
%
% _________________________________________________________________________
% INPUTS:
%
% PIPELINE
%   (structure) a pipeline structure, see PSOM_RUN_PIPELINE. The dependency 
%   graph of a pipeline can also be directly submitted instead of a
%   pipeline.
%
%
% OPT
%   (structure) with the following fields : 
%
%   TYPE_FILTER
%       (string, default 'dot') available options : 
%       'dot', 'neato', 'twopi', 'circo', 'fdp'
%       Type "man dot" in a terminal for more infos.
%
% _________________________________________________________________________
% OUTPUTS:
% 
% FILE_TMP
%   (spring) if GRAPHVIZ is used to generate the graph, this function is going 
%   to produce a temporary file (the pdf with the graph). This file needs to 
%   be cleaned out manually.
%
% _________________________________________________________________________
% SEE ALSO:
% PSOM_BUILD_DEPENDENCIES, PSOM_RUN_PIPELINE, PSOM_WRITE_DEPENDENCIES, 
% PSOM_WRITE_DEPENDENCIES
%
% _________________________________________________________________________
% COMMENTS:
%
% Copyright (c) Pierre Bellec, Montreal Neurological Institute, 2008.
% Maintainer : pbellec@bic.mni.mcgill.ca
% See licensing information in the code.
% Keywords : pipeline, PSOM

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

%% Options
gb_name_structure = 'opt';
gb_list_fields    = {'type_filter' };
gb_list_defaults  = {'dot'         };
psom_set_defaults

if exist('biograph')
    
    [graph_deps,list_jobs,files_in,files_out,files_clean,deps] = psom_build_dependencies(pipeline);
    bg = biograph(graph_deps,list_jobs);
    dolayout(bg);
    view(bg);
    file_tmp = '';

else

   [flag_dot,msg] = system('dot -V');

    if flag_dot==0
    
        file_tmp = psom_file_tmp('_graph.pdf');
        psom_write_dependencies(file_tmp,pipeline,opt);
        system([gb_psom_pdf_viewer ' ' file_tmp]);
        delete(file_tmp)

    else
    
        warning('I could not find the BIOGRAPH command or the DOT command. This probably means that the Matlab bioinformatics toolbox is not installed and that you did not install the GRAPHVIZ package on your system. Sorry dude, I can''t plot the graph.')
        file_tmp = '';

    end
end

