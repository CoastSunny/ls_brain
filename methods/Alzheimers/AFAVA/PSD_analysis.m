save=0;
delta=1+(2:4);
theta=1+(5:7);
alpha=1+(8:13);
beta=1+(14:30);
close all
idx_control=subject_identifier(used_subjects==1)==0;
idx_patient=subject_identifier(used_subjects==1)==1;

F_patient=squeeze(mean(cat(1,Freq{idx_patient}),1));
F_control=squeeze(mean(cat(1,Freq{idx_control}),1));
close all
cd([home '/Dropbox/Alzheimer/results/Descriptive/'])
%% average spectrum
% figure(1),hold on,
% plot(mean(F_patient)),plot(mean(F_control),'r'),title('PSD'),legend({'patients' 'controls'})

%% all channel average spectrum with error bar
pcount=1;
ccount=1;
Freq_pat=[];Freq_con=[];
% average spectrum over epochs of each subject
for i=1:23
    
    abs_p=Freq{i};
    tmp=sum(Freq{i},2);
    full_p=tmp*ones(1,41);
    if idx_patient(i)==1        
        Freq_pat(:,:,pcount)=abs_p./full_p;
        pcount=pcount+1;
    else
        Freq_con(:,:,ccount)=abs_p./full_p;
        ccount=ccount+1;
    end
    
end
% average spectrum over channels and then subjects
PSD_allchan_pat=mean(mean(Freq_pat,1),3);
% std of mean channel spectrum over subjects
vPSD_allchan_pat=std(mean(Freq_pat,1),0,3);

% average spectrum over channels and then subjects
PSD_allchan_con=mean(mean(Freq_con,1),3);
% std of mean channel spectrum over subjects
vPSD_allchan_con=std(mean(Freq_con,1),0,3);

figure('units','normalized','outerposition',[0 0 1 1]),
hold on,shadedErrorBar(freqs,PSD_allchan_pat,vPSD_allchan_pat,{'b' 'Linewidth',2},0);
xlabel('Frequency (Hz)'),ylabel('PSD'),
title('relative PSD over channels and subjects for AD (blue) and CN (gray)')
shadedErrorBar(freqs,PSD_allchan_con,vPSD_allchan_con,{'k' 'Linewidth',2},1);
set(gca,'fontsize',18)
if save==1; saveaspdf(gcf,'Group_PSDs');end;
%% statistical analysis (all combinations)

for i=1:size(Freq_pat,1)
    for j=1:size(Freq_pat,2)
        [hA(i,j) pA(i,j)]=ttest2(Freq_pat(i,j,:),Freq_con(i,j,:),'alpha',0.01/16);
    end
end

figure,imagesc(hA),set(gca,'YTick',1:16),set(gca,'YTickLabel',freq{1}.label),...
    xlabel('Frequency (Hz)'),title('AD-CN ttest result, yellow indicates p-value<0.01/16')
if save==1;saveaspdf(gcf,'Ttest_ADCN');end;
%% statistical analysis (band based combinations)
Bands={delta theta alpha beta};
for i=1:size(Freq_pat,1)1
    for j=1:numel(Bands)
        [hB(i,j) pB(i,j)]=ttest2(squeeze(mean(Freq_pat(i,Bands{j},:),2)),...
            squeeze(mean(Freq_con(i,Bands{j},:),2)),'alpha',0.01/16);
    end
end

figure,imagesc(hB),set(gca,'YTick',1:16),set(gca,'YTickLabel',freq{1}.label)
set(gca,'XTick',1:4),set(gca,'XTickLabel',{'delta' 'theta' 'alpha' 'beta'})
xlabel('Frequency (Hz)'),title('AD-CON ttest result, yellow indicates p-value<0.01/16')
if save==1;saveaspdf(gcf,'Ttest_bands_ADCN');end;

cfg=[];
cfg.layout=[home '/Documents/ls_brain/global/AFAVA.lay'];
cfg.comment='no';
cfreq=freq{1};
cfreq.freq='all';%cfreq=rmfield(cfreq,'cumsumcnt');cfreq=rmfield(cfreq,'cumtapcnt');
cfreq.dimord='chan_freq';
figure('units','normalized','outerposition',[0 0 1 1]),
subplot(2,2,1),cfreq.powspctrm=mean(Freq_pat(:,delta,:),3);ft_topoplotTFR(cfg,cfreq);title('Delta');colorbar
subplot(2,2,2),cfreq.powspctrm=mean(Freq_pat(:,theta,:),3);ft_topoplotTFR(cfg,cfreq);title('Theta');colorbar
subplot(2,2,3),cfreq.powspctrm=mean(Freq_pat(:,alpha,:),3);ft_topoplotTFR(cfg,cfreq);title('Alpha');colorbar
subplot(2,2,4),cfreq.powspctrm=mean(Freq_pat(:,beta,:),3);ft_topoplotTFR(cfg,cfreq);title('Beta');colorbar
a=text(-2,2.2,'PSDs of Patients over bands');
set(a,'fontsize',18)
if save==1;saveaspdf(gcf,'PSD_patients');end;

figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,2,1),cfreq.powspctrm=mean(Freq_con(:,delta,:),3);ft_topoplotTFR(cfg,cfreq);title('Delta');colorbar
subplot(2,2,2),cfreq.powspctrm=mean(Freq_con(:,theta,:),3);ft_topoplotTFR(cfg,cfreq);title('Theta');colorbar
subplot(2,2,3),cfreq.powspctrm=mean(Freq_con(:,alpha,:),3);ft_topoplotTFR(cfg,cfreq);title('Alpha');colorbar
subplot(2,2,4),cfreq.powspctrm=mean(Freq_con(:,beta,:),3);ft_topoplotTFR(cfg,cfreq);title('Beta');colorbar
a=text(-2,2.2,'PSDs of Controls over bands');
set(a,'fontsize',18)
if save==1;saveaspdf(gcf,'PSD_controls');end;

figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,2,1),cfreq.powspctrm=mean(Freq_pat(:,delta,:),3)-mean(Freq_con(:,delta,:),3);ft_topoplotTFR(cfg,cfreq);title('Delta');colorbar
subplot(2,2,2),cfreq.powspctrm=mean(Freq_pat(:,theta,:),3)-mean(Freq_con(:,theta,:),3);ft_topoplotTFR(cfg,cfreq);title('Theta');colorbar
subplot(2,2,3),cfreq.powspctrm=mean(Freq_pat(:,alpha,:),3)-mean(Freq_con(:,alpha,:),3);ft_topoplotTFR(cfg,cfreq);title('Alpha');colorbar
subplot(2,2,4),cfreq.powspctrm=mean(Freq_pat(:,beta,:),3)-mean(Freq_con(:,beta,:),3);ft_topoplotTFR(cfg,cfreq);title('Beta');colorbar
a=text(-2.2,2.2,'Difference of PSDs of Patients - Controls over bands');
set(a,'fontsize',18)
if save==1;saveaspdf(gcf,'PSD_diff');end;

figure('units','normalized','outerposition',[0 0 1 1])
cfreq.freq=1;
subplot(2,2,1),cfreq.powspctrm=hB(:,1);ft_topoplotTFR(cfg,cfreq);title('Delta');colorbar
subplot(2,2,2),cfreq.powspctrm=hB(:,2);ft_topoplotTFR(cfg,cfreq);title('Theta');colorbar
subplot(2,2,3),cfreq.powspctrm=hB(:,3);ft_topoplotTFR(cfg,cfreq);title('Alpha');colorbar
subplot(2,2,4),cfreq.powspctrm=hB(:,4);ft_topoplotTFR(cfg,cfreq);title('Beta');colorbar
a=text(-2,2.2,'Ttest result topoplot over bands');
set(a,'fontsize',18)
if save==1;saveaspdf(gcf,'Ttest_topo');end;