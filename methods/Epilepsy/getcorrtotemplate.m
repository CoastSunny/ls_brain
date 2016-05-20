CX=[];
CRX=[];
cX=[];
cRX=[];
for si=1:numel(subj)
    
    for ci=1:numel(subj)
        
        eval(['sEEG=' subj{ci} '_sEEG;']);
        X=mean(sEEG,3);
        for tr=1:size(TPX{si},3)
            temp=corrcoef(vec(TPX{si}(:,:,tr)),vec(X));
            cX(ci,tr)=temp(1,2);
            dX(ci,tr)=norm(TPX{si}(:,:,tr)-X,'fro');
            temp=corrcoef(vec(TPRX{si}(:,:,tr)),vec(X));
            cRX(ci,tr)=temp(1,2);
            dRX(ci,tr)=norm(TPRX{si}(:,:,tr)-X,'fro');
        end
        CX(si,ci)=mean(cX(ci,:),2);
        CRX(si,ci)=mean(cRX(ci,:),2);
        DX(si,ci)=mean(dX(ci,:),2);
        DRX(si,ci)=mean(dRX(ci,:),2);
        cX=[];dX=[];
        cRX=[];dRX=[];
    end
    
end