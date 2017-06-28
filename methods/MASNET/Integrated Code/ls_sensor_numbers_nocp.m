function ls_sensor_numbers_nocp(fl)


S_=96;      % Caution: This value might change
% This number of sensors helps to get the right
% number of sensors positioned later. For
% Separated: Num_sensors=76 if Sep_sensors=100 or
% Num_sensors=96 if Sep_sensors=78, for Mixed:
% Num_sensors=64 if Sep_sensors=250.
if nargin<1
    cd ~/Documents/projects/ls_brain/results/
    uiopen;
else
   load(fl) 
end

parsecfg
% Speed of light, wavelength
c = 3e8;
lambda = c/Fc;

%% Here we calculate the probabilities of detection and BER but focused on the sensors. The idea is to be able to represent heat maps for each sensor position to determine the best placements for sensors
ALL_snr = 10.^(ALL_SNR./10);
ALL_Pr = 10.^(ALL_Pr./10);
ALL_noise = 10.^(ALL_Noise./10);

pfa=0.01:0.01:0.1;
for pfa_idx=1:numel(pfa)
    
    for i=1:1:S_
        p_sep_d=[];p_div_d=[];p_best_d=[];
        for j=1:96
            
            idx = randperm(S_,i);
            p_sep = calculating_Prob_detection_No_CP(...
                ALL_Pr(:,:,:,idx),ALL_noise(:,:,:,idx),pfa(pfa_idx));                      
            p_div = calculating_Prob_detection_No_CP(...
                mean(ALL_Pr(:,:,:,idx),4),(ALL_noise(:,:,:,idx)),pfa(pfa_idx));
            p_best = calculating_Prob_detection_No_CP(...
                sum(ALL_Pr(:,:,:,idx),4),(ALL_noise(:,:,:,idx)),pfa(pfa_idx));
            
            p_sep_d(j,:) = mean(mean(mean(p_sep,1),2),3);
            p_div_d(j,:) = mean(mean(mean(p_div)));
            p_best_d(j,:) = mean(mean(mean(p_best)));
   
%             if i>=4            
%                 snr_3best=getNbest(ALL_snr(:,:,:,idx),3);
%                 p_3best = calculating_Prob_detection_v2(AC_sample,Td,Tc,sum(snr_3best,4),pfa(pfa_idx));
%                 p_3best = calculating_Prob_detection_No_CP(...
%                 ALL_Pr(:,:,:,idx),ALL_noise(:,:,:,idx),pfa_idx);
%                 p_3best_d(j,:) = mean(mean(mean(p_3best)));
%             end
            
                
            
        end
        psep_d(i,pfa_idx)=mean(max(p_sep_d'))';
        pdiv_d(i,pfa_idx)=mean(mean(p_div_d));
        pbest_d(i,pfa_idx)=mean(mean(p_best_d));
%         if i>=4;p3best_d(i,pfa_idx)=mean(mean(p_3best_d));end;
    end
end

 filename3 = ['~/Documents/ls_brain/results/Probs_CORRSHD_NOCP_TS_' num2str(Type_Scenario)...
        '_TE_' num2str(Type_Environment) '_Num_Sensors_' num2str(S_) '_SepTar_' num2str(Int_target_x) '_' num2str(Int_target_y) '_Pt_' num2str(Pt) 'dBW_sigma_' num2str(sigm) 'dB.mat'];
 save(filename3,'psep_d','pdiv_d','pbest_d'); 


end