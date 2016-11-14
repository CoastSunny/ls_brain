data=[];
if ~exist('sa')
load('~/Documents/bb/data/sa')
end
fs=100;
data=[];
data.fsample    = fs;
data.label=sa.EEG_clab_electrodes;
EEG=reshape(EEG_data,108,100,[]);
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
freqs=8:.5:13;
cfg.foi         = freqs;                                       
cfg.tapsmofrq   = 1;                                           
cfg.taper       = 'hanning';
cfg.output      = 'fourier';
freqc      = ft_freqanalysis(cfg, data);

Y=permute(freqc.fourierspctrm,[3 2 1]);
nsource=502;
ncomps=502;Options=.001;
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
[i m]=max(abs(PC));i(1:7),m(1:7)
out=tensor_connectivity(Fp,1,3);imagesc(out)