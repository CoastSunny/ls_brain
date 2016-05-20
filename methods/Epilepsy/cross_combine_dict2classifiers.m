W=[];

iall=(1:20)'*(ones(1,numel(subj)));
fpr_target=0.1;
itest=Itest;
dim=4;
Q=[];clear rd*;
for si=itest
    
    fprintf(num2str(si))
    eval(['X=cat(dim,' subj{si} '_fsEEG,' subj{si} '_frsEEG);'])
    Xtst=reshape(X,[],size(X,4));%Xtst=normc(Xtst);          
    
    labels=[];
    eval(['s_size=size(' subj{si} '_fiEEG,dim);']);
    eval(['r_size=size(' subj{si} '_friEEG,dim);']);
    labels(1:s_size)=1;
    labels(s_size+1:(s_size+r_size))=-1;
    labels=labels';
    dv=[]; dv2=[];dv3=[];dv4=[];dv5=[];dv6=[];dv7=[];dv8=[];dv9=[];dv10=[];
    % itrain=setdiff(itest,[si 1 5 6 8 9 10 13 16 19 20 21 25 26]);
    % itrain=setdiff(itest,[si 1 16 20 25]);
     itrain=setdiff(itest,[si]);
    for sj=itest
     
        if si==sj
            count=0;
            
            for ssi=itrain                
                count=count+1;
                
                
                eval(['fclsfr=' subj{ssi} 'sclsfr;']);                
                dv(count,:)=applyLinearClassifier(Xtst,fclsfr);
                dv(count,:)=dv(count,:)-mean(dv(count,:));

                eval(['fclsfr=' subj{ssi} 'dclsfr;']);
                eval(['Dsr=' subj{ssi} 'Dsr;']);
                DtTestSet=Dsr'*Xtst;
                sDtD=Dsr'*Dsr;
                dZ2=KSRSC(sDtD,DtTestSet,[],optionKSRDL);  
                dZ2=dZ2(1:k0,:);
                dv2(count,:)=applyLinearClassifier(dZ2,fclsfr);
                dv2(count,:)=dv2(count,:)-mean(dv2(count,:));
                    
                
            end
            
            f=mean(dv,1)';
            temp=fperf(f,labels);
            rd(si,sj)=temp.perf;
            rdSS(si,:)=[1-temp.fpr temp.tpr];
            
            f2=mean(dv2,1)';
            temp2=fperf(f2,labels);
            rd2(si,sj)=temp2.perf;
            rdSS2(si,:)=[1-temp.fpr temp.tpr];           
                
        else
            
        end
    end
    
    
    
end











