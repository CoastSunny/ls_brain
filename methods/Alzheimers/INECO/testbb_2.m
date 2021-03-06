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

OUT=[];OUT_b=[];PC=[];A=[];B=[];PCc=[];PCn=[];L=[];EV=[];INT=[];SNR=[];error=[];O=[];O_b=[];
expv=[];expv_b=[];
er_ev=[];er_ev_b=[];
er_ev=zeros(1,100);
locs=sa.cortex75K.EEG_V_fem_normal(:, sa.cortex2K.in_from_cortex75K);
roindcs=inds_roi_outer_2K;
for i=1:100
%     d1='/Documents/bb/data/Pair1SNRrandNoise01Norm/EEG/dataset_';
%     d1='/Documents/bb/data/Pair1SNR05Noise01Norm/EEG/dataset_';
%     d2='/Documents/bb/data/Pair1SNR05Noise01Norm/truth/dataset_';
% %     d1='/Documents/bb/data/test/EEG/dataset_';
% %     d2='/Documents/bb/data/test/truth/dataset_';
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
%     ncomps=16;
    xch=[truth.EEG_field_pat truth.EEG_noise_pat];
    Xch{i}=xch;
    
    rng('default')
    Options=[];
    Options(1)=10^-1;
    maxsub=20;
    [Fp{i},Yest,Ip(i),Exp(i),e]=parafac_reg(Y,ncomps,[],[],Options,[9 0 0]);    
    out_t=tensor_connectivity_t(Fp{i}{3},Fp{i}{2});
    OUT_t{i}=out_t;
    
    
    Options=[];
    Options(1)=10^-1;
    Options(3)=0;
    Options(5)=1;
    
    for subit=1:100
    ev=0;
    fprintf(num2str(subit))
    try
        [T{1} T{2} T{3} T{4} T{5} ev]=parafac2(Y,ncomps,[4 0],Options);%,Fp{i}{1},eye(ncomps),Fp{i}{3});
    catch
        er_ev(i)=er_ev(i)+1;
    end
    out=tensor_connectivity3(T{4},T{2},T{3});
    out=triu(mean(out(:,:,:),3));
    O(subit)=max(max(out));
    t{subit}=T;
    expv(subit)=ev;
    end
    
    if er_ev==100
           A(:,:,i)=[0 0;0 0;0 0;0 0];
           B(:,i)=[-ones(8,1)];
        continue
    end
    subidx=find(O==max(O));
    T=t{subidx(1)};
    out=tensor_connectivity3(T{4},T{2},T{3});
    
    for subit=1:100
    ev_b=0;subcount=0;
    fprintf(num2str(subit))
    try
        [T_b{1} T_b{2} T_b{3} T_b{4} T_b{5} ev_b]=parafac2(Y_b,ncomps,[4 0],Options);%,Fp{i}{1},eye(ncomps),Fp{i}{3});
    catch
        er_ev_b(i)=er_ev_b(i)+1;
    end
    out_b=tensor_connectivity3(T_b{4},T_b{2},T_b{3});
    out_b=triu(mean(out_b(:,:,:),3));
    O_b(subit)=max(max(out_b));
    t_b{subit}=T_b;
    expv_b(subit)=ev_b;
    end   
    
    if er_ev_b==100;
           A(:,:,i)=[0 0;0 0;0 0;0 0];
           B(:,i)=[-ones(8,1)];
        continue
    end
    subidx_b=find(O_b==max(O_b));
    T_b=t_b{subidx(1)};
    out_b=tensor_connectivity3(T_b{4},T_b{2},T_b{3});
    
    OUT{i}=out;
    OUT_b{i}=out_b;
    Tt{i}{1}=T;Tt{i}{2}=T_b;
    
%      T{1}=abs(T{1});
     T1Fp=(Fp{i}{1});
%      locs=(locs);
    EV(i,:)=[expv(subidx(1)) expv_b(subidx_b(1)) Exp(i)];
    
    for jj=1:ncomps
        for ii=1:nsource
            
            x=(T{1}(:,jj));
            y=(xch(:,ii));
            temp=corrcoef(x,y);
            PCc(jj,ii,i)=temp(1,2);
            x=(T{1}(:,jj))/norm(T{1}(:,jj));
            y=(xch(:,ii))/norm((xch(:,ii)));
            
            PCn(jj,ii,i)=norm(x-y);
            
        end
    end
    [lc mc]=max(abs(PCc(:,:,i)));
    [ln mn]=max(abs(PCn(:,:,i)));
    L(i,:)=lc;
    Cx=0;
    out=triu(mean(out(:,:,[8:13]),3));
    [tmp itmp]=sort(out(:));
    tmp=flipud(itmp);
    [tmpr tmpc]=ind2sub(size(out),tmp(1));
    r=tmpr;
    c=tmpc;
    %%
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
        
    %%
    out_t=triu(mean(out_t(:,:,[8:13]),3));
    [tmp itmp]=sort(out_t(:));
    tmp=flipud(itmp);
    [tmpr tmpc]=ind2sub(size(out_t),tmp(1));
    r=tmpr;
    c=tmpc;
    
    for jj=1:size(locs,2)
        tempr=corrcoef(T1Fp(:,r),locs(:,jj));
        tempc=corrcoef(T1Fp(:,c),locs(:,jj));
        scr(jj)=tempr(1,2);
        scc(jj)=tempc(1,2);
    end
    
    [q Mr]=max(abs(scr));
    [q Mc]=max(abs(scc));
    
    for jj=1:8
        
        Rr_t(jj)=isempty(find(roindcs{jj}==Mr));
        Rc_t(jj)=isempty(find(roindcs{jj}==Mc));
        
    end
    %%
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
    
    A(:,:,i)=[find(Rr==0) find(Rc==0);find(Rr_t==0) find(Rc_t==0);truth.in_roi;find(RrT==0) find(RcT==0)] 
    B(:,i)=[INT(i) SNR(i)...
        max(max(mean(OUT{i}(:,:,8:13),3))) max(max(mean(OUT_b{i}(:,:,8:13),3)))...
        666 max(max(mean(OUT_t{i}(:,:,:),3)))...
        max(max(mean(OUT{i},3))) max(max(mean(OUT_b{i},3)))]
    % A,B
    dummy=1;
    calcLOC_fin
    calcCONN
end