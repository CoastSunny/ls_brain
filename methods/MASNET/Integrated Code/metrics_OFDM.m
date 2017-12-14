function metrics_OFDM(fl)


if isunix==0
    pth='C:\Users\Loukianos\Documents\MATLAB\ls_brain\results\masnet\'
else
    pth='~/Documents/ls_brain/results/masnet/';
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
    
    for i=1:1:S_ % loops through the number of sensors so that we get results for 1,2,3,...S_ sensors
        
        for j=1:S_ %for each i in the loop above, we pick S_ random selections of i sensors (S choose i). 
            %We do that in order to evaluate the performance over many possibilitis of sensor locations.
            
            idx = randperm(S_,i); %
            p_all = calculating_Prob_detection_v2(AC_sample,Td,Tc,ALL_snr(:,:,:,idx,:),pfa(pfa_idx));
            p_mean = calculating_Prob_detection_v2(AC_sample,Td,Tc,mean(ALL_snr(:,:,:,idx,:),4),pfa(pfa_idx));
            p_sum= calculating_Prob_detection_v2(AC_sample,Td,Tc,sum(ALL_snr(:,:,:,idx,:),4),pfa(pfa_idx));
           

            % get average performance over all target locations and shadowing
            p_all_s(j,:) = mean(p_all(:)); 
            % compute std of the previous 
            s_all_s(j,:) = std(p_all(:));
            
            % get best sensor performance for each location, (max over sensors)          
            bsens          = max( p_all,[], 4 );
            % average the best sensor performance over all target locations and MC runs
            p_bsens_s(j,:) = mean(bsens(:));    
            % median best sensor performance over all locations and MC runs
            md_bsens_s(j,:) = median(bsens(:));  
            % 25% and 75% quantiles of the best sensor
            q_bsens_s(j,:) = quantile(bsens(:),[0.25 0.75]); 
            % std of the best sensor over all locations and MC runs
            s_bsens_s(j,:) = std(bsens(:));
            % get the MC std only, ignores std over locations
            noloc_bsens=mean(mean(bsens,1),2);
            % get the median 
            md_bsens_noloc(j,:) = median(noloc_bsens);
            % get the std
            s_bsens_noloc(j,:) = std(noloc_bsens);
            % get the quantiles when ignoring location variance
            q_bsens_noloc(j,:) = quantile(noloc_bsens,[0.25 0.75]);
            % average performance for the fusion method which averages the
            % SNR of the sensors
            p_mean_s(j,:)  = mean(p_mean(:)); 
            % get the std
            s_mean_s(j,:)  = std(p_mean(:));  
            % get the average performance of the optimal method which sums
            % the SNRs of the sensors
            p_sum_s(j,:)   = mean(p_sum(:));  
            % get the std
            s_sum_s(j,:)   = std(p_sum(:));   
            % get the 90% POI confidence, i.e. the ratio of the cases that
            % exceeded Pd=90% to the total number of cases
            p_bsens_s_old(j,:) = sum(bsens(:)==.9)/numel(bsens(:));
            
            [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(ALL_snr(:,:,:,idx,:)); 
            b_bpsk=min(Pe_BPSK,[],4);
            b_qpsk=min(Pe_QPSK,[],4);
            b_4am=min(Pe_4AM,[],4);
            b_8am=min(Pe_8AM,[],4);
            eb_bpsk_s(j,:) = mean(b_bpsk(:));  
            q_bpsk_s(j,:) = quantile(b_bpsk(:),[0.25 0.75]);
            seb_bpsk_s(j,:) = std(b_bpsk(:));
            eb_qpsk_s(j,:) = mean(b_qpsk(:));   
            q_qpsk_s(j,:) = quantile(b_qpsk(:),[0.25 0.75]);
            seb_qpsk_s(j,:) = std(b_qpsk(:));
            eb_4am_s(j,:) = mean(b_4am(:));  
            q_4am_s(j,:) = quantile(b_4am(:),[0.25 0.75]);
            seb_4am_s(j,:) = std(b_4am(:));
            eb_8am_s(j,:) = mean(b_8am(:));  
            q_8am_s(j,:) = quantile(b_8am(:),[0.25 0.75]);
            seb_8am_s(j,:) = std(b_8am(:));
            
        end
        
        pall_av(i,pfa_idx)=mean(p_all_s);
        pall_std(i,pfa_idx)=mean(s_all_s);
        pbsens_av(i,pfa_idx)=mean(p_bsens_s);
        pbsens_md(i,pfa_idx)=mean(md_bsens_s);
        pbsens_q(i,pfa_idx,:)=mean(q_bsens_s);
        pbsens_av_old(i,pfa_idx)=mean(p_bsens_s_old);
        pbsens_std(i,pfa_idx)=mean(s_bsens_s);
        pbsens_md_noloc(i,pfa_idx)=mean(md_bsens_noloc);
        pbsens_noloc_std(i,pfa_idx)=mean(s_bsens_noloc);
        pbsens_q_noloc(i,pfa_idx,:)=mean(q_bsens_noloc);
        pmean_av(i,pfa_idx)=mean(p_mean_s);
        pmean_std(i,pfa_idx)=mean(s_mean_s);
        psum_av(i,pfa_idx)=mean(p_sum_s);
        psum_std(i,pfa_idx)=mean(s_sum_s);
        
        eb_bpsk_av(i,pfa_idx)=mean(eb_bpsk_s);
        eb_bpsk_q(i,pfa_idx,:)=mean(q_bpsk_s);
        eb_bpsk_std(i,pfa_idx)=mean(seb_bpsk_s);
        eb_qpsk_av(i,pfa_idx)=mean(eb_qpsk_s);
        eb_qpsk_q(i,pfa_idx,:)=mean(q_qpsk_s);
        eb_qpsk_std(i,pfa_idx)=mean(seb_bpsk_s);
        eb_4am_av(i,pfa_idx)=mean(eb_4am_s);
        eb_4am_q(i,pfa_idx,:)=mean(q_4am_s);
        eb_4am_std(i,pfa_idx)=mean(seb_4am_s);
        eb_8am_av(i,pfa_idx)=mean(eb_8am_s);
        eb_8am_q(i,pfa_idx,:)=mean(q_8am_s);
        eb_8am_std(i,pfa_idx)=mean(seb_8am_s);
                                
%         if i>=4;p3best_d(i,pfa_idx)=mean(mean(p_3best_d));end;
    end
end

filetosave = [ pth 'probs/' 'Pr_ofdm_' filename '_Time_' num2str(Time_samples)...
        '_TS_' num2str(Type_Scenario)...
        '_TE_' num2str(Type_Environment)...
        '_Num_Sensors_' num2str(Num_sensors)...
        '_Pt_' num2str(Pt)...
        'dBW_sigma_' num2str(sigm) 'dB.mat'];
 %filename3 = ['~/Documents/projects/ls_brain/results/masnet/probs/test.mat'];
 save(filetosave,'pall_av','pall_std','pmean_av','pmean_std','psum_av','psum_std'...
     ,'pbsens_av','pbsens_std','pbsens_noloc_std','pbsens_av_old'...
     ,'pbsens_md','pbsens_md_noloc','pbsens_q','pbsens_q_noloc'...
     ,'eb_bpsk_av','eb_qpsk_av','eb_4am_av','eb_8am_av'...
     ,'eb_bpsk_std','eb_qpsk_std','eb_4am_std','eb_8am_std'...
     ,'eb_bpsk_q', 'eb_qpsk_q', 'eb_4am_q', 'eb_8am_q'); 


end