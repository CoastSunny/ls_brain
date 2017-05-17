function [varargout] = autocorrdetV2(varargin)

% Implements the autocorrelation spectrum sensing detection algorithm on a communications signal.
%
% [decision] = autocorrdetV2(y, Pfa, T_d, 'algo_type')
% y is the input signal, Pfa is the probability of false alarm and T_d is
% the time period of data in samples (equivalent to FFT size). The string:
% 'algo_type' determines which type of algorithm to run.
%
% [decision, test_statistic, R] = autocorrdetV2(y, Pfa, T_d, 'algo_type')
% allows the user to see the test statistic and the full autocorrelation
% coeeficient, R, upon which the test statistic is based.
%


%% Inputs

switch nargin
    case 5
        y                   =   varargin{1};                            % Signal.
        Pfa                 =   varargin{2};                            % Probability of false alarm.
        T_d                 =   varargin{3};                            % Duration of data segment (FFT size).
        algo_type           =   varargin{4};                            % Type of algorithm to implement.
        WC_type             =   varargin{5};                            % String denoting worst case scenario, 'WC1', 'WC2', 'none'.
        
    case 9
        y                   =   varargin{1};                            % Signal.
        Pfa                 =   varargin{2};                            % Probability of false alarm.
        T_d                 =   varargin{3};                            % Duration of data segment (FFT size).
        algo_type           =   varargin{4};                            % Type of algorithm to implement.
        rho_LUT             =   varargin{5};                            % Look-up table of rho values.
        precision_factor    =   varargin{6};                            % A factor to scale Re and Im.                           
        phase_step          =   varargin{7};                            % Phase step.
        LUT_uni             =   varargin{8};                            % Look-up table of uniform distributed numbers.        
        WC_type             =   varargin{9};                            % String denoting worst case scenario, 'WC1', 'WC2', 'none'.

     case 10
        y                   =   varargin{1};                            % Signal.
        Pfa                 =   varargin{2};                            % Probability of false alarm.
        T_d                 =   varargin{3};                            % Duration of data segment (FFT size).
        algo_type           =   varargin{4};                            % Type of algorithm to implement.
        rho_LUT             =   varargin{5};                            % Look-up table of rho values.
        precision_factor    =   varargin{6};                            % A factor to scale Re and Im.                           
        phase_step          =   varargin{7};                            % Phase step.
        LUT_uni             =   varargin{8};                            % Look-up table of uniform distributed numbers.         
        WC_type             =   varargin{9};
        mu_noise            =   varargin{10};                           % The noise autocorrelation coefficient.
       
        
     case 11
        y                   =   varargin{1};                            % Signal.
        Pfa                 =   varargin{2};                            % Probability of false alarm.
        T_d                 =   varargin{3};                            % Duration of data segment (FFT size).
        algo_type           =   varargin{4};                            % Type of algorithm to implement.
        rho_LUT             =   varargin{5};                            % Look-up table of rho values.
        precision_factor    =   varargin{6};                            % A factor to scale Re and Im.                           
        phase_step          =   varargin{7};                            % Phase step.
        LUT_uni             =   varargin{8};                            % Look-up table of uniform distributed numbers.         
        WC_type             =   varargin{9};                           % String denoting worst case scenario, 'WC1', 'WC2', 'none'.
        mu_noise            =   varargin{10};                           % The noise autocorrelation coefficient.        
        var_noise           =   varargin{11};                           % Variance of real part of autocorrelation coefficient under Ho.        
        
end



%% Remove dc and obtain sample lengths.
% Ensure samples are in a row vector with mean of zero.

M = length(y) - T_d;
y = reshape(y,1,length(y));
y = y - mean(y);

diff_comp = (1/(sqrt(2*M))) + (j*(1/(sqrt(2*M))));
diff_rms = abs(diff_comp);
diff_rms_pow = diff_rms^2;
LUT_angle = angle(randn(1,1) + j*randn(1,1));


%% Test statistic & threshold for various implementations of the algorithm.
switch algo_type
    case 'Standard1'
        % Calculate the threshold.
        threshold = (1/sqrt(M))*erfcinv(2*Pfa);
        % Extract the data in appropriate shifts relative to Td.
        y_seg1 = y(1:end-T_d);
        y_seg2 = y(T_d+1:end);
        % Estimate autocorrelation based test statistic.
        p_upper = (1/(2*M))*(sum(real(y_seg1.*conj(y_seg2))));
        sigma_z = (1/(2*(M+T_d)))*sum(abs(y).^2);
        % Calculate the full (complex) autocorrelation coefficient.
        p_upper_full = (1/(2*M))*(sum(y_seg1.*conj(y_seg2)));
        R = p_upper_full/sigma_z; 
        
        % Worst case scenarios. 
            switch WC_type
                case 'WC1'
                    R_WC = R*exp(-1*j*angle(R));
                    rand_angle = -pi + (pi - (-1*pi)).*rand(1);
                    R_WC = R_WC*exp(j*rand_angle);
                    R = R_WC;
                case 'WC2'
                    R_WC = R*exp(-1*j*angle(R));
                    R_WC = R_WC*exp(j*-pi);
                    R_WC = R_WC*exp(j*LUT_angle);
                    R = R_WC;
                case 'none'   
            end
        
        test_statistic = real(R);
        
    case 'Standard2'
        %% Implement the standard algorithm.
        % Calculate the threshold.
        threshold = (var(y)/sqrt(M))*erfcinv(2*Pfa);
        % Extract the data in appropriate shifts relative to Td.
        y_seg1 = y(1:end-T_d);
        y_seg2 = y(T_d+1:end);
        % Estimate autocorrelation based test statistic.
        R = (1/M)*(sum(y_seg1.*conj(y_seg2)));        
        % Worst case scenarios. 
            switch WC_type
                case 'WC1'
                    R_WC = R*exp(-1*j*angle(R));
                    rand_angle = -pi + (pi - (-1*pi)).*rand(1);
                    R_WC = R_WC*exp(j*rand_angle);
                    R = R_WC;
                case 'WC2'
                    R_WC = R*exp(-1*j*angle(R));
                    R_WC = R_WC*exp(j*-pi);
                    R_WC = R_WC*exp(j*LUT_angle);
                    R = R_WC;
                case 'none'   
            end        
        
        test_statistic = real(R);
        
        
    case 'FO_Corrected1'
        
        % Calculate the threshold.
        switch nargin
            case 9
        threshold = (1/sqrt(M))*erfcinv(2*Pfa);
            case 10        
        threshold = (1/sqrt(M))*erfcinv(2*Pfa) + mu_noise;
            case 11        
        threshold = sqrt(2*var_noise)*erfcinv(2*Pfa) + mu_noise;
        end
        
        
        % Extract the data in appropriate shifts relative to Td.
        y_seg1 = y(1:end-T_d);
        y_seg2 = y(T_d+1:end);
        
        % Estimate autocorrelation based test statistic.
        p_upper = (1/(2*M))*(sum(real(y_seg1.*conj(y_seg2))));
        sigma_z = (1/(2*(M+T_d)))*sum(abs(y).^2);
        
        % Calculate the full (complex) autocorrelation coefficient.
        p_upper_full = (1/(2*M))*(sum(y_seg1.*conj(y_seg2)));
        R = p_upper_full/sigma_z;  
        
        % Worst case scenarios. 
            switch WC_type
                case 'WC1'
                    R_WC = R*exp(-1*j*angle(R));
                    rand_angle = -pi + (pi - (-1*pi)).*rand(1);
                    R_WC = R_WC*exp(j*rand_angle);
                    R = R_WC;
                case 'WC2'
                    R_WC = R*exp(-1*j*angle(R));
                    R_WC = R_WC*exp(j*-pi);
                    R_WC = R_WC*exp(j*LUT_angle);
                    R = R_WC;
                case 'none'   
            end
        
        % Calculate the angular pdf and map angles from Uniform pdf.
        R_abs = abs(R);
        bins_P = [-pi:phase_step:pi];       
        R_abs_real = real(R)*precision_factor;      
        R_abs_imag = imag(R)*precision_factor;        
        R_abs_min_2sig2 = R_abs_real^2 + R_abs_imag^2 - ((precision_factor^2)*diff_rms_pow);        
        rho2 = (precision_factor^2)*(rho_LUT.^2); 
        [~,real_mean_ind] = min(abs(rho2-R_abs_min_2sig2));        
        pdf  = ComplexGaussPhasePDF((rho_LUT(real_mean_ind)),(1/(2*M)),(1/(2*M)),phase_step);     
        pdf = pdf / sum(pdf); 
        cdf = cumsum(pdf);
        
        % Map Uniformly distributed variable to the cdf.
        r = randi([1,length(LUT_uni)],1,1);
        uni_num = LUT_uni(r);
        [~,b] = min(abs(cdf-uni_num));
        rotation_angle = bins_P(b);
        R = 0;
        R = R_abs*exp(j*rotation_angle);
        test_statistic = real(R);
        
        

        
    case 'abs'
        
        % Calculate the threshold.
        threshold = (1/sqrt(M))*erfcinv(2*Pfa);
        % Extract the data in appropriate shifts relative to Td.
        y_seg1 = y(1:end-T_d);
        y_seg2 = y(T_d+1:end);
        % Estimate autocorrelation based test statistic.
        p_upper = (1/(2*M))*(sum(real(y_seg1.*conj(y_seg2))));
        sigma_z = (1/(2*(M+T_d)))*sum(abs(y).^2);
        % Calculate the full (complex) autocorrelation coefficient.
        p_upper_full = (1/(2*M))*(sum(y_seg1.*conj(y_seg2)));
        R = p_upper_full/sigma_z;  
        
        % Worst case scenarios. 
            switch WC_type
                case 'WC1'
                    R_WC = R*exp(-1*j*angle(R));
                    rand_angle = -pi + (pi - (-1*pi)).*rand(1);
                    R_WC = R_WC*exp(j*rand_angle);
                    R = R_WC;
                case 'WC2'
                    R_WC = R*exp(-1*j*angle(R));
                    R_WC = R_WC*exp(j*-pi);
                    R_WC = R_WC*exp(j*LUT_angle);
                    R = R_WC;
                case 'none'   
            end
            
        test_statistic = abs(R);
        
end


%% Make decision
decision = test_statistic >= threshold;


%% Outputs
switch nargout
    case 1
        varargout{1} = decision;
        
    case 3
        varargout{1} = decision;
        varargout{2} = test_statistic;
        varargout{3} = R;
        
    case 4
        varargout{1} = decision;
        varargout{2} = test_statistic;
        varargout{3} = R;
        varargout{4} = R_WC;
        
    case 5
        varargout{1} = decision;
        varargout{2} = test_statistic;
        varargout{3} = R;        
        varargout{4} = R_abs_min_2sig2;
        varargout{5} = real_mean_ind;
        
    case 6
        varargout{1} = decision;
        varargout{2} = test_statistic;
        varargout{3} = R;        
        varargout{4} = R_abs_min_2sig2;
        varargout{5} = real_mean_ind;
        varargout{6} = pdf;
       
        
end



end

