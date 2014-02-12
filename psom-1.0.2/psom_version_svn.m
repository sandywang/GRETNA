function [svn]= psom_version_svn(verbose)
% Retrieve the svn version of all root library in the matlab PATH 
%
% SYNTAX :
% VERSIONS = PSOM_VERSION_SVN( VERBOSE )
%
% _________________________________________________________________________
% INPUTS :
%   VERBOSE (boolean) (default false if output detected)
%   
% _________________________________________________________________________
% OUTPUTS:
%
%   VERSIONS
%       (structure) SVN.NAME Name of the svn lib.
%                   SVN.VERSION version number of the lib.
%                   SVN.PATH path of the svn root lib.
%                   SVN.INFO information from the function svnversion.
%
% _________________________________________________________________________
% COMMENTS : 
%
%
% Copyright (c) Christian L. Dansereau, Centre de recherche de l'Institut universitaire de gériatrie de Montréal, 2011.
% Maintainer : pbellec@bic.mni.mcgill.ca
% See licensing information in the code.
% Keywords : svn,version

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

if (nargout == 0) && ~exist('verbose','var')
    verbose = true;
elseif ~exist('verbose','var')
    verbose = false;
end

%%%%%%%%%%%%%%%%%
%%     SVN     %%
%%%%%%%%%%%%%%%%%
    
if verbose, tic,end
   
 k=0;
 
 output=path;
 svn_repositories=[];
 
 idx_line = strfind(output,':');
 
  for nb_line=1:size(idx_line,2)
    
    if nb_line == 1 
        str_path = output(1:idx_line(nb_line)-1);
    else
        str_path = output(idx_line(nb_line-1)+1:idx_line(nb_line)-1);
    end
    
    % Check if it is not a hiden path
    if isempty(strfind(str_path,'/.svn'))
    
        % Remove any filesep at the end of the path
        if strcmp(str_path(end),filesep)
            str_path = str_path(1:end-1);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        % put all paths in cells %
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        k=k+1;
        path_list{k}=str_path;
        
    end
  end
  
 n_root=0;
 for nb_line=1:size(path_list,2)
    
     str_path = path_list{nb_line};

        % Look if the path contain a .svn folder
        if (exist(cat(2,str_path,filesep,'.svn'),'dir') == 7)

            % Look if it's the root svn folder
            [parent_pathstr,parent_name,ext] = fileparts(str_path);

            if (exist(cat(2,parent_pathstr,filesep,'.svn'),'dir') == 7)
                % Do nothing!
                for idx=1:size(path_list,2)
                    detect_shortest_path(idx) = ~isempty(strmatch(path_list{idx},parent_pathstr));
                end
                if sum(detect_shortest_path) == 0
                    
                    % Find the real root dir
                    ppath = parent_pathstr;
                    flag_root = true;
                    while flag_root
                        % Look if it's the root svn folder
                        [ppath,pname,ext] = fileparts(ppath);
                        parent_name = cat(2,pname,'-',parent_name);
                        if (exist(cat(2,ppath,filesep,'.svn'),'dir') == 0)
                            flag_root = false;
                        end
                    end
                    
                    n_root=n_root+1;
                    svn(n_root) = get_info_svndir(str_path,parent_name,verbose);
                end
            else
                n_root=n_root+1;
                svn(n_root) = get_info_svndir(str_path,parent_name,verbose);
            end

        end
    
 end
 
if verbose, toc,end
end

%% sub function
function [svn]=get_info_svndir(rootpath,parent_name,verbose)

    [status,version]=system(cat(2,'svnversion ',rootpath,' 2>&1'));
    [status,info]=system(cat(2,'svn info ',rootpath,' 2>&1'));

    svn.name = parent_name;
    svn.version = version;
    svn.path = rootpath;
    svn.info = info;

    if verbose
        tmp_msg = cat(2,svn.name,': ',svn.version);
        tmp_msg(regexp(tmp_msg,'\n')) = '';
        fprintf('%s\n',tmp_msg);
    end
  
end
    
