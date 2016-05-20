function D=decorrelation_rotation(Patches,X,D,S,miu,n_itr,NbSources,y2)

%     'D1 decorrelation_rotation code'
%      size(D)
    [d1,d2]=size(D);
    i_itr=1;
    while i_itr <= n_itr
        m=0;
        for i=1:size(D,2)
            for j=i+1:size(D,2)
                m1=abs(sum(D(:,i).*D(:,j)));
                m=max(m,m1);
            end
        end
        if(m<=miu)
            break;
        end
        %Calculate Gram matrix
        G=D'*D;
        for i=1:size(G,1)
            G(i,i)=1;
        end
        %Project onto structural constraint set
        [b,c]=find(G>miu);
        for i=1:length(b)
            G(b(i),c(i))=miu;
        end
        
        [d,e]=find(G<-miu);
        for i=1:length(d)
            G(d(i),e(i))=-miu;
        end
        %Project onto spectral constraint set
        [q,lambda,q2]=svd(G);
%         diag(lambda)
        for i=1:size(lambda,1)
            if (lambda(i,i)<0||i>size(D,1))
                lambda(i,i)=0;
            end
        end
        
        D=lambda^0.5*q';
        D=D(1:d1,:);
        
        %Rotate dictionary
%         'X'
%         size(X)
%         'D'
%         size(D)
%         'S'
%         size(S)

          %for cases with overlap we reshape X 
          %for cases without overla we don't reshape X
        x_v=reshape(X,[1 prod(size(X))]);
        
        C=zeros(size(D,1));
        %calculate C for overlap cases
        for i=1:size(Patches,3)
%             size((Patches(:,:,i)*x_v')*(D*S(i,:)')')
             C=C+(D*S(i,:)')*(Patches(:,:,i)*x_v')';
        end
        
%         C=C/size(Patches,3);
        %no overlap cases
%         ds_v=[];
%         for i=1:size(Patches,3)
%             'D*S(i,:)  Transpose'
%             size(D*S(i,:)') 
%             ds_v=[ds_v;D*S(i,:)'];
%         end
        
        %reshape DS to size(X) for no overlap case
%         DS=reshape(ds_v, [NbSources y2]);
        
        %calculate C for no-overlap cases
%         'X'
%         size(X)
%         'DS'
%         size(DS)
%         C=X*DS';
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     C1=C+0.01*randn(71,71);
    C1=C;
    [u,sigma,v]=svd(C1);

        W=v*u';
%         'D'
%         size(D)
%         'W'
%         size(W)
        D=W*D;
        i_itr=i_itr+1;
    end
  %  D=abs(D);

end