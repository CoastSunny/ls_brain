
fs=100;
data=[];
data.fsample    = fs;
data.label={'ch1' 'ch2'};
X=truth.sources;
EEG=reshape(X,2,100,[]);
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
freqs=1:1:40;
cfg.foi         = freqs;                                       
cfg.tapsmofrq   = 1;                                           
cfg.taper       = 'hanning';
cfg.output      = 'fourier';
freqc      = ft_freqanalysis(cfg, data);
Y=permute(freqc.fourierspctrm,[3 2 1]);
cpli=ls_pli(Y,8:13);colorbar
nsource=2;
ncomps=2;Options=.1;
[Fp,Ye,Ip,Exp,e,Rpen]=parafac_reg(Y,ncomps,[],[],Options,[9 9 0]);
temp=Fp;Fp=[];
Fp{1}=temp;

