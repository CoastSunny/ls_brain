function [SNR Pr Noise] = SNR_calculation(cir,distance,lambda,Type_Environment,d_0,sigma,Num_sensors,Time_samples,Pt,NF,n,BW,layoutpar)

            % Calculate the large scale path loss for each link (because wim.m is not
            % doing it). 

            % This option for the simplest calculation using the Friis formula

            FSL1 = 20.*log10(4.*pi.*distance./lambda);     % In dB

            % This option for a more empirical approximation for indoor and
            % outdoor channels. It sets a determined fixed distance d_0 and
            % then calculates the Friis formula (FSL) at d_0 + an empirical
            % path loss (EPL)



%             if Type_Environment==0
%                 n = 3;              % Urban is between 2.7 and 3.5
%                 d_0 = 200;          % Outdoor is between 100m to 1km
%             else
%                 n = 2;              % This is for free space (LOS) which it is assumed for rural
%                 d_0 = 1000;         % Outdoor is between 100m to 1km
%             end

            FSL2 = 20.*log10(4.*pi.*d_0./lambda);     % In dB

            EPL = n.*10.*log10(distance./d_0);            % In dB

            % Total path loss

            PL1 = FSL1;

            PL2 = FSL2 + EPL;

            % Now calculate the random distributed fading by getting a random
            % value of shadowing that follows normal disribution with mean=0
            % and sigma (empirically obtianed, sigma can be between 6 and 12 dB).

            %sigma = 9;
%             SHD = normrnd(0,sigma,[Num_sensors 1]);
            d0=1;
            pos=[layoutpar.Stations.Pos];
            pos=pos(:,2:end);
            for i=1:Num_sensors
                for j=1:Num_sensors
                    
                    D(i,j)=norm(pos(:,i)-pos(:,j));
                    
                end
            end
            
            SHD=mvnrnd(zeros(1,Num_sensors),sigma^2*exp(-D/d0)).';
            %SHD = 0;

            % Calculate received power of the multipath components for each link at
            % each time sample. Small scale "losses".

            % Initialise matrix CIR where the squared coefficients of the channel
            % responser are stored. To have the same structure, CIR is just equal to
            % cir.
            CIR = cir;

            % Initialise the matrix where the addition of all the squared coefficients
            % of the channel respones (taps) are added for each time sample (ii) 
            % and sensor (i).
            MP = zeros(Num_sensors,Time_samples);

            for i=1:1:Num_sensors 
%                 % For each link between sensor (i) and target, we calculate the module
%                 % of each tap component
%                 CIR{i,1}=abs(cir{i,1}).^2;
%                 
% 
%                 % Check if there is any NaN values in CIR
%                 CIR{i,1}(isnan(CIR{i,1}))=0;
% 
%                 % Then, for each time sample, we add all the squared coefficients
%                 % ("power ratio coefficients")
%                 for ii=1:1:Time_samples
%                     MP(i,ii) = 10.*log10(sum(CIR{i,1}(:,:,:,ii)));
%                 end
                    
                  % This is to first add the taps together for each sensor
                  % and time sample, and then obtain their power
                  CIR{i,1}=cir{i,1};
                  CIR{i,1}(isnan(CIR{i,1}))=0;
                  for ii=1:1:Time_samples
                     MP(i,ii) = sum(CIR{i,1}(1,:,:,ii));    % Now, it only takes the taps from antenna element 1. If we want/need to take the others for any reason, we have to change this part of the code
%                      MP(i,ii) = MP(i,ii)./size(CIR{i,1}(1,:,:,ii),3);
                  end
            end
            
            % Then, for the added taps, then calculate the power and
            % convert to dB
            
            MP = (abs(MP)).^2;
            MP = 10.*log10(MP);

            % Calculating the total power received considering free space (FSL),
            % shadowing (SHD) and multipath propagation (MP).
            
%             P_target = 0.00005;     % In W
%             P_target = -43;     % In dBW

%             Pt = 10*log10(P_target);        % In dBW. Target powers if the target is: BST=40W, WIFI 
%                                           % user=50mW and LTE user=100mW.

            % Initizalise the matrix Pr for each sensor and time sample
            Pr = zeros(Num_sensors,Time_samples);

            for ii=1:1:Time_samples
                Pr(:,ii) = Pt - PL1 - SHD + MP(:,ii);      % For each sensor and time sample calculates the received power. Here we can choose what path loss model we want by changing PL1 to PL2
%                Pr(:,ii) = MP(:,1);                          % This option is for when the winner channel function already calculates the pathloss and shadowing so the multipath components are already the power received.
%                Pr(:,ii) = Pt - PL1;           % This option is to calculate a deterministic Pr. Used for the calibration analysis
%                Pr(:,ii) = Pt - PL1 - SHD;     % This option is to calculate a Pr considering only shadowing as a random factor. For the calibration analysis.
            end

            % Calculate the Noise

            Kb = 1.38064852e-23;    % Boltzmann constant in  J/K
            T = 295;                % Temeprature in K
%             BW = 20e6;              % Signal bandwidth in Hz. Up to 20MHz.
%             NF = 3.5;               % Noise figure of the RF receiver in dB

            Noise = 10*log10(Kb*T*BW)+NF;    

            % Calculate the SNR
            % Initialise the matrix SNR for each sensor and time sample
            SNR = zeros(Num_sensors,Time_samples);

            for ii=1:1:Time_samples
                SNR(:,ii) = Pr(:,ii) - Noise;
            end
            Noise=repmat(Noise,size(Pr,1),1);
end