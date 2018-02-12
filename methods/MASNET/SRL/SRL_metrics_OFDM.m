function metrics_OFDM(fl)


if isunix==0
    pth='C:\masnet\'
else
    pth='~/Documents/ls_brain/results/masnet/SRL/';
end

if nargin<1
    cd([pth 'snr/'])
    uiopen;
else
    load(fl)
end
parsecfg
% Speed of light, wavelength
c = 3e8;
lambda = c/Fc;
S_=cfg.Num_sensors;
%% Here we calculate the probabilities of detection and BER but focused on the sensors. The idea is to be able to represent heat maps for each sensor position to determine the best placements for sensors
ALL_snr = 10.^(ALL_SNR./10);
ALL_Pr = 10.^(ALL_Pr./10);
ALL_noise = 10.^(ALL_Noise./10);

pfa=0.01:0.01:0.1;
for pfa_idx=1:numel(pfa)
    
    p_all(:,:,:,:,pfa_idx) = calculating_Prob_detection_v2(AC_sample,Td,Tc,ALL_snr(:,:,:,:,:),pfa(pfa_idx));
    p_mean(:,:,:,:,pfa_idx)= calculating_Prob_detection_v2(AC_sample,Td,Tc,mean(ALL_snr(:,:,:,:),4),pfa(pfa_idx));
    p_sum(:,:,:,:,pfa_idx) = calculating_Prob_detection_v2(AC_sample,Td,Tc,sum(ALL_snr(:,:,:,:),4),pfa(pfa_idx));
        
end

% 
% for k=1:numel(target_x)
%     for m=1:numel(target_y)
%         target=[target_x(k), target_y(m), target_z];
%         sensors=[layoutpar.Stations(idx+1).Pos]';
%         [cr tmp]=crlb(target,sensors,loc_sigma);
%         acc(k,m)=tmp;
%     end
% end

filetosave = [ pth 'probs/' 'Pr_ofdm_' filename '_Time_' num2str(Time_samples)...
    '_TS_' num2str(Type_Scenario)...
    '_TE_' num2str(Type_Environment)...
    '_Num_Sensors_' num2str(Num_sensors)...
    '_Pt_' num2str(Pt)...
    'dBW_sigma_' num2str(sigm) 'dB.mat'];
%filename3 = ['~/Documents/projects/ls_brain/results/masnet/probs/test.mat'];
save(filetosave,'p_all','p_mean','ALL_snr');

end