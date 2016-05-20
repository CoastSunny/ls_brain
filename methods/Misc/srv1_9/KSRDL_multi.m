function [AtA,Y,A,pinvY,H,numIter,tElapsed,finalResidual]=KSRDL_multi(X,x,XtX,k,H,A,option)

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
if nargin<4
    option=optionDefault;
else
    option=mergeOption(option,optionDefault);
end

if strcmp(option.dicPrior,'uniform')
    option.alpha=0;
end
c=size(XtX,1);

if ~isempty(X)
    Xtf=true;
else
    Xtf=false;
    A=[];
end

Y=rand(k,c);

prevRes=Inf;

for i=1:option.iter
   
    fprintf(num2str(i))   
    
    pinvY=pinv(Y);
    if Xtf
        A=X*pinvY;
    end
    AtA=pinvY'*XtX*pinvY;
    AtX=pinvY'*XtX;
    
    % normalize AtA and AtX
    A=normc(A);
    [AtA,~,XtX,~,AtX]=normalizeKernelMatrix(AtA,XtX,AtX);
    
    
    Y=KSRSC(AtA,AtX,diag(XtX),option);
    if mod(i,20)==0 || i==option.iter
        if option.dis
            disp(['Iterating >>>>>> ', num2str(i),'th']);
        end
        switch option.SCMethod
            case {'l1lsIP','l1qpIP','l1lsAS','l1qpAS','l1lsPX','l1qpPX','l1lsSMO','l1qpSMO'}
                curRes=0.5*trace(XtX-Y'*AtX-AtX'*Y+Y'*AtA*Y) + 0.5*option.alpha*trace(AtA) + option.lambda*sum(sum(abs(Y)));
            case {'nnlsIP','nnqpIP','nnlsAS','nnqpAS','nnlsSMO','nnqpSMO'}
                curRes=0.5*trace(XtX-Y'*AtX-AtX'*Y+Y'*AtA*Y) + 0.5*option.alpha*trace(AtA);
        end
        curRes=norm(X-A*Y,'fro');
        fitRes=prevRes-curRes;
        prevRes=curRes;
        if option.tof>=fitRes || option.residual>=curRes || i==option.iter
            disp(['DL successes!, # of iterations is ',num2str(i),'. The final residual is ',num2str(curRes)]);
            numIter=i;
            finalResidual=curRes;
            break;
        end
    end
    
    for trial=1:size(X,2)
        if sum(Y(:,trial))>0
            for channel=1:size(x,1)
                H(channel,trial)=x(channel,:,trial)*pinv(A*Y(:,trial))';                
            end
            X(:,trial)=pinv(H(:,trial))*x(:,:,trial);
        else 
            fprintf('care')
        end
    end
    X=normc(X);
    XtX=computeKernelMatrix(X,X,option);

    
end
tElapsed=toc(tStart);
end