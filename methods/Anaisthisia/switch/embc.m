clear embc_res mtpr_sav mtpr_nrow mfpr_sav mfpr_nrow
%method=4;
%N=6;
m2=N;
tau=1:173;
% tp=0.1;
correc=1;
stdcorr=1;
dB=.0;
dN=0;
mcorrec=0;
mTTD=[];mtpr_savA=[];mfpr_savA=[];mfpr_nrowA=[];mtpr_nrowA=[];mnTTD=[];nTTD=[];
TTD=[];amtpr_savA=[];amfpr_savA=[];amtpr_nrowA=[];amfpr_nrowA=[];TTD2=[];nTTD2=[];
amfpr2=[];amtpr2=[];

% sel1=18;%sel;
% %sel2=27;%sel;
% tau=1:173;
% sel2start=1;
% sel2=18;
% %bias_target=-.5;
% %for jj=1:10;A(jj,:)=[-mean(Fp{jj}) -mean(Fn{jj}) std(Fp{jj}) std(Fn{jj})];end
% for jj=1:10;
%     if jj==1;
%         sel1=18;%48
%     elseif jj==4
%         sel1=18;%56
%     else
%         sel1=18;%60
%     end
%     A(jj,:)=[-mean(FpL{jj}(1:sel1)) -mean(FnL{jj}(1:sel1)) std(FpL{jj}(1:sel1)) std(FnL{jj}(1:sel1))];
%     
% 
%     [dummy1 dummy2 mpCI2(jj,:) spCI2(jj,:)] = normfit(-FpL{jj}(1:sel1),0);
%     [dummy3 dummy4 mnCI2(jj,:) snCI2(jj,:)] = normfit(-FnL{jj}(1:sel1),0);
% 
% end
% % for jj=1:10;B(jj,:)=[-mean(Fp{jj}(sel2start:sel2))-median(Fp{jj}(sel2start:sel2))...
% %         -mean(Fn{jj}(sel2start:sel2))-median(Fn{jj}(sel2start:sel2)) ...
% %         std(Fp{jj}(sel2start:sel2)) std(Fn{jj}(sel2start:sel2))];end;
% 
% % for jj=1:10;B(jj,:)=[-mean(Fp{jj}(sel2start:sel2))...
% %         -mean(Fn{jj}(sel2start:sel2))...
% %         std(Fp{jj}(sel2start:sel2)) std(Fn{jj}(sel2start:sel2))];end;
% for jj=1:10
% 
%     [dummy1 dummy2 mpCI(jj,:) spCI(jj,:)] = normfit(-Fp{jj}(1:sel2),0);
%     [dummy3 dummy4 mnCI(jj,:) snCI(jj,:)] = normfit(-Fn{jj}(1:sel2),0);
% 
% end
% for jj=1:10;A(jj,:)=[-mean(FpL{jj}) -mean(FnL{jj}(1:sel1)) std(FpL{jj}) std(FnL{jj}(1:sel1))];end;
% for jj=1:10;B(jj,:)=[-mean(Fp{jj}(1:sel2)) -mean(Fn{jj}(1:sel2)) std(Fp{jj}(1:sel2)) std(Fn{jj}(1:sel2))];end;
% %for jj=1:5;B(jj,:)=[-mean(Fp2{jj}) -mean(Fn2{jj}) std(Fp2{jj}) std(Fn2{jj})];end
% A=A;
% %A(4,4)=std(a);
% %B(:,1)=B(:,1)/2;
% %B(:,2)=B(:,2)/2;
% %B=B1+B2+B;B=B/3;
% for i=1:size(A,1)
%     
%     scorrec=1;snCI2(i,2)/A(i,4);
%     mcorrec=0;mnCI2(i,2)-A(i,2);
%     embc_res(i)=checkmethod(A(i,1),stdcorr*A(i,3),A(i,2),stdcorr*A(i,4),N,tp,method,0,0,scorrec,mcorrec);
%     mtpr_sav(i)=embc_res(i).tpr_sav;
%     mtpr_nrow(i)=embc_res(i).tpr_nrow;
%     mfpr_sav(i)=embc_res(i).fpr_sav;
%     mfpr_nrow(i)=embc_res(i).fpr_nrow;
%     bias_sav(i)=embc_res(i).bias_sav;
%     bias_nrow(i)=embc_res(i).bias_nrow;
%     
% end
% 
% for i=1:size(B,1)
%     
%     scorrec2=1;snCI(i,2)/B(i,4);
%     mcorrec2=0;mnCI(i,2)-B(i,2);
%     scorrec1=1;spCI(i,1)/B(i,3);
%     mcorrec1=0;mpCI(i,1)-B(i,1);
%     embc_res(i)=checkmethod(mcorrec1+B(i,1),scorrec1*stdcorr*B(i,3),B(i,2),stdcorr*B(i,4),N,tp,method,0,0,scorrec2,mcorrec2);
%     mtpr_savC(i)=embc_res(i).tpr_sav;
%     mtpr_nrowC(i)=embc_res(i).tpr_nrow;
%     mfpr_savC(i)=embc_res(i).fpr_sav;
%     mfpr_nrowC(i)=embc_res(i).fpr_nrow;
%     bias_savC(i)=embc_res(i).bias_sav;
%     bias_nrowC(i)=embc_res(i).bias_nrow;
%     tpr_ksav=embc_res(i).tpr_ksav;
%     tpr=[tpr_ksav repmat(mtpr_savC(i),1,173-numel(tpr_ksav))];
%     P=[tpr(1) tpr(2:end).*cumprod(1-tpr(1:end-1))];
%     if sum(P)>0.99
%         mTTD(i)=sum(P.*tau);
%     else
%         mTTD(i)=nan;
%     end
%     msTTD(i)=sqrt(sum( (tau-mTTD(i)).^2.*P ));
%     tpr_knrow=embc_res(i).tpr_knrow;
%     tpr=[tpr_knrow repmat(mtpr_nrowC(i),1,173-numel(tpr_knrow))];
%     P=[tpr(1) tpr(2:end).*cumprod(1-tpr(1:end-1))];
%     if sum(P)>0.99
%         mnTTD(i)=sum(P.*tau);
%     else
%         mnTTD(i)=nan;
%     end
%     mnsTTD(i)=sqrt(sum( (tau-mnTTD(i)).^2.*P ));
%     
% end
% %fpr_target=embc_res(1).fpr_sav_cal;
% fpr_target=tp;
% 
% synchperf_d1
% amtpr_sav=amtpr2;
% amfpr_sav=amfpr2;
% synchperf_cross
% amtpr_savC=amtpr;
% amfpr_savC=amfpr;
% amtpr2_savC=amtpr2;
% amfpr2_savC=amfpr2;
% 
% 
% %fpr_target=embc_res(1).fpr_nrow_cal;
% %fpr_target=0.01;
% synchperf_d1_nrow
% amtpr_nrow=amtpr2;
% amfpr_nrow=amfpr2;
% synchperf_cross_nrow
% amtpr_nrowC=amtpr;
% amfpr_nrowC=amfpr;
% amtpr2_nrowC=amtpr2;
% amfpr2_nrowC=amfpr2;
% 
% Gsav=[amtpr_sav;mtpr_sav;amfpr_sav;mfpr_sav;];
% Gsav(:,end+1)=mean(Gsav,2);
% Gnrow=[amtpr_nrow;mtpr_nrow;amfpr_nrow;mfpr_nrow;];
% Gnrow(:,end+1)=mean(Gnrow,2);
% GsavC=[amtpr_savC;mtpr_savC;amfpr_savC;mfpr_savC;];
% GsavC(:,end+1)=mean(GsavC,2);
% GnrowC=[amtpr_nrowC;mtpr_nrowC;amfpr_nrowC;mfpr_nrowC;];
% GnrowC(:,end+1)=mean(GnrowC,2);
% 
% fres=[TTD*6;mTTD*6;nTTD*6;mnTTD*6;GsavC(3,1:end-1);GnrowC(3,1:end-1);...
%     GsavC(4,1:end-1);GnrowC(4,1:end-1);amfpr222;amfpr2222];
% fres(:,end+1)=mean(fres,2);
% % R=[mTTD*6;TTD*6;mnTTD*6;nTTD*6;mtpr_savC;amtpr2_savC;amtpr_savC;mtpr_nrowC;amtpr2_nrowC;amtpr_nrowC;...
% % mfpr_savC;amfpr2_savC;amfpr_savC;mfpr_nrowC;amfpr2_nrowC;amfpr_nrowC;];
% Rsav=[mTTD*6;TTD*6;mtpr_savC;amtpr2_savC;amtpr_savC;mfpr_savC;amfpr2_savC;amfpr_savC;];
% %Rsav(:,end+1)=mean(Rsav(:,[1:6 8:10]),2);
% Rsav(:,end+1)=Rsav(:,[6]);
% Rnrow=[mnTTD*6;nTTD*6;mtpr_nrowC;amtpr2_nrowC;amtpr_nrowC;mfpr_nrowC;amfpr2_nrowC;amfpr_nrowC;];
% Rnrow(:,end+1)=mean(Rnrow,2);
% R=Rnrow;
% % fres2=[TTD2*6;Gsav(3,:);Gnrow(3,:)];
% % fres2(:,end+1)=mean(fres2,2)
% gres=[mean(Gsav')
% mean(Gnrow')
% mean(GsavC')
% mean(GnrowC')];
% % 
 seln=60;
 selp=30;
 
 FFp=FpAd; 
 FFn=FnAd;
 FFn2=FnAd;
 
 FFp
%  FFp=cFpI;
%  FFn=cFnI;
%  FFn2=cFnI;
%  
for jj=1:10
  %        selp=numel(FFp{jj});
   %       seln=numel(FFn2{jj});
%      y=-FFn2{jj}(1:seln)';
%      x=1:numel(y);
%      p=polyfit(x,y,4);
%      py=polyval(p,x);
% % %     %py=detrend(y);
%      y_prime{jj}=y-py+mean(py);
%    %  y_prime{jj}=y_prime{jj}-y_prime{jj}(1)+y(1);
%      C(jj,:)=[-trimmean(FFp{jj}(1:selp),0) trimmean(y_prime{jj},tp0)...
%          std(FFp{jj}(1:selp)) std(FFn2{jj}(1:seln))];
% 
    C(jj,:)=[-trimmean(FFp{jj}(1:selp),0) -trimmean(FFn2{jj}(1:seln),0)...
        std(FFp{jj}(1:selp)) std(FFn2{jj}(1:seln))];
%         C(jj,:)=[-median(FFp{jj}(1:selp)) -median(FFn2{jj}(1:seln))...
%         std(FFp{jj}(1:selp)) std(FFn2{jj}(1:seln))];
end
%for jj=1:10;C(jj,:)=[-mean(FpAd{jj}(1:end)) -mean(FnAd{jj}(1:end)) std(FpAd{jj}(1:end)) std(FnAd{jj}(1:end))];end;

%rho=0;
%C(:,3:4)=[mean(C(:,3:4),2) mean(C(:,3:4),2)];
for i=1:size(C,1)
 %    seln=numel(FFn2{i});
 %    selp=numel(FFp{i});
    tmp=xcorr(FFn2{i}(1:seln)-mean(FFn2{i}(1:seln)),FFn2{i}(1:seln)-mean(FFn2{i}(1:seln)),4,'coeff');
    tmp(tmp<0)=0;
    tmp2=xcorr(FFp{i}(1:selp)-mean(FFp{i}(1:selp)),FFp{i}(1:selp)-mean(FFp{i}(1:selp)),4,'coeff');
    tmp2(tmp2<0)=0;
    rhon(i,:)=[tmp(4) tmp(3) tmp(2) tmp(1)];
    rhop(i,:)=[tmp2(4) tmp2(3) tmp2(2) tmp2(1)];
   % rhop(i)=rhon(i);
    %  rhop(i)=0;rhon(i)=0;
    scorrec2=1;%snCI(i,2)/C(i,4);
    mcorrec2=0;%mnCI(i,2)-C(i,2);
    scorrec1=1;%spCI(i,1)/C(i,3);
    mcorrec1=0;%mpCI(i,1)-C(i,1);
%     if i==3;method=5;end;
    embc_res(i)=checkmethod(mcorrec1+C(i,1),scorrec1*stdcorr*C(i,3),C(i,2),stdcorr*C(i,4),N,tp,method,rhop(i,:),rhon(i,:),scorrec2,mcorrec2);
    Fcal(i)=embc_res(i).fpr_sav_cal;
    mtpr_savA(i)=embc_res(i).tpr_sav;
    mtpr_nrowA(i)=embc_res(i).tpr_nrow;
    mfpr_savA(i)=embc_res(i).fpr_sav;
    mfpr_nrowA(i)=embc_res(i).fpr_nrow;
    bias_savA(i)=embc_res(i).bias_sav;
    bias_nrowA(i)=embc_res(i).bias_nrow;
    tpr_ksav=embc_res(i).tpr_ksav;
    tpr=[tpr_ksav repmat(mtpr_savA(i),1,173-numel(tpr_ksav))];
    mTPR(i,:)=tpr;
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
    if sum(P)>0.99
        mnTTD(i)=sum(P.*tau);
    else
        mnTTD(i)=nan;
    end
    mnsTTD(i)=sqrt(sum( (tau-mnTTD(i)).^2.*P ));
    
end

amfpr2=[];amtpr2=[];

fpr_target=tp;
synchperf_asynch
amtpr_savA=amtpr;
amtpr_savA(end+1)=mean(amtpr);
amfpr_savA=amfpr;
amfpr_savA(end+1)=mean(amfpr_savA);
mfpr_savA(end+1)=mean(mfpr_savA);
amfpr2(end+1)=mean(amfpr2);
amtpr2(end+1)=mean(amtpr2);
mTTD(end+1)=nanmean(mTTD);
TTD(end+1)=nanmean(TTD);
TTD2(end+1)=nanmean(TTD2);
mtpr_savA(end+1)=mean(mtpr_savA);
Rsav=[mTTD;TTD2;TTD;mtpr_savA;amtpr2;amtpr_savA;mfpr_savA;amfpr2;amfpr_savA;]
%Rsav(end+1,:)=(Rsav(5,:)+1-Rsav(8,:))/2;
amfpr2=[];amtpr2=[];
synchperf_asynch_nrow
amtpr_nrowA=amtpr;
amtpr_nrowA(end+1)=mean(amtpr);
amfpr_nrowA=amfpr;
amfpr_nrowA(end+1)=mean(amfpr_nrowA);
mfpr_nrowA(end+1)=mean(mfpr_nrowA);
amfpr2(end+1)=mean(amfpr2);
amtpr2(end+1)=mean(amtpr2);
mnTTD(end+1)=nanmean(mnTTD);
nTTD(end+1)=nanmean(nTTD);
nTTD2(end+1)=nanmean(nTTD2);
mtpr_nrowA(end+1)=mean(mtpr_nrowA);
Rnrow=[mnTTD;nTTD2;nTTD;mtpr_nrowA;amtpr2;amtpr_nrowA;mfpr_nrowA;amfpr2;amfpr_nrowA;]
%Rnrow(end+1,:)=(Rnrow(5,:)+1-Rnrow(8,:))/2;
R=Rnrow;
%Rsav(:,1)





