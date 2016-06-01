if isunix==0
    data_folder='D:\Raw\AlzheimerEEG\Multivariate AFAVA artefact free';
    save_folder='D:\Extracted\Alzheimer\Multivariate AFAVA artefact free\AFAVA_1sectrials\';
else
    data_folder='/home/engbiome/AlzheimerEEG/Multivariate AFAVA artefact free/';
    save_folder='/home/lspyrou/Documents/results/AFAVA_1sectrials/';
end
channels_correct={'C3' 'C4' 'F3' 'F4' 'F7' 'F8' 'Fp1' 'Fp2' 'O1' 'O2' 'P3' 'P4' 'T7' 'T8' 'P7' 'P8'};
%% Connectivity Analysis
subject_identifier=[1 0 1 0 0 1 0 1 0 1 0 1 0 1 1 0 0 1 0 1 0 1 0 1 0 0 0];
used_subjects=[1 1 1 1 1 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 1 1 1 1 1 1 0 ];
fidx_control=find(subject_identifier(used_subjects==1)==0);
fidx_patient=find(subject_identifier(used_subjects==1)==1);

DirCon = dir([ save_folder '*.mat']);
cd(save_folder)
tmp=struct2cell(DirCon);
tmp=tmp(1,1:end);
names=sort_nat(tmp);
% Sets frequency bands (steps must match frequency resolution, see cfg.pad)
%freqBands = [[0.5 3]; [3.5 8]; [8.5 12]; [12.5 32]; [32.5 40]];
%numberOfBands = size(freqBands,1);
%PSI = NaN(16,16,100,5,50);
PSI             = []; PSI_full=[];
Conn            = []; Conn_full=[];freq=[];
ntrials_window=1;
freqs=0:1:40;
for q = 1:length(DirCon)
    clear data
    load( names{q} )
    
    ntrials=numel(data.trial);
    
    cfg             = [];
    cfg.method      = 'mtmfft';                                      % Type of analysis
    %     cfg.foi         = freqBands(i,1):0.2:freqBands(i,2);           % Frequency band to analyse
    cfg.foi         = freqs;                                       % Frequency band to analyse
    cfg.tapsmofrq   = 1;                                            % Or can test other values
    cfg.taper       = 'hanning';
    %     cfg.t_ftimwin   = 5;
    %     cfg.toi         = 2.5;
    cfg.output      = 'pow';
    %cfg.pad         = 5;                                                % Pads for 0.5Hz resolution
    freq{q}         = ft_freqanalysis(cfg, data);  
    freq{q}.label   = channels_correct;
    Freq{q}         = (freq{q}.powspctrm);
    
    cfg.output      = 'fourier';
    freqc{q}        = ft_freqanalysis(cfg, data);  
    freqc{q}.label  = channels_correct;

    % Applies connectivity measure
    cfg             = [];
    cfg.method      = 'coh';
    cfg.complex     = 'imag';
    parameter       = 'cohspctrm';
    
    %          cfg.bandwidth   = 1;
    for idx_trials=1:ntrials-ntrials_window
        cfg.trials      = idx_trials:idx_trials+ntrials_window-1;
        conn{q}            = ft_connectivityanalysis(cfg, freqc{q});
        PSI{q}(:,:,:,idx_trials) = abs(conn{q}.(parameter));
        for idx_freq = 1:numel(freqs)
            tmp               = (PSI{q}(:,:,idx_freq,idx_trials));
            idx_toremove      = find(tril(ones(size(tmp))));
            tmp(idx_toremove) = [];
            Conn{q}(:,idx_freq,idx_trials)  = tmp;
        end
    end
    
%     
    cfg.trials      = 1:min(50,ntrials);
    conn_full{q}            = ft_connectivityanalysis(cfg, freqc{q});
    PSI_full{q}(:,:,:) = abs(conn_full{q}.(parameter));
    for idx_freq = 1:numel(freqs)
        tmp               = (PSI_full{q}(:,:,idx_freq));
        idx_toremove      = find(tril(ones(size(tmp))));
        tmp(idx_toremove) = [];
        Conn_full{q}(:,idx_freq)  = tmp;
    end
    
    
    % Can plot the connectivity with following:
    % cfg           = [];
    % cfg.zlim      = [0 1];
    % cfg.parameter = wplispctrm'  % or _debiased
    % ft_connectivityplot(cfg, pli);
    
   
%     Y=Conn{q};
%     Options=1;
%     [Fp{q},Ip(q),Ep(q),Concp(q)]=parafac(Y,4,Options,[2 3 0]);
%     [Ft{q},Gt{q}]=tucker(Y,[4 4 -1],Options,[1 4 -1]);
    
    
end

for i=1:numel(Conn)
    
    X(:,:,i)=mean(Conn_full{i},3);
    
end

