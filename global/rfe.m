function out = rfe( X, labels , method, channels,nfolds)
exclusion_rate=0.05;
stop='no';
counter=0;
dim=ndims(X);

while (strcmp(stop,'no'))
    
    clear Z
    counter=counter+1;
    
    [clsfr, res]=cvtrainLinearClassifier(X,labels,[],nfolds,'dim',dim,'zeroLab',1,'balYs',1,'verb',-1);
    if( counter==1)
        out.clsfr=clsfr;
        out.res=res;
    end
    
    perf(counter)=res.tstbin(res.opt.Ci);
    eval(['clc;']);
    fprintf('\b Performance is: %s ' ,num2str(perf(counter)));
    W=clsfr.W;
    w=W(:).^2;
    if (strcmp(method,'all'))
        [s si]=sort(w(:));
        no_exclusions=round(exclusion_rate*numel(si));
        si=si(1:no_exclusions);
    elseif (strcmp(method,'time'))
        [m idx]=min(sum(W.^2));
        W(:,idx)=0;
        si=find(W==0);
    elseif (strcmp(method,'space'))
        [m idx]=min(sum(W'.^2));       
        W(idx,:)=0;
        si=find(W==0);       
    end
   
    channels(idx)=[];
    all_channels{counter}=channels;
    excluded{counter+1}=si;
    temp(counter).clsfr=clsfr;
    temp(counter).res=res;
    
    for i = 1 : size( X,dim )
        
        Y=X(:,:,i);
        if (strcmp(method,'all'))
            Y=Y(:);
            Y(si)=[];
        elseif (strcmp(method,'time'))
            Y(:,idx)=[];
        elseif (strcmp(method,'space'))
            Y(idx,:)=[];
        end
        
        Z(:,:,i)=Y;
        
    end
    X=Z;
    
    %     if (counter==3)
    %         [m i] = max(perf);
    %         out.clsfr=temp(i).clsfr;
    %         out.res=temp(i).res;
    %         out.perf=perf;
    %         out.excluded=excluded(1:i);
    %         stop='yes';
    %     end
    
    %if (perf(counter)<0.95*max(perf) | counter==40 & counter>10)
    %if ( (counter>10 && perf(counter)<0.95*max(perf) ) || counter==30)
    if (counter==50)
        [m i] = max(perf);
        out.opt.clsfr=temp(i).clsfr;
        out.opt.res=temp(i).res;
        out.perf=perf;
        out.excluded=excluded(1:i);
        out.all_channels=all_channels;
        stop='yes';
    end
end

end