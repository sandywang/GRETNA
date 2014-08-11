function [xml_struct] = psom_xml2struct(xml_string)
% Converts and XML string to an matlab/octave structure.
% 
% SYNTAX:
% [XML_STRUCT] = XML2STRUCT(XML_STRING)
%
% ___________________________________________________________________________
% INPUTS
%
% XML_STRING
%     String containing an standard XML structure.
% 
% ___________________________________________________________________________
% OUTPUTS
%
% XML_STRUCTURE
%     Matlab/Octave structure containing fields from the XML_STRING.
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
% Keywords : xml, struct, structure

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

key_a = strfind(xml_string,'<');
key_b = strfind(xml_string,'</');
if(length(key_a) == 0)
    if(xml_string(1) == '"')
	xml_struct = xml_string(2:end-1);
    else
	xml_struct = str2num(xml_string);
    end
    return
end

if(length(key_a) != length(key_b)*2)
  error('Error parsing xml file, misparsed key blocks.');
end

num_s = 1;
xml_struct = '';
key_index = 1;
contains_name = 0;
contains_path = 0;
while(num_s < length(xml_string)) 
  if(xml_string(num_s) == '<')
    key = '';
    num_s++;
    num_k = 1;
    while(xml_string(num_s) != '>')
      key(num_k) = xml_string(num_s);
      num_k++;
      num_s++;
    end
    key_start = strcat('<',key,'>');
    key_start_i = strfind(xml_string,key_start);
    key_end = strcat('</',key,'>');
    num_s++;
    value = '';
    num_v = 1;
    while(!strcmp(substr(xml_string,num_s,length(key_end)),key_end))
      value(num_v) = xml_string(num_s);
      num_v++;
      num_s++;
    end
    if(length(value) > 12)
      start = strfind(value,'<');
      if(strcmp(value(start:start+5),'<name>'))
        num_end = strfind(value,'</name>');
        key = value(start+7:num_end-2);
        contains_name = 1;
        value = value(num_end+6:end);
      end
    end
    if(contains_name == 1)
      xml_struct.(key) = psom_xml2struct(value);
    elseif(length(key_start_i) > 1)
      xml_struct.(key){key_index} = psom_xml2struct(value);
      key_index++;
    else
      xml_struct.(key) = psom_xml2struct(value);
    end
    num_s += length(key_end)-1;
    key_name = 0;
  end
  num_s++;
end

xml_struct = path2vec(xml_struct);
xml_struct = addFilesep2folderOut(xml_struct);
endfunction

function [xml_struct] = addFilesep2folderOut(xml_struct)
if(isstruct(xml_struct))
  names = fieldnames(xml_struct);
  for n = 1:length(names)
    if(strcmp(names{n},'folder_out'))
      if(ischar(xml_struct.folder_out))
        if(xml_struct.folder_out(end) ~= filesep)
          xml_struct.folder_out = strcat(xml_struct.folder_out,filesep);
        end
      end
    end
    xml_struct.(names{n}) = addFilesep2folderOut(xml_struct.(names{n}));
  end
end
endfunction

function [xml_struct] = path2vec(xml_struct) 

if(isstruct(xml_struct))
  names = fieldnames(xml_struct);
  if(length(names) == 1)
    if(strcmp(names{1},'path'))
      if(ischar(xml_struct.path))
        tmp{1} = xml_struct.path;
        xml_struct = tmp;
      else
        xml_struct = xml_struct.path;
      end
    end
  else
    for n = 1:length(names)
      xml_struct.(names{n}) = path2vec(xml_struct.(names{n}));
    end
  end
end
endfunction