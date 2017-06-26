function ls_sensor_numbers(fl)


S_=96;      % Caution: This value might change
% This number of sensors helps to get the right
% number of sensors positioned later. For
% Separated: Num_sensors=76 if Sep_sensors=100 or
% Num_sensors=96 if Sep_sensors=78, for Mixed:
% Num_sensors=64 if Sep_sensors=250.
if nargin<1
    cd ~/Documents/ls_brain/results/
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
        p_sep_d=[];p_div_d=[];p_opt_d=[];p_bsens_d=[];
        for j=1:96 %number of perms
            
            idx = randperm(S_,i);
            p_sep = calculating_Prob_detection_v2(AC_sample,Td,Tc,ALL_snr(:,:,:,idx),pfa(pfa_idx));
            p_div = calculating_Prob_detection_v2(AC_sample,Td,Tc,mean(ALL_snr(:,:,:,idx),4),pfa(pfa_idx));
            p_opt= calculating_Prob_detection_v2(AC_sample,Td,Tc,sum(ALL_snr(:,:,:,idx),4),pfa(pfa_idx));
%             p_sep = calculating_Prob_detection_No_CP(...
%                 ALL_Pr(:,:,:,idx),ALL_noise(:,:,:,idx),pfa(pfa_idx));                      
%             p_div = calculating_Prob_detection_No_CP(...
%                 sum(ALL_Pr(:,:,:,idx),4),(ALL_noise(:,:,:,idx)),pfa(pfa_idx));
            p_sep_d(j,:) = mean(mean(mean(p_sep,1),2),3);
            p_bsens_d(j,:) = mean(mean(max(mean(p_sep,3),[],4)));
            p_div_d(j,:) = mean(mean(mean(p_div)));
            p_opt_d(j,:) = mean(mean(mean(p_opt)));
   
%             if i>=4            
%                 snr_3best=getNbest(ALL_snr(:,:,:,idx),3);
%                 p_3best = calculating_Prob_detection_v2(AC_sample,Td,Tc,sum(snr_3best,4),pfa(pfa_idx));
%                 p_3best = calculating_Prob_detection_No_CP(...
%                 ALL_Pr(:,:,:,idx),ALL_noise(:,:,:,idx),pfa_idx);
%                 p_3best_d(j,:) = mean(mean(mean(p_3best)));
%             end
            
                
            
        end
        psep_d(i,pfa_idx)=mean(max(p_sep_d,[],2))';
        pdiv_d(i,pfa_idx)=mean(mean(p_div_d));
        popt_d(i,pfa_idx)=mean(mean(p_opt_d));
        pbsens_d(i,pfa_idx)=mean(p_bsens_d);
%         if i>=4;p3best_d(i,pfa_idx)=mean(mean(p_3best_d));end;
    end
end

 filename3 = ['~/Documents/ls_brain/results/Probs_CORRSHD_TS_' num2str(Type_Scenario)...
        '_TE_' num2str(Type_Environment) '_Num_Sensors_' num2str(S_) '_SepTar_' num2str(Int_target_x) '_' num2str(Int_target_y) '_Pt_' num2str(Pt) 'dBW_sigma_' num2str(sigm) 'dB.mat'];
 save(filename3,'psep_d','pdiv_d','popt_d','pbsens_d'); 


end