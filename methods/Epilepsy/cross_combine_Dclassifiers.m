W=[];

iall=(1:20)'*(ones(1,numel(subj)));
fpr_target=0.1;
itest=1:numel(subj);
dim=3;
Q=[];rd=[];rr=[];
for si=itest
    eval(['X=cat(dim,' subj{si} '_sEEG,' subj{si} '_rsEEG);'])
    X=X(iall(:,si),:,:,:);
    Xtst=reshape(permute(X,[2 1 3]),[],size(X,3));%Xs=normc(Xs);
    G=computeKernelMatrix(Xs,Xtst,optionKSRDL);
    B=computeKernelMatrix(Xtst,Xtst,optionKSRDL);
    DtTestSet=pinvYo'*G;
    dZ=KSRSC(DtDo,DtTestSet,diag(B),optionKSRDL);
    
    for i=1:size(X,1)
        % X(i,:)=(m(i,si))*X(i,:);
    end
    
    labels=[];
    eval(['s_size=size(' subj{si} '_fiEEG,dim);']);
    eval(['r_size=size(' subj{si} '_friEEG,dim);']);
    labels(1:s_size)=1;
    labels(s_size+1:(s_size+r_size))=-1;
    labels=labels';
    dv=[];
   % itrain=setdiff(itest,[si 1 5 6 8 9 10 13 16 19 20 21 25 26]); 
   % itrain=setdiff(itest,[si 1 16 20 25]);
    itrain=setdiff(itest,[si]);
    for sj=itest
        if si==sj
            count=0;
            
            for ssi=itrain
                
                count=count+1;
                eval(['fclsfr=' subj{ssi} 'dsclsfr;']);
                fclsfr.trX=fclsfr.trX(iall(:,ssi),:,:,:);
                dv(count,:)=applyLinearClassifier(dZ,fclsfr);
                dv(count,:)=dv(count,:)-mean(dv(count,:));
                
            end
            
            f=mean(dv,1)';
            temp=fperf(f,labels);
            rd(si,sj)=temp.perf;
             rdSS(si,:)=[1-temp.fpr temp.tpr];
%             out=multitrial_performance(f,labels,'all',1,'sav',1,1,0,0,[]);
%             fpr_idxs=find(out.fpr.sav<=fpr_target);
%             bias=out.bias(fpr_idxs(end));
%           %  bias=0;
%             temp=fperf(f+bias,labels);
%             rf(si,sj)=temp.perf;
%             rfSS(si,:)=[1-temp.fpr temp.tpr];
        else
            
%             eval(['fclsfr=' subj{sj} 'fsclsfr;']);
%             fclsfr.trX=fclsfr.trX(iall(:,sj),:,:,:);
%             f=applyNonLinearClassifier(X,fclsfr);            
%             
%             temp=fperf(f,labels);
%             rt(si,sj)=temp.perf;
%             Ft{si,sj}=f;
%            
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
%     
%     temp=fperf(ff',labels);
%     rr(si)=temp.perf;

end











