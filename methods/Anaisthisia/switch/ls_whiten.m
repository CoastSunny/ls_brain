function [white_data Sigma]=ls_whiten(colored_data,method,L,T,time_window)
%This function whitens or normalises the input data according to 5
%different methods.
%Method 1-simple single trial symmetric whitening with an ad-hoc regularisation
%Method 2-multi-trial equally weighted symmetric whitening with regularisation
%Method 3-multi-trial whitening with exponentially weighted data
%Method 4-multi-trial whitening with exponentially weighted covariance
%matrices
%Method 5-signle-trial channel normalisation
%
%[white_data Sigma]=ls_whiten(colored_data,method,L,trdim,T,time_window,timedim)
%
% Inputs:
%  colored_data - channel x time x trials data ONLY
%  method  - from 1 to 5
%  L - half-life forgetting factor for methods 3 and 4
%  trdim - dimension where the trials are
%  T = maximum number of consecutive trials to apply method on
oX=colored_data;
X=oX;
if (method~=0)    
    
    if nargin<4
        T=0;
    end
    if nargin<5
	time_window=1:size(X,2);
    end
           
    X=repop(X,'-',mean(X(:,time_window,:),2));
 
    alpha=@(n)(1-0.5^(1/n));
    ewma=@(L,K)((1-alpha(L)).^(K:-1:1));
    forg=ewma(L,size(X,3));
    S=[];
    for i=1:size(X,3)
        
        if (method==1)
            Y=X(:,time_window,i);
            M=cov(Y');           
            M=inv(sqrtm(M));% or pinv!!
            oX(:,:,i)=M*X(:,:,i);
        elseif method==2
            if (i<L)
                [R D wX]=whiten(X(:,time_window,1:i),1,1,0,0,1);
            else
                [R D wX]=whiten(X(:,time_window,i-L+1:i),1,1,0,0,1);
            end
            oX(:,:,i)=R'*X(:,:,i);
        elseif method==3
            
            if i<=T
                for jj=1:i
                    Y(:,:,jj)=forg(end-i+jj)*X(:,:,jj);
                end
            else
                for jj=1:T
                    Y(:,:,jj)=forg(end-i+jj)*X(:,:,jj+(i-T));
                end
            end
            [R D wX]=whiten(Y(:,time_window,:),1,1,0,0,1);
            oX(:,:,i)=wX(:,:,end);
        elseif method==4
                          
            [St shrink]=shrinkDiag(X(:,time_window,i)');
            if (i==1)
                S=St;
            else
                S=alpha(L)*St+(1-alpha(L))*S;
            end
                  
            [U V]=eig(S);
            P=U*inv(sqrtm(V))*U';
             if sum(sum(isnan(P)))>0
                continue;                
            end
            oX(:,:,i)=P*X(:,time_window,i);
       
            
        elseif method==5
            
            for channel=1:size(X,1)
                
                oX(channel,time_window,i)=X(channel,time_window,i)/norm(X(channel,time_window,i));
                
            end
        elseif method==6
            
            M=mean(X,1);
            S=std(X,[],1);
            X=repop(X,'-',M);
            oX=repop(X,'./',S);
            
        end
        
        clear Y
    end
    
end
white_data=oX;
end
