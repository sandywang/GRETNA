function OutputFile=gretna_FUN_GetOutputFile(File, Prefix)
%   Just a function to generate the output file
%   Used by cellfun

[Path, Name, Ext]=fileparts(File);
OutputFile=fullfile(Path, [Prefix, Name, Ext]);