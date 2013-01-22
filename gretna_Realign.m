function gretna_Realign(RealignBatch , HMLogDir , SubjName , EPIPath)
    if ~(exist(HMLogDir , 'dir')==7)
        mkdir(HMLogDir);
    end

    spm_jobman('run' , RealignBatch);
    HMFile=gretna_GetNeedFile(EPIPath , 'rp_*' , SubjName);
    HM=load(HMFile{1});
    HM(4:6) = HM(4:6).*180/pi;
    
    x=(1:size(HM , 1))';
    h=figure('Position',[1,1,1024,768]);
    subplot(2,1,1),plot(x,HM(:,1),x,HM(:,2),x,HM(:,3));
    title('Transtion');
    xlabel('Time Points');
    ylabel('mm');
    legend('x transtion','y transtion','z transtion','Location','Best');
    
    subplot(2,1,2),plot(x,HM(:,4),x,HM(:,5),x,HM(:,6));
    title('Rotation');
    xlabel('Time Point');
    ylabel('Degree');
    legend('pitch','roll','yaw','Location','Best');
    saveas(h,[HMLogDir , filesep , SubjName , '.jpg']);
    close(h);