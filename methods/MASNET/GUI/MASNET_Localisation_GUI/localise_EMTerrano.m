function [Sensors,est_target,Target,Best_est_target,Best_sensors,best_est_ls,est_ls,Best_est_targetL,best_est_lsL,est_targetL,est_lsL] = localise_EMTerrano(Nsensors,OutPutTable,c,p,pks,allCombs,Pt)
%%% this is the actual target location as in EM Terrano files actual_target,
Target = OutPutTable.TX_Location_X_Y_Z;
%%% obtain sensor locations and id from EM Terrano file
Sensor_locations = OutPutTable.RX_Location_X_Y_Z;
Sensors_id = OutPutTable.RX_ID;
%%% run a for loop to extract the sensor location and the average receiving
%%% time information
%%% run a for loop to extract the sensor location and the average receiving
%%% time information
for ss = 1:Nsensors
    idx = find(Sensors_id == ss);
    ID = idx(1);
    Sensors(ss,:) = Sensor_locations(ID,:);
    rx_times_tot = OutPutTable.Travel_Time_ns;
    %%% average receiving times are computed for each sensor
    rx_times(ss) = mean(rx_times_tot(idx));
    %%%% sort the receiving times for each sensor ascendingly, choose the
    %%%% first receiving time
    rx_times_los = sort(nonzeros(rx_times_tot(idx)),'ascend');
    rx_timesL(ss) = rx_times_los(1);
    delay_tot = OutPutTable.Delay_Between_Rays_of1RX_ns;
    %%% considering the average of the delay rays for each sensor
    delay(ss) = mean(delay_tot(idx));
end
for fp = 1:pks
    f = allCombs(fp,:);
    %     for jj = 1:length(f)
    %         dist_max(fp,:) = sqrt((Sensors(jj,1)-Sensors(:,1)).^2+(Sensors(jj,2)-Sensors(:,2)).^2+(Sensors(jj,3)-Sensors(:,3)).^2);
    %     end
    norm_S = sum(Sensors(f,1:p)'.^2);
    edm_S = bsxfun(@plus,norm_S',norm_S)-2*(Sensors(f,1:p)*Sensors(f,1:p).');
    sum_dist(fp) = sum(edm_S(:));
end
[~,id_max] = max(sum_dist);
fmax = allCombs(id_max,:);
% fmax = randperm(20,5);
%%% choose a subset from all the sensors
%[val,id_best] = sort(rx_pr,'descend');%sort(nonzeros(delay),'ascend');
Best_sensors = Sensors(fmax,:);
%%% localisation is performed over the average receiving time (taking into account multipath effect)
%%% compute the equivalent distance measurements from time measurements of
%%% the best 10 sensors (best is chosen according to the highest (averaged received power)
best_dhat = (rx_times(fmax)*1e-9)*c;
[Best_est_target,best_est_ls] = centralised_localisation_EMTerrano(best_dhat,Best_sensors,p);
Best_est_target = abs(Best_est_target);
best_est_ls = abs(best_est_ls);
%%% estimated target position using the exact distances
dactual = sqrt((Target(1,1)-Sensors(:,1)).^2+(Target(1,2)-Sensors(:,2)).^2+(Target(1,3)-Sensors(:,3)).^2);
% [actual_target] = centralised_localisation_EMTerrano(dactual,Sensors,p);
%%% compute the equivalent distance measurements from time measurementsdhat = (rx_times*1e-9)*c;
dhat = (rx_times*1e-9)*c;
[est_target,est_ls] = centralised_localisation_EMTerrano(dhat,Sensors,p);
%%% the absolute of the estimated target location is considered as we
%%% defined all coordinates in positive
est_target = abs(est_target);
est_ls = abs(est_ls);
%%% localisation is performed over the first receiving time (using LOS information only)
%%% compute the equivalent distance measurements from time measurements of
%%% the best 10 sensors (best is chosen according to the highest (averaged received power)
best_dhatL = (rx_timesL(fmax)*1e-9)*c;
[Best_est_targetL,best_est_lsL] = centralised_localisation_EMTerrano(best_dhatL,Best_sensors,p);
Best_est_targetL = abs(Best_est_targetL);
best_est_lsL = abs(best_est_lsL);
% % % %%% estimated target position using the exact distances
% % % dactual = sqrt((Target(1,1)-Sensors(:,1)).^2+(Target(1,2)-Sensors(:,2)).^2+(Target(1,3)-Sensors(:,3)).^2);
% [actual_target] = centralised_localisation_EMTerrano(dactual,Sensors,p);
%%% compute the equivalent distance measurements from time measurementsdhat = (rx_times*1e-9)*c;
dhatL = (rx_timesL*1e-9)*c;
[est_targetL,est_lsL] = centralised_localisation_EMTerrano(dhatL,Sensors,p);
%%% the absolute of the estimated target location is considered as we
%%% defined all coordinates in positive
est_targetL = abs(est_targetL);
est_lsL = abs(est_lsL);


noise = dhat-dactual.';
noiseL = dhatL-dactual.';
% if Pt == 23
% save('noise_values_7dB.mat','delay','noise');
%
% else
%     save('noise_values_MINUS23dB.mat','delay','noise');
% end
end

