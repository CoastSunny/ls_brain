W=[];
%[U,G]=tucker(fx,[4 4 4 -1]);
iall=(1:20)'*(ones(1,numel(subj)));
fpr_target=0.1;
itest=1:numel(subj);
dim=4;

for si=itest
    eval(['X=cat(dim,' subj{si} '_fsEEG,' subj{si} '_frsEEG);'])
    
    y=tprod(U{1}(1:20,sels),[-1 1],X,[-1 2 3 4]);
    z=tprod(y,[1 -1 3 4],U{2}(:,self),[-1 2]);
    q=tprod(z,[1 2 -1 4],U{3}(:,selt),[-1 3]);
    
    labels=[];
    eval(['s_size=size(' subj{si} '_fsEEG,dim);']);
    eval(['r_size=size(' subj{si} '_frsEEG,dim);']);
    labels(1:s_size)=1;
    labels(s_size+1:(s_size+r_size))=-1;
    labels=labels';
    dv=[];
    itrain=setdiff(itest,[si]);
    
    for sj=itest
        if si==sj
            
            count=0;
            for ssi=itrain
                
                count=count+1;
                eval(['ftclsfr=' subj{ssi} 'fticlsfr;']);
                dv(count,:)=applyLinearClassifier(q,ftclsfr);
                dv(count,:)=dv(count,:)-mean(dv(count,:));
                
            end
            
            f=mean(dv,1)';
            temp=fperf(f,labels);
            rtsi(si,sj)=temp.perf;
            
            out=multitrial_performance(f,labels,'all',1,'sav',1,1,0,0,[]);
            fpr_idxs=find(out.fpr.sav<=fpr_target);
            bias=out.bias(fpr_idxs(end));
            %  bias=0;
            temp=fperf(f+bias,labels);
            rf(si,sj)=temp.perf;
        else
            
        end
    end
    
end











