function X=update_X(A2,D,NbSources,y2,y_v,Patches,S,lambda)
    
    summation1=0;
    summation2=0;
    
    for i=1:size(Patches,3)
%         'update X_1'
%         i
        summation1=summation1+Patches(:,:,i)'*Patches(:,:,i);
    end
    
    for i=1:size(Patches,3)
%         'update X_2'
%         i

%         size(S(i,:))
%         size(D)
%         size(Patches(:,:,i))
        summation2=summation2+Patches(:,:,i)'*D*S(i,:)';
    end
    
    %multiplication 
    %x_v=inv(lambda*(kron(eye(length(y_v)),A)'*kron(eye(length(y_v)),A)))*(lamda*kron(eye(length(y_v)),A)'*y_v+summation2);
    
    %distance
   % size(A)
   % size(eye(length(y_v)))
    x_v=inv(lambda*(kron(eye(y2),A2)'*kron(eye(y2),A2))+summation1)*(lambda*kron(eye(y2),A2)'*y_v'+summation2);
    
    X=reshape(x_v,[NbSources y2]);

end