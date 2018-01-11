function [Pd] = calculating_Prob_detection_No_CP(ps,pn,Pfa)
% ps is the signal power
% pn is the noise power

             ned=inv(chi2cdf(1-Pfa,2)).*pn/2;    % threshold that achieves the target Pfa        
             Pd=1-chi2cdf(2*ned./(ps+pn),2); 	 %

end
