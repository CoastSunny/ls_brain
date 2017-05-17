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
    case 4
        y    =       varargin{1};                              % Signal.
        Pfa  =       varargin{2};                              % Probability of false alarm.
        T_d  =       varargin{3};                              % Duration of data segment (FFT size).
        algo_type  = varargin{4};                              % Type of algorithm to implement.
        
    case 7
        y    =       varargin{1};                              % Signal.
        Pfa  =       varargin{2};                              % Probability of false alarm.
        T_d  =       varargin{3};                              % Duration of data segment (FFT size).
        algo_type  = varargin{4};                              % Type of algorithm to implement.
        LUT_uni    = varargin{5};                              % A vector containing a look-up table of uniformly distributed random numbers.
        WC_type    = varargin{6};                              % A string to denote the type of frequency offset worst case scenario. 'WC1','WC2','none'.
        phase_step = varargin{7};                              % The phase step for the phase pdf.
        
    case 9
        y    =       varargin{1};                              % Signal.
        Pfa  =       varargin{2};                              % Probability of false alarm.
        T_d  =       varargin{3};                              % Duration of data segment (FFT size).
        algo_type  = varargin{4};                              % Type of algorithm to implement.
        LUT_uni    = varargin{5};                              % A vector containing a look-up table of uniformly distributed random numbers.
        WC_type    = varargin{6};                              % A string to denote the type of frequency offset worst case scenario. 'WC1','WC2','none'.
        phase_step = varargin{7};                              % The phase step for the phase pdf.
        Real_mean  = varargin{8};                              % The mean of the real component.
        Real_var   = varargin{9};                              % The variance of the real component.
end



%% Remove dc and obtain sample lengths.
% Ensure samples are in a row vector with mean of zero.

M = length(y) - T_d;
y = reshape(y,1,length(y));
y = y - mean(y);
Ray_thresh = 2*(abs(((1/sqrt(2*M)) + j*(1/sqrt(2*M)))));



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
        
        WC_test = exist('WC_type');
        if (WC_test)
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
        test_statistic = real(R);
        
    case 'FO_Corrected1'
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
        
        WC_test = exist('WC_type');
        if (WC_test)
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
        end
        
        %% The FFO correction scheme.
        
        % Calculate the angular pdf and map angles from Uniform pdf.
        R_abs = abs(R);
        bins_P = [-pi:phase_step:pi];
        real_var = ((1-(R_abs)^2)^2)/(2*M);
        % Derive the PDF of Complex Gauss Angles making appropriate approximations.
        pdf  = ComplexGaussPhasePDF(R_abs,real_var,(1/(2*M)),phase_step);
        pdf = pdf / sum(pdf);
        cdf = cumsum(pdf);
        %cdf = cdf/(cdf(end));
        
        % Make Uniformly distributed variable to the cdf.
        r = randi([1,length(LUT_uni)],1,1);
        uni_num = LUT_uni(r);
        [~,b] = min(abs(cdf-uni_num));
        rotation_angle = bins_P(b);
        
        
        % Introduce a sign ambiguity factor based on distance from the
        % mean under Ho: ~N(0,1/(2*M)).
        n = R_abs/sqrt(1/(2*M));   % n is the no. of stds from the mean assuming ~N(0,1/(2*M)) process.
        value_width = 1 - erf(n/sqrt(2));
        % Probability of R_abs being negative (if it were Real(R))
        Prob_negative = 0.5*value_width;
        % Express as a rounded percentage.
        Prob_negative = round(Prob_negative*100);
        % Do not implement if value of R_abs is beyond 99% quartile wrt ~N(0,1/(2*M)) process.
        if Prob_negative <= 0
            R_abs = R_abs*exp(j*rotation_angle);
        else
            LUT_correction = zeros(1,length(LUT_uni));
            Prob_negative_N_ones = round((Prob_negative*length(LUT_uni))/100);
            LUT_correction(randi([1,length(LUT_correction)],1,Prob_negative_N_ones)) = 1;
            neg_decision = randi([1,length(LUT_correction)],1,1);
            if LUT_correction(neg_decision) == 1
                R_abs = R_abs*exp(j*rotation_angle);
                if sign(real(R_abs)) == -1
                    R_abs = R_abs;
                elseif sign(real(R_abs)) == 1
                    R_abs = -1*R_abs;
                end
            elseif LUT_correction(neg_decision) == 0
                R_abs = R_abs*exp(j*rotation_angle);
            else
                error('The decision can only be 1 or 0')
            end
        end
        
        R = [];
        R = R_abs;
        test_statistic = real(R);
        
        
    case 'FO_Corrected2'
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
        
        WC_test = exist('WC_type');
        if (WC_test)
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
        end
        
        %% The FFO correction scheme.
        
        % Calculate the angular pdf and map angles from Uniform pdf.
        R_abs = abs(R);
        bins_P = [-pi:phase_step:pi];
        if R_abs > Ray_thresh
            
            real_var = ((1-(R_abs)^2)^2)/(2*M);
            % Derive the PDF of Complex Gauss Angles making appropriate approximations.
            pdf  = ComplexGaussPhasePDF(R_abs,real_var,(1/(2*M)),phase_step);
            pdf = pdf / sum(pdf);
            cdf = cumsum(pdf);
            % Make Uniformly distributed variable to the cdf.
            r = randi([1,length(LUT_uni)],1,1);
            uni_num = LUT_uni(r);
            [~,b] = min(abs(cdf-uni_num));
            rotation_angle = bins_P(b);
            R_abs = R_abs*exp(j*rotation_angle);
            
        elseif  R_abs <= Ray_thresh
            r = randi([1,length(bins_P)],1,1);
            rotation_angle = bins_P(r);
            R_abs = R_abs*exp(j*rotation_angle);
        end
        
        R = [];
        R = R_abs;
        test_statistic = real(R);
        
        
        
    case 'FO_Corrected3'
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
        
        WC_test = exist('WC_type');
        if (WC_test)
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
        end
        
        %% The FFO correction scheme.
        
        % Calculate the angular pdf and map angles from Uniform pdf.
        R_abs = abs(R);
        bins_P = [-pi:phase_step:pi];
        pdf  = ComplexGaussPhasePDF(Real_mean,Real_var,(1/(2*M)),phase_step);
        pdf = pdf / sum(pdf);
        cdf = cumsum(pdf);
        
        % Make Uniformly distributed variable to the cdf.
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
        
        WC_test = exist('WC_type');
        if (WC_test)
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
        
end



end

