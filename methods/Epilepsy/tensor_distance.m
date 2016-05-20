function metric = tensor_distance(X,Y,channel_idx,trial_idx,method)

if nargin<5
    method='eucl';
end

flag=0;
if norm(X(1,:,1))==0
    flag=1;
end

if strcmp(method,'eucl')
for i=1:size(X,trial_idx)

    x=X(:,:,i);
    y=Y(:,:,i);  
    for ch=1:size(X,channel_idx)    
        if flag==0
        x(ch,:)=x(ch,:)/norm(x(ch,:));
        end
        y(ch,:)=y(ch,:)/norm(y(ch,:));
    end
    
    e(i)=norm(x-y,'fro');

end
metric=sum(e);
elseif strcmp(method,'corr')

    for i=1:size(X,trial_idx)

    x=X(:,:,i);
    y=Y(:,:,i);  
    for ch=1:size(X,channel_idx)    
     corrxy(ch)=corr(x(ch,:)',y(ch,:)');
    end
    
    c(i)=mean(corrxy);

end
metric=mean(c);
end


end
