W=[];
%[U,G]=tucker(fx,[4 4 4 -1]);
iall=(1:20)'*(ones(1,numel(subj)));
fpr_target=0.01;
itest=1:numel(subj);
dim=4;
F=[];
for si=itest
    eval(['X=cat(dim,' subj{si} '_fsEEG,' subj{si} '_frsEEG);'])
    %     X=X(iall(:,si),:,:,:);
        y=tprod(U{1}(:,sels),[-1 1],X,[-1 2 3 4]);
        z=tprod(y,[1 -1 3 4],U{2}(:,self),[-1 2]);
        q=tprod(z,[1 2 -1 4],U{3}(:,selt),[-1 3]);
    
    
    
    labels=[];
    eval(['s_size=size(' subj{si} '_fsEEG,dim);']);
    eval(['r_size=size(' subj{si} '_frsEEG,dim);']);
    labels(1:s_size)=1;
    labels(s_size+1:(s_size+r_size))=-1;
    labels=labels';
    dv=[];
    itrain=setdiff(itest,[si ]);
    
    for sj=itest
        if si==sj
            
            count=0;
            for ssi=itrain
                
                count=count+1;
                sels=SELs{ssi};
                us=U{1}(:,sels);               
                self=SELf{ssi};
                uf=U{2}(:,self);               
                selt=SELt{ssi};
                ut=U{3}(:,selt);
               
                y=tprod(us,[-1 1],X,[-1 2 3 4]);
                z=tprod(y,[1 -1 3 4],uf,[-1 2]);
                q=tprod(z,[1 2 -1 4],ut,[-1 3]);
                eval(['ftclsfr=' subj{ssi} 'ftsclsfr;']);
                dv(count,:)=applyLinearClassifier(q,ftclsfr);
                dv(count,:)=dv(count,:)-mean(dv(count,:));
                
            end
            
            f=mean(dv,1)';
            temp=fperf(f,labels);
            rt2(si,sj)=temp.perf;
            
            %             count=0;dv=[];
            %             for idxf=self
            %                 y=tprod(U{1},[-1 1],X,[-1 2 3 4]);
            %                 z=tprod(y,[1 -1 3 4],U{2}(:,idxf),[-1 2]);
            %                 q=tprod(z,[1 2 -1 4],U{3},[-1 3]);
            %                 for ssi=itrain
            %
            %                     eval(['ftclsfr=' subj{ssi} 'ftsclsfrsf{idxf};']);
            %                     count=count+1;
            %                     dv(count,:)=applyLinearClassifier(q,ftclsfr);
            %
            %                 end
            %                 f=mean(dv,1)';
            %                 f=f-mean(f);
            %                 F{idxf,sj}=f;
            %                 temp=fperf(f,labels);
            %                 count=0;dv=[];
            %                 resf(idxf,sj)=temp.perf;
            %                 [~, ~, fc]=dvCalibrate(labels,f,'cr');
            %                 presf(idxf,sj)=mean(1./(1+exp(-(fc(fc>0)))));
            %                 fresf(idxf,sj)=mean((f(f>0)))-mean(f(f<0));
            %                 qresf(idxf,sj)=(sum(sum(sum(abs(q(:,:,:,f>0))))));
            %
            %             end
            %
            %             count=0;dv=[];
            %             for idxt=selt
            %                 y=tprod(U{1},[-1 1],X,[-1 2 3 4]);
            %                 z=tprod(y,[1 -1 3 4],U{2},[-1 2]);
            %                 q=tprod(z,[1 2 -1 4],U{3}(:,idxt),[-1 3]);
            %                 for ssi=itrain
            %
            %                     eval(['ftclsfr=' subj{ssi} 'ftsclsfrst{idxt};']);
            %                     count=count+1;
            %                     dv(count,:)=applyLinearClassifier(q,ftclsfr);
            %
            %                 end
            %                 f=mean(dv,1)';
            %                 f=f-mean(f);
            %                 F{idxf,sj}=f;
            %                 temp=fperf(f,labels);
            %                 [~, ~, fc]=dvCalibrate(labels,f,'cr');
            %                 count=0;dv=[];
            %                 rest(idxt,sj)=temp.perf;
            %                 prest(idxt,sj)=mean(1./(1+exp(-(fc(fc>0)))));
            %             end
            
            %             count=0;dv=[];
            %             for idxs=sels
            %                 y=tprod(U{1}(:,idxs),[-1 1],X,[-1 2 3 4]);
            %                 z=tprod(y,[1 -1 3 4],U{2},[-1 2]);
            %                 q=tprod(z,[1 2 -1 4],U{3},[-1 3]);
            %                 for ssi=itrain
            %
            %                     eval(['ftclsfr=' subj{ssi} 'ftsclsfrss{idxs};']);
            %                     count=count+1;
            %                     dv(count,:)=applyLinearClassifier(q,ftclsfr);
            %
            %                 end
            %                 dv(count,:)=dv(count,:)-mean(dv(count,:));
            %                 f=mean(dv,1)';
            %                 F{idxf,sj}=f;
            %                 temp=fperf(f,labels);
            %                 count=0;dv=[];
            %                 ress(idxt,sj)=temp.perf;
            %            end
            %             ff=zeros(size(F{1,1,1,si}));
            %             for idxs=sels
            %             for idxf=self
            %                 for idxt=selt
            %                     if sres(idxs,idxf,idxt,si)<0.50
            %                     ff=ff+F{idxs,idxf,idxt,si};
            %                     end
            %                 end
            %             end
            %             end
            %
            %             temp=fperf(ff,labels);
            %             rr(si)=temp.perf;
        else
            
        end
    end
    
end











