function [Pd] = calculating_Prob_detection_No_CP(ps,pn,Pfa)

%             Tc = 144;       % # of samples in the cyclic prefix (CP)
%             Td = 2048;      % Number of samples of data in the LTE trace
%             
%             AC_sample = 6;
            
            ned=inv(chi2cdf(1-Pfa,2)).*pn/2;
            
            Pd=1-chi2cdf(2*ned./(ps+pn),2);

end