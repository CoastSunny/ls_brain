 
cheating_bias=0;
m2=N;
out=dmsavAd;
out_nrow=dmnrowAd;
tau=1:173;

Pf=FpAd;
Nf=FnAd;
selp=1:20;
seln=1:20;
for jj=1:10;
  
    B(jj,:)=[-mean(Pf{jj}(selp)) -mean(Nf{jj}(seln)) std(Pf{jj}(selp)) std(Nf{jj}(seln))];    

end
clear rr
for i=1:10;tmp=xcorr(Nf{i}-mean(Nf{i}),5,'coeff');rr(i,:)=tmp(end-4:end);end;%rr,mean(rr)

for i=1:size(B,1)  
    
    %embc_res(i)=checkmethod(B(i,1),B(i,3),B(i,2),B(i,4),N,tp,method,0);
    embc_res(i)=threshold_calculations(B(i,1),B(i,3),0,B(i,2),B(i,4),rr(i,:),N,tp,method);
    mtpr_savA(i)=embc_res(i).tpr_sav;
    mtpr_nrowA(i)=embc_res(i).tpr_nrow;
    mfpr_savA(i)=embc_res(i).fpr_sav;
    mfpr_nrowA(i)=embc_res(i).fpr_nrow;
    bias_savA(i)=embc_res(i).bias_sav;
    bias_nrowA(i)=embc_res(i).bias_nrow;
    tpr_ksav=embc_res(i).tpr_ksav;
    tpr=[tpr_ksav repmat(mtpr_savA(i),1,173-numel(tpr_ksav))];
    P=[tpr(1) tpr(2:end).*cumprod(1-tpr(1:end-1))];
    if sum(P)>0.99
        mTTD(i)=sum(P.*tau);
    else
        mTTD(i)=nan;
    end
    msTTD(i)=sqrt(sum( (tau-mTTD(i)).^2.*P ));
    tpr_knrow=embc_res(i).tpr_knrow;
    tpr=[tpr_knrow repmat(mtpr_nrowA(i),1,173-numel(tpr_knrow))];
    P=[tpr(1) tpr(2:end).*cumprod(1-tpr(1:end-1))];
    if sum(P)>.99
        mnTTD(i)=sum(P.*tau);
    else
        mnTTD(i)=nan;
    end
    mnsTTD(i)=sqrt(sum( (tau-mnTTD(i)).^2.*P ));
    
end
fpr_target=embc_res(1).fpr_sav_cal;
%fpr_target=0.15;
synchperf_crossA
amtpr_savA=amtpr;
amfpr_savA=amfpr;


fpr_target=embc_res(1).fpr_nrow_cal;
synchperf_cross_nrowA
amtpr_nrowA=amtpr;
amfpr_nrowA=amfpr;

GsavA=[amtpr_savA;mtpr_savA;amfpr_savA;mfpr_savA;];
GsavA(:,end+1)=mean(GsavA,2);
GnrowA=[amtpr_nrowA;mtpr_nrowA;amfpr_nrowA;mfpr_nrowA;];
GnrowA(:,end+1)=mean(GnrowA,2);


% gres=[mean(GsavC');
% mean(GnrowC')];
GsavA
GnrowA