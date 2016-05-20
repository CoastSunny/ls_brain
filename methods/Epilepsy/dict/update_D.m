function [D1,S]=update_D(Patches,X,S,D)

    x_v=reshape(X,[1 prod(size(X))]);    
    for i=1:size(D,2)
%         'update D'
%         i
        e=[];
        w=find(S(:,i)~=0);
        
        for j=1:size(w)
            d=[D(:,1:i-1) D(:,i+1:end)];
            s=S(w(j),:);
            s=[s(:,1:i-1) s(:,i+1:end)];
            e(:,j)=Patches(:,:,w(j))*x_v'-d*s';
        end
        [u,delta,v]=svds(e,1);
        if(size(u,1)==0)
            D1(:,i)=D(:,i);
        else
            D1(:,i)=u(:,1);
        end
        %This was missed before
        S(w,i)=v*delta;
    end
    
end