function [xml_struct] = psom_read_xml(xml_file)
% Reads an XML file to a matlab structure.
% 
% SYNTAX:
% [XML_STRUCT] = PSOM_READ_XML(XML_FILE)
%
% ___________________________________________________________________________
% INPUTS
% 
% XML_FILE
% 
%     A standard XML file.
% 
% ___________________________________________________________________________
% OUTPUTS
%
% XML_STRUCT
% 
%     A standard matlab/octave structure containing the fields of the xml file. 
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
% Keywords : xml, structure

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


[fid,msg] = fopen(xml_file,'r');
if(fid == -1)
  error(msg);
end

xml_text = char(fread(fid,[1,Inf],'char'));
xml_uncommented = psom_string_remove(xml_text,'<!','>');
xml_uncommented = psom_string_remove(xml_uncommented,'<?','?>');
xml_struct = psom_xml2struct(xml_uncommented);
fclose(fid);
endfunction