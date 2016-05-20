function V = ls_lasso(X,Ds,rDs,param)

V=mexLasso(X,cat(2,Ds,rDs),param);
% 
% for i=1:size(X,2)
% Ms=max(max(abs(Ds'*X(:,i))));
% Mrs=max(max(abs(rDs'*X(:,i))));
% 
% if Ms>=Mrs
%     vs=mexLasso(X(:,i),Ds,param);
%     X(:,i)=X(:,i)-Ds*vs;
%     vrs=mexLasso(X(:,i),rDs,param);
%     V(:,i)=cat(1,full(vs),full(vrs));
% else   
%     vrs=mexLasso(X(:,i),rDs,param);
%     X(:,i)=X(:,i)-rDs*vrs;
%     vs=mexLasso(X(:,i),Ds,param);
%     V(:,i)=cat(1,full(vs),full(vrs));
% end

end