cd([home '/Dropbox/Alzheimer/results/Descriptive/INECO/SHAPE'])
save=1;
delta=[1];
theta=[2 3];
alpha=[4 5 6];
beta1=[7:10];
beta2=[11:15];
periods=5;
close all
g1={'PATIENTS' 'CONTROLS'};g2={'SHAPE' 'BINDING'};g3={'ENCOD' 'TEST'};

binding_test_idxs=g_idx(g_idx(:,2)==0 & g_idx(:,3)==0,:);
fidx_patient=find(gc_idx(:,1)==1);
fidx_control=find(gc_idx(:,1)==0);

temp=conn_full{1,1};
ch=temp.label;
parameter='cohspctrm';

for i=1:numel(conn_full)
    stmp=conn_full{i}.(parameter);
    %         spctrm(:,:,:,period,i)=conn_full{i,period}.(parameter);
    for ff=1:numel(temp.freq)
        stmp2=stmp(:,:,ff);
        stmp2(logical(eye(size(stmp2,1))))=0;
        spctrm(:,:,ff,i)=stmp2;
    end
end

Ccpat=mean(abs(spctrm(:,:,:,fidx_patient)),4);
Cccon=mean(abs(spctrm(:,:,:,fidx_control)),4);

Ptemp=conn_full{1,1};
Ctemp=conn_full{1,1};

ccpat=abs(spctrm(:,:,:,fidx_patient));
cccon=abs(spctrm(:,:,:,fidx_control));

cfg=[];
cfg.layout='C:\Users\Loukianos\Documents\ls_brain\global\biosemi128.lay';
cfg.newfigure='yes';
cfg.foi=10;
% cfg.colormap=cool;
Ccpat_old=Ccpat;
Cccon_old=Cccon;
factor=1.25;

bands(1).x=delta;bands(2).x=theta;bands(3).x=alpha;bands(4).x=beta1;bands(5).x=beta2;
bands(1).y='delta';bands(2).y='theta';bands(3).y='alpha';bands(4).y='beta1';bands(5).y='beta2';

% for ii=1:numel(bands)
% for period=1:periods
%     tmp_pat=mean(Ccpat(:,:,bands(ii).x,period),3);
%     tmp_pat=weight_conversion(tmp_pat,'normalize');
%     [tmp_pat th]=CST(tmp_pat);
%
%
%     tmp_con=mean(Cccon(:,:,bands(ii).x,period),3);
%     tmp_con=weight_conversion(tmp_con,'normalize');
%     tmp_con=CST(tmp_con);
%     tmp_con=tmp_con>th;
%
%
%     %     temp.cohspctrm(:,:,11)=tmp_pat;
%     %     %subplot(1,2,1),
%     %     [tmp h1]=ft_topoplotCC(cfg,temp)
%     %     pat=gca;
%     %     temp.cohspctrm(:,:,11)=tmp_con;
%     %     %subplot(1,2,2),
%     %     [tmp h2]=ft_topoplotCC(cfg,temp)
%     %     con=gca;
%     %     figure,p1=subplot(1,2,1),title('Patients');axis off;p2=subplot(1,2,2),title('Controls');axis off;
%     %     copyobj(get(pat,'children'),p1);
%     %     copyobj(get(con,'children'),p2);
%     %     close(h1),close(h2)
%     %     a=text(-1.5,.6,bands(ii).y);
%     %     set(a,'fontsize',18)
%     %     saveaspdf(gcf,[bands(ii).y '_topo_CST'])
%
%     Gmetrics(ii,period,:)=[transitivity_bd(tmp_pat) transitivity_bd(tmp_con)...
%         mean(clustering_coef_bd(tmp_pat)) mean(clustering_coef_bd(tmp_con))...
%         mean(degrees_und(tmp_pat)) mean(degrees_und(tmp_con))...
%         density_und(tmp_pat) density_und(tmp_con)...
%         efficiency_bin(tmp_pat) efficiency_bin(tmp_con)];
%
% end
% end
th=0.5;

for ii=1:size(ccpat,4)
    for jj=1:numel(bands)
        tmp_pat=mean(ccpat(:,:,bands(jj).x,ii),3);
        tmp_pat=weight_conversion(tmp_pat,'normalize');
        
        [tmp_pat thth(jj)]=CST(tmp_pat);
        %         tmp_pat=tmp_pat>th;
        
        Pmetrics(ii,jj,:)=[transitivity_bu(tmp_pat) ...
            mean(clustering_coef_bu(tmp_pat)) ...
            mean(degrees_und(tmp_pat)) ...
            density_und(tmp_pat) ...
            efficiency_bin(tmp_pat) ];
    end
    
end

for ii=1:size(cccon,4)
    for jj=1:numel(bands)
        tmp_con=mean(cccon(:,:,bands(jj).x,ii),3);
        tmp_con=weight_conversion(tmp_con,'normalize');
        tmp_con=CST(tmp_con);
        %         tmp_con=tmp_con>th;
        
        Cmetrics(ii,jj,:)=[transitivity_bu(tmp_con)...
            mean(clustering_coef_bu(tmp_con))...
            mean(degrees_und(tmp_con))...
            density_und(tmp_con)...c
            efficiency_bin(tmp_con)];
    end
    
end


al=0.01;
for jj=1:numel(bands)
    for ii=1:5
        [hm(ii,jj) pm(ii,jj)]=ttest2(squeeze(Pmetrics(:,jj,ii)),squeeze(Cmetrics(:,jj,ii)),al);
    end
end

figure,imagesc(hm)
set(gca,'Ytick',1:5),set(gca,'YtickLabel',{'trans' 'clust' 'degrees' 'density' 'efficiency'})
set(gca,'Xtick',1:5),set(gca,'XtickLabel',{'delta' 'theta' 'alpha' 'beta1' 'beta2'})
figure,imagesc(pm)
set(gca,'Ytick',1:5),set(gca,'YtickLabel',{'trans' 'clust' 'degrees' 'density' 'efficiency'})
set(gca,'Xtick',1:5),set(gca,'XtickLabel',{'delta' 'theta' 'alpha' 'beta1' 'beta2'})
caxis([0 1])

