W=[];

iall=(1:20)'*(ones(1,numel(subj)));
fpr_target=0.1;
itest=1:numel(subj);
dim=4;

for si=itest
    eval(['X=cat(dim,' subj{si} '_fsEEG,' subj{si} '_frsEEG);'])
    X=X(iall(:,si),:,:,:);
    for i=1:size(X,1)
        % X(i,:)=(m(i,si))*X(i,:);
    end
    
    labels=[];
    eval(['s_size=size(' subj{si} '_fsEEG,dim);']);
    eval(['r_size=size(' subj{si} '_frsEEG,dim);']);
    labels(1:s_size)=1;
    labels(s_size+1:(s_size+r_size))=-1;
    labels=labels';
    dv=[];
    % itrain=setdiff(itest,[si 1 5 6 8 9 10 13 16 19 20 21 25 26]);
    % itrain=setdiff(itest,[si 1 16 20 25]);
    
    for permtest=2:17
        itrain=setdiff(itest,[si]);
        tmp=nchoosek(itrain,permtest);
        tmp_idx=randi(size(tmp,1),1,min(50,size(tmp,1)));
        for idx=1:numel(tmp_idx)
            itrain=tmp(tmp_idx(idx),:);
            
            count=0;
            for ssi=itrain
                
                count=count+1;
                eval(['fclsfr=' subj{ssi} 'fsclsfr;']);
                fclsfr.trX=fclsfr.trX(iall(:,ssi),:,:,:);
                dv(count,:)=applyLinearClassifier(X,fclsfr);
                dv(count,:)=dv(count,:)-mean(dv(count,:));
                
            end
            
            f=mean(dv,1)';
            temp=fperf(f,labels);
            rp(si,idx,permtest)=temp.perf;                        
            
        end
    end
    
    
end











