data=[];
if ~exist('sa')
load('~/Documents/bb/data/sa')
end
fs=100;

data.fsample    = fs;
data.label=sa.EEG_clab_electrodes;
EEG=reshape(EEG_data,108,500,[]);
for k=1:size(EEG,3)
    data.trial{1,k} = EEG(:,:,k);
    data.time{1,k}  = (0:(size(EEG,2)-1))/fs;
end
cfg             = [];
cfg.reref       = 'yes';
cfg.refchannel  = 'all'; % average reference
cfg.lpfilter    = 'no';
cfg.lpfreq      = 40;
cfg.preproc.demean='yes';
cfg.preproc.detrend='yes';
data            = ft_preprocessing(cfg,data);

cfg             = [];
cfg.method      = 'mtmfft';                                    
freqs=1:1:40;
cfg.foi         = freqs;                                       
cfg.tapsmofrq   = 2;                                           
cfg.taper       = 'hanning';
cfg.output      = 'fourier';
freqc      = ft_freqanalysis(cfg, data);

Y=permute(freqc.fourierspctrm,[3 2 1]);
nsource=502;
ncomps=510;Options=[];
[Fp,Ye,Ip,Exp,e,Rpen]=parafac_reg(Y,ncomps,[],[],Options,[9 9 0]);
temp=Fp;Fp=[];
Fp{1}=temp;
xch=[truth.EEG_field_pat truth.EEG_noise_pat];
PC=[];
for jj=1:ncomps
    for ii=1:nsource
        
        x=(Fp{1}{2}(:,jj));
        y=(xch(:,ii));
        temp=corrcoef(x,y);
        PC(jj,ii)=temp(1,2);
        
    end
end
