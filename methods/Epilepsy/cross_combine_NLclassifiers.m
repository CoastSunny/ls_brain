

itest=1:numel(subj);
dim=3;
Q=[];
for si=itest
    eval(['X=cat(dim,' subj{si} '_sEEG,' subj{si} '_rsEEG);'])
    X=X(iall(:,si),:,:);
    for i=1:size(X,1)
        % X(i,:)=(m(i,si))*X(i,:);
    end
    
    labels=[];
    eval(['s_size=size(' subj{si} '_iEEG,dim);']);
    eval(['r_size=size(' subj{si} '_riEEG,dim);']);
    labels(1:s_size)=1;
    labels(s_size+1:(s_size+r_size))=-1;
    labels=labels';
    dv=[];
    itrain=setdiff(itest,si);
    for sj=itest
        if si==sj
            count=0;
            
            for ssi=itrain
                count=count+1;
                eval(['fclsfr=' subj{ssi} 'sclsfr;']);
                fclsfr.trX=fclsfr.trX(iall(:,ssi),:,:);
                dv(count,:)=applyLinearClassifier(X,fclsfr);
                dv(count,:)=dv(count,:)-mean(dv(count,:));
                
            end
            
            f=mean(dv,1)';
            temp=fperf(f,labels);
            rt(si,sj)=temp.perf;
            
        else
            
%             eval(['fclsfr=' subj{sj} 'sclsfr;']);
%             fclsfr.trX=fclsfr.trX(iall(:,sj),:,:);
%             f=applyNonLinearClassifier(X,fclsfr);
%             
%             temp=fperf(f,labels);
%             rt(si,sj)=temp.perf;
%             F{si,sj}=f;
        end
    end
    
%     temp=[];
%     for sj=itrain
%         
%         temp=cat(2,temp,F{si,sj});
%         
%     end
%     Q{si}=temp;
%     [q iq]=max(abs(Q{si}'));
%     ff=[];
%     for i=1:size(Q{si},1)
%         
%         ff(i)=Q{si}(i,iq(i));
%         
%     end
%     temp=fperf(ff',labels);
%     rrt(si)=temp.perf;
end











