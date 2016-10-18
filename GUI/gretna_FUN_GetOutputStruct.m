function V_out=gretna_FUN_GetOutputStruct(V_in, OutputFile)
%   Just a function to generate the output file
%   Used by cellfun
V_out=V_in;
if numel(OutputFile)==1 %4D
    for i=1:numel(V_out)
        V_out{i}.fname=OutputFile{1};
        V_out{i}.n=[i, 1];
    end
else
    for i=1:numel(V_out)
        V_out{i}.fname=V_in{i}.fname;
    end
end
