OUT=[];OUT_b=[];PC=[];
locs=sa.cortex75K.EEG_V_fem_normal(:, sa.cortex2K.in_from_cortex75K);
roindcs=inds_roi_outer_2K;
for i=1:25
    
    load(['~/Documents/bb/data/testsnrsensor/EEG/dataset_' num2str(i) '/data']),
    load(['~/Documents/bb/data/testsnrsensor/truth/dataset_' num2str(i) '/truth']),
    truth
    INT(i)=truth.interaction;
    SNR(i)=truth.snr;
    data=[];
    if ~exist('sa')
        load('~/Documents/bb/data/sa')
    end
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
    cfg.preproc.demean='no';
    cfg.preproc.detrend='no';
    data            = ft_preprocessing(cfg,data);
    data_b          = ft_preprocessing(cfg,data_b);
    
    cfg             = [];
    cfg.method      = 'mtmfft';
    freqs=2:2:20;
    cfg.foi         = freqs;
    cfg.tapsmofrq   = 1;
    cfg.taper       = 'hanning';
    cfg.output      = 'fourier';
    freqc      = ft_freqanalysis(cfg, data);
    freqc_b    = ft_freqanalysis(cfg, data_b);
    
    Y=permute(freqc.fourierspctrm,[2 1 3]);
    Y_b=permute(freqc_b.fourierspctrm,[2 1 3]);
    nsource=2;
    ncomps=502;
    xch=[truth.EEG_field_pat truth.EEG_noise_pat];
    Xch{i}=xch;

    Options=[];
    Options(1)=10^-3;
    Options(3)=2;
    Options(5)=1;
    [T{1} T{2} T{3} T{4} T{5}]=parafac2(Y,ncomps,[4 4],Options);
    [T_b{1} T_b{2} T_b{3} T_b{4} T_b{5}]=parafac2(Y_b,ncomps,[4 4],Options);
    out=tensor_connectivity2(T{4},T{2});
    out_b=tensor_connectivity2(T_b{4},T_b{2});
    OUT{i}=out;
    OUT_b{i}=out_b;
    Tt{i}{1}=T;Tt{i}{2}=T_b;
    

    for jj=1:ncomps
        for ii=1:nsource
            
            x=(T{1}(:,jj));
            y=(xch(:,ii));
            temp=corrcoef(x,y);
            PC(jj,ii,i)=temp(1,2);
            
        end
    end
    [l m]=max(abs(PC(:,:,i)));

Cx=0;
out=triu(out(:,:,5));
[tmp itmp]=sort(out(:));
tmp=flipud(itmp);
[tmpr tmpc]=ind2sub(size(out),tmp(1));
r=tmpr;
c=tmpc;    

for jj=1:size(locs,2)
    tempr=corrcoef(T{1}(:,r),locs(:,jj));
    tempc=corrcoef(T{1}(:,c),locs(:,jj));
    scr(jj)=tempr(1,2);
    scc(jj)=tempc(1,2);
end

[q Mr]=max(abs(scr));
[q Mc]=max(abs(scc));

for jj=1:8

    Rr(jj)=isempty(find(roindcs{jj}==Mr));
    Rc(jj)=isempty(find(roindcs{jj}==Mc));

end

% figure,subplot(3,2,1),plot(xch(:,1)/norm(xch(:,1))),subplot(3,2,2),plot(xch(:,2)/norm(xch(:,2)))
% subplot(3,2,3),plot(T{1}(:,r)/norm(T{1}(:,r))),subplot(3,2,4),plot(T{1}(:,c)/norm(T{1}(:,c)))
% subplot(3,2,5),plot(-T{1}(:,r)/norm(T{1}(:,r))),subplot(3,2,6),plot(-T{1}(:,c)/norm(T{1}(:,c)))
% 
% figure,subplot(1,3,1),plot(xch(:,1)),subplot(1,3,2),plot(T{1}(:,m(1))),subplot(1,3,3),plot(-T{1}(:,m(1)))
% figure,subplot(1,3,1),plot(xch(:,2)),subplot(1,3,2),plot(T{1}(:,m(2))),subplot(1,3,3),plot(-T{1}(:,m(2)))
INT(i),SNR(i),max(max(OUT{i}(:,:,5))),max(max(OUT_b{i}(:,:,5)))
A(:,:,i)=[find(Rr==0) find(Rc==0);truth.in_roi];
end