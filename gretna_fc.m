function gretna_fc(DataList ,  LabMask , OutputName)
    P=spm_vol(DataList);
    TimePoint=size(P , 1);
    PMask=spm_vol(LabMask);
    Mask=spm_read_vols(PMask);
    Mask=reshape(Mask , [] , 1);
    Node=max(Mask , [] ,  1);
    TimeCourse=zeros(TimePoint , Node);
    
    Volume=spm_read_vols(cell2mat(P));
    Volume=reshape(Volume , [] , TimePoint);
    
    
    for i=1:Node
        Pos= find(Mask==i);
        %OneNodeTC=zeros(size(Pos , 1) , TimePoint);
        %for t=1:TimePoint
        %    Volume=spm_read_vols(P{t});
        %    Volume=reshape(Volume , [] ,1 );
        %    OneNodeTC(:,t)=Volume(Pos);
        %end
        
        OneNodeTC=Volume(Pos , :);
        
        MeanTC=mean(OneNodeTC , 1);
        TimeCourse(:,i)=MeanTC;
    end
    r=corrcoef(TimeCourse);
    r(isnan(r))=0;
    [Path , File , Ext]=fileparts(OutputName);
    save([Path , filesep , 'TimeCourse_' , File , Ext] ,...
        'TimeCourse' , '-ASCII', '-DOUBLE','-TABS');
    save(OutputName , 'r' , '-ASCII', '-DOUBLE','-TABS');
