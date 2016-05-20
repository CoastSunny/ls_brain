mp=.7;sp=.8;mn=-.7;sn=.8;c=0.1;n=3;

% 
% norminv(1-pnrow(tnrow(c,2,mn,sn),2,mp,sp))*sp/sqrt(n)
% -norminv(1-c)*sn/sqrt(n)
% norminv(1-pnrow(tnrow(c,2,mn,sn),2,mp,sp))*sp/sqrt(n)-norminv(1-c)*sn/sqrt(n)
norminv(1-pnrow(tnrow(c,n,mn,sn),n,mp,sp))*sp/sqrt(n)-norminv(1-c)*sn/sqrt(n)+mp-mn
norminv(1-pnav(tnav(c,n,mn,sn),n,mp,sp))*sp/sqrt(n)-norminv(1-c)*sn/sqrt(n)+mp-mn
