function EEG_estimate_lcmv_imcoh_psi(ndatasets, dataset_string)
% Stefan Haufe, 2014-16
% stefan.haufe@tu-berlin.de
%
% Arne Ewald, 2015, mail@aewald.net
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


%% settings

mfname = 'EEG_lcmv_imcoh_psi';

plotting = 0;

% band of interest in HZ
bandpass=[8 13];

% to estimate the cross-spectrum
fs=100;                     % sampling frequency
segleng=fs;                 % length of each segment to estimate the FFT
epleng=2*fs;                % length of one epoch (can be ignored here: only important for event-related analysis)
segshift=segleng/2;         % shift of each segment. segleng/2 leads to 50% overlap of segments
maxfreqbin=(segleng/2)+1;   % maximum frequency bin to estimate.

para=[];
para.segave = 1; % average over segments ?
para.subave = 0; % subtract average ?


%%

load('data/sa')
load('data/miscdata')


L=sa.cortex75K.EEG_V_fem(:, sa.cortex2K.in_from_cortex75K, :);

grid=sa.cortex75K.vc(sa.cortex2K.in_from_cortex75K, :);

all_est = {};

for idata = 1:ndatasets
    
    disp(['processing dataset ' num2str(idata) '/' num2str(ndatasets)])
    
    load(['data/' dataset_string '/EEG/dataset_' num2str(idata) '/data']);

    %% cross-spectrum and coherency on sensor level
    % data
    data=EEG_data';
    [cs, coh, nave]=data2cs_event(data, segleng, segshift, epleng, maxfreqbin, para);
    [nch,nch,nf]=size(cs);
    
    % baseline
    [csb, cohb, ~]=data2cs_event(EEG_baseline_data', segleng, segshift, epleng, maxfreqbin, para);
    
    % band of interest in bin
    boib=bandpass+1;
    
    % estimate SNR in band of interest
    pob=zeros(nf,1); % power baseline
    pod=zeros(nf,1); % power data
    mimcoh=zeros(nf,1); % maximum imcoh
    for ff=1:nf
        pob(ff)=mean(diag(squeeze(csb(:,:,ff))));
        pod(ff)=mean(diag(squeeze(cs(:,:,ff))));
        mimcoh(ff)=max(max(abs(imag(coh(:,:,ff)))));
    end
    
    % estimate of SNR in frequency band of interest
    snr_est=max(pod(boib(1):boib(2)))/mean(pob(boib(1):boib(2)));
    
    
    max_imcoh_data=abs(max(max(max(imag(coh(:,:,boib(1):boib(2)))))));
    max_imcoh_noise=abs(max(max(max(imag(cohb(:,:,boib(1):boib(2)))))));
   
    % real/imag. part of the cross-spectrum at a single frequency bin (or a mean)
    % data
    rcs1f=mean(real(cs(:,:,boib(1):boib(2))),3);
    % baseline
    rcs1f_bs=mean(real(csb(:,:,boib(1):boib(2))),3);
    
    %% Beamforming
    
    % band of interest, in which interaction takes place
    [~, A1, po]=mkfilt_lcmv(L,rcs1f);

    % resulting in
    %
    %         A1 : 1-dimensional filter along direction with strongest power (channels x voxels)
    %         po : Mx1 vector for M voxels, po(i) is the power at the i.th voxel along
    %              stronges direction (voxels x 1)
    
    % power of baseline data on source level
    [~, ~, pox]=mkfilt_lcmv(L,rcs1f_bs);

    % Power contrast data/baseline on source level
    P = po./pox;
    clear po pox
    
    %% finding the two ROIs with highest power
    
    % power in each ROI
    for iroi = 1:length(inds_roi_outer_2K)
        po(iroi) = sum(P(inds_roi_outer_2K{iroi}));
    end
    
    % sort
    [so, in_] = sort(po, 'descend');
    
    % take the two ROIs containing the most signal power
    in_roi = in_(1:2);
    
    
    %% find the two voxels with maximum power in each of the two ROIs
    
    [~,im]=max(P(sa.cortex2K.roi_mask==in_roi(1)));
    proi1i=inds_roi_outer_2K{in_roi(1)}(im);
    
    [~,im]=max(P(sa.cortex2K.roi_mask==in_roi(2)));
    proi2i=inds_roi_outer_2K{in_roi(2)}(im);
      
    %% Connectivity in source space
    % project data to source space
    % and do a connectivity analysis between the two estimated source voxels
    % plus a Jackknife statistics
    
    freq_inds = (bandpass(1)+1):(bandpass(2)+1);
    
    % time-series for the two voxels with highest signal power
    mdats=data*A1(:,[proi1i proi2i]);

    
    % Estimating the information flow between the time-series at voxels with high power
    % by using the Phase-Slope-Index (PSI)
    [psi1, stdpsi1] = data2psi2(mdats, fs, 4*fs, freq_inds, 1, 2);
    % z-scores
    z1 = psi1./stdpsi1;
    % p-values
    p1 = 2*normcdf(-abs(z1));
    
    % if there is a significant interaction
    if p1 < 0.01
        psi_sig = z1(1);
    else
        psi_sig = 0;
    end
    
    %% define the estimated localization and connectivity
    
    est=[];
    if snr_est > 1.5
        est.rois = rois(in_roi);
    end
    
    % if ImCoh exeeds the noise ImCoh
    if (max_imcoh_data-max_imcoh_noise) > 0.1
        est.interaction = 1;
        % if there is a significant PSI
        if (psi_sig~=0)
            % if there is a significant PSI
            % define sender
            if psi_sig > 0
                est.sender = 1;
            else
                est.sender = 2;
            end
        end
    else
        % if there is no significant interaction
        est.interaction = 0;
    end
    
%     % save predictions
%     save(['data/' dataset_string '/EEG/dataset_' num2str(idata) '/est_' mfname], 'est')
    
    all_est{idata} = est;
    
    try
      % load ground truth and evaluate predictions
      load(['data/' dataset_string '/truth/dataset_' num2str(idata) '/truth']);
      res(idata) = evaluate_performance(truth, est);

      clc
      fprintf('\nresults for %s', mfname);
      fprintf('\nlocalization:\t\t\t%.2f (SE %.2f)',  mean([res(:).loc]), std([res(:).loc])/sqrt(idata));
      fprintf('\nconnectivity presence: \t%.2f (SE %.2f)', mean([res(:).conn]), std([res(:).conn])/sqrt(idata));
      fprintf('\ndirectionality: \t\t%.2f (SE %.2f)\n', mean([res(:).dir]), std([res(:).dir])/sqrt(idata));

      save(['data/' dataset_string '/results_' mfname], 'res')
    catch
      fprintf('No ground truth given. Skipping evaluation.\n');
    end
    
    %% Plot
    
    if plotting
        
        sh = filesep;
        dir = ['figures' sh dataset_string sh 'truth' sh 'dataset' num2str(idata) sh];
        
        if ~exist (dir, 'dir')
            mkdir (dir)
        end
        
        % Plot log(power) for data and baseline
        figure;
        plot(log(pob),'-g');
        hold on;
        plot(log(pod));
        legend('baseline','data');
        xlabel('Frequency (Hz)');
        ylabel('log(Power)');
        title('EEG')
        export_fig(['figures/' dataset_string '/truth/dataset' num2str(idata) '/power'], '-r150', '-a2');
        
        % Plot ImCoh & GIM
        figure;
        hp=plot(reshape(imag(permute(coh(:,:,1:maxfreqbin),[3 2 1])),maxfreqbin, nch*nch));
        hold on
        line([bandpass(1)+1 bandpass(1)+1],get(gca,'YLim'),'Color',[0 1 0], 'LineStyle', '--');
        line([bandpass(2)+1 bandpass(2)+1],get(gca,'YLim'),'Color',[0 1 0], 'LineStyle', '--');
        hold off
        %setting the x axis label such that it corresponds to Hz
        label_step=5;
        set(gca,'XTick',1:label_step:maxfreqbin);
        set(gca,'XTickLabel',(0: label_step :maxfreqbin));
        xlabel('Frequency (Hz)');
        ylabel('ImCoh');
        title('EEG')
        export_fig(['figures/' dataset_string '/truth/dataset' num2str(idata) '/ImCoh'], '-r150', '-a2');

        
        %       plot true sources
        load('tools/cm17')
        
        sourceamp = sum(truth.source_amp, 2);
        ma = max(sourceamp);
        
        allplots_cortex(sa, sourceamp(sa.cortex2K.in_to_cortex75K_geod), ...
            [0 ma], cm17a, 'A.U.', 1, ['figures/' dataset_string '/truth/dataset' num2str(idata) '/sources'], ...
            {sa.cortex75K.vc_smooth(sa.cortex2K.in_from_cortex75K(truth.in_centers), :)}, struct('mymarkersize', 15, 'dipnames', {{{'d_1', 'd_2'}}}));
        
        
        allplots_cortex(sa, sqrt(P(sa.cortex2K.in_to_cortex75K_geod)), ...
            [min(sqrt(P)) max(sqrt(P))], cm17a, 'A.U.', 1, ['figures/' dataset_string '/' mfname '/dataset' num2str(idata) '/sources'], ...
            {sa.cortex75K.vc_smooth(sa.cortex2K.in_from_cortex75K(truth.in_centers), :)}, struct('mymarkersize', 15, 'dipnames', {{{'d_1', 'd_2'}}}));
        
        
        if est.interaction == 1
            % data in source space
            mdats=data*A1;
            [psi, stdpsi] = data2psi2(mdats, fs, 4*fs, freq_inds, proi1i, 1:size(mdats,2));
            
            z = psi ./ (stdpsi + eps);
            z(abs(z) < 1.96) = 0;
            z=z';
            
            % plot connectivity
            ma = max(abs(z(:)));
            allplots_cortex(sa, -z(sa.cortex2K.in_to_cortex75K_geod, 1), ...
                [-ma ma], cm17, 'z', 1, ['figures/' dataset_string '/' mfname '/dataset' num2str(idata) '/psi1'], ...
                {sa.cortex75K.vc_smooth(sa.cortex2K.in_from_cortex75K(truth.in_centers), :)}, struct('mymarkersize', 15, 'dipnames', {{{'d_1', 'd_2'}}}));
            
            [psi, stdpsi] = data2psi2(mdats, fs, 4*fs, freq_inds, proi2i, 1:size(mdats,2) );
            
            z = psi ./ (stdpsi + eps);
            z(abs(z) < 1.96) = 0;
            z=z';
            
            allplots_cortex(sa, -z(sa.cortex2K.in_to_cortex75K_geod, 1), ...
                [-ma ma], cm17, 'z', 1, ['figures/' dataset_string '/' mfname '/dataset' num2str(idata) '/psi2'], ...
                {sa.cortex75K.vc_smooth(sa.cortex2K.in_from_cortex75K(truth.in_centers), :)}, struct('mymarkersize', 15, 'dipnames', {{{'d_1', 'd_2'}}}));
            
        end
        close all
        
    end % of plotting
    
end   % dataset

% save predictions
save(['data/' dataset_string '/all_est_' mfname], 'all_est')

end  % of function
