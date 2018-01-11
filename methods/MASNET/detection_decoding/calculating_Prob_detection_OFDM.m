function [Pd] = calculating_Prob_detection_OFDM(AC_sample,Td,Tc,snr,Pfa)
% S. Chaudhari, V. Koivunen, and H. V. Poor, “Autocorrelation-based decentralized se-
% quential detection of OFDM signals in cognitive radios,” IEEE Transactions on Signal
% Processing, vol. 57, no. 7, pp. 2690–2700, 2009.

            Tc = 144;       % # of samples in the cyclic prefix (CP) for OFDM
            Td = 2048;      % Number of samples of data in the LTE trace
             
            AC_sample = 6;
            M = AC_sample*(2*Td+Tc);    % Autocorrelation size
 
            rho = (Tc/(Td+Tc)).*(snr./(1+snr));       

            eta = (1/sqrt(M))*(erfcinv(2*Pfa));

            Pd = (1/2).*erfc(sqrt(M).*((eta-rho)./(1-rho.^2)));

end
