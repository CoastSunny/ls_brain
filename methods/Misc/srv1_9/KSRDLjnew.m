function [DtD,Y1,Y2,Dh,pinvY,Cs,Ci,rr,numIter,tElapsed,finalResidual]=KSRDLjnew(Xs,Xi,Cs,rDs,XtX,k,option)

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

Y1=rand(k-size(rDs,2),c);
Y2=zeros(size(rDs,2),c);

%Y=ones(k,c);
Ns=size(Xs,1);Ni=size(Xi,1);
prevRes=Inf;
% alternative updating
for i=1:option.iter
    fprintf(num2str(i))
    %     % normalize AtA and AtX
    %     [AtA,~,XtX,~,AtX]=normalizeKernelMatrix(AtA,XtX,AtX);
    
    % update kernel matrices
    
    pinvY1=pinv(Y1);
   
    Xf=[Xs-rDs*Y2;Xi];
    Hf=computeKernelMatrix(Xf,Xf,option);
    Ch=[Cs;eye(size(Xi,1))];
    if Xtf
        %D=inv(Ch'*Ch)*Ch'*Xf*pinvY1;
        Dh=Xf*pinvY1;
    end
    
    %Dh=Ch*D;
    Dho=Dh;
    DtD=Dh'*Dh;
    DtX=Dh'*Xf;
    
    % normalize AtA and AtX
    if Xtf
        nh=diag(Dh(1:Ns,:)'*Dh(1:Ns,:));
        Dh=normc(Dh);
        % D=normc(D);
    end
    
    [DtD,~,XtX,~,DtX]=normalizeKernelMatrix(DtD,XtX,DtX);
    %     if i==40
    %         keyboard
    %     end
%     option.lambda=0.2;
    Y1=KSRSC(DtD,DtX,diag(XtX),option);
%     option.lambda=0.1;
    Xs2=Xs-Dh(1:size(Xs,1),:)*Y1;
    Hs2=computeKernelMatrix(Xs2,Xs2,option);
    rDtD=rDs'*rDs;
    rDtX=rDs'*Xs2;
    [rDtD,~,Hs2,~,rDtX]=normalizeKernelMatrix(rDtD,Hs2,rDtX);
    Y2=KSRSC(rDtD,rDtX,diag(Hs2),option);
        

    %Cs=Xs*pinv(Dh(size(Xs,1)+1:end,:)*Y);
    %Cs=Dho(1:Ns,:)*pinv(Dho(Ns+1:end,:));
%     Cs=Xs*pinv(D*Y);
    
    %C=C/norm(C,'fro');
    
    %     delay=finddelay(mean(D*Y,2),mean(Xs,2));
    %     hC=diag(ones(1,27-delay),delay)';
    %     C=(mean(Xs,2)'*pinv(mean(hC*D*Y,2)'))*hC;
    %     if pen==0
    %         C=eye(size(C));
    %     end
    %C=((mean(Xs,2)'*pinv(mean(D*Y,2)'))*eye(size(C)));
    
   
%     curRes=norm(Xf-Ch*D*Y1,'fro');   
    curRes=norm(Xi-Dh(size(Xs,1)+1:end,:)*Y1,'fro');   

    if mod(i,20)==0 || i==option.iter      
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