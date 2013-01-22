function opt_up = psom_struct_defaults(opt,list_fields,list_defaults)
% Assign default values to the fields of a structure.
%
% SYNTAX:
% OPT_UP = PSOM_STRUCT_DEFAULTS(OPT,LIST_FIELDS,LIST_DEFAULTS)
%
% _________________________________________________________________________
% INPUTS: 
%
%   OPT
%       (structure)
%
%   LIST_FIELDS      
%       (cell of strings, size 1*N) names of fields.
%
%   LIST_DEFAULTS    
%       (cell, size 1*N) the default values for each listed field. A NaN 
%       will produce an error message if the field is not found in OPT. 
%       Fields present in OPT and absent from LIST_FIELDS will issue a 
%       warning.
%
% _________________________________________________________________________
% OUTPUTS :
%
%   OPT_UP
%       (structure) same as OPT, but with updated default values.
%
% _________________________________________________________________________
% COMMENTS:
%
% It is still possible to specify NaN as a value in the fields of OPT, but 
% not as a default. If you need to use NaN as a default, set the default 
% to [] and add an ad-hoc a posteriori test. This mechanism can be used in
% general if a default value depends on the values set for other fields of
% OPT.
%
% The fields found in OPT and not listed in LIST_FIELDS will be ignored,
% i.e. they won't be copied into OPT_UP.
%
% Copyright (c) Pierre Bellec, Centre de recherche de l'institut de 
% Gériatrie de Montréal, Département d'informatique et de recherche 
% opérationnelle, Université de Montréal, 2010
% Maintainer : pbellec@criugm.qc.ca
% See licensing information in the code.

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

if ~isstruct(opt)
    error('OPT should be a structure');
end

%% Build a default structure
opt_up = cell2struct(list_defaults,list_fields,2);

%% Check that no "NaN" field was omitted
str_field = '';
for num_f = 1:length(list_fields)
    if isreal(list_defaults{num_f})&&(length(list_defaults{num_f}(:))==1)&&isnan(list_defaults{num_f})&&~isfield(opt,list_fields{num_f})
        if isempty(str_field)
            str_field = list_fields{num_f};
        else
            str_field = [str_field ' , ' list_fields{num_f}];
        end
    end
end
if ~isempty(str_field)
    error(sprintf('A value must be specified for the following fields (%s)\n',str_field));
end

%% Set defaults
list_fields_opt = fieldnames(opt);
nb_fields = length(list_fields_opt);
for num_f = 1:nb_fields    
    opt_up.(list_fields_opt{num_f}) = opt.(list_fields_opt{num_f});    
end

%% Test if some field were not used, and eventually issue a warning.
if length(fieldnames(opt_up))>length(list_fields)
    list_fields_up = fieldnames(opt_up);
	mask = ~ismember(list_fields_up,list_fields);
    list_ind = find(mask);
    str_field = '';
    for num_i = 1:length(list_ind)
        str_field = [str_field ' ' list_fields_up{list_ind(num_i)}];
    end
    warning(sprintf('The following field(s) were ignored in the structure : %s\n',str_field));
    opt_up = rmfield(opt_up,list_fields_up(mask));
end