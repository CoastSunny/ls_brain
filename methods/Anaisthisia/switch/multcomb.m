function out=multcomb(tfpr,n,mp,sp,mn,sn)

pnav=@(theta,n,m,s)( 1-normcdf(theta,m,s/sqrt(n)) );
pnrow=@(theta,n,m,s)( (1-normcdf(theta,m,s))^n );
tnav=@(c,n,m,s)( norminv(1-c,m,s/sqrt(n)) );
tnrow=@(c,n,m,s)( norminv(1-c^(1/n),m,s) );

out.theta_nav=tnav(tfpr,n,mn,sn);
out.theta_nrow=tnrow(tfpr,n,mn,sn);
out.theta_prime=tnav(pnrow(out.theta_nrow,n,mp,sp),n,mp,sp);

out.df=out.theta_prime-out.theta_nav;

out.tpr=pnav(0,1,mp,sp);
out.tnr=1-pnav(0,1,mn,sn);

out.fpr_nrow=pnrow(out.theta_nrow,n,mn,sn);
out.fpr_nav=pnav(out.theta_nav,n,mn,sn);
out.fpr_prime=pnav(out.theta_prime,n,mn,sn);

out.tpr_nrow=pnrow(out.theta_nrow,n,mp,sp);
out.tpr_nav=pnav(out.theta_nav,n,mp,sp);
out.tpr_prime=pnav(out.theta_prime,n,mp,sp);


end