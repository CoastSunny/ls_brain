% Opens channels from file and normalises according to relative 
% user path loss, where nearest user sees near unity gain channel,
% rather than absolute path loss based on distance from BS.

clear

%% File paths
cdir = cd;
Load_channels_path = 'H:\MATLAB\DSTL\MASNET_Project\WINNER2';
Save_channels_path = 'H:\MATLAB\DSTL\MASNET_Project\WINNER2';
%Channels_name = 'WINNER_channels_smallscale';
Channels_name = 'WINNER_channels_largescale';
% Note: There 10 receivers and 15 'drops'.
% Each drop contains 1000 channels impulse responses 


%% Load channels
cd(Load_channels_path);
WINNER_Channels = load(Channels_name);
cd(cdir);

%% Channels paramters

switch Channels_name
    case 'WINNER_channels_smallscale'
Tx_pos = [265; 435; 3];
Rx_pos(:,1) = [449.0000; 250; 1.5];
Rx_pos(:,2) = [276.0000; 175.0000; 1.5];
Rx_pos(:,3) = [99.0000; 299.0000; 1.5];
Rx_pos(:,4) = [469.0000;  190.0000; 1.5];
Rx_pos(:,5) = [314.0000; 198.0000; 1.5];
Rx_pos(:,6) = [104.0000; 283.0000; 1.5];
Rx_pos(:,7) = [189.0000; 217.0000; 1.5];
Rx_pos(:,8) = [463.0000; 120.0000; 1.5];
Rx_pos(:,9) = [44.0000; 261.000; 1.5];
Rx_pos(:,10) = [157.0000; 357.0000; 1.5];

% Find nearest user to base station
Rx_dists = zeros(1,length(Rx_pos));
for dd = 1:length(Rx_pos)
    Rx_dists(dd) = sqrt(sum((Rx_pos(:,dd) - Tx_pos).^2));
end
[~,Nearest_user] = min(Rx_dists);
disp(['The nearest user is receiver (mobile station) number: ',num2str(Nearest_user),' .'])

    case 'WINNER_channels_largescale'
Nearest_user = 1;
disp(['The nearest user is assumed to be receiver (mobile station) number: ',num2str(Nearest_user),' .'])
end

scenario = WINNER_Channels.scenario;
CIR_out =  WINNER_Channels.CIR_out;
newdelays = WINNER_Channels.newdelays;
Fs_desired = 31e6;
N_Rxs = size(CIR_out,1);
Ndrops = size(CIR_out,2);
Temp = size(CIR_out{1,1},4);
NRx = size(CIR_out{1,1},1);
NTx = size(CIR_out{1,1},2);
CIR_length = size(CIR_out{1,1},3);
Drop_norm_reference = 1;


%% Normalisation

% Calculation of normalisation factor (based on mean Frobenius norm of nearest user in first drop)
CIR_comp_sum = zeros(NRx, NTx, Temp);
CIR_comp_fro = zeros(1,Temp);
CIR_out_norm = cell(size(CIR_out));


for xx4 = 1:Temp
    for xx1 = 1:NRx
        for xx2 = 1:NTx
            CIR_comp_sum(xx1,xx2,xx4) = sum(CIR_out{Nearest_user,Drop_norm_reference}(xx1, xx2, :, xx4));           
        end
    end
    CIR_comp_fro(xx4) = norm(CIR_comp_sum(:,:,xx4),'fro');
end
    
Norm_factor = mean(CIR_comp_fro);

% Normalise entire set of channel impulse reponses.
% 'CIR_out_norm' is the new cell containing normalised channel impulse responses.
% Note: Signal may be convolved with channel as in: conv(squeeze(channl_vec, signal_vec) + noise;
for rr = 1:N_Rxs
    for dd = 1:Ndrops
        for xx4 = 1:Temp
            for xx1 = 1:NRx
                for xx2 = 1:NTx                
                    CIR_out_norm{rr,dd}(xx1,xx2,:,xx4) = (sqrt(NRx))*(CIR_out{rr,dd}(xx1,xx2,:,xx4)./Norm_factor); %                 
                end
            end
        end
    end
end

%% Examine the effect of normalisation.
CIR_out_norm_sum = cell(size(CIR_out));
CIR_comp_fro_norm2_check = cell(size(CIR_out));
CIR_comp_fro_norm2_check_mean = zeros(N_Rxs,Ndrops); 

for rr = 1:N_Rxs
    for dd = 1:Ndrops
        for xx4 = 1:Temp
            for xx1 = 1:NRx
                for xx2 = 1:NTx
                    CIR_out_norm_sum{rr,dd}(xx1,xx2,xx4) = sum(CIR_out_norm{rr,dd}(xx1, xx2,:,xx4));                    
                end
            end
            CIR_comp_fro_norm2_check{rr,dd}(xx4) = norm(CIR_out_norm_sum{rr,dd}(:,:,xx4),'fro')^2;
        end
        CIR_comp_fro_norm2_check_mean(rr,dd) = mean(CIR_comp_fro_norm2_check{rr,dd});
    end
end

figure(1)
imagesc(10*log10(CIR_comp_fro_norm2_check_mean))
ylabel('Rx number')
xlabel('Time, [Drop index]')
colorbar
