clear C D E

n=3;
W=sym('w',[n n]);
W(find(tril(ones(n))))=0;
W=W+W.';
R=zeros(n);
col=2;
R(:,col)=1;
H=ones(n)-eye(n);
tau=trace(W^2*R);
rho=trace(W*R);
% WW=sym('w',[3 3]);
% WW(2,1)=WW(1,2);WW(3,1)=WW(1,3);WW(3,2)=WW(2,3);
% w=vec(WW);
% der=(rho/tau-1) * ( (tau*(W*R+R*W).'-rho*R.')/tau^2 );
% der=der+der.';
% vder=vec(der);
% for i=1:numel(w)
%     for j=1:numel(w)
%           
%         E( i, j )=...
%             diff( vder(i) , w(j) );
%         
%     end
% end

% 
% for i=1:n
%     for j=1:n
%         tmp=['w' num2str(i) '_' num2str(j)];
% %         C( n*(i-1)+1:n*i,n*(j-1)+1:n*j)=(diff( (W*R).'/trace(W*R),tmp));
% %         D( n*(i-1)+1:n*i,n*(j-1)+1:n*j)=(diff( (trace(W^2*R)*R.')/trace(W*R)^2,tmp));
%         E( n*(i-1)+1:n*i,n*(j-1)+1:n*j)=...
%             diff( ( (rho/tau-1) * ( (tau*(W*R+R*W).'-rho*R.')/tau^2) ) + ( (rho/tau-1) * ( (tau*(W*R+R*W).'-rho*R.')/tau^2) ).',tmp);
%     end
% end