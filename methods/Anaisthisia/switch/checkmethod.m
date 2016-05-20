function out = checkmethod(mp,sp,mn,sn,N,tar,method,rhop,rhon,cal_diff,mcorrec,x)

if nargin<10
    cal_diff=1;
end
if nargin<11
    mcorrec=0;
end
if nargin<12
    x=-5:0.01:5;
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
   % bias_sav=norminv(1-tar,mn+mcorrec,cal_diff*sn/sqrt(N));
   if N<3
       rhon(2:end)=0;
   end
    bias_sav=norminv(1-tar,mn+mcorrec,sn/N*sqrt(N+2*(N-1)*rhon(1)+2*(N-2)*rhon(2)));
    %bias_sav=norminv(1-tar,mn+mcorrec,sn/N*sqrt(N + 2*( (N-1)*rhon(1) + (N-2)* rhon(2) + (N-3) * rhon(3) ) ));
    bias_nrow=norminv(1-tar^(1/N),mn+mcorrec,cal_diff*sn);
elseif method==3
    bias_sav=norminv(1-cal,mn,cal_diff*sn);
    bias_nrow=norminv(1-tar^(1/N),mn,cal_diff*sn);
elseif method==4
    bias_sav=0;
    bias_nrow=0;
elseif method==5
    
    tmpd=diag(repmat(sn^2,1,N));
    if N==1
        S=tmpd;
    elseif N==2
        tmpd1=diag(repmat(sn^2*rhon(1),1,N-1),1);
        tmpdm1=diag(repmat(sn^2*rhon(1),1,N-1),-1);      
        S=tmpd+tmpd1+tmpdm1;
    elseif N==3
        tmpd1=diag(repmat(sn^2*rhon(1),1,N-1),1);
        tmpdm1=diag(repmat(sn^2*rhon(1),1,N-1),-1);      
        tmpd2=diag(repmat(sn^2*rhon(2),1,N-2),2);
        tmpdm2=diag(repmat(sn^2*rhon(2),1,N-2),-2);    
        S=tmpd+tmpd1+tmpdm1+tmpd2+tmpdm2;
    elseif N==4
        tmpd1=diag(repmat(sn^2*rhon(1),1,N-1),1);
        tmpdm1=diag(repmat(sn^2*rhon(1),1,N-1),-1);      
        tmpd2=diag(repmat(sn^2*rhon(2),1,N-2),2);
        tmpdm2=diag(repmat(sn^2*rhon(2),1,N-2),-2);    
        tmpd3=diag(repmat(sn^2*rhon(3),1,N-3),3);
        tmpdm3=diag(repmat(sn^2*rhon(3),1,N-3),-3);
        S=tmpd+tmpd1+tmpdm1+tmpd2+tmpdm2+tmpd3+tmpdm3;
    elseif N>4    
        tmpd1=diag(repmat(sn^2*rhon(1),1,N-1),1);
        tmpdm1=diag(repmat(sn^2*rhon(1),1,N-1),-1);      
        tmpd2=diag(repmat(sn^2*rhon(2),1,N-2),2);
        tmpdm2=diag(repmat(sn^2*rhon(2),1,N-2),-2);    
        tmpd3=diag(repmat(sn^2*rhon(3),1,N-3),3);
        tmpdm3=diag(repmat(sn^2*rhon(3),1,N-3),-3);
        tmpd4=diag(repmat(sn^2*rhon(4),1,N-4),4);
        tmpdm4=diag(repmat(sn^2*rhon(4),1,N-4),-4);
        S=tmpd+tmpd1+tmpdm1+tmpd2+tmpdm2+tmpd3+tmpdm3+tmpd4+tmpdm4;
    end
    
    warning off
    thr=-6:.02:6;
    for y=1:numel(thr)
       temp(y) = mvncdf(-repmat(thr(y),N,1),-repmat(mn,N,1),S);
        %temp = mvncdf(-repmat(x,N,1),-repmat(mn,N,1),diag(repmat( (sn/N*sqrt(N+2*(N-1)*rhon))^2,1,N)));              
    end
    warning on
    idx=find(temp<tar);
   % if x==thr(end); fprintf('asdasdas'); end;
    bias_nrow=thr(idx(1));
    bias_sav=norminv(1-tar,mn+mcorrec,sn/N*sqrt(N+2*(N-1)*rhon(1)+2*(N-2)*rhon(2)));
end


out.tpr_sav=1-normcdf(bias_sav,mp,sp/N*sqrt(N+2*(N-1)*rhop(1)));
out.tpr_nrow=(1-normcdf(bias_nrow,mp,sp))^N;
if method==5
out.tpr_nrow=mvncdf(-repmat(bias_nrow,N,1),-repmat(mp,N,1),S);
end

k=1:N-1;
% out.tpr_ksav = (N-k)./N .* (1-normcdf(bias_sav,mn,sn./sqrt(N))) + ...
%     k/N.*(1-normcdf(bias_sav,mp,sp./sqrt(N)));
% % 
%  out.tpr_ksav = (1-normcdf(bias_sav,(N-k)./N*(mn+mcorrec)...
%      +k/N.*mp,sqrt( ( (N-k)*cal_diff*sn^2+k*sp^2) )/N ) );

out.tpr_ksav = (1-normcdf(bias_sav,(N-k)./N*(mn+mcorrec)...
    +k/N.*mp,sqrt( ( ( (N-k)+2*(N-k-1)*rhon(1))*cal_diff*sn^2+(k+2*(N-k-1)*rhop(1))*sp^2) )/N ) );
    
out.tpr_knrow = (1-normcdf(bias_nrow,(mn+mcorrec),cal_diff*sn))...
    .^(N-k).*(1-normcdf(bias_nrow,mp,sp)).^k;
if method==5
out.tpr_knrow = mvncdf(-repmat(bias_nrow,N,1),-repmat(mp,N,1),S)*...
    mvncdf(-repmat(bias_nrow,N,1),-repmat(mn,N,1),S);
end

out.fpr_sav=(1-normcdf(bias_sav,(mn+mcorrec),cal_diff*sn/N*sqrt(N+2*(N-1)*rhon(1)+2*(N-2)*rhon(2))));
out.fpr_nrow=(1-normcdf(bias_nrow,(mn+mcorrec),cal_diff*sn))^N;
if method==5
 out.fpr_nrow=mvncdf(-repmat(bias_nrow,N,1),-repmat(mn,N,1),S);
end
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
