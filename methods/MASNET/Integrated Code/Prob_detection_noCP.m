function [Pd] = Prob_detection_noCP(ps,pn,Pfa)

% ps: signal power
% pn: noise power
% Pfa: probability of false alarm
% Pd: probability of detection
			
df=2; % degrees of freedom, 2 for 1 sample detection
ned=inv(chi2cdf(1-Pfa,df)).*pn/2; % threshold for the specific Pfa
Pd=1-chi2cdf(2*ned./(ps+pn),2); % probability of detection

end

%Danev, D., Axell, E., & Larsson, E. G. (2010). Spectrum sensing methods for detection of DVB-T signals in AWGN and fading channels. IEEE %International Symposium on Personal, Indoor and Mobile Radio Communications, PIMRC, (1), 2721–2726. doi:10.1109/PIMRC.2010.5671804
