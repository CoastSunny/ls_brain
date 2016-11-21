data=[];
if ~exist('sa')
load('~/Documents/bb/data/sa')
end
fs=100;
len=180;
bandpass=[8 13];
data=[];
data.fsample    = fs;
data.label=sa.EEG_clab_electrodes;
% [sources_int, sources_nonint, P_ar] = generate_sources_ar(fs, len, bandpass);
% EEG_field_pat(:,2) = sa.cortex75K.EEG_V_fem_normal(:,randi(74382));
% EEG_field_pat(:,2) = sa.cortex75K.EEG_V_fem_normal(:,randi(74382));
% EEG_data=EEG_field_pat*sources_int;

% EEG_data=truth.EEG_field_pat*randn(2,18000);
EEG=reshape(EEG_data,108,500,[]);
for k=1:size(EEG,3)
    data.trial{1,k} = EEG(:,:,k);
    data.time{1,k}  = (0:(size(EEG,2)-1))/fs;
end
cfg             = [];

cfg.reref       = 'no';
cfg.refchannel  = 'all'; % average reference
cfg.lpfilter    = 'no';
cfg.lpfreq      = 40;
cfg.preproc.demean='no';
cfg.preproc.detrend='no';
data            = ft_preprocessing(cfg,data);

cfg             = [];
cfg.method      = 'mtmfft';                                    
freqs=2:2:20;
cfg.foi         = freqs;                                       
cfg.tapsmofrq   = 1;                                           
cfg.taper       = 'hanning';
cfg.output      = 'fourier';
freqc      = ft_freqanalysis(cfg, data);

Y=permute(freqc.fourierspctrm,[1 2 3]);
nsource=2;
ncomps=2;Options=10^-2;
xch=[truth.EEG_field_pat truth.EEG_noise_pat];
[Fp,Ye,Ip,Exp,e,Rpen]=parafac_reg(Y,ncomps,[],[],Options,[0 9 0]);
temp=Fp;Fp=[];
Fp{1}=temp;
PC=[];
for jj=1:ncomps
    for ii=1:nsource
        
        x=(Fp{1}{2}(:,jj));
        y=(xch(:,ii));
        temp=corrcoef(x,y);
        PC(jj,ii)=temp(1,2);
        
    end
end
[i m]=max(abs(PC));i(1:2),m(1:2)
out=tensor_connectivity(Fp,1,3);imagesc(out),colorbar
figure,hold on,plot(xch(:,1)),plot(xch(:,2),'r')
figure,hold on,plot((Fp{1}{2}(:,m(1)))),plot((Fp{1}{2}(:,m(2))),'r')





