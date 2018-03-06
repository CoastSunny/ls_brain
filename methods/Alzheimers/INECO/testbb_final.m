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

N=250;
OUT=[];OUT_b=[];PC=[];A=[];B=[];PCc=[];PCn=[];L=[];EV=[];INT=[];SNR=[];error=[];O=[];
er_ev=zeros(1,N);
locs=sa.cortex75K.EEG_V_fem_normal(:, sa.cortex2K.in_from_cortex75K);
roindcs=inds_roi_outer_2K;
elecrois=elec2roi(sa.EEG_locs_3D(:,1:3));
for i=1:N
    fprintf(['dataset ' num2str(i)])
%     d1='/Documents/bb/data/Pair1SNRrandNoise01Norm/EEG/dataset_';
%     d1='/Documents/bb/data/Pair1SNR05Noise01Norm/EEG/dataset_';
%     d2='/Documents/bb/data/Pair1SNR05Noise01Norm/truth/dataset_';
%      d1='/Documents/bb/data/snr05norm/EEG/dataset_';
%      d2='/Documents/bb/data/snr05norm/truth/dataset_';
    load([home d1 num2str(i) '/data']),
    load([home d2 num2str(i) '/truth']),
    truth
    INT(i)=truth.interaction;
    SNR(i)=truth.snr;
    sig(i)=mean(truth.sigmas);
    data=[];
    warning off
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
    cfg.lpfilter    = 'yes';
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
%     ncomps=8;
    xch=[truth.EEG_field_pat truth.EEG_noise_pat];
    Xch{i}=xch;
%     cfg=[];cfg.method='fastica';cfg.numcomponent=8;
%     data=ft_componentanalysis(cfg,data);

    cfg=[];cfg.order=10;cfg.output='residual';
    mvardata=ft_mvaranalysis(cfg,data);
    cfg=[];cfg.method='runica';cfg.numcomponent=mvarncomps;
    cfg.runica.verbose='off';cfg.feedback='no';cfg.pca=mvarncomps;
    mvarica=ft_componentanalysis(cfg,mvardata);
    W=mvarica.unmixing;
    H=mvarica.topo;
    cfg=[];cfg.order=10;
    mvardata=ft_mvaranalysis(cfg,data);  
    clear new_coeffs
    for pi=1:cfg.order
        new_coeffs(:,:,pi)=W*mvardata.coeffs(:,:,pi)*pinv(W);        
    end
    mvardata.noisecov=W*mvardata.noisecov*(W'); 
    mvardata.coeffs=new_coeffs;
    mvardata.label=mvardata.label(1:mvarncomps);
    cfg=[];cfg.foi=1:1:40;
    fmvar=ft_freqanalysis_mvar(cfg,mvardata);  
    cfg=[];cfg.method='coh';cfg.bandwidth=100;cfg.complex='imag';
    stat = ft_connectivityanalysis(cfg, fmvar);
   
    cfg=[];cfg.order=10;cfg.output='residual';
    mvardata_b=ft_mvaranalysis(cfg,data_b);
    cfg=[];cfg.method='runica';cfg.numcomponent=mvarncomps;
    cfg.runica.verbose='off';cfg.feedback='no';cfg.pca=mvarncomps;
    mvarica_b=ft_componentanalysis(cfg,mvardata_b);
    W_b=mvarica_b.unmixing;
    H_b=mvarica_b.topo;
    cfg=[];cfg.order=10;
    mvardata_b=ft_mvaranalysis(cfg,data_b);
    clear new_coeffs
    for pi=1:cfg.order
        new_coeffs(:,:,pi)=W*mvardata_b.coeffs(:,:,pi)*pinv(W);        
    end
    mvardata_b.noisecov=W*mvardata_b.noisecov*(W'); 
    mvardata_b.coeffs=new_coeffs;
    mvardata_b.label=mvardata_b.label(1:mvarncomps);
    cfg=[];cfg.foi=1:1:40;    
    fmvar_b=ft_freqanalysis_mvar(cfg,mvardata_b);
    cfg=[];cfg.method='coh';cfg.bandwidth=100;cfg.complex='imag';
    stat_b = ft_connectivityanalysis(cfg, fmvar_b);
    param='cohspctrm';
    %%
%     [Am,Su,Yp,Up]=idMVAR(EEG_data,5,0);
%     [DC,DTF,PDC,GPDC,COH,PCOH,PCOH2,H,S,P,f] = fdMVAR(Am,Su,40,100);
%     coh=abs(imag(COH));
%     [mdtf_p idtf_p]=max(coh(:));
%     [fdtf_p rdtf_p cdtf_p]=ind2sub(size(coh),idtf);
%     coh813=(coh(:,:,8:13));
%     [mdtf idtf]=max(coh813(:));
%     [fdtf rdtf cdtf]=ind2sub(size(coh),idtf);
    
    %%
    CS_p=permute(abs(stat.(param)),[3 1 2]);
    [mcs ics]=max(CS_p(:));
    [tmpf mtmpr_p mtmpc_p]=ind2sub(size(CS_p),ics);
    mvar_proper=CS_p(tmpf,mtmpr_p,mtmpc_p);
    %cross_mvar=real(fmvar.crsspctrm(:,:,tmpf));
%     [p_mvar1 w_mvar1]=ls_lcmv(H(:,mtmpr_p)*H(:,mtmpr_p).',locs);
%     [mp1 ip1]=sort(p_mvar1);
%     [p_mvar2 w_mvar2]=ls_lcmv(H(:,mtmpc_p)*H(:,mtmpc_p).',locs);
%     [mp2 ip2]=sort(p_mvar2);
    for jj=1:size(locs,2)
        tempr=corrcoef(H(:,mtmpr_p),locs(:,jj));
        tempc=corrcoef(H(:,mtmpc_p),locs(:,jj));
        scr(jj)=tempr(1,2);
        scc(jj)=tempc(1,2);
    end
    
    [q Mr]=max(abs(scr));
    [q Mc]=max(abs(scc));
    
    for jj=1:8
        
        Rr_mvar(jj)=isempty(find(roindcs{jj}==Mr));
        Rc_mvar(jj)=isempty(find(roindcs{jj}==Mc));
        
    end
    ROI1_mvar=find(Rr_mvar==0);
    ROI2_mvar=find(Rc_mvar==0);
    
%     ROI1_mvar=sa.cortex75K.roi_mask(sa.cortex2K.in_from_cortex75K(ip1(end)));
%     ROI2_mvar=sa.cortex75K.roi_mask(sa.cortex2K.in_from_cortex75K(ip2(end)));
%     CS_b_p=ls_pli(permute(Y_b,[3 1 2]),[],0);
    CS_b_p=permute(abs(stat_b.(param)),[3 1 2]);
    [mcs ics]=max(CS_b_p(:));
    [tmpf_b mtmpr_b_p mtmpc_b_p]=ind2sub(size(CS_b_p),ics);
    mvar_proper_b=CS_b_p(tmpf,mtmpr_b_p,mtmpc_b_p);
   
    
%     diff_pli_proper=(CS_p(tmpf,tmpr_p,tmpc_p)-CS_b_p(tmpf,tmpr_p,tmpc_p))>0.1;
    
    %%
%     CS=ls_pli2(permute(Y,[3 1 2]),[8:13],0);
    CS=permute(stat.(param)(:,:,8:13),[3 1 2]);
    [mcs ics]=max(CS(:));
    [tmpf mtmpr mtmpc]=ind2sub(size(CS),ics);
%     CS_b=ls_pli2(permute(Y_b,[3 1 2]),[8:13],0);
    CS_b=permute(stat_b.(param)(:,:,8:13),[3 1 2]);
%     diff_pli=(CS(tmpf,tmpr,tmpc)-CS_b(tmpf,tmpr,tmpc))>0.1;
    mvar=CS(tmpf,mtmpr,mtmpc);
    %%

    rng('default')
    Options=[];
    Options(1)=10^-1;
    maxsub=20;
 
    [Fp{i},Yest,Ip(i),Exp(i),e]=parafac_reg(Y,ncomps,[],[],Options,[9 0 0]);       
    out_t=tensor_connectivity_t(Fp{i}{3},Fp{i}{2});
    OUT_t{i}=out_t;
    
    %%
    Options=[];
    Options(1)=10^-1;
    Options(3)=0;
    Options(5)=1;
    maxsub=5;
    rng('default')

    for subit=1:1
    ev=0;subcount=0;
    fprintf(num2str(subit))
    while ev<=0 && subcount<maxsub
        subcount=subcount+1;        
        try
            [T{1} T{2} T{3} T{4} T{5} ev]=parafac2(Y,ncomps,[4 0],Options);%,Fp{i}{1},eye(ncomps),Fp{i}{3});
        catch
            er_ev(i)=er_ev(i)+1;
        end
    end
    out=tensor_connectivity3(T{4},T{2},T{3});
    out=triu(mean(out(:,:,:),3));
    O(subit)=max(max(out));
    t{subit}=T;
    expv(subit)=ev;
    end
    
    if subcount>=maxsub
           A(:,:,i)=zeros(6,2);
           B(:,i)=[-ones(12,1)];
        continue
    end
    subidx=find(O==max(O));
    T=t{subidx(1)};
    
    [T_b{1} T_b{2} T_b{3} T_b{4} T_b{5} tev]=parafac2(Y_b,ncomps,[4 0],Options);
    out=tensor_connectivity3(T{4},T{2},T{3});
    
    out_b=tensor_connectivity3(T_b{4},T_b{2},T{3});

    OUT{i}=out;
    OUT_b{i}=out_b;
    Tt{i}{1}=T;Tt{i}{2}=T_b;
    %%
%      T{1}=abs(T{1});
     T1Fp=(Fp{i}{1});
%      locs=(locs);
    EV(i,:)=[expv(subidx(1)) tev Exp(i)];
    
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
    
   % out=triu(mean(out(:,:,[8:13]),3));
    [tmp itmp]=sort(out(:));
    tmp=flipud(itmp);
    [tmpr tmpc tmpf]=ind2sub(size(out),tmp(1));
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
    %out_t=triu(mean(out_t(:,:,:),3));
    [tmp itmp]=sort(out_t(:));
    tmp=flipud(itmp);
    [tmpr tmpc tmpf]=ind2sub(size(out_t),tmp(1));
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
%     [p1_para2 w1_para2]=ls_lcmv(T{1}(:,r)*T{1}(:,r)',locs);
%     [m i1]=max(p1_para2);
%     [p2_para2 w2_para2]=ls_lcmv(T{1}(:,c)*T{1}(:,c)',locs);
%     [m i2]=max(p2_para2);
%     ROI1_para2=sa.cortex75K.roi_mask(sa.cortex2K.in_from_cortex75K(i1));
%     ROI2_para2=sa.cortex75K.roi_mask(sa.cortex2K.in_from_cortex75K(i2));
    A(:,:,i)=[find(Rr==0) find(Rc==0);find(Rr_t==0) find(Rc_t==0);...%ROI1_para2 ROI2_para2;...
        truth.in_roi;find(RrT==0) find(RcT==0);...
        ROI1_mvar ROI2_mvar;elecrois(mtmpr) elecrois(mtmpc)];%...
%         elecrois(rdtf_p) elecrois(cdtf_p);elecrois(rdtf) elecrois(cdtf)];
    B(:,i)=[INT(i) SNR(i)...
        max(OUT{i}(:)) max(OUT_b{i}(:))...
        666 max(OUT_t{i}(:))...
        max(OUT{i}(:)) max(OUT_b{i}(:)) ...
        666 mvar_proper mvar mvar_proper_b];%...
%         666 max(coh(:)) max(coh813(:))];
    % A,B
    dummy=1;
    calcLOC_fin
    calcCONN
    Result=[Lpara2 Cpara2;Lpara Cpara;Lmvar_p Cmvar_p;Lmvar Cmvar]%;Lmvar_p Cmvar_p;Lmvar Cmvar]
    cdir=pwd;
    cd ~/Desktop
    save('tRes','Result')
    cd(cdir)
end