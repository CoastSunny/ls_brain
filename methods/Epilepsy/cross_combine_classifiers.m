W=[];
[ua sa va]=svd(mean(A_S_iEEG,3));
[ub sb vb]=svd(mean(B_G_iEEG,3));
[ue se ve]=svd(mean(E_N_iEEG,3));
[uc sc vc]=svd(mean(C_R_iEEG,3));
[ud sd vd]=svd(mean(D_L_iEEG,3));
U=[ua(:,1) -ub(:,1) ue(:,1) uc(:,1) ud(:,1)];
[m iall]=sort(U);
% a=mean(mean(A_S_iEEG(:,31:33,:),2),3);
% b=mean(mean(B_G_iEEG(:,31:33,:),2),3);
% e=mean(mean(E_N_iEEG(:,31:33,:),2),3);
% c=mean(mean(C_R_iEEG(:,31:33,:),2),3);
% d=mean(mean(D_L_iEEG(:,31:33,:),2),3);
% U=[a -b e c d];
% [m iall]=sort((U));
%iall=(1:12)'*([1 1 1 1 1]);
W(:,:,1)=A_Siclsfr.W(iall(:,1),:);
W(:,:,2)=B_Giclsfr.W(iall(:,2),:);
W(:,:,3)=E_Niclsfr.W(iall(:,3),:);
W(:,:,4)=C_Riclsfr.W(iall(:,4),:);
W(:,:,5)=D_Liclsfr.W(iall(:,5),:);
% for i=1:5
%     for j=1:size(W,1)
%         W(j,:,:,i)=1/(m(j,i))*W(j,:,:,i);
%     end
% end

itest=1:numel(subj);
b=[];
for si=itest
    eval(['b(si)=' subj{si} 'iclsfr.b;']);
end
for si=itest
    itrain=setdiff(itest,si);
    %     itrain=[3];
    %itrain=setdiff(itrain,5);
    eval(['X=cat(3,' subj{si} '_iEEG,' subj{si} '_riEEG);'])
    X=X(iall(:,si),:,:);
    for i=1:size(X,1)
        
        %   X(i,:)=1/(m(i,si))*X(i,:);
        
        
    end
    labels=[];
    eval(['s_size=size(' subj{si} '_iEEG,3);'])
    eval(['r_size=size(' subj{si} '_riEEG,3);'])
    labels(1:s_size)=1;
    labels(s_size+1:(s_size+r_size))=-1;
    labels=labels';
    fclsfr.W=mean(W(:,:,itrain),3);
    fclsfr.b=mean(b(itrain));
    fclsfr.dim=3;
    f=applyLinearClassifier(X,fclsfr);
    r(si,si)=fperf(f,labels);
    
end
Q=[];
for si=itest
    eval(['X=cat(3,' subj{si} '_iEEG,' subj{si} '_riEEG);'])
    X=X(iall(:,si),:,:);
    for i=1:size(X,1)
        % X(i,:)=(m(i,si))*X(i,:);
    end
    
    labels=[];
    eval(['s_size=size(' subj{si} '_iEEG,3);']);
    eval(['r_size=size(' subj{si} '_riEEG,3);']);
    labels(1:s_size)=1;
    labels(s_size+1:(s_size+r_size))=-1;
    labels=labels';
  
    itrain=setdiff(itest,si);
    for sj=itest
        if si==sj
            %continue;
        end
        if si==2 && sj==1
        %W(:,:,sj)=W(:,:,sj);
        for j=1:12
      %      W(j,:,sj)=m(j,sj)/(m(j,si))*W(j,:,sj);
          
            %W(j,:,sj)=1/bbb(j)*W(j,:,sj);
           
          end
        end        
        
        fclsfr.W=(W(:,:,sj));
        fclsfr.b=b(sj);
        
        f=applyLinearClassifier(X,fclsfr);
        
        r(si,sj)=fperf(f,labels);
        F{si,sj}=f;
        
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
    rr(si)=fperf(ff',labels);
end











