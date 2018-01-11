function [rx_times] = var_delay_calc(distance,cir,c,mu,Num_sensors)



%rx_times = zeros(length(mu),Num_sensors,size(cir{1},3));
    t_flight = distance/c;
    %epd = cell(1,length(idx));
    %rx_times_los = zeros(length(idx),size(cir_ds{1},3));
    %for kk= 1:length(idx)
        epd=sort(exprnd(10^mu,[Num_sensors,cir]));
        rx_times = t_flight+epd;
    %end
%end

% t_flight_nlos = distance(nidx)/c;
% epd_nlos = cell(1,length(nidx));
% rx_times_nlos = zeros(length(nidx),size(cir_ds{1},3));
% for ll= 1:length(nidx)
%     epd_nlos{ll}=sort(unifrnd(0,800e-9,[1,size(cir_ds{nidx(ll)},3)]));
%     rx_times_nlos(ll,:) = t_flight_nlos(ll)+epd_nlos{ll}.';
end