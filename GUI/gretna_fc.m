function gretna_fc(DataList, LabMask, OutputName, DFCStruct)
    P=spm_vol(DataList);
    TimePoint=size(P , 1);
    PMask=spm_vol(LabMask);
    Mask=spm_read_vols(PMask);
    [n1, n2, n3]=size(Mask);
    Mask=reshape(Mask , [] , 1);
    NodeNum=max(Mask , [] ,  1);
     
    Volume=spm_read_vols(cell2mat(P));
    Volume=reshape(Volume , [] , TimePoint);   
    
    TimeCourse=zeros(TimePoint , NodeNum);      
    NodePos=zeros(NodeNum, 3);
    for n=1:NodeNum
        Ind= Mask==n;
        [I, J, K]=ind2sub([n1, n2, n3], find(Ind));
        I=mean(I);
        J=mean(J);
        K=mean(K);
        TmpIJK=[I; J; K; 1];
        
        TmpXYZ=PMask.mat*TmpIJK;
        NodePos(n, :)=TmpXYZ(1:3);
        
        OneNodeTC=Volume(Ind , :);
        
        MeanTC=mean(OneNodeTC , 1);
        TimeCourse(:,n)=MeanTC;
    end
    r=corrcoef(TimeCourse);
    r=(r+r')/2;%Add by Sandy
    r(isnan(r))=0;
    r(r>=1)=1-1e-16;
    
    z=(0.5 * log((1 + r)./(1 - r)));

    [Path , File , Ext]=fileparts(OutputName);
    
    %Output the node file of lab mask
    [LabPath, LabFile, LabExt]=fileparts(LabMask);
    NodeFile=fullfile(Path, [LabFile, '_Example.node']);
    if exist(NodeFile, 'file')~=2
        NodeColor=ones(NodeNum, 1);
        NodeSize=ones(NodeNum, 1);
        NodeLab=cell(NodeNum, 1);
        NodeLab=cellfun(@ (l) '-', NodeLab, 'UniformOutput', false);
    
        gretna_gen_node_file(NodePos, NodeColor, NodeSize, NodeLab, NodeFile);
    end
    
    if ~isempty(DFCStruct)
        DFCWin=DFCStruct.DFCWin;
        DFCStep=DFCStruct.DFCStep;
        
        WinNum=floor((TimePoint-DFCWin)./DFCStep)+1;
        
        dr_struct=[];
        dTC_struct=[];
        dz_struct=[];
        for s=1:WinNum
            First=(s-1)*DFCStep+1;
            Last=(s-1)*DFCStep+DFCWin;
            WinInd=(First:Last)';
            Tag=sprintf('W_%.4d_%.4d', First, Last);
            dTC=TimeCourse(WinInd, :);
            dr=corrcoef(dTC);
            dr=(dr+dr')/2;%Add by Sandy
            dr(isnan(dr))=0;
            dr(dr>=1)=1-1e-16;
    
            dz=(0.5 * log((1 + dr)./(1 - dr)));
            
            dr_struct.(Tag)=dr;
            %dTC_struct.(Tag)=dTC;
            dz_struct.(Tag)=dz;
            
            %save(fullfile(Path, ['TimeCourse_', Tag, '_', File, Ext]),...
            %    'dTC' , '-ASCII', '-DOUBLE','-TABS');
            %save(fullfile(Path, [Tag, '_', File, Ext]),...
            %    'dr', '-ASCII', '-DOUBLE','-TABS');
            %save(fullfile(Path, ['z_', Tag, '_', File, Ext]),...
            %    'dz', '-ASCII', '-DOUBLE', '-TABS');            
        end
        save(fullfile(Path, ['TimeCourse_W-All_', File, '.mat']), 'dr_struct');        
        save(fullfile(Path, ['W-All_', File, '.mat']), 'dr_struct');
        save(fullfile(Path, ['z_W-All_', File, '.mat']), 'dz_struct');        
    end
    
    save(fullfile(Path, ['TimeCourse_', File, Ext]),...
        'TimeCourse' , '-ASCII', '-DOUBLE','-TABS');
    save(OutputName , 'r' , '-ASCII', '-DOUBLE','-TABS');
    save(fullfile(Path, ['z_', File, Ext]),...
        'z', '-ASCII', '-DOUBLE', '-TABS');
    
