function generate_datasets_ar(ndatasets, dataset_string)
% Stefan Haufe, 2014, 2015
% stefan.haufe@tu-berlin.de
%
% Arne Ewald, Sept. 2015, mail@aewald.net
%
% If you use this code for a publication, please ask Stefan Haufe for the
% correct reference to cite.

% License
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see http://www.gnu.org/licenses/.
if isunix==0
    home='C:\Users\Loukianos';
    home_bci='D:\';
else
    home='~';
    home_bci='~';
end


% load head model and some miscallaneous data
load([home '/Documents/bb/data/sa'])
load([home '/Documents/bb/data/miscdata'])

% create directory to store data in
mkdir([home '/Documents/bb/data/' dataset_string])

% initialize random number generator
rng('default');
rng('shuffle');
sd = rng;

% save random number seed
save([home '/Documents/bb/data/' dataset_string '/sd'], 'sd');

% if true, a lot of plots are generated
plotting = 0;

% spatial standard deviation of the sources (along cortical manifold) in mm
truth.sigma_range = [10 40];

% SNR range to sample from
truth.snr_range = [0.1 0.9];

%number of biological noise source
n_noise_sources = 500;

% sampling frequency
fs = 100;

% length of recording in sec
truth.len = 3*60; 

% resulting number of samples
N = fs*truth.len;

% band of interest, in which interaction takes place
truth.bandpass = [8 13];

% number of electrodes
EEG_M = length(sa.EEG_clab_electrodes);
% MEG_M = length(sa.MEG_clab_electrodes);

% highpass filter coefficients
[b_high a_high] = butter(3, 0.1/fs*2, 'high');

% bandpass filter coefficients
if ~isempty(truth.bandpass)
  [b_band a_band] = butter(3, truth.bandpass/fs*2);
end

% loop over datasets to be generated
for idata = 1:ndatasets
  
  % create folder for dataset idata
  mkdir([home '/Documents/bb/data/' dataset_string '/EEG/dataset_' num2str(idata)])
%   mkdir(['data/' dataset_string '/MEG/dataset_' num2str(idata)])
  mkdir([home '/Documents/bb/data/' dataset_string '/truth/dataset_' num2str(idata)])
  
  disp(['generating dataset ' num2str(idata) '/' num2str(ndatasets)])

  % sample snr
  truth.snr = truth.snr_range(1) + diff(truth.snr_range)*rand(1);  
  
  %% spatial structure definition
  % sample source rois
  in_ = randperm(8);  
  truth.in_roi = in_(1:2);
  
  truth.rois = rois(truth.in_roi);

  % sample source extents
  truth.sigmas = truth.sigma_range(1) + diff(truth.sigma_range)*rand(2, 1);

  % sample source centers within rois
  truth.in_centers(1) = inds_roi_inner_2K{truth.in_roi(1)}(ceil(length(inds_roi_inner_2K{truth.in_roi(1)})*rand(1)));
  truth.in_centers(2) = inds_roi_inner_2K{truth.in_roi(2)}(ceil(length(inds_roi_inner_2K{truth.in_roi(2)})*rand(1)));
  truth.centers = sa.cortex75K.vc(sa.cortex2K.in_from_cortex75K(truth.in_centers), :);

  % calculate source amplitude distribution
  cortex2K = [];
  cortex2K.vc = sa.cortex75K.vc(sa.cortex2K.in_from_cortex75K, :);
  cortex2K.tri = sa.cortex2K.tri;
  
  % generate Gaussian distributions on cortical manifold
  [~, truth.source_amp(:, 1)] = graphrbf(cortex2K, truth.sigmas(1), truth.in_centers(1));
  [~, truth.source_amp(:, 2)] = graphrbf(cortex2K, truth.sigmas(2), truth.in_centers(2));
  
  % set activity outside of source octant to zero
  truth.source_amp(setdiff(1:size(truth.source_amp, 1), inds_roi_outer_2K{truth.in_roi(1)}), 1) = 0;
  truth.source_amp(setdiff(1:size(truth.source_amp, 1), inds_roi_outer_2K{truth.in_roi(2)}), 2) = 0;

  % normalize amplitude distributions
  truth.source_amp(:, 1) = truth.source_amp(:, 1) ./ norm(truth.source_amp(:, 1));
  truth.source_amp(:, 2) = truth.source_amp(:, 2) ./ norm(truth.source_amp(:, 2));

  % calculate field spread assuming perpendicular source orientations
  truth.EEG_field_pat(:, 1) = sa.cortex75K.EEG_V_fem_normal(:, sa.cortex2K.in_from_cortex75K)*truth.source_amp(:, 1);
  truth.EEG_field_pat(:, 2) = sa.cortex75K.EEG_V_fem_normal(:, sa.cortex2K.in_from_cortex75K)*truth.source_amp(:, 2);
  
  %% time series generation
  % randomize if dataset contains interaction
  truth.interaction=rand(1)>0.5;
  
% truth.interaction=1;
  if truth.interaction==1
      truth.dataset = {'interacting'};
  else
      truth.dataset = {'non-interacting'};
  end
  
  % generate source time series restricted to band of interest
  % [truth.sources_int, truth.sources_nonint, truth.lag, truth.sourcecorr] = generate_sources_lagged(fs, truth.len, truth.bandpass);
  [truth.sources_int, truth.sources_nonint, truth.P_ar] = generate_sources_ar(fs, truth.len, truth.bandpass);

  % sample noise source locations
  noise_inds = ceil(size(sa.cortex75K.EEG_V_fem_normal, 2)*rand(n_noise_sources, 1));
  
  if truth.interaction==1
      % generate pseudo-EEG/MEG with interacting sources     
      no_signal = norm(truth.source_amp*truth.sources_int, 'fro');
      EEG_signal = truth.EEG_field_pat*truth.sources_int;
  else      
      % generate pseudo-EEG/MEG with non-interacting sources
      no_signal = norm(truth.source_amp*truth.sources_nonint, 'fro');
      EEG_signal = truth.EEG_field_pat*truth.sources_nonint;
  end
  
  EEG_signal = EEG_signal ./ no_signal;
 
  % biological noise, mixture of independent pink noise sources 
  pn = mkpinknoise(N, n_noise_sources)';
  
  EEG_brain_noise = sa.cortex75K.EEG_V_fem_normal(:, noise_inds)*pn;
  truth.EEG_noise_pat = sa.cortex75K.EEG_V_fem_normal(:, noise_inds);

  % compute noise amplitude in band of interest (only needed for SNR computation)
  if ~isempty(truth.bandpass)
      norm_brain_noise = norm(filtfilt(b_band, a_band, pn')', 'fro');
  else
      norm_brain_noise = norm(pn, 'fro');
  end
  % normalize noise by amplitude in band of interest
  EEG_brain_noise = EEG_brain_noise ./ norm_brain_noise;

  EEG_brain_signal_noise = truth.snr*EEG_signal + (1-truth.snr)*EEG_brain_noise;
  EEG_brain_signal_noise = EEG_brain_signal_noise ./ norm(EEG_brain_signal_noise, 'fro');
 
  % white sensor noise
  EEG_sensor_noise = randn(EEG_M, N);
  EEG_sensor_noise = EEG_sensor_noise ./ norm(EEG_sensor_noise, 'fro');
 
  % overall noise is dominated by biological noise
  sensor_noise=0.1;
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
   
  %% plotting
  if plotting

    load([home '/Documents/ls_brain/methods/Misc/bb/tools/cm17'])

%       freq_inds = (truth.bandpass(1)*2+1):(truth.bandpass(2)*2+1); 
%       [psi, stdpsi] = data2psi2(truth.sources_int', fs*2, fs*4, freq_inds);
%       % figure; imagesc(psi./stdpsi); colorbar
%       max(max(abs(psi./stdpsi)))

    % first source amplitude distribution
    ma = max(truth.source_amp(:, 1));
    allplots_cortex(sa, truth.source_amp(sa.cortex2K.in_to_cortex75K_geod, 1), ...
        [0 ma], cm17a, 'A.U.', 1, ['figures/' dataset_string '/truth/dataset' num2str(idata) '/source1']);
    %       [sa.cortex75K.vc_smooth(truth.in_centers(1), :)]);

    % second source amplitude distribution
    ma = max(truth.source_amp(:, 2));
    allplots_cortex(sa, truth.source_amp(sa.cortex2K.in_to_cortex75K_geod, 2), ...
        [0 ma], cm17a, 'A.U.', 1, ['figures/' dataset_string '/truth/dataset' num2str(idata) '/source2']);

    % both source amplitude distributions
    ma = max(sum(truth.source_amp, 2));
    allplots_cortex(sa, sum(truth.source_amp(sa.cortex2K.in_to_cortex75K_geod, :), 2), ...
        [0 ma], cm17a, 'A.U.', 1, ['figures/' dataset_string '/truth/dataset' num2str(idata) '/sources']);

    % dipole patterns
    ma = max(abs(truth.EEG_field_pat(:, 1)));
    allplots_head(sa, sa.EEG_elec2head*truth.EEG_field_pat(:, 1), [-ma ma], cm17, 'A.U.', ['figures/' dataset_string '/truth/dataset' num2str(idata) '/EEG_pat1'], sa.EEG_locs_3D(:, 1:3));

    ma = max(abs(truth.MEG_field_pat(:, 1)));
    allplots_head(sa, sa.MEG_elec2head*truth.MEG_field_pat(:, 1), [-ma ma], cm17, 'A.U.', ['figures/' dataset_string '/truth/dataset' num2str(idata) '/MEG_pat1'], sa.MEG_locs_3D(:, 1:3));
    
    ma = max(abs(truth.EEG_field_pat(:, 2)));
    allplots_head(sa, sa.EEG_elec2head*truth.EEG_field_pat(:, 2), [-ma ma], cm17, 'A.U.', ['figures/' dataset_string '/truth/dataset' num2str(idata) '/EEG_pat2'], sa.EEG_locs_3D(:, 1:3));

    ma = max(abs(truth.MEG_field_pat(:, 2)));
    allplots_head(sa, sa.MEG_elec2head*truth.MEG_field_pat(:, 2), [-ma ma], cm17, 'A.U.', ['figures/' dataset_string '/truth/dataset' num2str(idata) '/MEG_pat2'], sa.MEG_locs_3D(:, 1:3));

    %   ma = max(abs(sum(truth.field_pat, 2)));
    %   allplots_head(sa, sum(truth.field_pat, 2), [-ma ma], cm17, 'A.U.', ['figures/' dataset_string '/truth/dataset' num2str(idata) '/pats']);

    % plot power spectrum
    no = sqrt(sum(EEG_data.^2, 2));
    [~, in_no] = max(no);
    ss = std(EEG_data(in_no, :));
    [P1, f1] = pwelch(EEG_data(in_no, :)/ss, hanning(fs), [], fs, fs);     
    [Pb, fb] = pwelch(EEG_baseline_data(in_no, :)/ss, hanning(fs), [], fs, fs);
    figure; 
    subplot(3, 1, [1 2])
    semilogy(f1, P1, 'linewidth', 2)
    hold on     
    semilogy(fb, Pb, 'r', 'linewidth', 2)
    set(gca, 'fontsize', 18)
    ylabel('Power [dB]')
    xlabel('Frequency [Hz]')
    title('EEG')
    grid on
    legend(truth.dataset, 'Baseline')
    axis tight
    xlim([0 45])
    export_fig(['figures/' dataset_string '/truth/dataset' num2str(idata) '/EEG_psd'], '-r150', '-a2');
    
    % plot svd spectrum
    P1 = svd(EEG_data);      
    Pb = svd(EEG_baseline_data);
    figure; subplot(3, 1, [1 2])
    plot(P1, 'linewidth', 2)
    hold on    
    plot(Pb, 'r', 'linewidth', 2)
    set(gca, 'fontsize', 18)
    ylabel('Singular value')
    xlabel('Data component')
    title('EEG')
    grid on
    legend(truth.dataset, 'Baseline')
    axis tight
    export_fig(['figures/' dataset_string '/truth/dataset' num2str(idata) '/EEG_svd'], '-r150', '-a2');

    % plot normalize time series
    figure; subplot(2, 1, 1)
    ss = std(EEG_data(in_no, 1:1000));
    plot((1:1000)/100, 10 + EEG_data(in_no, 1:1000)/ss)
    hold on     
    plot((1:1000)/100, EEG_baseline_data(in_no, 1:1000)/ss, 'r')
    set(gca, 'fontsize', 10, 'ytick', [])
    xlabel('Time [s]')
    ylabel('Voltage [AU]')
    title('EEG')
    grid on
    legend(truth.dataset, 'Baseline')
    axis tight
    export_fig(['figures/' dataset_string '/truth/dataset' num2str(idata) '/EEG_timeseries'], '-r150', '-a2');

    
    % plot power spectrum
    no = sqrt(sum(MEG_data.^2, 2));
    [~, in_no] = max(no);
    ss = std(MEG_data(in_no, :));
    [P1, f1] = pwelch(MEG_data(in_no, :)/ss, hanning(fs), [], fs, fs);     
    [Pb, fb] = pwelch(MEG_baseline_data(in_no, :)/ss, hanning(fs), [], fs, fs);
    figure; 
    subplot(3, 1, [1 2])
    semilogy(f1, P1, 'linewidth', 2)
    hold on     
    semilogy(fb, Pb, 'r', 'linewidth', 2)
    set(gca, 'fontsize', 18)
    ylabel('Power [dB]')
    xlabel('Frequency [Hz]')
    title('MEG')
    grid on
    legend(truth.dataset, 'Baseline')
    axis tight
    xlim([0 45])
    export_fig(['figures/' dataset_string '/truth/dataset' num2str(idata) '/MEG_psd'], '-r150', '-a2');

    % plot svd spectrum
    P1 = svd(MEG_data);      
    Pb = svd(MEG_baseline_data);
    figure; subplot(3, 1, [1 2])
    plot(P1, 'linewidth', 2)
    hold on    
    plot(Pb, 'r', 'linewidth', 2)
    set(gca, 'fontsize', 18)
    ylabel('Singular value')
    xlabel('Data component')
    title('MEG')
    grid on
    legend(truth.dataset, 'Baseline')
    axis tight
    export_fig(['figures/' dataset_string '/truth/dataset' num2str(idata) '/MEG_svd'], '-r150', '-a2');
    
    % plot normalize time series
    figure; subplot(2, 1, 1)
    ss = std(MEG_data(in_no, 1:1000));
    plot((1:1000)/100, 10 + MEG_data(in_no, 1:1000)/ss)
    hold on     
    plot((1:1000)/100, MEG_baseline_data(in_no, 1:1000)/ss, 'r')
    set(gca, 'fontsize', 10, 'ytick', [])
    xlabel('Time [s]')
    ylabel('Voltage [AU]')
    title('MEG')
    grid on
    legend(truth.dataset, 'Baseline')
    axis tight
    export_fig(['figures/' dataset_string '/truth/dataset' num2str(idata) '/EEG_timeseries'], '-r150', '-a2');

    
    close all

  end

  %% some renaming
  if truth.interaction==1
      truth.sources=truth.sources_int; 
  else
      truth.sources=truth.sources_nonint;
  end
  truth = rmfield(truth, 'sources_nonint');
  truth = rmfield(truth, 'sources_int');
  truth.sensor_noise=sensor_noise;  
  % save data  
  save([home '/Documents/bb/data/' dataset_string '/EEG/dataset_' num2str(idata) '/data'], 'EEG_data', 'EEG_baseline_data', 'fs');
%   save(['data/' dataset_string '/MEG/dataset_' num2str(idata) '/data'], 'MEG_data', 'MEG_baseline_data', 'fs');
  save([home '/Documents/bb/data/' dataset_string '/truth/dataset_' num2str(idata) '/truth'], 'truth');
  
end
  
end

