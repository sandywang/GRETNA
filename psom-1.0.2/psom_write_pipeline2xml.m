function [] = psom_write_pipeline2xml(pipeline, path_write, opt)
% Split a pipeline into seperate .mat jobs and an xml representation
% 
% SYNTAX:
% [] = PSOM_WRITE_PIPE2XML(PIPELINE,PATH_WRITE,OPT)
%
% ___________________________________________________________________________
% INPUTS
%
% PIPELINE
%	(structure) A formated PSOM PIPELINE.
% 
% PATH_WRITE
%   (string) String containing the folder where to save the outputs.
%
% OPT
%   (structure) with the following fields :
%       
%	XML_NAME
%   	(string) Name of the xml file to save in.
% 
%	PATH_JOBS
%   	(string) Path where to save the jobs.
% 
% ___________________________________________________________________________
% OUTPUTS
%
% This functional will create the following files in PATH_WRITE : 
%
% PIPELINE.xml
% 
%	A .xml file containing the pipeline.
%       
%   If OPT.XML_NAME is specified, that filename will be used instead.
%
%   
% JOB_(NAME OF JOB).mat 
% 
%   Files for each job in the given PIPELINE.
%
%   Will be saved in PATH_WRITE folder or OPT.PATH_JOBS if defined.
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
% Keywords : pipeline, xml

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


gb_name_structure = 'opt';
gb_list_fields    = {'xml_name'                        , 'path_jobs' };
gb_list_defaults  = {strcat(path_write,'pipeline.xml') , path_write  };
niak_set_defaults;

num_jobs = 1;

[deps,list_jobs,files_in,files_out,files_clean] = psom_build_dependencies(pipeline);

[fid, msg] = fopen(xml_name,'w','native');
if (fid == -1)
    printf(strcat('ERROR Opening xml file : ',msg,': ',xml_name));
    exit(-1);
end

fprintf(fid,'<?xml version="1.0" encoding="UTF-8" ?>\n');
fprintf(fid,'<pipeline>\n');

for i=1:size(list_jobs,1)
  name=list_jobs{i};
  fprintf(fid,'  <job>\n');
  job=pipeline.(name);
  save(strcat(path_jobs,'job_',name,'.mat'),'-struct','job');

  fprintf(fid,strcat('    <id>',md5sum(name,true),'</id>\n'));
  fprintf(fid,strcat('    <name>',name,'</name>\n'));
  fprintf(fid,strcat('    <job_file>job_',strcat(name,'.mat'),'</job_file>\n'));

  if sum(deps(i,:)) ~= 0
    fprintf(fid,'    <dependencies>\n');
    idx_deps = find(deps(1,:));
    for j=1:length(idx_deps)
      fprintf(fid,strcat('      <dependency>',md5sum(list_jobs{idx_deps(j)},true),'</dependency>\n'));
    end
    fprintf(fid,'    </dependencies>\n');
  end

  if ~isempty(files_in.(name))
    fprintf(fid,'    <files_in>\n');
    for num = 1:length(files_in.(name))
      fprintf(fid,strcat('      <file_in>',files_in.(name){num},'</file_in>\n'));
    end
    fprintf(fid,'    </files_in>\n');
  end

  if ~isempty(files_out.(name))
    fprintf(fid,'    <files_out>\n');
    for num = 1:length(files_out.(name))
      fprintf(fid,strcat('      <file_out>',files_out.(name){num},'</file_out>\n'));
    end
    fprintf(fid,'    </files_out>\n');
  end

  if ~isempty(files_clean.(name))
    fprintf(fid,'    <files_clean>\n');
    for num = 1:length(files_clean.(name))
      fprintf(fid,strcat('      <file_clean>',files_clean.(name){num},'</file_clean>\n'));
    end
    fprintf(fid,'    </files_clean>\n');
  end

  fprintf(fid,'  </job>\n');
end

fprintf(fid,'</pipeline>');

test = fclose(fid);
if (test == -1)
  printf('There was an error closing the xml file. It might be corrupted, or it might not.');
end
