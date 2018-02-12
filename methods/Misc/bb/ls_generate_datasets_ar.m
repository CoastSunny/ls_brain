function ls_generate_datasets_ar(ndatasets, dataset_string, options)
%
if isunix==0
    home='C:\Users\Loukianos';
    home_bci='D:\';
else
    home='~';
    home_bci='~';
end

load([home '/Documents/bb/data/sa'])
load([home '/Documents/bb/data/miscdata'])
mkdir([home '/Documents/bb/data/' dataset_string])
rng('default');
%rng('shuffle');
sd = rng;
save([home '/Documents/bb/data/' dataset_string '/sd'], 'sd');
truth.sigma_range = [10 40];
truth.snr_range = [0.1 0.9];
n_noise_sources = 500;
fs = 100;
truth.len = 3*60;
N = fs*truth.len;
EEG_M = length(sa.EEG_clab_electrodes);

% highpass filter coefficients
[b_high a_high] = butter(3, 0.1/fs*2, 'high');

% bandpass filter coefficients
for i=1:options.sourcepairs
    [tmp_b tmp_a] = butter(3, options.bandpass{i}/fs*2);
    b_band{i}=tmp_b;
    a_band{i}=tmp_a;
end

% loop over datasets to be generated
for idata = 1:ndatasets
    
    mkdir([home '/Documents/bb/data/' dataset_string '/EEG/dataset_' num2str(idata)])
    mkdir([home '/Documents/bb/data/' dataset_string '/truth/dataset_' num2str(idata)])
    disp(['generating dataset ' num2str(idata) '/' num2str(ndatasets)])
    
    truth.snr = truth.snr_range(1) + diff(truth.snr_range)*rand(1);
    if ~isempty(options.snr)
        truth.snr=options.snr;
    end
    
    %% spatial structure definition
    % sample source rois
    in_ = randperm(8);
    truth.in_roi = in_(1:(options.sourcepairs*2));
    
    truth.rois = rois(truth.in_roi);
    
    % sample source extents
    truth.sigmas = truth.sigma_range(1) + diff(truth.sigma_range)*rand(2, 1);
    
    % sample source centers within rois
    for i=1:(options.sourcepairs*2)
        truth.in_centers(i) = inds_roi_inner_2K{truth.in_roi(i)}(ceil(length(inds_roi_inner_2K{truth.in_roi(i)})*rand(1)));
    end
    truth.centers = sa.cortex75K.vc(sa.cortex2K.in_from_cortex75K(truth.in_centers), :);
    
    % calculate source amplitude distribution
    cortex2K = [];
    cortex2K.vc = sa.cortex75K.vc(sa.cortex2K.in_from_cortex75K, :);
    cortex2K.tri = sa.cortex2K.tri;
    
    % generate Gaussian distributions on cortical manifold
    for i=1:(options.sourcepairs*2)
        [~, truth.source_amp(:, i)] = graphrbf(cortex2K, truth.sigmas(mod(i-1,2)+1), truth.in_centers(i));
    end
    % set activity outside of source octant to zero
    for i=1:(options.sourcepairs*2)
        truth.source_amp(setdiff(1:size(truth.source_amp, 1), inds_roi_outer_2K{truth.in_roi(i)}), i) = 0;
    end
    % normalize amplitude distributions
    for i=1:(options.sourcepairs*2)
        truth.source_amp(:, i) = truth.source_amp(:, i) / norm(truth.source_amp(:, i));
    end
    % calculate field spread assuming perpendicular source orientations
    for i=1:(options.sourcepairs*2)
        truth.EEG_field_pat(:, i) = sa.cortex75K.EEG_V_fem_normal(:, sa.cortex2K.in_from_cortex75K)*truth.source_amp(:, i);
    end
    
    for i=1:(options.sourcepairs)
        truth.interaction(i)=rand(1)>0.5;
    end
    
    %% time series generation
    for i=1:(options.sourcepairs)
        [sources_int, sources_nonint, P_ar] = generate_sources_ar(fs, truth.len, options.bandpass{i}, options.pow);
        truth.sources_int(2*i-1:2*i,:)=sources_int;
        truth.sources_nonint(2*i-1:2*i,:)=sources_nonint;
    end
    if options.normalise_sources==1
        for i=1:(2*options.sourcepairs)
            truth.sources_int(i,:)=truth.sources_int(i,:)/norm(truth.sources_int(i,:));
            truth.sources_nonint(i,:)=truth.sources_nonint(i,:)/norm(truth.sources_nonint(i,:));
        end
    end
    % sample noise source locations
    noise_inds = ceil(size(sa.cortex75K.EEG_V_fem_normal, 2)*rand(n_noise_sources, 1));
    no_signal = 0; EEG_signal = 0;
    
    for i=1:options.sourcepairs
        if truth.interaction(i)==1
            no_signal  = no_signal  + truth.source_amp(:,2*i-[1 0])*truth.sources_int(2*i-[1 0],:);
            EEG_signal = EEG_signal + truth.EEG_field_pat(:,2*i-[1 0])*truth.sources_int(2*i-[1 0],:);
        else
            no_signal  = no_signal  + truth.source_amp(:,2*i-[1 0])*truth.sources_nonint(2*i-[1 0],:);
            EEG_signal = EEG_signal + truth.EEG_field_pat(:,2*i-[1 0])*truth.sources_nonint(2*i-[1 0],:);
        end
    end
    no_signal = norm(no_signal,'fro');
    EEG_signal = EEG_signal ./ no_signal;
    
    % biological noise, mixture of independent pink noise sources
    pn = mkpinknoise(N, n_noise_sources)';
    
    EEG_brain_noise = sa.cortex75K.EEG_V_fem_normal(:, noise_inds)*pn;
    truth.EEG_noise_pat = sa.cortex75K.EEG_V_fem_normal(:, noise_inds);
    
    % compute noise amplitude in band of interest (only needed for SNR computation)
    norm_brain_noise = 0;
    for i=1:options.sourcepairs
        if ~isempty(options.bandpass{i})
            norm_brain_noise =  norm_brain_noise + norm(filtfilt(b_band{i}, a_band{i}, pn')', 'fro');
        else
            norm_brain_noise =  norm_brain_noise + norm(pn, 'fro');
        end
    end
    % normalize noise by amplitude in band of interest
    EEG_brain_noise = EEG_brain_noise ./ norm_brain_noise;
    
    EEG_brain_signal_noise = truth.snr*EEG_signal + (1-truth.snr)*EEG_brain_noise;
    EEG_brain_signal_noise = EEG_brain_signal_noise ./ norm(EEG_brain_signal_noise, 'fro');
    
    % white sensor noise
    EEG_sensor_noise = randn(EEG_M, N);
    EEG_sensor_noise = EEG_sensor_noise ./ norm(EEG_sensor_noise, 'fro');
    
    % overall noise is dominated by biological noise
    sensor_noise=options.sensor_noise;
    EEG_data = (1-sensor_noise)*EEG_brain_signal_noise + sensor_noise*EEG_sensor_noise;
    
    % apply high-pass
    EEG_data = filtfilt(b_high, a_high, EEG_data')';
    
    %% generate pseudo-baseline EEG/MEG without sources
    % everything as above except that no signal is added at all
    pn = mkpinknoise(N, n_noise_sources)';
    EEG_brain_noise = sa.cortex75K.EEG_V_fem_normal(:, noise_inds)*pn;
    EEG_brain_noise = EEG_brain_noise ./ norm(EEG_brain_noise, 'fro');
    
    % white sensor noise
    EEG_sensor_noise = randn(EEG_M, N);
    EEG_sensor_noise = EEG_sensor_noise ./ norm(EEG_sensor_noise, 'fro');
    
    EEG_baseline_data = (1-sensor_noise)*EEG_brain_noise + sensor_noise*EEG_sensor_noise;
    EEG_baseline_data = filtfilt(b_high, a_high, EEG_baseline_data')';
    
    %% some renaming
    truth.sensor_noise=sensor_noise;
    % save data
    save([home '/Documents/bb/data/' dataset_string '/EEG/dataset_' num2str(idata) '/data'], 'EEG_data', 'EEG_baseline_data', 'fs');
    %   save(['data/' dataset_string '/MEG/dataset_' num2str(idata) '/data'], 'MEG_data', 'MEG_baseline_data', 'fs');
    save([home '/Documents/bb/data/' dataset_string '/truth/dataset_' num2str(idata) '/truth'], 'truth');
    
end

end

