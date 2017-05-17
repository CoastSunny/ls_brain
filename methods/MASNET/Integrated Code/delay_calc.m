function rx_times = delay_calc(distance,Type_Environment,cir_ds,Num_sensors,c)

t_flight = distance/c;

if Type_Environment==0
    epd=sort(exprnd(10^-7.2886,[Num_sensors,size(cir_ds{1},3)]));
    rx_times = t_flight+epd;
else
    epd=sort(exprnd(10^-7.6886,[Num_sensors,size(cir_ds{1},3)]));
    rx_times = t_flight+epd;
end


end
