W=[];
%[U,G]=tucker(fx,[4 4 4 -1]);
iall=(1:20)'*(ones(1,numel(subj)));
fpr_target=0.01;
itest=Itest;
dim=4;
F=[];tdi=[];rt=[];
for si=itest
    
    eval(['X=cat(dim,' subj{si} '_fsEEG,' subj{si} '_frsEEG);'])
    %     X=X(iall(:,si),:,:,:);
    %     y=tprod(U{1},[-1 1],X,[-1 2 3 4]);
    %     z=tprod(y,[1 -1 3 4],U{2},[-1 2]);
    %     q=tprod(z,[1 2 -1 4],U{3},[-1 3]);
    
    % [U,G]=tucker(fx,[6 6 6 -1]);
    
    labels=[];
    eval(['s_size=size(' subj{si} '_fsEEG,dim);']);
    eval(['r_size=size(' subj{si} '_frsEEG,dim);']);
    labels(1:s_size)=1;
    labels(s_size+1:(s_size+r_size))=-1;
    labels=labels';
    dv=[];
    itrain=setdiff(itest,[si]);
    
    cc=0;
    for sjj=itrain
        cc=cc+1;
        U=Us{sjj};
        y=tprod(U{1}(:,sels),[-1 1],X,[-1 2 3 4]);
        z=tprod(y,[1 -1 3 4],U{2}(:,self),[-1 2]);
        temp_q{sjj}=tprod(z,[1 2 -1 4],U{3}(:,selt),[-1 3]);
        a=tprod(U{1}(:,sels),[1 -1] , temp_q{sjj} , [-1 2 3 4] );
        b=tprod(U{2}(:,self),[2 -1], a , [1 -1 3 4]);
        c=tprod(U{3}(:,selt),[3 -1], b , [1 2 -1 4]);
        tdi(cc)=1/size(X,4)*sum(tprod(c-X,[-1 -2 -3 1],c-X,[-1 -2 -3 1]).^.5);
        % tdi(cc)=norm(Us{sjj}{1}-Us{si}{1},'fro')+norm(Us{sjj}{2}-Us{si}{2},'fro')+norm(Us{sjj}{3}-Us{si}{3},'fro');
    end
    [m i]=sort(tdi);
    ssi=itrain(i);
    %     ssi=ssi(randperm(numel(ssi)));
    for sj=itest
        
        if si==sj
            asd=[];
            %             dv=[];
            for cj=1
                q=temp_q{ssi(cj)};
                eval(['ftclsfr=' subj{ssi(cj)} 'ftsclsfr;']);
                dv(cj,:)=applyLinearClassifier(q,ftclsfr);
            end
            dv=mean(dv,1);
            dv=dv-mean(dv);
            
            f=dv;
            temp=fperf(f,labels);
            rt5(si,sj)=temp.perf;
            
            count=0;dv=[];
            for idxs=sels
                y=tprod(U{1}(:,idxs),[-1 1],X,[-1 2 3 4]);
                z=tprod(y,[1 -1 3 4],U{2},[-1 2]);
                temp_q2{idxs}=tprod(z,[1 2 -1 4],U{3},[-1 3]);
                a=tprod(U{1}(:,idxs),[1 -1] , temp_q2{idxs} , [-1 2 3 4] );
                b=tprod(U{2},[2 -1], a , [1 -1 3 4]);
                c=tprod(U{3},[3 -1], b , [1 2 -1 4]);
                tdi(cc)=sum(tprod(c-X(:,:,:,icool),[-1 -2 -3 1],c-X(:,:,:,icool),[-1 -2 -3 1]).^.5);
                for ssi=itrain
                    
                    eval(['ftclsfr=' subj{ssi} 'ftsclsfrss{idxs};']);
                    count=count+1;
                    dv(count,:)=applyLinearClassifier(q,ftclsfr);
                    
                end
                dv(count,:)=dv(count,:)-mean(dv(count,:));
                f=mean(dv,1)';
                F{idxf,sj}=f;
                temp=fperf(f,labels);
                count=0;dv=[];
                ress(idxt,sj)=temp.perf;
            end
       
            
        else
            q=temp_q{sj};
            eval(['ftclsfr=' subj{sj} 'ftsclsfr;']);
            f=applyLinearClassifier(q,ftclsfr);
            f=f-mean(f);
            temp=fperf(f,labels);
            rt5(si,sj)=temp.perf;
            
        end
    end
    
end











