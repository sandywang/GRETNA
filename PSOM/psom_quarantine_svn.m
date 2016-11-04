function []=psom_quarantine_svn(quarantine_path,svn_rev_libs)
% Create a quarantine at the path specified of all the svn libraries, you
% can also specify the version of each library that you whant in the
% quarantine.
%
% SYNTAX :
% PSOM_QUARANTINE_SVN(QUARENTINE_PATH,SVN_REV_LIBS)
%
% _________________________________________________________________________
% INPUTS :
%
% QUARANTINE_PATH 
%    (string) the path of the quarantine.
%
% SVN_REV_LIBS 
%    (structure, optional) a structure with two fields 'name' and 'version' 
%    for each lib to add in the quarantine    
%   
% _________________________________________________________________________
% OUTPUTS:
%
% _________________________________________________________________________
% COMMENTS : 
%
% This function uses PSOM_VERSION_SVN to find all the SVN libraries in the 
% search path. The folder of the SVN library and its position in the SVN
% project defines its name (ex the subfolder 'trunk' of the SVN library 
% located in the folder 'my_library' is called 'my_library-trunk'
%
% Copyright (c) Christian L. Dansereau, 
% Centre de recherche de l'Institut universitaire de gériatrie de Montréal, 2011.
% Maintainer : pierre.bellec@criugm.qc.ca
% See licensing information in the code.
% Keywords : svn, version, export, quarantine

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


if ~exist('quarantine_path','var')
    error(strcat('You need to specify the quarantine path!'))
    return;
end

% Remove any filesep at the end of the path
if strcmp(quarantine_path(end),filesep)
    quarantine_path = quarantine_path(1:end-1);
end

% Create destination path
if ~exist(quarantine_path)
    psom_mkdir(quarantine_path);
end

% Get the SVN root repositories
vers = psom_version_svn();
if exist('svn_rev_libs','var')
    
    if ~isstruct(svn_rev_libs)
        error(strcat('The quarantine path must be a struct: .name and .version'))
        return;
    end
    
    for k=1:size(vers,2)
        
        for i=1:size(svn_rev_libs,2)
            
            if ~isfield(svn_rev_libs(i),'name')
                error(strcat('You need to specify the .name field'))
                return;
            end
            if ~isfield(svn_rev_libs(i),'version')
                error(strcat('You need to specify the .version field'))
                return;
            end
            
            if isequal(vers(k).name,svn_rev_libs(i).name)
                % Check if version is a number
                if isnumeric(svn_rev_libs(i).version)
                    svn_rev_libs(i).version = num2str(svn_rev_libs(i).version);
                end

                % Create destination folder
                destination_folder = cat(2,filesep,svn_rev_libs(i).name,'-',svn_rev_libs(i).version);

                % Execute the svn export command
                fprintf('%s\n',cat(2,'Exporting the quarantine of "',svn_rev_libs(i).name,'" Version: ',svn_rev_libs(i).version,' ...'))
                [status,output]=system(cat(2,'svn export -r ',svn_rev_libs(i).version,' ',vers(k).path,' ',quarantine_path,destination_folder,' 2>&1'));
                fprintf('%s\n',cat(2,svn_rev_libs(i).name,': ',output))
            end
        end
    end
else
        
    for k=1:size(vers,2)

        %Clean the version string
        vers(k).version(strfind(vers(k).version,':')) = '-';
        vers(k).version(regexp(vers(k).version,'\n')) = '';

        % Create destination folder
        destination_folder = cat(2,filesep,vers(k).name,'-',vers(k).version);

        % Execute the svn export command
        fprintf('%s\n',cat(2,'Exporting the quarantine of "',vers(k).name,'" ...'))
        [status,output]=system(cat(2,'svn export ',vers(k).path,' ',quarantine_path,destination_folder,' 2>&1'));
        fprintf('%s\n',cat(2,vers(k).name,': ',output))

    end
end

end