W=[];
%[U,G]=tucker(fx,[4 4 4 -1]);
iall=(1:12)'*(ones(1,numel(subj)));
fpr_target=0.01;
itest=1:numel(subj);
dim=4;
Q=[];r=[];rr=[];F=[];rt=[];rti=[];rtf=[];Rind=[];
for si=itest
    eval(['X=cat(dim,' subj{si} '_fiEEG,' subj{si} '_friEEG);'])
    X=X(iall(:,si),:,:,:);
    %     y=tprod(U{1},[-1 1],X,[-1 2 3 4]);
    %     z=tprod(y,[1 -1 3 4],U{2},[-1 2]);
    %     q=tprod(z,[1 2 -1 4],U{3},[-1 3]);
    self=1:4;
    selt=1:4;
    y=tprod(U{1}(:,sels),[-1 1],X,[-1 2 3 4]);
    z=tprod(y,[1 -1 3 4],U{2}(:,self),[-1 2]);
    q=tprod(z,[1 2 -1 4],U{3}(:,1),[-1 3]);
    y=tprod(U{1}(:,sels),[-1 1],X,[-1 2 3 4]);
    z=tprod(y,[1 -1 3 4],U{2}(:,self),[-1 2]);
    q2=tprod(z,[1 2 -1 4],U{3}(:,2),[-1 3]);
    y=tprod(U{1}(:,sels),[-1 1],X,[-1 2 3 4]);
    z=tprod(y,[1 -1 3 4],U{2}(:,self),[-1 2]);
    q3=tprod(z,[1 2 -1 4],U{3}(:,3),[-1 3]);
    y=tprod(U{1}(:,sels),[-1 1],X,[-1 2 3 4]);
    z=tprod(y,[1 -1 3 4],U{2}(:,self),[-1 2]);
    q4=tprod(z,[1 2 -1 4],U{3}(:,4),[-1 3]);
    y=tprod(U{1}(:,sels),[-1 1],X,[-1 2 3 4]);
    z=tprod(y,[1 -1 3 4],U{2}(:,self),[-1 2]);
    q12=tprod(z,[1 2 -1 4],U{3}(:,[1 2]),[-1 3]);
    y=tprod(U{1}(:,sels),[-1 1],X,[-1 2 3 4]);
    z=tprod(y,[1 -1 3 4],U{2}(:,self),[-1 2]);
    q13=tprod(z,[1 2 -1 4],U{3}(:,[1 3]),[-1 3]);
    y=tprod(U{1}(:,sels),[-1 1],X,[-1 2 3 4]);
    z=tprod(y,[1 -1 3 4],U{2}(:,self),[-1 2]);
    q14=tprod(z,[1 2 -1 4],U{3}(:,[1 4]),[-1 3]);
    % for idxs=sels
    %     for idxf=self
    %             for idxt=selt
    %                 y=tprod(U{1}(:,idxs),[-1 1],X,[-1 2 3 4]);
    %                 z=tprod(y,[1 -1 3 4],U{2}(:,idxf),[-1 2]);
    %                 q{idxs,idxf,idxt}=tprod(z,[1 2 -1 4],U{3}(:,idxt),[-1 3]);
    %             end
    %     end
    % end
    for i=1:size(X,1)
        
        % X(i,:)=(m(i,si))*X(i,:);
    end
    
    labels=[];
    eval(['s_size=size(' subj{si} '_fiEEG,dim);']);
    eval(['r_size=size(' subj{si} '_friEEG,dim);']);
    labels(1:s_size)=1;
    labels(s_size+1:(s_size+r_size))=-1;
    labels=labels';
    dv=[];dv2=[];dv3=[];dv4=[];dv12=[];dv13=[];dv14=[];
    % itrain=setdiff(itest,[si 1 5 6 8 9 10 13 16 19 20 21 25 26]);
    %itrain=setdiff(itest,[si 1 16 20 25]);
    itrain=setdiff(itest,[si 1 19 20 25]);
    %     itrain2=setdiff(itest,[si 1:2 4:9 11:13 17 18:20 22:23 25:26]);
    %     itrain3=setdiff(itest,[si 1:7 9 12:13 16:18 20:22 24:25 ]);
    %     itrain4=setdiff(itest,[si 1:9 12:13 18 20 22 24:26]);
    itrain=setdiff(itest,[si]);
    itrain2=setdiff(itest,[si ]);
    itrain3=setdiff(itest,[si  ]);
    itrain4=setdiff(itest,[si ]);
    itrain12=setdiff(itest,[si ]);
    itrain13=setdiff(itest,[si ]);
    itrain14=setdiff(itest,[si ]);
    
    for sj=itest
        if si==sj
            %             for idxs=sels
            %                  for idxf=self
            %                     for idxt=selt
            %                        count=0;
            %                        for ssi=itrain
            %                             count=count+1;
            %                             if Result{ssi}(idxs,idxf,idxt)>0
            %                                 eval(['ftclsfr=' subj{ssi} 'ftsclsfr{idxs,idxf,idxt};']);
            %                                 dv(count,:)=applyLinearClassifier(q{idxs,idxf,idxt},ftclsfr);
            %                                 dv(count,:)=dv(count,:)-mean(dv(count,:));
            %                             else
            %                                 dv(count,:)=zeros(1,size(q{idxs,idxf,idxt},4));
            %                             end
            %                        end
            %                             Ft{si,idxs,idxf,idxt}=mean(dv,1);
            %                             temp=fperf(Ft{si,idxs,idxf,idxt},labels');
            %                             rti(si,idxs,idxf,idxt)=temp.perf;
            %                     end
            %                  end
            %             end
            %
            %              f=zeros(1,size(q{idxs,idxf,idxt},4));
            %              for idxs=sels
            %                  for idxf=self
            %                     for idxt=selt
            %                             f=f+Ft{si,idxs,idxf,idxt};
            %                     end
            %                  end
            %              end
            %              temp=fperf(f,labels');
            %              rtf(si)=temp.perf;
            count=0;
            for ssi=itrain
                if R(ssi,2)>0.9
                    count=count+1;
                    eval(['ftclsfr=' subj{ssi} 'ftsclsfr;']);
                    dv(count,:)=applyLinearClassifier(q,ftclsfr);
                    dv(count,:)=dv(count,:)-mean(dv(count,:));
                end
            end
            if count==0
                dv(1,:)=zeros(1,size(q,4));
            end
            count=0;
            for ssi=itrain2
                if R(ssi,3)>0.9
                    count=count+1;
                    eval(['ftclsfr2=' subj{ssi} 'ftsclsfr2;']);
                    dv2(count,:)=applyLinearClassifier(q2,ftclsfr2);
                    dv2(count,:)=dv2(count,:)-mean(dv2(count,:));
                end
            end
            if count==0
                dv2(1,:)=zeros(1,size(dv,2));
            end
            count=0;
            for ssi=itrain3
                if R(ssi,4)>0.9
                    count=count+1;
                    eval(['ftclsfr3=' subj{ssi} 'ftsclsfr3;']);
                    dv3(count,:)=applyLinearClassifier(q3,ftclsfr3);
                    dv3(count,:)=dv3(count,:)-mean(dv3(count,:));
                end
            end
            if count==0
                dv3(1,:)=zeros(1,size(dv,2));
            end
            count=0;
            for ssi=itrain4
                if R(ssi,5)>0.9
                    count=count+1;
                    eval(['ftclsfr4=' subj{ssi} 'ftsclsfr4;']);
                    dv4(count,:)=applyLinearClassifier(q4,ftclsfr4);
                    dv4(count,:)=dv4(count,:)-mean(dv4(count,:));
                end
                
            end
            if count==0
                dv4(1,:)=zeros(1,size(dv,2));
            end
            count=0;
            for ssi=itrain12
                
                if R(ssi,6)>0.9
                    count=count+1;
                    eval(['ftclsfr12=' subj{ssi} 'ftsclsfr12;']);
                    dv12(count,:)=applyLinearClassifier(q12,ftclsfr12);
                    dv12(count,:)=dv12(count,:)-mean(dv12(count,:));
                end
            end
            if count==0
                dv13(1,:)=zeros(1,size(dv,2));
            end
            count=0;
            for ssi=itrain13
                
                if R(ssi,7)>0.9
                    count=count+1;
                    eval(['ftclsfr13=' subj{ssi} 'ftsclsfr13;']);
                    dv13(count,:)=applyLinearClassifier(q13,ftclsfr13);
                    dv13(count,:)=dv13(count,:)-mean(dv13(count,:));
                end
            end
            if count==0
                dv13(1,:)=zeros(1,size(dv,2));
            end
            count=0;
            for ssi=itrain14
                
                if R(ssi,8)>0.9
                    count=count+1;
                    eval(['ftclsfr14=' subj{ssi} 'ftsclsfr14;']);
                    dv14(count,:)=applyLinearClassifier(q14,ftclsfr14);
                    dv14(count,:)=dv14(count,:)-mean(dv14(count,:));
                end
            end
            if count==0
                dv14(1,:)=zeros(1,size(dv,2));
            end
            f=mean(dv,1)';f2=mean(dv2,1)';f3=mean(dv3,1)';f4=mean(dv4,1)';
            f12=mean(dv12,1)';f13=mean(dv13,1)';f14=mean(dv14,1)';
            %             f12=(f+f2)/2;f13=(f+f3)/2;f14=(f+f4)/2;
            F{si}=[f f2 f3 f4 f12 f13 f14];            
            %[ftemp itemp]=max(abs(F{si}(:,[1:4])'));     
            [ftemp]=sign((F{si}(:,[1:7])'));            

%             fmax=[];
%             for qwe=1:numel(itemp)
%                 fmax(qwe)=F{si}(qwe,itemp(qwe));                
%             end
            fmax=sum(ftemp);
            F{si}(:,end+1)=fmax;
            temp=fperf(f,labels);temp2=fperf(f2,labels);temp3=fperf(f3,labels);temp4=fperf(f4,labels);
            temp12=fperf(f12,labels);temp13=fperf(f13,labels);temp14=fperf(f14,labels);
            tempmax=fperf(fmax',labels);
            %             temp12=fperf(f12,labels);temp13=fperf(f13,labels);temp14=fperf(f14,labels);
            rt(si,sj)=temp.perf;rt2(si,sj)=temp2.perf;rt3(si,sj)=temp3.perf;rt4(si,sj)=temp4.perf;
            rt12(si,sj)=temp12.perf;rt13(si,sj)=temp13.perf;rt14(si,sj)=temp14.perf;
            rmax(si,sj)=tempmax.perf;
            eval(['tmp=' subj{si} '_idx_iEEG;']);
            rind_left=sum(F{si}(tmp>6,1:4)>0,1);
            rind_right=sum(F{si}(tmp<7,1:4)>0,1);
            f_left=F{si}(tmp>6,1:4);
            f_right=F{si}(tmp<7,1:4);
            h_left=hist(1./(1+exp(-f_left)),2);
            if(size(h_left)==[1 2]); h_left=zeros(2,4); end;
            h_right=hist(1./(1+exp(-f_right)),2);
            Hl(:,:,si)=h_left;
            Hr(:,:,si)=h_right;
            Fl{si}=f_left;Fr{si}=f_right;
            n_left=numel(tmp(tmp>6));n_right=numel(tmp(tmp<7));
            N(si,:)=[n_left n_right];
            Rind(si,:)=[ si rind_left./n_left  rind_right./n_right];
            %             rt12(si,sj)=temp12.perf;rt13(si,sj)=temp13.perf;rt14(si,sj)=temp14.perf;
            %             rtSS(si,:)=[1-temp.fpr temp.tpr];
            %             out=multitrial_performance(f,labels,'all',1,'sav',1,1,0,0,[]);
            %             fpr_idxs=find(out.fpr.sav<=fpr_target);
            %             bias=out.bias(fpr_idxs(end));
            %           %  bias=0;
            %             temp=fperf(f+bias,labels);
            %             rtf(si,sj)=temp.perf;
            %             rtfSS(si,:)=[1-temp.fpr temp.tpr];
        else
            
            %             eval(['ftclsfr=' subj{sj} 'ftclsfr;']);
            %            % ftclsfr.trX=ftclsfr.trX(iall(:,sj),:,:,:);%% FIX
            %             f=applyNonLinearClassifier(q,ftclsfr);
            %             temp=fperf(f,labels);
            %             r(si,sj)=temp.perf;
            %             F{si,sj}=f;
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











