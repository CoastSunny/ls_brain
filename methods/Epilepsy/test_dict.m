
DN=[];

catall2
noise_values=0.0:.01:.1;
M=randn(size(Xs));
for izz=1:numel(noise_values)

    nn=noise_values(izz);
    N=nn*M;
    catall2
    ls_dict3
    xx=Xi(:,tst);dd=D*Y2;ddx=Dx*Yx2;
    XtX=xx'*xx;dtd=dd'*dd;dtdx=ddx'*ddx;
    nxtx=ones(27,1)*sqrt(diag(XtX))';ndtd=ones(27,1)*sqrt(diag(dtd))';ndtdx=ones(27,1)*sqrt(diag(dtdx))';
    
DN(izz,:)=[...
 norm(Xi(:,tst)-D*Y2,'fro') norm(Xi(:,tst)-Dx*Yx2,'fro') norm(Xi(:,tst)-Dyi*Yy2,'fro')...
 norm(mean(Xi(:,tst),2)-mean(D*Y2,2)) norm(mean(Xi(:,tst),2)-mean(Dx*Yx2,2))...
 norm(mean(Xi(:,tst),2)-mean(Dyi*Yy2,2))...
 norm(Xi(:,tst)-D*Y2i,'fro') norm(Xi(:,tst)-Dx*Yx2i,'fro')...
 norm(Xs(:,tst)-Dc*Y2,'fro') norm(Xs(:,tst)-Dxc*Yx2,'fro')...
 norm(Xs(:,tst)-Dys*Yy2,'fro') norm(Xs(:,tst)-Do*Yo2,'fro')...
  rrx rr(end,:) rry]/L;

DN(end,:)
    
end

%
% DN2=[];
% M=randn(size(Xs));
% pen_values=0.4:0.2:10;
% noise_values=0.01:0.05:.25;
% for izz=1:numel(pen_values)
% for izz2=1:numel(noise_values)
% 
%     pen=pen_values(izz)
%     nn=noise_values(izz2)
%     N=nn*M;
%     catall
%     ls_dict3
%     L=size(Xi(:,tst),2);
%     DN2(izz,izz2,:)=[...
%  norm(Xi(:,tst)-D*Y2,'fro') norm(Xi(:,tst)-Dx*Yx2,'fro') norm(Xi(:,tst)-Dyi*Yy2,'fro')...
%  norm(mean(Xi(:,tst),2)-mean(D*Y2,2)) norm(mean(Xi(:,tst),2)-mean(Dx*Yx2,2))...
%  norm(mean(Xi(:,tst),2)-mean(Dyi*Yy2,2))...
%  norm(Xi(:,tst)-D*Y2i,'fro') norm(Xi(:,tst)-Dx*Yx2i,'fro')...
%  norm(Xs(:,tst)-Dc*Y2,'fro') norm(Xs(:,tst)-Dxc*Yx2,'fro')...
%  norm(Xs(:,tst)-Dys*Yy2,'fro') norm(Xs(:,tst)-Do*Yo2,'fro')]/L;
% %  DN(izz,:)=[norm(XI(:,[tst rtst])-D*Y2,'fro') norm(XI(:,[tst rtst])-Dx*Yx2,'fro')...
% %  norm(XI(:,[tst rtst])-D*Y2i,'fro') norm(XI(:,[tst rtst])-Dx*Yx2i,'fro')...
% %  norm(XS(:,[tst rtst])-Dc*Y2,'fro') norm(XS(:,[tst rtst])-Dxc*Yx2,'fro')...
% %  norm(XS(:,[tst rtst])-Do*Yo2,'fro')];
% 
% squeeze(DN2(izz,izz2,:))'
% end
% end

% 
% DNr=[];
% 
% pen_values=0.2:0.2:5;
% 
% for izz=1:numel(pen_values)
% 
%     pen=pen_values(izz)         
%     ls_dict3
%     L=size(Xi(:,tst),2);
%     DNr(izz,:)=[norm(Xi(:,tst)-D*Y2,'fro') norm(Xi(:,tst)-Dx*Yx2,'fro') norm(Xi(:,tst)-Dyi*Yy2,'fro')...
%  norm(mean(Xi(:,tst),2)-mean(D*Y2,2)) norm(mean(Xi(:,tst),2)-mean(Dx*Yx2,2))...
%  norm(mean(Xi(:,tst),2)-mean(Dyi*Yy2,2))...
%  norm(Xi(:,tst)-D*Y2i,'fro') norm(Xi(:,tst)-Dx*Yx2i,'fro')...
%  norm(Xs(:,tst)-Dc*Y2,'fro') norm(Xs(:,tst)-Dxc*Yx2,'fro')...
%  norm(Xs(:,tst)-Dys*Yy2,'fro') norm(Xs(:,tst)-Do*Yo2,'fro')]/L;
% %  DN(izz,:)=[norm(XI(:,[tst rtst])-D*Y2,'fro') norm(XI(:,[tst rtst])-Dx*Yx2,'fro')...
% %  norm(XI(:,[tst rtst])-D*Y2i,'fro') norm(XI(:,[tst rtst])-Dx*Yx2i,'fro')...
% %  norm(XS(:,[tst rtst])-Dc*Y2,'fro') norm(XS(:,[tst rtst])-Dxc*Yx2,'fro')...
% %  norm(XS(:,[tst rtst])-Do*Yo2,'fro')];
%     
% DNr(izz,:)
% end
% 
% 
% DNr2=[];
% k_values=2:25;
% 
% for izz=1:numel(k_values)
% 
%     k=k_values(izz);   
%     ls_dict3
%        DNr2(izz,:)=[norm(Xi(:,tst)-D*Y2,'fro') norm(Xi(:,tst)-Dx*Yx2,'fro') norm(Xi(:,tst)-Dyi*Yy2,'fro')...
%  norm(mean(Xi(:,tst),2)-mean(D*Y2,2)) norm(mean(Xi(:,tst),2)-mean(Dx*Yx2,2))...
%  norm(mean(Xi(:,tst),2)-mean(Dyi*Yy2,2))...
%  norm(Xi(:,tst)-D*Y2i,'fro') norm(Xi(:,tst)-Dx*Yx2i,'fro')...
%  norm(Xs(:,tst)-Dc*Y2,'fro') norm(Xs(:,tst)-Dxc*Yx2,'fro')...
%  norm(Xs(:,tst)-Dys*Yy2,'fro') norm(Xs(:,tst)-Do*Yo2,'fro')...
% rrx rr(end,:) rry]/L;
% %  DN(izz,:)=[norm(XI(:,[tst rtst])-D*Y2,'fro') norm(XI(:,[tst rtst])-Dx*Yx2,'fro')...
% %  norm(XI(:,[tst rtst])-D*Y2i,'fro') norm(XI(:,[tst rtst])-Dx*Yx2i,'fro')...
% %  norm(XS(:,[tst rtst])-Dc*Y2,'fro') norm(XS(:,[tst rtst])-Dxc*Yx2,'fro')...
% %  norm(XS(:,[tst rtst])-Do*Yo2,'fro')];
% 
%     
% end
% % 
% l_values=0:0.02:0.2;
% 
% for izz=1:numel(k_values)
% 
%     l=l_values(izz);   
%     ls_dict2
%     DN(izz,:)=[norm(Xi(:,tst)-D*Y2,'fro') norm(Xi(:,tst)-Dx*Yx2,'fro')...
%         norm(mean(Xi(:,tst),2)-mean(D*Y2,2)) norm(mean(Xi(:,tst),2)-mean(Dx*Yx2,2))...
%  norm(Xi(:,tst)-D*Y2i,'fro') norm(Xi(:,tst)-Dx*Yx2i,'fro')...
%  norm(Xs(:,tst)-Dc*Y2,'fro') norm(Xs(:,tst)-Dxc*Yx2,'fro')...
%  norm(Xs(:,tst)-Do*Yo2,'fro')...
%  rrx rr(end,:)];
% %  DN(izz,:)=[norm(XI(:,[tst rtst])-D*Y2,'fro') norm(XI(:,[tst rtst])-Dx*Yx2,'fro')...
% %  norm(XI(:,[tst rtst])-D*Y2i,'fro') norm(XI(:,[tst rtst])-Dx*Yx2i,'fro')...
% %  norm(XS(:,[tst rtst])-Dc*Y2,'fro') norm(XS(:,[tst rtst])-Dxc*Yx2,'fro')...
% %  norm(XS(:,[tst rtst])-Do*Yo2,'fro')];
% DN(end,:)
%     
% end




