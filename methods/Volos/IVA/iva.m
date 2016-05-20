function res = iva(X,varargin)

opts = struct ( 'paths' , [] , 'marker' , [] , 'cfg' , [] ) ;
[ opts  ] = parseOpts( opts , varargin );
opts2var

K=size(X,3);
N=size(X,1);
T=size(X,2);
change=1;
l=.01;
for k=1:K
    W(:,:,k)=eye(N);
    Wold(:,:,k)=eye(N);
    ek(:,k)=zeros(K,1);ek(k,k)=1;
end
while change >0.0001
    for k=1:K
        Y(:,:,k)=W(:,:,k)*X(:,:,k);
    end
    for k=1:K
        %phi=Y(:,:,k)./sqrt(sum(Y.^2,3));
        dW=zeros(N,N);
        y_k(:,:,k)=Y(:,:,k)';
        for i=1:N
            cov(:,:,i)=zeros(K,K);
            for t=1:T
                y_n=Y(i,t,:);
                y_n=reshape(y_n,K,1);
                cov(:,:,i) = cov(:,:,i) + y_n * y_n';
            end
            cov(:,:,i)=1/T*cov(:,:,i);
        end
        clear y_n
        
        for i=1:N
            tmp=Y(i,:,:);
            y_n=reshape(tmp,K,T);
            phi(i,:,k)=(y_n'*inv(cov(:,:,i))*ek(:,k))';
        end
    end
        
    for k=1:K
%         a=zeros(N,N);
%         for t=1:T
%             a=a+phi(:,t,k)*y_k(t,:,k);
%         end
%         a=1/T*a;
        tmp=1/T*phi(:,:,k)*y_k(:,:,k);
        dW=l*(tmp-eye(N))*W(:,:,k);
        W(:,:,k)=W(:,:,k) - dW;        
        vchange(k)=norm(W(:,:,k)-Wold(:,:,k),'fro');
        Wold(:,:,k)=W(:,:,k);
    end
    
    change=max(vchange);
    fprintf('change: %s\n',num2str(change));
    l=0.96*l;
end
for k =1:K
    Y(:,:,k)=W(:,:,k)*X(:,:,k);
end
res.Y=Y;
res.W=W;
l
end

