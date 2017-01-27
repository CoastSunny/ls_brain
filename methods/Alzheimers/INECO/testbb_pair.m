if isunix==0
    home='C:/Users/Loukianos';
    home_bci='D:\';
else
    home='~';
    home_bci='~';
end
if ~exist('sa')
        load([home '/Documents/bb/data/sa'])     
end
if ~exist('inds_roi_outer_2K')
        load([home '/Documents/bb/data/miscdata'])
end

OUT=[];OUT_b=[];PC=[];A=[];B=[];EV=[];INT=[];L=[];
locs=sa.cortex75K.EEG_V_fem_normal(:, sa.cortex2K.in_from_cortex75K);
roindcs=inds_roi_outer_2K;
for i=1
    d1='/Documents/bb/data/test/EEG/dataset_';
    d2='/Documents/bb/data/test/truth/dataset_';
    load([home d1 num2str(i) '/data']),
    load([home d2 num2str(i) '/truth']),
    truth
    INT(i,:)=truth.interaction;
    SNR(i)=truth.snr;
    data=[];
    
    fs=100;
    len=180;
    bandpass=[8 13];
    data=[];
    data.fsample    = fs;
    data.label      = sa.EEG_clab_electrodes;
    % [sources_int, sources_nonint, P_ar] = generate_sources_ar(fs, len, bandpass);
    % EEG_field_pat(:,2) = sa.cortex75K.EEG_V_fem_normal(:,randi(74382));
    % EEG_field_pat(:,2) = sa.cortex75K.EEG_V_fem_normal(:,randi(74382));
    % EEG_data=EEG_field_pat*sources_int;
    
    % EEG_data=truth.EEG_field_pat*randn(2,18000);
    EEG=reshape(EEG_data,108,100,[]);
    for k=1:size(EEG,3)
        data.trial{1,k} = EEG(:,:,k);
        data.time{1,k}  = (0:(size(EEG,2)-1))/fs;
    end
    EEG_b=reshape(EEG_baseline_data,108,100,[]);
    data_b=data;
    for k=1:size(EEG,3)
        data_b.trial{1,k} = EEG_b(:,:,k);
        data_b.time{1,k}  = (0:(size(EEG_b,2)-1))/fs;
    end
    cfg             = [];
    
    cfg.reref       = 'no';
    cfg.refchannel  = 'all'; % average reference
    cfg.lpfilter    = 'no';
    cfg.lpfreq      = 40;
    cfg.preproc.demean='yes';
    cfg.preproc.detrend='yes';
    data            = ft_preprocessing(cfg,data);
    data_b          = ft_preprocessing(cfg,data_b);
    
    cfg             = [];
    cfg.method      = 'mtmfft';
    freqs=1:1:40;
    cfg.foi         = freqs;
    cfg.tapsmofrq   = 1;
%     cfg.pad         = 5;
    cfg.taper       = 'hanning';
    cfg.output      = 'fourier';
    freqc      = ft_freqanalysis(cfg, data);
    freqc_b    = ft_freqanalysis(cfg, data_b);
    
    Y=permute(freqc.fourierspctrm,[2 1 3]);
    Y_b=permute(freqc_b.fourierspctrm,[2 1 3]);
    nsource=4;
    ncomps=4;
    xch=[truth.EEG_field_pat truth.EEG_noise_pat];
    Xch{i}=xch;

    Options=[];
    Options(1)=10^-1;
    Options(3)=0;
    Options(5)=0;
    [T{1} T{2} T{3} T{4} T{5} ev]=parafac2(Y,ncomps,[4 4],Options);
%     [T_b{1} T_b{2} T_b{3} T_b{4} T_b{5} tev]=parafac2(Y_b,ncomps,[4 4],Options);
    out=tensor_connectivity2(T{4},T{2});
    out_b=tensor_connectivity2(T_b{4},T_b{2});
    OUT{i}=out;
    OUT_b{i}=out_b;
    Tt{i}{1}=T;Tt{i}{2}=T_b;
    EV(i,:)=[ev tev];

    for jj=1:ncomps
        for ii=1:nsource
            
%             x=(T{1}(:,jj));
%             y=(xch(:,ii));
            x=(T{1}(:,jj))/norm(T{1}(:,jj));
            y=(xch(:,ii))/norm((xch(:,ii)));
%             temp=corrcoef(x,y);
%             PC(jj,ii,i)=temp(1,2);
            PC(jj,ii,i)=norm(x-y);
            
        end
    end
    [l m]=min(abs(PC(:,:,i)));
% PC
L(i,:)=l;
Cx=0;
out1=triu(mean(out(:,:,[8:13]),3));
[tmp itmp]=sort(out1(:));
tmp=flipud(itmp);
[tmpr tmpc]=ind2sub(size(out2),tmp(1));
r1=tmpr;
c1=tmpc;   
out2=triu(mean(out(:,:,[14:20]),3));
[tmp itmp]=sort(out2(:));
tmp=flipud(itmp);
[tmpr tmpc]=ind2sub(size(out2),tmp(2));
r2=tmpr;
c2=tmpc;    

for jj=1:size(locs,2)
    tempr=corrcoef(T{1}(:,r1),locs(:,jj));
    tempc=corrcoef(T{1}(:,c1),locs(:,jj));
    scr(jj)=tempr(1,2);
    scc(jj)=tempc(1,2);
end

[q Mr]=max(abs(scr));
[q Mc]=max(abs(scc));

for jj=1:8

    Rr(jj)=isempty(find(roindcs{jj}==Mr));
    Rc(jj)=isempty(find(roindcs{jj}==Mc));

end

continue

for jj=1:size(locs,2)
    tempr=corrcoef(xch(:,1),locs(:,jj));
    tempc=corrcoef(xch(:,2),locs(:,jj));
    scr(jj)=tempr(1,2);
    scc(jj)=tempc(1,2);
end

[q Mr]=max(abs(scr));
[q Mc]=max(abs(scc));

for jj=1:8

    RrT(jj)=isempty(find(roindcs{jj}==Mr));
    RcT(jj)=isempty(find(roindcs{jj}==Mc));

end
% figure,subplot(3,2,1),plot(xch(:,1)/norm(xch(:,1))),subplot(3,2,2),plot(xch(:,2)/norm(xch(:,2)))
% subplot(3,2,3),plot(T{1}(:,r)/norm(T{1}(:,r))),subplot(3,2,4),plot(T{1}(:,c)/norm(T{1}(:,c)))
% subplot(3,2,5),plot(-T{1}(:,r)/norm(T{1}(:,r))),subplot(3,2,6),plot(-T{1}(:,c)/norm(T{1}(:,c)))
% 
% figure,subplot(1,3,1),plot(xch(:,1)),subplot(1,3,2),plot(T{1}(:,m(1))),subplot(1,3,3),plot(-T{1}(:,m(1)))
% figure,subplot(1,3,1),plot(xch(:,2)),subplot(1,3,2),plot(T{1}(:,m(2))),subplot(1,3,3),plot(-T{1}(:,m(2)))

A(:,:,i)=[find(Rr==0) find(Rc==0);truth.in_roi;find(RrT==0) find(RcT==0)];
B(:,i)=[INT(i) SNR(i)...
    max(max(OUT{i}(:,:,5))) max(max(OUT_b{i}(:,:,5))) max(max(max(OUT{i}))) max(max(max(OUT_b{i})))];
% A,B
dummy=1;
end