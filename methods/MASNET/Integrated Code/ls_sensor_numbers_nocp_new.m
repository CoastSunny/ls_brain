function ls_sensor_numbers(fl)


if nargin<1
    cd ~/Documents/projects/ls_brain/results/masnet/snr
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
    
    for i=1:1:S_
        
        for j=1:cfg.Num_sensors %number of perms
            
            idx = randperm(S_,i);
            p_all = calculating_Prob_detection_No_CP(AC_sample,Td,Tc,ALL_snr(:,:,:,idx,:),pfa(pfa_idx));
            p_mean = calculating_Prob_detection_No_CP(AC_sample,Td,Tc,mean(ALL_snr(:,:,:,idx,:),4),pfa(pfa_idx));
            p_sum= calculating_Prob_detection_No_CP(AC_sample,Td,Tc,sum(ALL_snr(:,:,:,idx,:),4),pfa(pfa_idx));

            % get average performance over all target locations and shadowing
            p_all_s(j,:) = mean(p_all(:)); 
            s_all_s(j,:) = std(p_all(:));
            % get average performance over all target locations but for the
            % best sensor in each case
            bsens          = max( p_all,[], 4 ); % get best sensor performance, (max over sensors)
            p_bsens_s(j,:) = mean(bsens(:));
            s_bsens_s(j,:) = std(bsens(:));
            p_mean_s(j,:)  = mean(p_mean(:)); % get average performance over sensors @@
            s_mean_s(j,:)  = std(p_mean(:));  % get average performance over sensors @@
            p_sum_s(j,:)   = mean(p_sum(:));  % get average performance over sensors @@
            s_sum_s(j,:)   = std(p_sum(:));   % get average performance over sensors @@
   
%             if i>=4            
%                 snr_3best=getNbest(ALL_snr(:,:,:,idx),3);
%                 p_3best = calculating_Prob_detection_v2(AC_sample,Td,Tc,sum(snr_3best,4),pfa(pfa_idx));
%                 p_3best = calculating_Prob_detection_No_CP(...
%                 ALL_Pr(:,:,:,idx),ALL_noise(:,:,:,idx),pfa_idx);
%                 p_3best_d(j,:) = mean(mean(mean(p_3best)));
%             end
            
                
            
        end
        
        pall_av(i,pfa_idx)=mean(p_all_s);
        pall_std(i,pfa_idx)=mean(s_all_s);
        pbsens_av(i,pfa_idx)=mean(p_bsens_s);
        pbsens_std(i,pfa_idx)=mean(s_bsens_s);
        pmean_av(i,pfa_idx)=mean(p_mean_s);
        pmean_std(i,pfa_idx)=mean(s_mean_s);
        psum_av(i,pfa_idx)=mean(p_sum_s);
        psum_std(i,pfa_idx)=mean(s_sum_s);
        
%         if i>=4;p3best_d(i,pfa_idx)=mean(mean(p_3best_d));end;
    end
end

filetosave = [ '~/Documents/projects/ls_brain/results/masnet/probs/' 'Pr_nocp' filename '_Time_' num2str(Time_samples)...
        '_TS_' num2str(Type_Scenario)...
        '_TE_' num2str(Type_Environment)...
        '_Num_Sensors_' num2str(Num_sensors)...
        '_Pt_' num2str(Pt)...
        'dBW_sigma_' num2str(sigm) 'dB.mat'];
 %filename3 = ['~/Documents/projects/ls_brain/results/masnet/probs/test.mat'];
 save(filetosave,'pall_av','pall_std','pmean_av','pmean_std','psum_av','psum_std','pbsens_av','pbsens_std'); 


end