function gretna_fc(DataList ,  LabMask , OutputName)
    P=spm_vol(DataList);
    TimePoint=size(P , 1);
    PMask=spm_vol(LabMask);
    Mask=spm_read_vols(PMask);
    Mask=reshape(Mask , [] , 1);
    Node=max(Mask , [] ,  1);
    TimeCourse=zeros(TimePoint , Node);
    for i=1:Node
        Pos= Mask==i;
        OneNodeTC=zeros(size(find(Pos~=0) , 1) , TimePoint);
        for t=1:TimePoint
            Volume=spm_read_vols(P{t});
            Volume=reshape(Volume , [] ,1 );
            OneNodeTC(:,t)=Volume(Pos);
        end
        OneNodeTC=OneNodeTC';
        
        MeanTC=mean(OneNodeTC , 2);
        TimeCourse(:,i)=MeanTC;
    end
    r=corrcoef(TimeCourse);
    r(isnan(r))=0;
    save(OutputName , 'r' , '-ASCII', '-DOUBLE','-TABS');
