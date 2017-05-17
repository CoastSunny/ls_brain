function [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(snr_)

            % Calculating the BER (Proakis) for BPSK for the best snr and
            % save it. Q(z)=(1/2)erfc(z/sqrt(2))
            
            Pe_BPSK = (1./2).*erfc(sqrt(2.*snr_)./sqrt(2));
            
            
            % Calculating the BER (Proakis) for QPSK for the best snr
            
            Pe_QPSK = (erfc(sqrt(2.*snr_)./sqrt(2))).*(1-(1./4).*(erfc(sqrt(2.*snr_)./sqrt(2))));
            
            
            % Calculating the BER (Alouini paper) for 4-PAM/QAM
            
            Pe_4AM = (3./8).*(erfc(sqrt(snr_./5))) + (1./4).*(erfc(3.*sqrt(snr_./5))) - (1./8).*(erfc(5.*sqrt(snr_./5)));
           
            
            % Calculating the BER (Alouini paper) for 8-PAM/QAM
            
            Pe_8AM = (7./24).*(erfc(sqrt(snr_./21))) + (1./4).*(erfc(3.*sqrt(snr_./21))) - (1./24).*(erfc(5.*sqrt(snr_./21))) + ...
                (1./24).*(erfc(9.*sqrt(snr_./21))) - (1./24).*(erfc(13.*sqrt(snr_./21)));
            
end