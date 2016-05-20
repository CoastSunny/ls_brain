W=[];

iall=(1:20)'*(ones(1,numel(subj)));
fpr_target=0.1;
itest=Itest;
dim=4;
Q=[];clear rd*;
for si=itest
       fprintf(num2str(si))
    eval(['X=cat(dim,' subj{si} '_fsEEG,' subj{si} '_frsEEG);'])
    X=X(iall(:,si),:,:,:);
    Xtst=reshape(X,[],size(X,4));Xtst=normc(Xtst);    
    eval(['Xi=cat(dim,' subj{si} '_fiEEG,' subj{si} '_friEEG);']) 
    Xitst=reshape(Xi,[],size(Xi,4));Xitst=normc(Xitst);        
    
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
                
                
                eval(['fclsfr=' subj{ssi} 'fsclsfr;']);                
                dv(count,:)=applyLinearClassifier(X,fclsfr);
                dv(count,:)=dv(count,:)-mean(dv(count,:));

%                 eval(['fclsfr=' subj{ssi} 'fdsclsfr2;']);
%                 eval(['Ds=' subj{ssi} 'Ds;']);
%                 DtTestSet=Ds'*Xtst;
%                 DtDs=Ds'*Ds;
%                 dZ2=KSRSC(DtDs,DtTestSet,[],optionKSRDL);  
%                 dv2(count,:)=applyLinearClassifier(dZ2,fclsfr);
%                 dv2(count,:)=dv2(count,:)-mean(dv2(count,:));

                    
%                 eval(['fclsfr=' subj{ssi} 'fdsclsfr;']);
%                 eval(['Df=' subj{ssi} 'Df;']);
%                 DtTestSet=Df'*Xtst;
%                 DtDf=Df'*Df;
%                 dZ3=KSRSC(DtDf,DtTestSet,[],optionKSRDL);  
%                 dv3(count,:)=applyLinearClassifier(dZ3,fclsfr);
%                 dv3(count,:)=dv3(count,:)-mean(dv3(count,:));
% 
                eval(['fclsfr=' subj{ssi} 'fdsclsfr3;']);
                eval(['Dsrs=' subj{ssi} 'Dsrs;']);
                DtTestSet=Dsrs'*Xtst;
                DtDsrs=Dsrs'*Dsrs;
                dZ4=KSRSC(DtDsrs,DtTestSet,[],optionKSRDL);  
                dv4(count,:)=applyLinearClassifier(dZ4,fclsfr);
                dv4(count,:)=dv4(count,:)-mean(dv4(count,:));
%                 
%                 
                eval(['fclsfr=' subj{ssi} 'fdsclsfr4;']);
                eval(['Dsrsf=' subj{ssi} 'Dsrsf;']);
                DtTestSet=Dsrsf'*Xtst;
                DtDsrsf=Dsrsf'*Dsrsf;
                dZ5=KSRSC(DtDsrsf,DtTestSet,[],optionKSRDL);  
                dv5(count,:)=applyLinearClassifier(dZ5,fclsfr);
                dv5(count,:)=dv5(count,:)-mean(dv5(count,:));
%                 
                eval(['fclsfr=' subj{ssi} 'ficlsfr;']);            
                dv6(count,:)=applyLinearClassifier(Xi,fclsfr);
                dv6(count,:)=dv6(count,:)-mean(dv6(count,:));
                
%                 eval(['fclsfr=' subj{ssi} 'fdiclsfr;']);
%                 eval(['Disrsf=' subj{ssi} 'Disrsf;']);
%                 eval(['Cis=' subj{ssi} 'Cis;']);
%                 Zc=Cis*Xtst;%Zc=normc(Zc);
%                 DtDisrsf=Disrsf'*Disrsf;
%                 DtTestSet=Disrsf'*Zc;                
%                 dZ7=KSRSC(DtDisrsf,DtTestSet,[],optionKSRDL);  
%                 dv7(count,:)=applyLinearClassifier(dZ7,fclsfr);
%                 dv7(count,:)=dv7(count,:)-mean(dv7(count,:));
%                 
                eval(['fclsfr=' subj{ssi} 'fdiclsfr;']);
                eval(['Disrsf=' subj{ssi} 'Disrsf;']);     
                eval(['Cis=' subj{ssi} 'Cis;']);
                DtDisrsf=Disrsf'*Disrsf;
                DtTestSet=Disrsf'*Cis*Xtst;      
                dZ8=KSRSC(DtDisrsf,DtTestSet,[],optionKSRDL);  
                dv8(count,:)=applyLinearClassifier(dZ8,fclsfr);
                dv8(count,:)=dv8(count,:)-mean(dv8(count,:));
%                 
                eval(['fclsfr=' subj{ssi} 'fdiclsfr2;']);
                eval(['Disrsf=' subj{ssi} 'Disrsf;']);               
                DtDisrsf=Disrsf'*Disrsf;
                DtTestSet=Disrsf'*Xitst;           
                dZ9=KSRSC(DtDisrsf,DtTestSet,[],optionKSRDL);  
                dv9(count,:)=applyLinearClassifier(dZ9,fclsfr);
                dv9(count,:)=dv9(count,:)-mean(dv9(count,:));
                
                eval(['fclsfr=' subj{ssi} 'fdiclsfr3;']);
                eval(['Diri=' subj{ssi} 'Diri;']);                    
                DtDiri=Diri'*Diri;
                DtTestSet=Diri'*Xitst;                
                dZ10=KSRSC(DtDiri,DtTestSet,[],optionKSRDL);  
                dv10(count,:)=applyLinearClassifier(dZ10,fclsfr);
                dv10(count,:)=dv10(count,:)-mean(dv10(count,:));
                
            end
            
            f=mean(dv,1)';
            temp=fperf(f,labels);
            rd(si,sj)=temp.perf;
            rdSS(si,:)=[1-temp.fpr temp.tpr];
%             f2=mean(dv2,1)';
%             temp2=fperf(f2,labels);
%             rd2(si,sj)=temp2.perf;
%             rdSS2(si,:)=[1-temp.fpr temp.tpr];
%             out=multitrial_performance(f2,labels,'all',1,'sav',1,1,0,0,[]);
%             fpr_idxs=find(out.fpr.sav<=fpr_target);
%             bias=out.bias(fpr_idxs(end));      
%             temp=fperf(f+bias,labels);
%             rfd2(si,sj)=temp.perf;
%             rfSSd2(si,:)=[1-temp.fpr temp.tpr];
% 
%             f3=mean(dv3,1)';
%             temp3=fperf(f3,labels);
%             rd3(si,sj)=temp3.perf;
%             rdSS3(si,:)=[1-temp3.fpr temp3.tpr];
            f4=mean(dv4,1)';
            temp4=fperf(f4,labels);
            rd4(si,sj)=temp4.perf;
            rdSS4(si,:)=[1-temp4.fpr temp4.tpr];    
            f5=mean(dv5,1)';
            temp5=fperf(f5,labels);
            rd5(si,sj)=temp5.perf;
            rdSS5(si,:)=[1-temp5.fpr temp5.tpr];   
            f6=mean(dv6,1)';
            temp6=fperf(f6,labels);
            rd6(si,sj)=temp6.perf;
            rdSS6(si,:)=[1-temp6.fpr temp6.tpr]; 
%             f7=mean(dv7,1)';
%             temp7=fperf(f7,labels);
%             rd7(si,sj)=temp7.perf;
%             rdSS7(si,:)=[1-temp7.fpr temp7.tpr]; 
%             
            f8=mean(dv8,1)';
            temp8=fperf(f8,labels);
            rd8(si,sj)=temp8.perf;
            rdSS8(si,:)=[1-temp8.fpr temp8.tpr]; 
            
            f9=mean(dv9,1)';
            temp9=fperf(f9,labels);
            rd9(si,sj)=temp9.perf;
            rdSS9(si,:)=[1-temp9.fpr temp9.tpr]; 

            f10=mean(dv10,1)';
            temp10=fperf(f10,labels);
            rd10(si,sj)=temp10.perf;
            rdSS10(si,:)=[1-temp10.fpr temp10.tpr]; 
            
            f11=[];
            [m11 i11]=max(abs(dv10));
            for i=1:numel(i11);f11(i)=dv10(i11(i),i);end;
            temp11=fperf(f11,labels);
            rd11(si,sj)=temp11.perf;
            rdSS11(si,:)=[1-temp11.fpr temp11.tpr]; 
            
            f12=[];
            [m12 i12]=max(abs(dv10));
            for i=1:size(dv10,1);ic(i)=sum(i12==i);end;
            [mmc iic]=max(ic);
            f12=dv10(iic,:);
            temp12=fperf(f12,labels);
            rd12(si,sj)=temp12.perf;
            rdSS12(si,:)=[1-temp12.fpr temp12.tpr]; 
            
            f13=[];
            [m13 i13]=max(abs(dv6));
            for i=1:size(dv6,1);ic(i)=sum(i13==i);end;
            [mmc iic]=max(ic);
            f13=dv6(iic,:);
            temp13=fperf(f13,labels);
            rd13(si,sj)=temp13.perf;
            rdSS13(si,:)=[1-temp13.fpr temp13.tpr]; 
                
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











