function gretna_fc(DataList, LabMask, OutputName, DFCStruct)
    P=spm_vol(DataList);
    TimePoint=size(P , 1);
    PMask=spm_vol(LabMask);
    Mask=spm_read_vols(PMask);
    Mask=reshape(Mask , [] , 1);
    Node=max(Mask , [] ,  1);
 
    Volume=spm_read_vols(cell2mat(P));
    Volume=reshape(Volume , [] , TimePoint);   
    
    
    TimeCourse=zeros(TimePoint , Node);      
    for i=1:Node
        Pos= Mask==i;
        OneNodeTC=Volume(Pos , :);
        
        MeanTC=mean(OneNodeTC , 1);
        TimeCourse(:,i)=MeanTC;
    end
    r=corrcoef(TimeCourse);
    r=(r+r')/2;%Add by Sandy
    r(isnan(r))=0;
    r(r>=1)=1-1e-16;
    
    z=(0.5 * log((1 + r)./(1 - r)));

    [Path , File , Ext]=fileparts(OutputName);    
    if ~isempty(DFCStruct)
        DFCWin=DFCStruct.DFCWin;
        DFCStep=DFCStruct.DFCStep;
        
        WinNum=floor((TimePoint-DFCWin)./DFCStep)+1;
        
        for s=1:WinNum
            WinInd=((s-1)*DFCStep+1:(s-1)*DFCStep+DFCWin)';
            dTC=TimeCourse(WinInd, :);
            dr=corrcoef(dTC);
            dr=(dr+dr')/2;%Add by Sandy
            dr(isnan(dr))=0;
            dr(dr>=1)=1-1e-16;
    
            dz=(0.5 * log((1 + dr)./(1 - dr)));
            save(fullfile(Path, ['TimeCourse_', File, sprintf('_Win%.4d', s), Ext]),...
                'dTC' , '-ASCII', '-DOUBLE','-TABS');
            save(fullfile(Path, [File, sprintf('_Win%.4d', s), Ext]),...
                'dr', '-ASCII', '-DOUBLE','-TABS');
            save(fullfile(Path, ['z_', File, sprintf('_Win%.4d', s), Ext]),...
                'dz', '-ASCII', '-DOUBLE', '-TABS');            
        end
    end
    
    save(fullfile(Path, ['TimeCourse_', File, Ext]),...
        'TimeCourse' , '-ASCII', '-DOUBLE','-TABS');
    save(OutputName , 'r' , '-ASCII', '-DOUBLE','-TABS');
    save(fullfile(Path, ['z_', File, Ext]),...
        'z', '-ASCII', '-DOUBLE', '-TABS');