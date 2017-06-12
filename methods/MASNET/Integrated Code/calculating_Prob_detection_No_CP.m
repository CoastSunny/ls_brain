function [BN_Pd,BN_Pnd,NS_Pnd,OS_Pd,snr,Best_snr,BN_indx,BN_indx2] = calculating_Prob_detection_No_CP(SNR,Pr,Noise,Pfa,Num_sensors,Td)

%             Tc = 144;       % # of samples in the cyclic prefix (CP)
%             Td = 2048;      % Number of samples of data in the LTE trace
%             
%             AC_sample = 6;
            snr = 10.^(SNR./10);
            ps = 10.^(Pr./10);
            pn=10.^(Noise./10);
            
            ned=inv(chi2cdf(1-Pfa,2)).*pn/2;
            
            Pd=1-chi2cdf(2*ned./(ps+pn),2);



            % Calculating the probability of the best node (BN) to detect and not detect
            % (with the highest SNR) (Option 1)

            [BN_SNR,BN_indx] = max(SNR);
            [BN_SNR,BN_indx2] = max(BN_SNR);
            
            % Save the best snr for this target position and Montecarlo run
            
            Best_snr = snr(BN_indx(BN_indx2));

            % Initialise a vector to store the probability of detection of the
            % best sensor for each time sample
            %bn_pd = zeros(Time_samples,1);

            % Store the Pd of the best node for each time sample

            bn_pd = Pd(BN_indx(BN_indx2),:);

            % Calculate the average probability along all the time samples for the best sensor
            Avg_Pd = mean(bn_pd);

            BN_Pd = Avg_Pd;

            BN_Pnd = 1 - BN_Pd;



            % Calculating the probability of no sensor (NS) detects and that at least one
            % sensor (OS) detects (Option 2)

            % Calculate the average probability along the time samples of detection for each sensor
            Avg_Pd = zeros(Num_sensors,1);

            for i=1:1:Num_sensors
                Avg_Pd(i) = mean(Pd(i,:));
            end

            NS_Pnd = prod(1-Avg_Pd);

            OS_Pd = 1 - NS_Pnd;
end