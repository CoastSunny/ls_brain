function out = threshold_calculations(mp,sp,rp,mn,sn,rn,N,tar,method)

mcorrec=0;
cal_diff=1;

x=-5:0.01:5;

Mu=repmat(mn,1,N);
Sigma=eye(N)*sn^2;
for rc=1:numel(rn)
    for i=1:N
        for j=1:N
            if (abs(i-j)==rc)
                Sigma(i,j)=rn(rc)*sn^2;
            end
        end
    end
end
phi_target=norminv(1-tar);
phi_cal=phi_target/sqrt(N);
theta_cal=phi_cal*sn+mn;
cal=1-normcdf(theta_cal,mn,sn);

if (method==1)
    bias_sav=norminv(1-tar,mn,sn/sqrt(N));
    tt=tar^(1/N);
    bias_nrow=norminv(1-tt,mn,sn);
elseif method==2
    
    bias_sav=norminv(1-tar,mn+mcorrec,cal_diff*sn/N*sqrt(N+2*(N-1)*rn(1)));
    bias_nrow=norminv(1-tar^(1/N),mn+mcorrec,cal_diff*sn);
    tmp=-bias_nrow-2:0.02:-bias_nrow+2;
    
    for i=1:numel(tmp)
        tmp_nrow(i)=mvncdf(repmat(tmp(i),1,N),-Mu,Sigma);
    end
    
    idx_nrow= find(tmp_nrow<=tar);
    bias_nrow=-tmp(idx_nrow(end));
elseif method==3
    bias_sav=norminv(1-cal,mn,cal_diff*sn);
    bias_nrow=norminv(1-tar^(1/N),mn,cal_diff*sn);
elseif method==4
    bias_sav=0;
    bias_nrow=0;
end


out.tpr_sav=1-normcdf(bias_sav,mp,sp/sqrt(N));
out.tpr_nrow=(1-normcdf(bias_nrow,mp,sp))^N;

k=1:N-1;
% out.tpr_ksav = (N-k)./N .* (1-normcdf(bias_sav,mn,sn./sqrt(N))) + ...
%     k/N.*(1-normcdf(bias_sav,mp,sp./sqrt(N)));

out.tpr_ksav = (1-normcdf(bias_sav,(N-k)./N*(mn+mcorrec)...
    +k/N.*mp,sqrt( ( (N-k)*cal_diff*sn^2+k*sp^2) )/N ) );

out.tpr_knrow = (1-normcdf(bias_nrow,(mn+mcorrec),cal_diff*sn))...
    .^(N-k).*(1-normcdf(bias_nrow,mp,sp)).^k;


out.fpr_sav=(1-normcdf(bias_sav,(mn+mcorrec),cal_diff*sn/N*sqrt(N+2*(N-1)*rn(1))));
%out.fpr_nrow=(1-normcdf(bias_nrow,(mn+mcorrec),cal_diff*sn))^N;
out.fpr_nrow=mvncdf(-repmat(bias_nrow,1,N),-Mu,Sigma);

out.fpr_sav_cal=(1-normcdf(bias_sav,mn,sn));
out.fpr_nrow_cal=(1-normcdf(bias_nrow,mn,sn));

out.pos_class=1-normcdf(0,mp,sp);
out.neg_class=normcdf(0,mn,sn);

out.fpr_single=(1-normcdf(bias_sav,mn,sn));

out.PSCDF=1-normcdf(x,mp,sp/sqrt(N));
out.PNCDF=(1-normcdf(x,mp,sp)).^N;
out.NSCDF=1-normcdf(x,mn,sn/sqrt(N));
out.NNCDF=(1-normcdf(x,mn,sn)).^N;
out.PCDF=1-normcdf(x,mp,sp);
out.NCDF=1-normcdf(x,mn,sn);
out.x=x;
out.bias_sav=bias_sav;
out.bias_nrow=bias_nrow;
out.clperf_sav=out.tpr_sav/2+(1-out.fpr_sav)/2;
out.clperf_nrow=out.tpr_nrow/2+(1-out.fpr_nrow)/2;

end
