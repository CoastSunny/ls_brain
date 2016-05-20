W=[];
%[U,G]=tucker(fx,[4 4 4 -1]);
iall=(1:20)'*(ones(1,numel(subj)));
fpr_target=0.01;
itest=1:numel(subj);
dim=4;
F=[];
for si=itest
    eval(['X=cat(dim,' subj{si} '_fsEEG,' subj{si} '_frsEEG);'])
    
    labels=[];
    eval(['s_size=size(' subj{si} '_fsEEG,dim);']);
    eval(['r_size=size(' subj{si} '_frsEEG,dim);']);
    labels(1:s_size)=1;
    labels(s_size+1:(s_size+r_size))=-1;
    labels=labels';
    dv=[];
    itrain=setdiff(itest,[si]);
    asd=[];
    for sj=itest
        if si==sj
            temp_dv=[];
            for icool=1:size(X,4)
                
                cc=0;temp_q2=[];tdi=[];
                for idxs=sels
                    cc=cc+1;
                    y=tprod(U{1}(:,idxs),[-1 1],X(:,:,:,icool),[-1 2 3 4]);
                    z=tprod(y,[1 -1 3 4],U{2},[-1 2]);
                    temp_q2{idxs}=tprod(z,[1 2 -1 4],U{3},[-1 3]);
                    a=tprod(U{1}(:,idxs),[1 -1] , temp_q2{idxs} , [-1 2 3 4] );
                    b=tprod(U{2},[2 -1], a , [1 -1 3 4]);
                    c=tprod(U{3},[3 -1], b , [1 2 -1 4]);
                    tdi(cc)=sum(tprod(c-X(:,:,:,icool),[-1 -2 -3 1],c-X(:,:,:,icool),[-1 -2 -3 1]).^.5);
                end
                [m i]=sort(tdi);
                ui=sels(i);
                asd(end+1,:)=ui;
                count=0;
                for cj=1
                    q=temp_q2{cj};
                    for ssi=itrain
                        count=count+1;
                        eval(['ftclsfr=' subj{ssi} 'ftsclsfrs{ui(cj)};']);
                        temp_dv(count,icool)=applyLinearClassifier(q,ftclsfr);
                    end
                end
                dv(icool)=sum(temp_dv(:,icool),1);
            end
            dv=dv-mean(dv);
            f=dv';
            temp=fperf(f,labels);
            rt4(si,sj)=temp.perf;
        end
        
        
    end
end













