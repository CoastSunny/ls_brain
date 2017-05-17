function [aoa,aoa_b]=AOA_Detection(Type_Environment,sensor,Tx_signal,cir_f,T_target_pos,l)

% Signal source directions

az = (atan((T_target_pos(2)-sensor(:,2))./(T_target_pos(1)-sensor(:,1)))*180/pi).'; % Azimuths
el = zeros(size(az)); % Simple example: assume elevations zero
M = length(az); % Number of sources
if l==1
    if Type_Environment==0
        az = az+normrnd(10^1.4,10^0.2,1,M);
    else
        az = az+normrnd(10^1.2,10^0.18,1,M);
    end
elseif l==0
    if Type_Environment==1
        az = az+(normrnd(10^1.55,10^0.2,1,M));
    else
         az = az+(normrnd(10^1.52,10^0.27,1,M));
%        az = az+(normrnd(0,10^0.27,1,M));
    end
end
    

    
% Wavenumber vectors (in units of wavelength/2)
k = pi*[cosd(az).*cosd(el); sind(az).*cosd(el); sind(el)].';

% Array geometry [rx,ry,rz]
N = 10; % Number of antennas
r = [zeros(N,1),(1:N).',zeros(N,1)]; % Assume uniform linear array
% Matrix of array response vectors
A = exp(-1j*r*k');

for kk=1:1:size(sensor,1)
    cir_f{kk}=squeeze(cir_f{kk});
    Rx_signal{kk}=A(:,kk)*conv(Tx_signal.',cir_f{kk}(:,1));
    R{kk} =(Rx_signal{kk}*Rx_signal{kk}')/(size(Rx_signal{kk},2));
    
%     % Eigendecompose
    [E,D] = eig(R{kk});
    [lambda,idx] = sort(diag(D)); % Vector of sorted eigenvalues
    E = E(:,idx); % Sort eigenvalues accordingly
    En{kk} = E(:,1:end-M); % Noise eigenvectors (ASSUMPTION: M IS KNOWN)
    % MUSIC search directions
    AzSearch = (-90:1:90).'; % Azimuth values to search
    ElSearch = zeros(size(AzSearch)); % Simple 1D example
    
    % Corresponding points on array manifold to search
    kSearch = pi*[cosd(AzSearch).*cosd(ElSearch), ...
        sind(AzSearch).*cosd(ElSearch), sind(ElSearch)].';
    ASearch = exp(-1j*r*kSearch);
    P_mu{kk} = 1./sum(abs(ASearch'*En{kk}).^2,2);
    P_bar{kk} = sum(abs(ASearch'*R{kk}(:,1)).^2,2);
   
[~,id]=sort(P_mu{kk},'descend');
aoa(kk) =  AzSearch(id(1));
[~,id_b] = max(P_bar{kk});
aoa_b(kk) = AzSearch(id_b);
end
