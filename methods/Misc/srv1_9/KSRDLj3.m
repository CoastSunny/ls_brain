function [DtD,Y,D,Dh,pinvY,Cs,Ci,rr,numIter,tElapsed,finalResidual]=KSRDLj3(Xi,Xs,Cs,Ci,pen,XtX,k,option)

Cio=Ci;
tStart=tic;
optionDefault.lambda=0.1;
optionDefault.SCMethod='nnlsAS';
optionDefault.kernel='linear';
optionDefault.param=[];
optionDefault.dicPrior='uniform';
optionDefault.iter=100;
optionDefault.dis=0;
optionDefault.residual=1e-4;
optionDefault.tof=1e-4;
if nargin<6
    option=optionDefault;
else
    option=mergeOption(option,optionDefault);
end

if strcmp(option.dicPrior,'uniform')
    option.alpha=0;
end
c=size(XtX,1);

if ~isempty(Xi)
    Xtf=true;
else
    Xtf=false;
    A=[];
end

Y=rand(k,c);
%Y=ones(k,c);

prevRes=Inf;
% alternative updating
for i=1:option.iter
    fprintf(num2str(i))
    %     % normalize AtA and AtX
    %     [AtA,~,XtX,~,AtX]=normalizeKernelMatrix(AtA,XtX,AtX);
    
    % update kernel matrices
    
    pinvY=pinv(Y);
    Xh=[pen*Xs;Xi];
    Ch=[pen*Cs;Ci];
    if Xtf
        D=inv(Ch'*Ch)*Ch'*Xh*pinvY;
    end
    Dh=Ch*D;
    DtD=Dh'*Dh;
    DtX=Dh'*Xh;
    
    % normalize AtA and AtX
    if Xtf
        Dh=normc(Dh);
        % D=normc(D);
    end
    
    [DtD,~,XtX,~,DtX]=normalizeKernelMatrix(DtD,XtX,DtX);
    %     if i==40
    %         keyboard
    %     end
    Y=KSRSC(DtD,DtX,diag(XtX),option);
    Cs=Xs*pinv(D*Y);
    Ci=[];
    for icool=1:12
        idxs=(icool-1)*65+1:icool*65;
        ci(icool)=mean(Xi(idxs,:),2)'*pinv(mean(D*Y,2))';
    end
    for icool=1:12
        tmp{icool}=diag(ci(icool)*ones(1,65));
        Ci=[Ci;tmp{icool}];
    end
    
    %C=C/norm(C,'fro');
    
    %     delay=finddelay(mean(D*Y,2),mean(Xs,2));
    %     hC=diag(ones(1,27-delay),delay)';
    %     C=(mean(Xs,2)'*pinv(mean(hC*D*Y,2)'))*hC;
    %     if pen==0
    %         C=eye(size(C));
    %     end
    %C=((mean(Xs,2)'*pinv(mean(D*Y,2)'))*eye(size(C)));
    
    curRes1=norm(Xs-Cs*D*Y,'fro');
    curRes2=norm(Xi-Ci*D*Y,'fro');
    curRes3=norm(Xh-Ch*D*Y,'fro');
    
    rr(i,:)=[curRes1 curRes2 curRes3];
    if mod(i,20)==0 || i==option.iter
        curRes=curRes3;
        fitRes=prevRes-curRes;
        prevRes=curRes;
        if option.tof>=fitRes || option.residual>=curRes || i==option.iter
            disp(['DL successes!, # of iterations is ',num2str(i),'. The final residual is ',num2str(curRes)]);
            numIter=i;
            finalResidual=curRes;
            break;
        end
    end
end
tElapsed=toc(tStart);
end