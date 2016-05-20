function S=update_S(D, sigma, Patches, X)
 
    x_v=reshape(X,[1 prod(size(X))]);
    
    for i=1:size(Patches,3)
%         'update S'
%         i
        Data=Patches(:,:,i)*x_v';
        %omp2 in ompbox10 toolbox
        S(i,:)=omp2(D'*Data,sum(Data.*Data),D'*D,sigma)';
%         S(i,:)=omp2(D,Data,[],sigma)'
    end

end