function [varargout] = WINUnpack(varargin)
% Takes in set of input channel impulse repsonses, CIR_in, and shifts them in time according
% to an offset distance, d. f is the carrier frequency and Fs is the sampling
% frequency.
%
% [CIR_out,d_round] = WINUnpack(CIR_in, delays, d, f, Fs_desired)
%
% CIR_out is the resultant output channel impulse response. CIR_in must be
% an array of NRx x NTx x Ntaps x NSamples. delays is a vector of delay domain
% time indices corresponding to each tap. d_round is the actual value of
% delay used as a result of rounding, d, according to the nearest sampling
% interval: 1/Fs_desired. If Fs_desired is set at 0, the default WINNER II
% sample frequency, Fs = 100 MHz, is assumed.
%
% [CIR_out,d_round] = WINUnpack(CIR_in, delays, d, f, Fs, 'PL_model')
%
% uses d to also calculate a path loss and scale the channel energy
% ('Frobenius norm squared') accordingly.
%
% NB: In the 'cleaning-up' process, some of the features of this function
% should perhaps be removed.

%% Inputs

switch nargin
    case 5
        
        CIR_in          = varargin{1};
        delays          = varargin{2};
        d               = varargin{3};
        f               = varargin{4};
        Fs_desired      = varargin{5};
        
    case 6
        
        CIR_in          = varargin{1};
        delays          = varargin{2};
        d               = varargin{3};
        f               = varargin{4};
        Fs_desired      = varargin{5};
        PL              = varargin{6};
        
end


if length(size(CIR_in)) ~=4
    error('The input array of channel impulse responses must be of dimension: NRx x NTx x Ntaps x NSamples')
end

if length(size(delays)) >= 3
    error('The input of delays must be a vector')
elseif (size(delays,1)*size(delays,2)) ~= length(delays)
    error('The input of delays must be a vector')
end


Fs = 200e6;                 % As specified in WINNER II model.
NRx = size(CIR_in,1);
NTx = size(CIR_in,2);
Taps = size(CIR_in,3);
Temp = size(CIR_in,4);

%% Path loss.
d_0 = 1;
n = 2;
c = 3e8;
lambda = c/f;

% Free space path loss (FSL).
PL_0 = 20*log10((4*pi*d_0/lambda));
OL = PL_0 + (10*n)*log10(d/d_0);
OL_lin = 10^(-OL/10);


%% Downscaling the bandwidth in the delay domain.
if Fs_desired == 0
    Fs_desired = Fs;
elseif Fs_desired < 0
    error('Desired sampling frequency, Fs, must be greater than or equal zero where zero means use default WINNER II sampling frequency of 200 MHz (BW = 100 MHz)')
end

Ts_desired = 1/Fs_desired;
max_sample = max(delays);
if Ts_desired >= max_sample
    error('Desired sampling frequency must give smaller sampling interval than the maximum delay component')
end
delay_grid = [0:Ts_desired:max_sample];
if delay_grid(end) <= max_sample
    delay_grid = [delay_grid (delay_grid(end) + Ts_desired)];
end

CIR_in_unpacked = zeros(NRx,NTx,length(delay_grid),Temp);

for xx4 = 1:Temp
    for xx1 = 1:NRx
        for xx2 = 1:NTx
            amplitude_tmp = zeros(size(delay_grid));
            for xx3 = 1:Taps
                [~, delay_ind] = min(abs(delays(xx3) - delay_grid));
                amplitude_tmp(delay_ind) = amplitude_tmp(delay_ind) + CIR_in(xx1, xx2, xx3, xx4);
            end
            CIR_in_unpacked (xx1, xx2, :, xx4) = amplitude_tmp;
        end
    end
end



%%  Impose a time delay for localisataion work.
T_d = (d/c);
Ts = (1/Fs_desired);
T_d_points = round(T_d/Ts);
T_d_zeros = zeros(T_d_points,1);
d_actual = T_d_points*Ts;


%% Normalise the channel impulse response according E{||H||_{F}^{2}} and append zeros according to time delay.
CIR_out = zeros(NRx, NTx, (size(CIR_in_unpacked,3) + T_d_points), Temp);
PL_model_check = exist('PL');

if (PL_model_check) && strcmp(PL_model_check,'PL_model')
    CIR_comp_sum = zeros(NRx, NTx, Temp);
    CIR_comp_fro = zeros(1,Temp);
    for xx4 = 1:Temp
        for xx1 = 1:NRx
            for xx2 = 1:NTx
                CIR_comp_sum(xx1,xx2,xx4) = sum(CIR_in_unpacked(xx1, xx2, :, xx4));
                CIR_comp_fro(xx4) = norm(CIR_comp_sum(:,:,xx4),'fro');
            end
        end
    end
    
    H1_comp_fro_mean = mean(CIR_comp_fro);
    CIR_out_tmp = zeros(size(CIR_in_unpacked));
    
    for xx4 = 1:Temp
        for xx1 = 1:NRx
            for xx2 = 1:NTx
                CIR_out_tmp(xx1,xx2,:,xx4) = (sqrt(NRx*NTx*OL_lin))*(CIR_in_unpacked(xx1,xx2,:,xx4)./H1_comp_fro_mean);
                CIR_temp = [T_d_zeros; squeeze(CIR_out_tmp(xx1,xx2,:,xx4))];
                delay_grid =  [reshape(T_d_zeros,1,length(T_d_zeros)) delay_grid];
                CIR_out(xx1,xx2,:,xx4) = CIR_temp;
            end
        end
    end
elseif PL_model_check == 0
    for xx4 = 1:Temp
        for xx1 = 1:NRx
            for xx2 = 1:NTx
                CIR_temp = [T_d_zeros; squeeze(CIR_in_unpacked(xx1,xx2,:,xx4))];
                delay_grid =  [reshape(T_d_zeros,1,length(T_d_zeros)) delay_grid];
                CIR_out(xx1,xx2,:,xx4) = CIR_temp;
            end
        end
    end
end


%% Outputs.

varargout{1} = CIR_out;
varargout{2} = d_actual;
varargout{3} = delay_grid;


end

