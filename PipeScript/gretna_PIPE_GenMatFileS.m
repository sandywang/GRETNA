function S=gretna_PIPE_GenMatFileS(in)
M=load(in);
S=GenMatS(M, in);

function S=GenMatS(M, in)
[Path, File, Ext]=fileparts(in);
FileExt=[File, Ext];
S=[];
if isnumeric(M)
    S.File=in;
    S.Type='T';
    S.Alias=File;
    S.Size=size(M);
    S.Lab=sprintf('%s', FileExt);
    S.Mat=M;
    S.GrpID=1;
elseif isstruct(M)
    FN=fieldnames(M);
    for n=1:numel(FN)
        TmpM=M.(FN{n});
        if iscell(TmpM)
            TmpM=reshape(TmpM, [], 1);
            TmpC=cell(size(TmpM));
            for i=1:numel(TmpC)
                TmpS=[];
                TmpS.File=in;
                TmpS.Type='C';
                TmpS.Size=size(TmpM{i});
                TmpS.Lab=sprintf('%s: [%s]%s - %.5d',...
                    FileExt, TmpS.Type, FN{n}, i);
                TmpS.Alias=sprintf('%s_%s_%s%.5d', ...
                    File, TmpS.Type, FN{n}, i);
                TmpS.GrpID=1;
                TmpS.Mat=TmpM{i};
                TmpC{i, 1}=TmpS;
            end
            S=[S; TmpC];
        elseif isstruct(TmpM)
            SubFN=fieldnames(TmpM);
            TmpC=cell(size(SubFN));
            for i=1:numel(SubFN)
                TmpS=[];
                TmpS.File=in;
                TmpS.Type='S';
                TmpS.Size=size(TmpM.(SubFN{i}));
                TmpS.Lab=sprintf('%s: [%s]%s - %s',...
                    FileExt, TmpS.Type, FN{n}, SubFN{i});
                TmpS.Alias=sprintf('%s_%s_%s_%s',...
                    File, TmpS.Type, FN{n}, SubFN{i});
                TmpS.GrpID=1;
                TmpS.Mat=TmpM.(SubFN{i});
                TmpC{i, 1}=TmpS;
            end
            S=[S; TmpC];
        elseif isnumeric(TmpM)
            TmpS=[];
            TmpS.File=in;
            TmpS.Type='V';
            TmpS.Size=size(TmpM);
            TmpS.Lab=sprintf('%s: [%s]%s',...
                FileExt, TmpS.Type, FN{n});
            TmpS.Alias=sprintf('%s_%s_%s', File, TmpS.Type, FN{n});
            TmpS.GrpID=1;
            TmpS.Mat=TmpM;
            S=[S; {TmpS}];
        else
            warning('Error: Invalid Matrix Found, Check again!');
        end
    end
end

