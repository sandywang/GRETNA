function V_out=gretna_FUN_GetOutputStruct(V_in, OutputFile, DataType)
%   Just a function to generate the output file
%   Used by cellfun
V_out=V_in;
Dt=V_out{1}.dt;
if exist('DataType', 'var')==1
    Dt=[spm_type(DataType), 0];
end
if numel(OutputFile)==1 %4D
    for i=1:numel(V_out)
        V_out{i}.fname=OutputFile{1};
        V_out{i}.n=[i, 1];
        V_out{i}.dt=Dt;
    end
else
    for i=1:numel(V_out)
        V_out{i}.fname=V_in{i}.fname;
        V_out{i}.dt=Dt;
    end
end
