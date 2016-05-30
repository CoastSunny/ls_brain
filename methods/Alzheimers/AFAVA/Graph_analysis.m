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

Cpat=X(:,:,fidx_patient);
Ccon=X(:,:,fidx_control);
parameter='cohspctrm';

for i=1:23

    spctrm(:,:,:,i)=conn_full{i}.(parameter);
    
end

Ccpat=mean(abs(spctrm(:,:,:,fidx_patient)),4);
Cccon=mean(abs(spctrm(:,:,:,fidx_control)),4);

Ptemp=conn_full{1};
Ctemp=conn_full{1};

ccpat=abs(spctrm(:,:,:,fidx_patient));
cccon=abs(spctrm(:,:,:,fidx_control));

cfg=[];
cfg.layout='/home/lspyrou/Documents/AFAVA.lay';
cfg.newfigure='yes';
cfg.foi=10;
% cfg.colormap=cool;
Ccpat_old=Ccpat;
Cccon_old=Cccon;
factor=1.25;

bands(1).x=delta;bands(2).x=theta;bands(3).x=alpha;bands(4).x=beta;
bands(1).y='delta';bands(2).y='theta';bands(3).y='alpha';bands(4).y='beta';

for ii=1:4
    
    tmp_pat=mean(Ccpat(:,:,bands(ii).x),3);
    tmp_pat=weight_conversion(tmp_pat,'normalize');
    [tmp_pat th]=CST(tmp_pat);
    
    
    tmp_con=mean(Cccon(:,:,bands(ii).x),3);
    tmp_con=weight_conversion(tmp_con,'normalize');
    %     tmp_con=CST(tmp_con);
    tmp_con=tmp_con>th;
    
    
    %     temp.cohspctrm(:,:,11)=tmp_pat;
    %     %subplot(1,2,1),
    %     [tmp h1]=ft_topoplotCC(cfg,temp)
    %     pat=gca;
    %     temp.cohspctrm(:,:,11)=tmp_con;
    %     %subplot(1,2,2),
    %     [tmp h2]=ft_topoplotCC(cfg,temp)
    %     con=gca;
    %     figure,p1=subplot(1,2,1),title('Patients');axis off;p2=subplot(1,2,2),title('Controls');axis off;
    %     copyobj(get(pat,'children'),p1);
    %     copyobj(get(con,'children'),p2);
    %     close(h1),close(h2)
    %     a=text(-1.5,.6,bands(ii).y);
    %     set(a,'fontsize',18)
    %     saveaspdf(gcf,[bands(ii).y '_topo_CST'])
    
    Gmetrics(ii,:)=[transitivity_bd(tmp_pat) transitivity_bd(tmp_con)...
        mean(clustering_coef_bd(tmp_pat)) mean(clustering_coef_bd(tmp_con))...
        mean(degrees_und(tmp_pat)) mean(degrees_und(tmp_con))...
        density_und(tmp_pat) density_und(tmp_con)...
        efficiency_bin(tmp_pat) efficiency_bin(tmp_con)];
    
end

for ii=1:size(ccpat,4)
    for jj=1:4
        tmp_pat=mean(ccpat(:,:,bands(jj).x,ii),3);
        tmp_pat=weight_conversion(tmp_pat,'normalize');        
        [tmp_pat thth(jj)]=CST(tmp_pat);
%         tmp_pat=tmp_pat>th;
        Pmetrics(ii,jj,:)=[transitivity_bd(tmp_pat) ...
            mean(clustering_coef_bd(tmp_pat)) ...
            mean(degrees_und(tmp_pat)) ...
            density_und(tmp_pat) ...
            efficiency_bin(tmp_pat) ];
    end
    
end


for ii=1:size(cccon,4)
    for jj=1:4
        tmp_con=mean(cccon(:,:,bands(jj).x,ii),3);
        tmp_con=weight_conversion(tmp_con,'normalize');        
        %         tmp_con=CST(tmp_con);
        tmp_con=tmp_con>thth(jj);
        Cmetrics(ii,jj,:)=[transitivity_bd(tmp_con)...
            mean(clustering_coef_bd(tmp_con))...
            mean(degrees_und(tmp_con))...
            density_und(tmp_con)...
            efficiency_bin(tmp_con)];
    end
    
end

mPmetrics=squeeze(mean(Pmetrics,1));
mCmetrics=squeeze(mean(Cmetrics,1));
al=0.05;
for jj=1:4
    for ii=1:5
        [hm(ii,jj) pm(ii,jj)]=ttest2(squeeze(Pmetrics(:,jj,ii)),squeeze(Cmetrics(:,jj,ii)),al);
    end
end

figure,imagesc(hm)
set(gca,'Ytick',1:5),set(gca,'YtickLabel',{'trans' 'clust' 'degrees' 'density' 'efficiency'})
set(gca,'Xtick',1:4),set(gca,'XtickLabel',{'delta' 'theta' 'alpha' 'beta'})
if save==1;saveaspdf(gcf,'ttest_graphmetrics');end;
figure,imagesc(pm)
set(gca,'Ytick',1:5),set(gca,'YtickLabel',{'trans' 'clust' 'degrees' 'density' 'efficiency'})
set(gca,'Xtick',1:4),set(gca,'XtickLabel',{'delta' 'theta' 'alpha' 'beta'})
caxis([0 1])
if save==1;saveaspdf(gcf,'ttest_graphmetrics_pvalue');end;

