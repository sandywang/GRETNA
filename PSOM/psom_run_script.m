function [flag_failed,msg] = psom_run_script(cmd,script,opt,logs)
% Run an Octave/Matlab command in a script 
%
% SYNTAX:
% [FLAG_FAILED,MSG] = PSOM_RUN_SCRIPT(CMD,SCRIPT,OPT,LOGS)
%
%_________________________________________________________________________
% INPUTS:
%
% CMD
%    (string) A Matlab/Octave command. If it is empty, it is still possible 
%    to run a command using OPT.SHELL_OPTIONS below.
%
% SCRIPT
%    (string) The name of the script that will be generated to run the 
%    command (except if OPT.MODE is 'session', in which case no script is
%    generated to execute the command and SCRIPT is ignored).
%
% OPT
%    (structure) describes how to execute the command.
%
%    NAME_JOB
%        (string, default 'psom_script') This name is used when submitting
%        the script in 'qsub' or 'msub' execution modes (see below).
%
%    MODE
%        (string) the execution mechanism. Available 
%        options :
%        'session'    : current Matlab session.
%        'background' : background execution, non-unlogin-proofed 
%                       (asynchronous system call).
%        'batch'      : background execution, unlogin-proofed ('at' in 
%                       UNIX, start in WINDOWS.
%        'qsub'       : remote execution using qsub (torque, SGE, PBS).
%        'msub'       : remote execution using msub (MOAB)
%        'condor'     : remote execution using condor
%
%    SHELL_OPTIONS
%       (string, default GB_PSOM_SHELL_OPTIONS defined in PSOM_GB_VARS)
%       some commands that will be added at the begining of the shell
%       script. This can be used to set important variables, or source an 
%       initialization script.
%
%    QSUB_OPTIONS
%        (string, GB_PSOM_QSUB_OPTIONS defined in PSOM_GB_VARS)
%        This field can be used to pass any argument when submitting a
%        job with qsub/msub. For example, '-q all.q@yeatman,all.q@zeus'
%        will force qsub/msub to only use the yeatman and zeus
%        workstations in the all.q queue. It can also be used to put
%        restrictions on the minimum avalaible memory, etc.
%
%    COMMAND_MATLAB
%        (string, default GB_PSOM_COMMAND_MATLAB or
%        GB_PSOM_COMMAND_OCTAVE depending on the current environment)
%        how to invoke matlab (or OCTAVE).
%        You may want to update that to add the full path of the command.
%        The defaut for this field can be set using the variable
%        GB_PSOM_COMMAND_MATLAB/OCTAVE in the file PSOM_GB_VARS.
%
%    INIT_MATLAB
%        (string, GB_PSOM_INIT_MATLAB defined in PSOM_GB_VARS) a matlab 
%        command (multiple commands can actually be passed using comma 
%        separation) that will be executed at the begining of any 
%        matlab/Octave job.
%
%    PATH_SEARCH
%        (string, default GB_PSOM_PATH_SEARCH in the file PSOM_GB_VARS). 
%        If PATH_SEARCH is empty, the current path is used. If 
%        PATH_SEARCH equals 'gb_psom_omitted', then PSOM will not attempt 
%        to set the search path, i.e. the search path for every job will 
%        be the current search path in 'session' mode, and the default 
%        Octave/Matlab search path in the other modes. 
%
%    FLAG_SHORT_JOB_NAMES
%        (boolean, default true) only the 8 first characters of a job 
%        name are used to submit to qsub/msub. Most qsub systems truncate
%        the name of the job anyway, and some systems even refuse to
%        submit jobs with long names.
%
%    FLAG_DEBUG
%        (boolean, default false) if FLAG_DEBUG is true, the program
%        prints additional information for debugging purposes.
%
%    FILE_HANDLE
%        (scalar, default []) if non-empty, the handle of a text file 
%        where all verbose will be appended.
%
% LOGS
%    (structure, optional) Indicates where to save the logs. If 
%    unspecified, no log is generated. LOGS can have the following 
%    fields:
%
%    TXT
%        (string) where the text log file will be saved.
%
%    EQSUB
%        (string) where the error log file from QSUB will be generated.
%        This is only required in 'qsub' and 'msub' and 'condor' modes.
%
%    OQSUB
%        (string) where the output log file from QSUB will be generated.
%        This is only required in 'qsub' and 'msub' and 'condor' modes.
%
%    FAILED
%        (string) the name of a tag file to indicate that the job has
%        failed in case the submission was not successful.
%        This is only required in 'qsub' and 'msub' and 'condor' modes.
%
%    EXIT
%        (string) the name of an empty file that will be generated 
%        when the script is finished. 
% 
%_________________________________________________________________________
% OUTPUTS:
%
% FLAG_FAILED
%    (boolean) FLAG_FAILED is true if the script has failed. 
%
% MSG
%    (string) the output of the script.
%         
% _________________________________________________________________________
% COMMENTS:
%
% The function will automatically use Matlab (Octave) to execute the 
% commmand in the specified mode. In all modes but 'session', this involves
% the generation of a script which runs a new Matlab (Octave) session.
%
% The following files are generated:
%   * A script to run the command calling matlab (except in 'session' mode)
%   * A .mat file with the search path (same as script, with an '_path.mat'
%     extension. That's if OPT.PATH_SEARCH is not used to directly specify 
%     a search path. (except in 'session' mode)
%   * A text log file (if LOGS.TXT is used)
%   * A text log file from qsub (if LOGS.OQSUB is used, in qsub/msub modes)
%   * A text error file from qsub (if LOGS.EQSUB is used, in qsub/msub modes)
%   * A "failed" tag file (if LOGS.FAILED is used, in qsub/msub modes)
%   * A tag file (upon completion of the script, if LOGS.EXIT is used)
%
% Copyright (c) Pierre Bellec, Montreal Neurological Institute, 2008-2010.
% Departement d'informatique et de recherche operationnelle
% Centre de recherche de l'institut de Geriatrie de Montreal
% Universite de Montreal, 2010-2012.
% Maintainer : pierre.bellec@criugm.qc.ca
% See licensing information in the code.
% Keywords : pipeline

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

%% Check syntax
if nargin<3
    error('SYNTAX: [] = PSOM_RUN_SCRIPT(CMD,SCRIPT,OPT,LOGS). Type ''help psom_run_script'' for more info.')
end

%% Options
list_fields    = { 'flag_short_job_names' , 'path_search'       , 'file_handle' , 'name_job'    , 'init_matlab'       , 'flag_debug' , 'shell_options'       , 'command_matlab' , 'mode' , 'qsub_options'       };
list_defaults  = { true                   , gb_psom_path_search , []            , 'psom_script' , gb_psom_init_matlab , false        , gb_psom_shell_options , ''               , NaN    , gb_psom_qsub_options };
opt = psom_struct_defaults(opt,list_fields,list_defaults);

if opt.flag_debug
    msg = sprintf('\n    The execution mode is %s\n',opt.mode);
    fprintf(msg);
    if ~isempty(opt.file_handle)
        fprintf(opt.file_handle,'%s',msg);
    end
end

if isempty(opt.path_search)
    opt.path_search = path;
end

if ~isempty(opt.init_matlab)&&~ismember(opt.init_matlab(end),{',',';'})
    opt.init_matlab = [opt.init_matlab ','];
end

if isempty(opt.command_matlab)
    if strcmp(gb_psom_language,'matlab')
        opt.command_matlab = gb_psom_command_matlab;
    else
        opt.command_matlab = gb_psom_command_octave;
    end
end

%% Logs
if nargin < 4
    logs = [];
else
    list_fields   = { 'txt' , 'eqsub' , 'oqsub' , 'failed' , 'exit' };
    if ismember(opt.mode,{'qsub','msub','condor'})
        list_defaults = { NaN   , NaN     , NaN     , NaN    , ''     };
    else
        list_defaults = { NaN   , ''      , ''      , ''     , ''     };
    end
    logs = psom_struct_defaults(logs,list_fields,list_defaults);
end

%% Check that the execution mode exists
if ~ismember(opt.mode,{'session','background','batch','qsub','msub','condor'})
    error('%s is an unknown mode of command execution. Sorry dude, I must quit ...',opt.mode);
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate the script %%
%%%%%%%%%%%%%%%%%%%%%%%%%

%% Generate some OS-appropriate options to start Matlab/Octave
switch gb_psom_language
    case 'matlab'
        if ispc
            opt_matlab = '-automation -nodesktop -r';
        else
            opt_matlab = '-nosplash -nodesktop -r';
        end        
    case 'octave'
        opt_matlab = '--silent --eval';       
end

%% Set-up the search path for the job
if ~strcmp(opt.mode,'session')&&~isempty(cmd)
    if (length(opt.path_search)>4)&&(strcmp(opt.path_search(end-3:end),'.mat'))
        file_path = opt.path_search;
    else
        [path_f,name_f] = fileparts(script);
        file_path = fullfile(path_f,[name_f '_path.mat']);
        path_work = opt.path_search;
        save(file_path,'path_work');
    end 
    opt.init_matlab = [sprintf('load(''%s'',''path_work''), if ~ismember(path_work,{''gb_niak_omitted'',''gb_psom_omitted''}), path(path_work), end,',file_path) opt.init_matlab];
else
    file_path = '';
end
        
%% Add an appropriate call to Matlab/Octave
if ~isempty(cmd)            
    instr_job = sprintf('"%s" %s "%s %s,exit"',opt.command_matlab,opt_matlab,opt.init_matlab,cmd);
    if ~isempty(logs)
        if opt.flag_debug
            instr_job = sprintf('%s >"%s" 2>&1\n',instr_job,logs.txt);
        else
            instr_job = sprintf('%s >"%s"\n',instr_job,logs.txt);
        end
    else
        instr_job = sprintf('%s\n',instr_job);
    end
else
    instr_job = '';
end
        
%% Add shell options
if ~isempty(opt.shell_options)
    instr_job = sprintf('%s\n%s',opt.shell_options,instr_job);
end    

%% Add a .exit tag file
if ~isempty(logs)&&~isempty(logs.exit)
    if ispc % this is windows
        instr_job = sprintf('%stype nul > "%s"\nexit\n',instr_job,logs.exit);
    else
        instr_job = sprintf('%stouch "%s"',instr_job,logs.exit);
    end
else
    if ispc
        instr_job = sprintf('%sexit\n',instr_job);
    end
end

%% Write the script
if ~strcmp(opt.mode,'session')            
    if opt.flag_debug
        msg = sprintf('    This is the content of the script used to run the command :\n"\n%s\n"\n',instr_job);
        if ~strcmp(opt.path_search,'gb_niak_omitted')&&~isempty(cmd)
            msg = sprintf('%s    The following matlab search path is used (may be truncated):\n%s\n',msg,opt.path_search(1:min(100,length(opt.path_search))));
            msg = sprintf('%s    The search path will be loaded from the following file:\n%s\n',msg,file_path);
        end
        fprintf('%s',msg);
        if ~isempty(opt.file_handle)
            fprintf(opt.file_handle,'%s',msg);
        end
    end
    
    hf = fopen(script,'w');
    fprintf(hf,'%s',instr_job);
    fclose(hf);
else
    if opt.flag_debug
        msg = sprintf('    The following command is going to be executed :\n%s\n\n',cmd);
        fprintf('%s',msg);
        if ~isempty(opt.file_handle)
            fprintf(opt.file_handle,'%s',msg);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%   
%% Execute the script %%
%%%%%%%%%%%%%%%%%%%%%%%%

switch opt.mode

    case 'session'

        try
            if ~isempty(logs)
                diary(logs.txt);
                sub_eval(cmd);
                diary off;
            else
                sub_eval(cmd);
            end
            flag_failed = false;
            msg = '';
        catch
            flag_failed = true;
            errmsg = lasterror;
            msg = errmsg.message;
            if isfield(errmsg,'stack')
                for num_e = 1:length(errmsg.stack)
                    msg = sprintf('%s\nFile %s at line %i\n',msg,errmsg.stack(num_e).file,errmsg.stack(num_e).line);
                end           
            end
        end
        if ~isempty(logs.exit)
            save(logs.exit,'flag_failed')
        end

    case 'background'

       if ispc
            cmd_script = ['"' script '"']; % /min instead of /b ?
       else
            cmd_script = ['. "' script '"'];
       end

       if opt.flag_debug
           if strcmp(gb_psom_language,'octave')
               cmd_script = [cmd_script ' 2>&1']; % In octave, the error stream is lost. Redirect it to standard output
           end
           msg = sprintf('    The script is executed using the command :\n%s\n\n',cmd_script);
           fprintf('%s',msg);
           if ~isempty(opt.file_handle)
               fprintf(opt.file_handle,'%s',msg);
           end
           [flag_failed,msg] = system(cmd_script);
       else
           if strcmp(gb_psom_language,'octave')
               system(cmd_script,false,'async');
               flag_failed = 0;
           else 
               flag_failed = system([cmd_script ' &']);
           end
           msg = '';
       end

    case 'batch'

        if ispc
            instr_batch = sprintf('start /min "%s" "%s"',opt.name_job,script); 
        else
            instr_batch = ['at -f "' script '" now'];
        end
        if strcmp(gb_psom_language,'octave')
            instr_batch = [instr_batch ' 2>&1']; % In octave, the error stream is lost. Redirect it to standard output
        end
        if opt.flag_debug 
            msg = sprintf('    The script is executed using the command :\n%s\n\n',instr_batch);
            fprintf('%s',msg);
            if ~isempty(opt.file_handle)
                fprintf(opt.file_handle,'%s',msg);
            end
        end
        [flag_failed,msg] = system(instr_batch);    
        
    case {'qsub','msub','condor'}
        script_submit = [gb_psom_path_psom 'psom_submit.sh'];
        switch opt.mode
            case {'qsub','msub'}
                sub = opt.mode;
            case 'condor'
                sub = [gb_psom_path_psom 'psom_condor.sh'];
        end
        if ~isempty(logs)
            qsub_logs = [' -e \"' logs.eqsub '\" -o \"' logs.oqsub '\"'];
        else 
            qsub_logs = '';
        end
        if opt.flag_short_job_names
            name_job = opt.name_job(1:min(length(opt.name_job),8));
        else
            name_job = opt.name_job;
        end
        instr_qsub = sprintf('%s%s -N %s %s %s',sub,qsub_logs,name_job,opt.qsub_options,['\"' script '\"']);            
        if ~isempty(logs)
            instr_qsub = [script_submit ' "' instr_qsub '" ' logs.failed ' ' logs.exit ' ' logs.oqsub ];
        end
        if opt.flag_debug
            if strcmp(gb_psom_language,'octave')
                instr_qsub = [instr_qsub ' 2>&1']; % In octave, the error stream is lost. Redirect it to standard output
            end
            msg = sprintf('    The script is executed using the command :\n%s\n\n',instr_qsub);
            fprintf('%s',msg);
            if ~isempty(opt.file_handle)
                fprintf(opt.file_handle,'%s',msg);
            end
            [flag_failed,msg] = system(instr_qsub);
        else 
            if strcmp(gb_psom_language,'octave')
                system([instr_qsub ' > /dev/null'],false,'async');
                flag_failed = 0;
            else
                flag_failed = system([instr_qsub ' > /dev/null &']);
            end
            msg = '';
        end
end

%%%%%% Subfunctions %%%%%%

function [] = sub_eval(cmd)
eval(cmd)
