function gretna_GUI_ResultsSettle(MatList, OutName)
TempMat=load(MatList{1});
FieldNames=fieldnames(TempMat);

%%Matlist Loop
Result=[];
ModFlag=false;
for j=1:numel(FieldNames)
    f=FieldNames{j};
    
    
    if strcmpi(f, 'module_property')% iscell(TempMat.(f))
        ModFlag=true;
        continue;
    end
    
    n1=size(TempMat.(f), 1);
    n2=size(TempMat.(f), 2);
    if n1>1 && n2>1 %&& ~strcmpi(f, 'community_index')
        %for i=1:n1
        %    Result.(sprintf('%s_Node%.4d', f, i))=...
        %        cell2mat(cellfun(@(m) GetVariable(m, f, i), MatList,...
        %            'UniformOutput', false));
        %end
        
        for i=1:n2
            Result.(sprintf('%s_Thres%.4d', f, i))=...
                cell2mat(cellfun(@(m) GetVariable2(m, f, i), MatList,...
                    'UniformOutput', false));
        end        
    end
    
    if n1==1 && n2>1
        Result.(sprintf('%s_All_Threshold', f))=cell2mat(cellfun(@(m) GetVariable(m, f), MatList,...
            'UniformOutput', false));
    end
    
    if n2==1 && n1>1
        if strcmpi(f, 'phi_real') || strcmpi(f, 'phi_norm')
            Result.(sprintf('%s_All_K', f))=cell2mat(cellfun(@(m) GetVariable2(m, f), MatList,...
                'UniformOutput', false));           
        else
            Result.(sprintf('%s_All_Node', f))=cell2mat(cellfun(@(m) GetVariable2(m, f), MatList,...
                'UniformOutput', false));
        end
    end
    
    if n1==1 && n2==1
        Result.(f)=cell2mat(cellfun(@(m) GetVariable2(m, f), MatList,...
            'UniformOutput', false));
    end
end

ResultFields=fieldnames(Result);

Path=fileparts(OutName);
if exist(Path, 'dir')~=7
    mkdir(Path);
end

for j=1:numel(ResultFields)
    save(fullfile(Path, sprintf('%s.txt', ResultFields{j})),...
        '-struct', 'Result', ResultFields{j},...
        '-ASCII', '-DOUBLE', '-TABS');
end

if exist(OutName, 'file')==2
    delete(OutName);
end
save(OutName, '-struct', 'Result');

if ModFlag
    module_property=[];
    for i=1:numel(MatList)
        TmpStruct=load(MatList{i}, 'module_property');
        module_property=[module_property; TmpStruct.('module_property')];
    end
    save(OutName, 'module_property', '-append');
end

function Output=GetVariable(MatName, FieldName, Row)
if exist('Row', 'var')~=1
    Row=1;
end

Mat=load(MatName);
Output=Mat.(FieldName)(Row, :);

function Output=GetVariable2(MatName, FieldName, Col)
if exist('Col', 'var')~=1
    Col=1;
end

Mat=load(MatName);
Output=Mat.(FieldName)(:, Col)';
