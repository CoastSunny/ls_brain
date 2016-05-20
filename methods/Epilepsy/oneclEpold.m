for si=1:numel(subj)
cd ~/Documents/MATLAB/res/oneclass/
%  tmp=TPfRX{si}(:,:,:,TRD{si}>0);
%  tmp2=TPfRX{si}(:,:,:,TRD{si}==-1);
%  tmp3=cat(4,tmp,tmp2);
 %tmp3=TPfX{si};
% tmp3=TPfRX{si}(:,:,:,TRD{si}~=0);
% tmp=TPX{si}(:,:,TD{si}~=0);
% tmp2=TPRX{si}(:,:,TRD{si}==-1);
% tmp2=TPfRX{si}(:,:,:,:);
%  tmp=TPfX{si};
%  tmp2=TPfRX{si};
%  tmp3=cat(4,tmp,tmp2);
%  tmp4=cat(3,TPX{si},TPRX{si});
%  Y=reshape(fRX{si},16*9*7,[]);
%  Z=reshape(tmp,16*9*7,[]);
%  Zr=reshape(tmp2,16*9*7,[]);
%  Zsr=reshape(tmp3,16*9*7,[]);
%  ktype='poly';
%  order=[4];
%  [a b c d]=svmoneclass(Y',ktype,order,.9,0);
%  yy=svmoneclassval(Y',a,b,c,ktype,order);
%  y=svmoneclassval(Z',a,b,c,ktype,order);
%  yr=svmoneclassval(Zr',a,b,c,ktype,order);
%  [mean(yy) mean(y) mean(yr)]
%  figure,hold on,plot(yr),plot(y,'r')
 
Y=reshape(fRX{si},size(fRX{si},4),size(fRX{si},1)*size(fRX{si},2)*size(fRX{si},3));
Zr=reshape(TPfRX{si},size(TPfRX{si},4),size(fRX{si},1)*size(fRX{si},2)*size(fRX{si},3));
Z=reshape(TPfX{si},size(TPfX{si},4),size(fRX{si},1)*size(fRX{si},2)*size(fRX{si},3));

 clear svmmodel
 svmmodel=svmtrain(-ones(1,size(Y,1))',Y(:,:),'-s 2 -t 1 -g 1 -d 4');
 svmmodel.rho=svmmodel.rho;
%  [sra srb src]=svmpredict(-ones(1,size(Zsr,2))',Zsr,svmmodel);
 [ra rb rc]=svmpredict(-ones(1,size(Zr,1))',Zr,svmmodel);
 [a b c]=svmpredict(ones(1,size(Z,1))',Z,svmmodel);
% 
% 
Acc(si,:)=[sum(ra==-1)/numel(ra) sum(a==1)/numel(a)];
% 
RC{si}=rc;
C{si}=c;
d=[c' rc'];
[sq id]=sort(d);
highest_id=id(end-50:end);
sig_id=find(highest_id<=size(c,1));
interf_id=find(highest_id>size(c,1));
mixed_sig=cat(3,TPX{si}(:,:,highest_id(sig_id)),TPRX{si}(:,:,highest_id(interf_id)-size(c,1)));
% mixed_sig=tmp4(:,:,highest_id);
% mixed_sig=repop(mixed_sig,'-',mean(mixed_sig,1));
% D{si}=d;
figure,
subplot(2,2,3),hold on,plot(RC{si}),plot(C{si},'r'),title('post-prediction')
subplot(2,2,1),plot(nanmean(ls_whiten(mixed_sig,5,0),3)'),title('predicted')
% subplot(2,2,1),plot(nanmean(detrend(ls_whiten(mixed_sig,5,0),2),3)'),title('predicted')

eval(['Xx=' subj{si} '_sEEG;']);
subplot(2,2,2),plot(mean(Xx,3)'),title('actual')
subplot(2,2,4),hold on,plot(DRP{si}),plot(DP{si},'r','Linewidth',2),title('prediction')
saveaspdf(gcf,['postpred' num2str(si)],'closef')
PPD(si)=norm(ls_whiten(mean(Xx,3),5,0)-ls_whiten(nanmean(mixed_sig,3),5,0),'fro');
%close all
% figure,hold on,scatter(c,zeros(1,numel(c)),'ro'),scatter(rc,zeros(1,numel(rc)),'b*')
% dims=101:150;
% tstd=kde(Y(:,dims)','localp');
% tstZ=evaluate(tstd,Z(:,dims)');
% tstZr=evaluate(tstd,Zr(:,dims)');
% figure,hold on,plot(tstZ,'Linewidth',4),plot(tstZr,'r')
%figure,hold on,plot(DRP{si}),plot(DP{si},'r')
%figure,hold on,plot(d)
end