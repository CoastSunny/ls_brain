function [Pd] = calculating_Prob_detection_update(AC_sample,Td,Tc,SNR,Pfa)

%             Tc = 144;       % # of samples in the cyclic prefix (CP)
%             Td = 2048;      % Number of samples of data in the LTE trace
%             
%             AC_sample = 6;

            M = AC_sample*(2*Td+Tc);    % Autocorrelation size

            snr = SNR; % linear SNR 
            
            
            rho = (Tc/(Td+Tc)).*(snr./(1+snr)); % the average of the test statistics


            eta = (1/sqrt(M))*erfcinv(2*Pfa); % threshold


            Pd = (1/2).*erfc(sqrt(M).*((eta-rho)./(1-rho.^2))); % closed form expression for probability of detection




end