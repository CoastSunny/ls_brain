A=[];B=[];
i=9;
d1='/Documents/bb/data/test/EEG/dataset_';
    d2='/Documents/bb/data/test/truth/dataset_';
    load([home d1 num2str(i) '/data']),
    load([home d2 num2str(i) '/truth']),
    truth
    INT(i)=truth.interaction;
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
    
    cfg.reref       = 'yes';
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
    cfg.taper       = 'hanning';
    cfg.output      = 'fourier';
    freqc           = ft_freqanalysis(cfg, data);
    freqc_b         = ft_freqanalysis(cfg, data_b);
    
    Y=permute(freqc.fourierspctrm,[2 1 3]);
    Y_b=permute(freqc_b.fourierspctrm,[2 1 3]);
    nsource=2;
    ncomps=16;
    xch=[truth.EEG_field_pat truth.EEG_noise_pat];
    Xch{i}=xch;
    
    Options=[];
    Options(1)=10^-2;
    Options(3)=0;
    Options(5)=0;
for xi=1:10 
    ev=0;
   while(ev<=0)
        try
            [T{1} T{2} T{3} T{4} T{5} ev]=parafac2(Y,ncomps,[0 0],Options);%,Fp{i}{1},eye(ncomps),Fp{i}{3});
        catch
            er_ev(i)=er_ev(i)+1;
        end
   end
   
    Tt{xi}=T;
    expv(xi)=ev;
    out=tensor_connectivity3(T{4},T{2},T{3});
    Ot{xi}=out;
    out=triu(mean(out(:,:,[8:13]),3));
    [tmp itmp]=sort(out(:));
    tmp=flipud(itmp);
    [tmpr tmpc]=ind2sub(size(out),tmp(1));
    r1=tmpr;
    c1=tmpc;
    
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
   
    A(:,:,xi)=[find(Rr==0) find(Rc==0);truth.in_roi;find(RrT==0) find(RcT==0);randi(8) randi(8)]
    B(:,xi)=[INT(i) SNR(i)...
        max(max((out))) ]  
    
    
    
    
    
end
     