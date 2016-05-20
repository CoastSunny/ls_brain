
cvx=[];cvy=[];
for ci=1:numel(subj)
    
    SigmaQ=[];
    SigmaL=[];
    eval(['sEEG=' subj{ci} '_sEEG;']);
    eval(['rsEEG=' subj{ci} '_rsEEG;']);
    eval(['fsEEG=' subj{ci} '_fsEEG;']);
    eval(['frsEEG=' subj{ci} '_frsEEG;']);
    %     eval(['cEEG=' subj{ci} '_cEEG;']);
    %     eval(['rcEEG=' subj{ci} '_rcEEG;']);
    %
    eval(['iEEG=' subj{ci} '_iEEG;']);
    eval(['riEEG=' subj{ci} '_riEEG;']);
    eval(['fiEEG=' subj{ci} '_fiEEG;']);
    eval(['friEEG=' subj{ci} '_friEEG;']);
    eval([ 'schannels=' subj{ci} '_schannels;'])
    eval([ 'ichannels=' subj{ci} '_ichannels;'])    
    
    X=sEEG(schannels,10:24,:);
    Y=rsEEG(schannels,10:24,:);
    
    x=reshape(X,size(X,1)*size(X,2),size(X,3));
    y=reshape(Y,size(Y,1)*size(Y,2),size(Y,3));
    Cx=cov(x');
    Cy=cov(y');
        
    cvx{ci}=Cx;
    cvy{ci}=Cy;
    D=size(Cx,1);
    N=size(X,3)+size(Y,3);
    Nclass=[size(X,3) size(Y,3)];
    K=2;
    SigmaQ(:,:,1)=Cx;
    SigmaQ(:,:,2)=Cy;
    SigmaL = mean(SigmaQ,3);
    logV = (N-K)*log(det(SigmaL));
    for k=1:K
        logV = logV - (Nclass(k)-1)*log(det(SigmaQ(:,:,k)));
    end
    nu = (K-1)*D*(D+1)/2;
    pval(ci) = 1 - chi2cdf(logV,nu)
end

