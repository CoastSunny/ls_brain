cd([home '/Dropbox/Alzheimer/results/Descriptive/'])
save=0;
delta=1+(2:4);
theta=1+(5:7);
alpha=1+(8:13);
beta=1+(14:30);
close all
idx_control=subject_identifier(used_subjects==1)==0;
idx_patient=subject_identifier(used_subjects==1)==1;
fidx_control=find(subject_identifier(used_subjects==1)==0);
fidx_patient=find(subject_identifier(used_subjects==1)==1);
temp=conn_full{1};
Cpat=X(:,:,fidx_patient);
Ccon=X(:,:,fidx_control);
parameter='wpli_debiasedspctrm';
for i=1:23

    spctrm(:,:,:,i)=conn_full{i}.(parameter);    
   
end

Ccpat=mean(abs(spctrm(:,:,:,fidx_patient)),4);
Cccon=mean(abs(spctrm(:,:,:,fidx_control)),4);

Ptemp=conn_full{1};
Ctemp=conn_full{1};

cfg=[];
cfg.layout=[home '/Documents/ls_brain/global/AFAVA.lay'];
cfg.parameter=parameter;

cfg.vlim=[-.2 0.2];

% Ptemp.(cfg.parameter)=cat(3,mean(Ccpat(:,:,delta,:),3), mean(Ccpat(:,:,theta,:),3),...
% mean(Ccpat(:,:,alpha,:),3), mean(Ccpat(:,:,beta,:),3));
% 
% Ctemp.(cfg.parameter)=cat(3,mean(Cccon(:,:,delta,:),3), mean(Cccon(:,:,theta,:),3),...
%     mean(Cccon(:,:,alpha,:),3), mean(Cccon(:,:,beta,:),3));

% Ptemp.cohspctrm=Ccpat;
% Ctemp.cohspctrm=Cccon;
% cfg.refchannel='F3';
% figure,subplot(1,2,1),ft_multiplotER(cfg,Ptemp)
% subplot(1,2,2),ft_multiplotER(cfg,Ctemp)
% cfg.refchannel='F4';
% figure,subplot(1,2,1),ft_multiplotER(cfg,Ptemp)
% subplot(1,2,2),ft_multiplotER(cfg,Ctemp)
% cfg.refchannel='O1';
% figure,subplot(1,2,1),ft_multiplotER(cfg,Ptemp)
% subplot(1,2,2),ft_multiplotER(cfg,Ctemp)
% cfg.refchannel='O2';
% figure,subplot(1,2,1),ft_multiplotER(cfg,Ptemp)
% subplot(1,2,2),ft_multiplotER(cfg,Ctemp)

figure('units','normalized','outerposition',[0.25 0.25 .52 .52]),
subplot(1,2,1),imagesc(mean(Ccpat(:,:,delta),3)),title('Patients')
set(gca,'Ytick',1:16),set(gca,'YtickLabels',temp.label)
set(gca,'Xtick',1:16),set(gca,'XtickLabels',temp.label)
caxis([0 0.1])
subplot(1,2,2), imagesc(mean(Cccon(:,:,delta),3)),title('Controls')
text(-4,-0.5,'(Delta CONN)'),set(gca,'Ytick',1:16),set(gca,'YtickLabels',temp.label)
set(gca,'Xtick',1:16),set(gca,'XtickLabels',temp.label)
caxis([0 0.1])
if save==1;saveaspdf(gcf,'Delta_conn_wplid');end;
figure('units','normalized','outerposition',[0.25 0.25 .52 .52]),
subplot(1,2,1),imagesc(mean(Ccpat(:,:,theta),3)),title('Patients')
set(gca,'Ytick',1:16),set(gca,'YtickLabels',temp.label)
set(gca,'Xtick',1:16),set(gca,'XtickLabels',temp.label)
caxis([0 0.1])
subplot(1,2,2), imagesc(mean(Cccon(:,:,theta),3)),title('Controls')
text(-4,-0.5,'(Theta CONN)'),set(gca,'Ytick',1:16),set(gca,'YtickLabels',temp.label)
set(gca,'Xtick',1:16),set(gca,'XtickLabels',temp.label)
caxis([0 0.1])
if save==1;saveaspdf(gcf,'Theta_conn_wplid');end;
figure('units','normalized','outerposition',[0.25 0.25 .52 .52]),
subplot(1,2,1),imagesc(mean(Ccpat(:,:,alpha),3)),title('Patients')
set(gca,'Ytick',1:16),set(gca,'YtickLabels',temp.label)
set(gca,'Xtick',1:16),set(gca,'XtickLabels',temp.label)
caxis([0 0.1])
subplot(1,2,2), imagesc(mean(Cccon(:,:,alpha),3)),title('Controls')
text(-4,-0.5,'(Alpha CONN)'),set(gca,'Ytick',1:16),set(gca,'YtickLabels',temp.label)
set(gca,'Xtick',1:16),set(gca,'XtickLabels',temp.label)
caxis([0 0.1])
if save==1;saveaspdf(gcf,'Alpha_conn_wplid');end;
figure('units','normalized','outerposition',[0.25 0.25 .52 .52]),
subplot(1,2,1),imagesc(mean(Ccpat(:,:,beta),3)),title('Patients')
set(gca,'Ytick',1:16),set(gca,'YtickLabels',temp.label)
set(gca,'Xtick',1:16),set(gca,'XtickLabels',temp.label)
caxis([0 0.1])
subplot(1,2,2), imagesc(mean(Cccon(:,:,beta),3)),title('Controls')
text(-4,-0.5,'(Beta CONN)'),set(gca,'Ytick',1:16),set(gca,'YtickLabels',temp.label)
set(gca,'Xtick',1:16),set(gca,'XtickLabels',temp.label)
caxis([0 0.1])
if save==1;saveaspdf(gcf,'Beta_conn_wplid');end;
al=0.05;
for i=1:16
    for j=1:16
        [hd(i,j) pd(i,j)]=ttest2(mean(abs(spctrm(i,j,delta,fidx_patient)),3),...
            mean(abs(spctrm(i,j,delta,fidx_control)),3),al);
    end
end

for i=1:16
    for j=1:16
        [ht(i,j) pt(i,j)]=ttest2(mean(abs(spctrm(i,j,theta,fidx_patient)),3),...
            mean(abs(spctrm(i,j,theta,fidx_control)),3),al);
    end
end



for i=1:16
    for j=1:16
        [ha(i,j) pa(i,j)]=ttest2(mean(abs(spctrm(i,j,alpha,fidx_patient)),3),...
            mean(abs(spctrm(i,j,alpha,fidx_control)),3),al);
    end
end

for i=1:16
    for j=1:16
        [hb(i,j) pb(i,j)]=ttest2(mean(abs(spctrm(i,j,beta,fidx_patient)),3),...
            mean(abs(spctrm(i,j,beta,fidx_control)),3),al);
    end
end

figure('units','normalized','outerposition',[0 0 1 1]),
subplot(2,2,1),imagesc(hd),set(gca,'Ytick',1:16),set(gca,'YtickLabels',temp.label),title('Delta')
set(gca,'Xtick',1:16),set(gca,'XtickLabels',temp.label)
subplot(2,2,2),imagesc(ht),set(gca,'Ytick',1:16),set(gca,'YtickLabels',temp.label),title('Theta')
set(gca,'Xtick',1:16),set(gca,'XtickLabels',temp.label)
subplot(2,2,3),imagesc(ha),set(gca,'Ytick',1:16),set(gca,'YtickLabels',temp.label),title('Alpha')
set(gca,'Xtick',1:16),set(gca,'XtickLabels',temp.label)
subplot(2,2,4),imagesc(hb),set(gca,'Ytick',1:16),set(gca,'YtickLabels',temp.label),title('Beta')
set(gca,'Xtick',1:16),set(gca,'XtickLabels',temp.label)
if save==1;saveaspdf(gcf,'allttests_conn_wplid');end;


cfg=[];
cfg.layout=[home '/Documents/ls_brain/global/AFAVA.lay'];
cfg.newfigure='yes';
cfg.foi=10;
cfg.colormap=cool;
cfg.colorparam=parameter;
Ccpat_old=Ccpat;
Cccon_old=Cccon; 
factor=1.25;

bands(1).x=delta;bands(2).x=theta;bands(3).x=alpha;bands(4).x=beta;
bands(1).y='delta';bands(2).y='theta';bands(3).y='alpha';bands(4).y='beta';
for ii=1:4

tmp_pat=mean(Ccpat(:,:,bands(ii).x),3);
tmp_pat=weight_conversion(tmp_pat,'normalize');
% mm=factor*mean(mean(mean(tmp_pat)));
% tmp_pat(tmp_pat<mm)=0;
% if ii==1;
[tmp_pat th_pat]=CST(tmp_pat);
%  else
%      tmp_pat=tmp_pat>th_pat;
%  end

tmp_con=mean(Cccon(:,:,bands(ii).x),3);
tmp_con=weight_conversion(tmp_con,'normalize');
% tmp_con(tmp_con<mm)=0;
tmp_con=tmp_con>th_pat;
% [tmp_con th_con]=CST(tmp_con);

temp.(cfg.colorparam)(:,:,11)=tmp_pat;
%subplot(1,2,1),
[tmp h1]=ft_topoplotCC(cfg,temp)
pat=gca;
temp.(cfg.colorparam)(:,:,11)=tmp_con;
%subplot(1,2,2),
[tmp h2]=ft_topoplotCC(cfg,temp)
con=gca;
figure,p1=subplot(1,2,1);axis off;p2=subplot(1,2,2);axis off;
copyobj(get(pat,'children'),p1);
copyobj(get(con,'children'),p2);
close(h1),close(h2)
a=text(-1.5,.6,bands(ii).y);
set(a,'fontsize',18)
if save==1;saveaspdf(gcf,[bands(ii).y '_topo_thresholded_patfixed_wplid']);end;

end



