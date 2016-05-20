W=[];

iall=(1:16)'*(ones(1,numel(subj)));
fpr_target=0.01;
itest=1:numel(subj);
dim=4;
Q=[];r=[];rr=[];
for si=itest
    eval(['X=cat(dim,' subj{si} '_fsEEG,' subj{si} '_frsEEG);'])
    X=X(iall(:,si),:,:,:);
    for i=1:size(X,1)
        % X(i,:)=(m(i,si))*X(i,:);
    end
    
    slabels=[];
    eval(['s_size=size(' subj{si} '_fsEEG,dim);']);
    eval(['r_size=size(' subj{si} '_frsEEG,dim);']);
    slabels(1:s_size)=1;
    slabels(s_size+1:(s_size+r_size))=-1;
    slabels=slabels';
    dv=[];
    classifiyall_cv_step2
    itrain=setdiff(itest,[si 1 5 6 8 9 10 13 16 19 20 21 25 26]);
   
    for sj=itest
        
        
        if si==sj
            count=0;
            
            for ssi=itrain
                
                count=count+1;
                eval(['fclsfr=' subj{ssi} 'fsclsfr;']);
                fclsfr.trX=fclsfr.trX(iall(:,ssi),:,:,:);
                dv(count,:)=applyNonLinearClassifier(X,fclsfr);
                
            end
            
            f=mean(dv,1)';
            temp=fperf(f,slabels);
            r2(si,sj)=temp.perf;
            rSS(si,:)=[1-temp.fpr temp.tpr];
            out=multitrial_performance(f,slabels,'all',1,'sav',1,1,0,0,[]);
%             fpr_idxs=find(out.fpr.sav<=fpr_target);
%             bias=out.bias(fpr_idxs(end));
            bias=0;
            temp=fperf(f+bias,slabels);
            rf(si,sj)=temp.perf;
            rfSS(si,:)=[1-temp.fpr temp.tpr];
            
        else
            
            eval(['fclsfr=' subj{sj} 'fsclsfr;']);
            fclsfr.trX=fclsfr.trX(iall(:,sj),:,:,:);
            f=applyNonLinearClassifier(X,fclsfr);            
            
            temp=fperf(f,slabels);
            r2(si,sj)=temp.perf;
           % F{si,sj}=f;
           
        end
    end
    
    temp=[];
    for sj=itrain
        
        temp=cat(2,temp,F{si,sj});
        
    end
    Q{si}=temp;
    [q iq]=max(abs(Q{si}'));
    ff=[];
    for i=1:size(Q{si},1)
        
        ff(i)=Q{si}(i,iq(i));
        
    end
    
    temp=fperf(ff',slabels);
    rr2(si)=temp.perf;
end











