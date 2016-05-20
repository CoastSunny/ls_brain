w=[];b=[];
itest=1:numel(subj);
for si=itest
    
    eval(['F=' subj{si} '_F;'])
    eval(['labels=' subj{si} 'labels;'])
    S=cov(F);
    Fp=F(labels==1,:);
    Fn=F(labels==-1,:);
    Mp=mean(Fp,1);%sum(Mp)/numel(Mp)
    Mn=mean(Fn,1);%sum(Mn)/numel(Mn)
    w(:,si)=inv(S)*(Mp-Mn)';
    b(si)=1/2*(Mp*inv(S)*Mp'-Mn*inv(S)*Mn');
    %    w(:,si)=2*inv(S)*(-Mn)';
    out=fperf(F*w(:,si),labels');
    wcr(si)=out.perf;
end

[m iall]=sort(w);
iall=(1:16)'*([1 1 1 1 1 1 1 1 1]);
dim=4;
Q=[];
dv=[];
for si=itest
    eval(['X=cat(dim,' subj{si} '_fsEEG,' subj{si} '_frsEEG);'])
    X=X(iall(:,si),:,:,:);
    labels=[];
    eval(['s_size=size(' subj{si} '_fsEEG,dim);']);
    eval(['r_size=size(' subj{si} '_frsEEG,dim);']);
    labels(1:s_size)=1;
    labels(s_size+1:(s_size+r_size))=-1;
    labels=labels';
    
    itrain=setdiff(itest,[si 2 7]);
  
    for sj=itest
        if si==sj
            dv_ch=[];
            for ssi=itrain
                fprintf(num2str(ssi))
                for chtrn=1:16
                    eval(['fsclsfr=' subj{ssi} 'SCfsclsfr{iall(chtrn,ssi)};']);
                    fsclsfr.trX=fsclsfr.trX(:,:,:,:);
                    %dv_ch(end+1,:)=w(chtrn,sj)*applyNonLinearClassifier(X(chtrn,:,:,:),fsclsfr);
                    dv_ch(end+1,:)=applyLinearClassifier(X(chtrn,:,:,:),fsclsfr);
                end
                %dv{end+1}=dv_ch;
            end
            out=fperf(mean(dv_ch,1),labels');
            SIcr(si,sj)=out.perf;
            pidx{si}=out.ppidx;
            nidx{si}=out.npidx;
            chSS(si,:)=[1-out.fpr out.tpr];
            %dv{si,sj}=dv_ch;
            
        else
            dv_ch=[];
            for chtrn=1:16
                eval(['fsclsfr=' subj{sj} 'SCfsclsfr{iall(chtrn,sj)};']);
                fsclsfr.trX=fsclsfr.trX(:,:,:,:);
                dv_ch(end+1,:)=applyNonLinearClassifier(X(chtrn,:,:,:),fsclsfr);
            end
            out=fperf(mean(dv_ch,1),labels');
            SIcr(si,sj)=out.perf;
        end
    end
    
    
end

%  itrain=setdiff(itest,si);
%     for sj=itest
%         if si==sj
%             dv_ch=[];
%             for ssi=itrain
%                 fprintf(num2str(ssi))
%                 for chtrn=1:18
%                     eval(['fsclsfr=' subj{ssi} 'SCfsclsfr{chtrn};']);
%                     fsclsfr.trX=fsclsfr.trX(:,:,:,:);
%                     for chtst=1:18
%                         dv_ch(ssi,chtrn,chtst,:)=applyNonLinearClassifier(X(chtst,:,:,:),fsclsfr);
%                     end
%                 end
%                 %dv{end+1}=dv_ch;
%             end
%
%             dv{si,sj}=dv_ch;
%
%         else
%             dv_ch=[];
%             for chtrn=1:18
%                 eval(['fsclsfr=' subj{sj} 'SCfsclsfr{chtrn};']);
%                 fsclsfr.trX=fsclsfr.trX(:,:,:,:);
%                 for chtst=1:18
%                     dv_ch(chtrn,chtst,:)=applyNonLinearClassifier(X(chtst,:,:,:),fsclsfr);
%                 end
%             end
%             dv{si,sj}=dv_ch;
%         end
%     end
%
%
% end











