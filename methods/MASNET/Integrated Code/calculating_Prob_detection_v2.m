function [Pd] = calculating_Prob_detection_v2(AC_sample,Td,Tc,snr,Pfa)

%             Tc = 72;       % # of samples in the cyclic prefix (CP)
%             Td = 1210;      % Number of samples of data in the LTE trace
%             
%             AC_sample = 6;

            M = AC_sample*(2*Td+Tc);    % Autocorrelation size
 
            rho = (Tc/(Td+Tc)).*(snr./(1+snr)); 

%             Pfa = 0.1;      % Probability of false alarm

            %eta = (1/sqrt(M))*erfcinv(2*Pfa);

            eta = (1/sqrt(M))*(erfcinv(2*Pfa));

            Pd = (1/2).*erfc(sqrt(M).*((eta-rho)./(1-rho.^2)));

end