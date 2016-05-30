cd([home '/Dropbox/Alzheimer/results/Descriptive/INECO'])
save=1;
delta=[1];
theta=[2 3];
alpha=[4 5 6];
beta1=[7:10];
beta2=[11:15];
periods=5;
close all
g1={'PATIENTS' 'CONTROLS'};g2={'SHAPE' 'BINDING'};g3={'ENCOD' 'TEST'};

binding_encod_idxs=g_idx(g_idx(:,2)==0 & g_idx(:,3)==1,:);
fidx_patient=find(binding_encod_idxs(:,1)==1);
fidx_control=find(binding_encod_idxs(:,1)==0);

temp=conn_full{1,1};
ch=temp.label;
parameter='wpli_debiasedspctrm';

for i=1:size(binding_encod_idxs,1)
    for period=1:periods
        stmp=conn_full{i,period}.(parameter);
%         spctrm(:,:,:,period,i)=conn_full{i,period}.(parameter);
        for ff=1:numel(temp.freq)
            stmp2=stmp(:,:,ff);
            stmp2(logical(eye(size(stmp2,1))))=0;
            spctrm(:,:,ff,period,i)=stmp2;
        end
    end
    
end

Ccpat=mean(abs(spctrm(:,:,:,:,fidx_patient)),5);
Cccon=mean(abs(spctrm(:,:,:,:,fidx_control)),5);

Ptemp=conn_full{1,1};
Ctemp=conn_full{1,1};

cfg=[];
cfg.layout=[home '/Documents/ls_brain/global/biosemi128.lay'];
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
for period=1:periods
    figure('units','normalized','outerposition',[0.25 0.25 .52 .52]),
    subplot(1,2,1),imagesc(mean(Ccpat(:,:,delta,period),3)),title('Patients')
    set(gca,'Ytick',1:numel(ch)),set(gca,'YtickLabels',temp.label)
    set(gca,'Xtick',1:numel(ch)),set(gca,'XtickLabels',temp.label)
    caxis([0 0.1])
    subplot(1,2,2), imagesc(mean(Cccon(:,:,delta,period),3)),title('Controls')
    text(-45,-5,['Delta CONN' ' at period ' num2str(period)]),
    set(gca,'Ytick',1:numel(ch)),set(gca,'YtickLabels',temp.label)
    set(gca,'Xtick',1:numel(ch)),set(gca,'XtickLabels',temp.label)
    caxis([0 0.1])
    if save==1;saveaspdf(gcf,'Delta_conn_wplid');end;
    figure('units','normalized','outerposition',[0.25 0.25 .52 .52]),
    subplot(1,2,1),imagesc(mean(Ccpat(:,:,theta,period),3)),title('Patients')
    set(gca,'Ytick',1:numel(ch)),set(gca,'YtickLabels',temp.label)
    set(gca,'Xtick',1:numel(ch)),set(gca,'XtickLabels',temp.label)
    caxis([0 0.1])
    subplot(1,2,2), imagesc(mean(Cccon(:,:,theta,period),3)),title('Controls')
    text(-45,-5,['Theta CONN' ' at period ' num2str(period)]),
    set(gca,'Ytick',1:numel(ch)),set(gca,'YtickLabels',temp.label)
    set(gca,'Xtick',1:numel(ch)),set(gca,'XtickLabels',temp.label)
    caxis([0 0.1])
    if save==1;saveaspdf(gcf,'Theta_conn_wplid');end;
    figure('units','normalized','outerposition',[0.25 0.25 .52 .52]),
    subplot(1,2,1),imagesc(mean(Ccpat(:,:,alpha,period),3)),title('Patients')
    set(gca,'Ytick',1:numel(ch)),set(gca,'YtickLabels',temp.label)
    set(gca,'Xtick',1:numel(ch)),set(gca,'XtickLabels',temp.label)
    caxis([0 0.1])
    subplot(1,2,2), imagesc(mean(Cccon(:,:,alpha,period),3)),title('Controls')
    text(-45,-5,['Alpha CONN' ' at period ' num2str(period)]),
    set(gca,'Ytick',1:numel(ch)),set(gca,'YtickLabels',temp.label)
    set(gca,'Xtick',1:numel(ch)),set(gca,'XtickLabels',temp.label)
    caxis([0 0.1])
    if save==1;saveaspdf(gcf,'Alpha_conn_wplid');end;
    figure('units','normalized','outerposition',[0.25 0.25 .52 .52]),
    subplot(1,2,1),imagesc(mean(Ccpat(:,:,beta1,period),3)),title('Patients')
    set(gca,'Ytick',1:numel(ch)),set(gca,'YtickLabels',temp.label)
    set(gca,'Xtick',1:numel(ch)),set(gca,'XtickLabels',temp.label)
    caxis([0 0.1])
    subplot(1,2,2), imagesc(mean(Cccon(:,:,beta1,period),3)),title('Controls')
    text(-45,-5,['Beta1 CONN' ' at period ' num2str(period)]),
    set(gca,'Ytick',1:numel(ch)),set(gca,'YtickLabels',temp.label)
    set(gca,'Xtick',1:numel(ch)),set(gca,'XtickLabels',temp.label)
    caxis([0 0.1])
    if save==1;saveaspdf(gcf,'Beta1_conn_wplid');end;
    figure('units','normalized','outerposition',[0.25 0.25 .52 .52]),
    subplot(1,2,1),imagesc(mean(Ccpat(:,:,beta2,period),3)),title('Patients')
    set(gca,'Ytick',1:numel(ch)),set(gca,'YtickLabels',temp.label)
    set(gca,'Xtick',1:numel(ch)),set(gca,'XtickLabels',temp.label)
    caxis([0 0.1])
    subplot(1,2,2), imagesc(mean(Cccon(:,:,beta2,period),3)),title('Controls')
    text(-45,-5,['Beta2 CONN' ' at period ' num2str(period)]),
    set(gca,'Ytick',1:numel(ch)),set(gca,'YtickLabels',temp.label)
    set(gca,'Xtick',1:numel(ch)),set(gca,'XtickLabels',temp.label)
    caxis([0 0.1])
    if save==1;saveaspdf(gcf,'Beta2_conn_wplid');end;
end

for period=1:periods
al=0.01/128;
for i=1:numel(ch)
    for j=1:numel(ch)
        [hd(i,j) pd(i,j)]=ttest2(mean(abs(spctrm(i,j,delta,period,fidx_patient)),3),...
            mean(abs(spctrm(i,j,delta,period,fidx_control)),3),al);
    end
end

for i=1:numel(ch)
    for j=1:numel(ch)
        [ht(i,j) pt(i,j)]=ttest2(mean(abs(spctrm(i,j,theta,period,fidx_patient)),3),...
            mean(abs(spctrm(i,j,theta,period,fidx_control)),3),al);
    end
end



for i=1:numel(ch)
    for j=1:numel(ch)
        [ha(i,j) pa(i,j)]=ttest2(mean(abs(spctrm(i,j,alpha,period,fidx_patient)),3),...
            mean(abs(spctrm(i,j,alpha,period,fidx_control)),3),al);
    end
end

for i=1:numel(ch)
    for j=1:numel(ch)
        [hb1(i,j) pb1(i,j)]=ttest2(mean(abs(spctrm(i,j,beta1,period,fidx_patient)),3),...
            mean(abs(spctrm(i,j,beta1,period,fidx_control)),3),al);
    end
end
for i=1:numel(ch)
    for j=1:numel(ch)
        [hb2(i,j) pb2(i,j)]=ttest2(mean(abs(spctrm(i,j,beta2,period,fidx_patient)),3),...
            mean(abs(spctrm(i,j,beta2,period,fidx_control)),3),al);
    end
end
figure('units','normalized','outerposition',[0 0 1 1]),
subplot(2,3,1),imagesc(hd),set(gca,'Ytick',1:numel(ch)),set(gca,'YtickLabels',temp.label),title('Delta')
set(gca,'Xtick',1:numel(ch)),set(gca,'XtickLabels',temp.label)
subplot(2,3,2),imagesc(ht),set(gca,'Ytick',1:numel(ch)),set(gca,'YtickLabels',temp.label),title('Theta')
set(gca,'Xtick',1:numel(ch)),set(gca,'XtickLabels',temp.label)
subplot(2,3,3),imagesc(ha),set(gca,'Ytick',1:numel(ch)),set(gca,'YtickLabels',temp.label),title('Alpha')
set(gca,'Xtick',1:numel(ch)),set(gca,'XtickLabels',temp.label)
subplot(2,3,4),imagesc(hb1),set(gca,'Ytick',1:numel(ch)),set(gca,'YtickLabels',temp.label),title('Beta1')
set(gca,'Xtick',1:numel(ch)),set(gca,'XtickLabels',temp.label)
subplot(2,3,5),imagesc(hb2),set(gca,'Ytick',1:numel(ch)),set(gca,'YtickLabels',temp.label),title('Beta2')
set(gca,'Xtick',1:numel(ch)),set(gca,'XtickLabels',temp.label)
text(-40,-195,['ttests' ' at period ' num2str(period)]),

if save==1;saveaspdf(gcf,['allttests_conn_wplid at period ' num2str(period) ]);end;
end

% cfg=[];
% cfg.layout=[home '/Documents/ls_brain/global/biosemi128.lay'];
% cfg.newfigure='yes';
% cfg.foi=10;
% cfg.colormap=cool;
% cfg.colorparam=parameter;
% Ccpat_old=Ccpat;
% Cccon_old=Cccon;
% factor=1.25;
% 
% bands(1).x=delta;bands(2).x=theta;bands(3).x=alpha;bands(4).x=beta;
% bands(1).y='delta';bands(2).y='theta';bands(3).y='alpha';bands(4).y='beta';
% for ii=1:4
%     
%     tmp_pat=mean(Ccpat(:,:,bands(ii).x),3);
%     tmp_pat=weight_conversion(tmp_pat,'normalize');
%     % mm=factor*mean(mean(mean(tmp_pat)));
%     % tmp_pat(tmp_pat<mm)=0;
%     % if ii==1;
%     [tmp_pat th_pat]=CST(tmp_pat);
%     %  else
%     %      tmp_pat=tmp_pat>th_pat;
%     %  end
%     
%     tmp_con=mean(Cccon(:,:,bands(ii).x),3);
%     tmp_con=weight_conversion(tmp_con,'normalize');
%     % tmp_con(tmp_con<mm)=0;
%     tmp_con=tmp_con>th_pat;
%     % [tmp_con th_con]=CST(tmp_con);
%     
%     temp.(cfg.colorparam)(:,:,11)=tmp_pat;
%     %subplot(1,2,1),
%     [tmp h1]=ft_topoplotCC(cfg,temp)
%     pat=gca;
%     temp.(cfg.colorparam)(:,:,11)=tmp_con;
%     %subplot(1,2,2),
%     [tmp h2]=ft_topoplotCC(cfg,temp)
%     con=gca;
%     figure,p1=subplot(1,2,1);axis off;p2=subplot(1,2,2);axis off;
%     copyobj(get(pat,'children'),p1);
%     copyobj(get(con,'children'),p2);
%     close(h1),close(h2)
%     a=text(-1.5,.6,bands(ii).y);
%     set(a,'fontsize',18)
%     if save==1;saveaspdf(gcf,[bands(ii).y '_topo_thresholded_patfixed_wplid']);end;
%     
% end



