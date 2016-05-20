function out = sptemp(Xtr,Ytr)

%%initialisation
W=randn(size(Xtr,1),size(Ytr,1));
W=inv(mean(Xtr,3)*mean(Xtr,3)')*mean(Xtr,3)*mean(Ytr,3)';
H=randn(size(Xtr,2),size(Xtr,2));
%H=
mw=10^-5;
mh=10^-5;
ch=0.99;
conv_error=10^-2;
%% alternating minimisation
residual=2*conv_error;
count=0;
while residual>conv_error
    count=count+1;
    dW=zeros(size(W));
    dH=zeros(size(H));
    W1=zeros(size(W,1),size(W,1));W2=zeros(size(W));
    H1=zeros(size(H));H2=zeros(size(H));
    
    for tr=1:size(Xtr,3)
        X=Xtr(:,:,tr);
        Y=Ytr(:,:,tr);
        %dH=dH+(X'*W*W'*X*H-X'*W*Y+1*eye(size(H)));
        H1=H1+X'*W*Y;
        H2=H2+X'*W*W'*X;        
    end           
    %H=H-mh*dH;
    H=H1*inv(H2+1*eye(size(H2)));
    
    for tr=1:size(Xtr,3)
        X=Xtr(:,:,tr);
        Y=Ytr(:,:,tr);
       % dW=dW+(X*H*H'*X'*W-X*H*Y'+1*eye(size(W)));
        W1=W1+(X*H*H'*X');
        W2=W2+X*H*Y';
    end
    %W=W-mw*dW;
    W=inv(W1+1*eye(size(W1)))*W2;
    
    
   
    for tr=1:size(Xtr,3)
        res(tr)=norm(Ytr(:,:,tr)-W'*Xtr(:,:,tr)*H,'fro');
        Yest(:,:,tr)=W'*Xtr(:,:,tr)*H;
    end
%     Yest=(tprod((tprod(W,[-1 1],Xtr,[-1 2 3])),[1 -2 3],H,[-2 2]));
%     residual=sum(tprod(Ytr-Yest,[-1 -2 1],Ytr-Yest,[-1 -2 1]).^.5);
    residual=sum(res);
    %fprintf(['g' num2str(round(residual))]);
    if count==100
        break;
    end
end
out.W=W;
out.H=H;
out.Yest=Yest;
out.residual=residual;
end