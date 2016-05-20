W=[];

fpr_target=0.01;
itest=1:numel(subj);

Q=[];r=[];rr=[];
for si=itest
    eval(['X=' subj{si} '_HOF;'])
       
    labels=[];
    dim=4;
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
                eval(['clsfr=' subj{ssi} 'hofclsfr;']);
            
                dv(count,:)=applyNonLinearClassifier(X',clsfr);
                
            end
            
            f=mean(dv,1)';
            temp=fperf(f,labels);
            r(si,sj)=temp.perf
            rSS(si,:)=[1-temp.fpr temp.tpr];
%             out=multitrial_performance(f,labels,'all',1,'sav',1,1,0,0,[]);
%             fpr_idxs=find(out.fpr.sav<=fpr_target);
%             bias=out.bias(fpr_idxs(end));
%             temp=fperf(f+bias,labels);
%             rf(si,sj)=temp.perf;
%             rfSS(si,:)=[1-temp.fpr temp.tpr];
        else
            
            eval(['clsfr=' subj{sj} 'hofclsfr;']);
            
            f=applyNonLinearClassifier(X',clsfr);            
            
            temp=fperf(f,labels);
            r(si,sj)=temp.perf;
            F{si,sj}=f;
           
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
    
    temp=fperf(ff',labels);
    rr(si)=temp.perf;
end











