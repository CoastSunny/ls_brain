%% housekeeping

losstype='bal';
kerType='linear';
par1=[];par2=[];
Cs=5.^[3:-1:-3];
nfolds=5;

idx_control=subject_identifier(used_subjects==1)==0;
idx_patient=subject_identifier(used_subjects==1)==1;
fidx_control=find(subject_identifier(used_subjects==1)==0);
fidx_patient=find(subject_identifier(used_subjects==1)==1);

%% frequency spectrum classifier, whole group


 %%
for si=1:23
    
    fsA=cat(1,Freq{setdiff(fidx_patient,si)});
    fsC=cat(1,Freq{setdiff(fidx_control,si)});
    labels=[ones(1,size(fsA,1)) -ones(1,size(fsC,1))];
    fsD=cat(1,fsA,fsC);fsD=permute(fsD,[2 3 1]);
    [fsclsfr, fsres]=cvtrainLinearClassifier(fsD,labels,Cs,nfolds,'dim',3,'balYs',1);%,options);
    f=applyLinearClassifier(permute(Freq{si},[2 3 1]),fsclsfr);%f=f-mean(f);
    if sum(si==fidx_patient)>0
        R(si,1)=sum(f>0)/numel(f);
    else
        R(si,1)=sum(f<=0)/numel(f);
    end
    

    csA=cat(3,Conn{setdiff(fidx_patient,si)});
    csC=cat(3,Conn{setdiff(fidx_control,si)});
    labels=[ones(1,size(csA,3)) -ones(1,size(csC,3))];
    csD=cat(3,csA,csC);
    [csclsfr, csres]=cvtrainLinearClassifier(csD,labels,Cs,nfolds,'dim',3,'balYs',1);
    f=applyLinearClassifier(Conn{si},csclsfr);
    if sum(si==fidx_patient)>0
        R(si,2)=sum(f>0)/numel(f);
    else
        R(si,2)=sum(f<=0)/numel(f);
    end
    
    [tF,tG]=tucker(csD,[4 4 -1],[],[0 0 -1]);
    [tsclsfr, tsres]=cvtrainLinearClassifier(tG,labels,Cs,nfolds,'dim',3,'balYs',1);    
    y=tprod(tF{1}(:,:),[-1 1],Conn{si},[-1 2 3]);
    z=tprod(y,[1 -1 3],tF{2}(:,:),[-1 2]);
    f=applyLinearClassifier(z,tsclsfr);
    if sum(si==fidx_patient)>0
        R(si,3)=sum(f>0)/numel(f);
    else
        R(si,3)=sum(f<=0)/numel(f);
    end
    R
end


