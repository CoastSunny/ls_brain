function [g_direct,g_iter]= TDOA_localization(times,LOS_sensor,c)
    


is2d = true;
if is2d, D = 2; else D = 3;end 

[val,id] = min(times);
dists = (times-val)*c;
new_origin = LOS_sensor(id,1:D);
sensor_offsets = bsxfun(@minus, LOS_sensor(:,1:D),new_origin);%LOS_sensor(:,1:D)-new_origin; 
%sensor_iter= sensor_offsets(p(1:3),:);
guess = localize_srdls(sensor_offsets,dists);
g_direct = guess(1:D) + new_origin';
iter_guess = localization_mantilla(sensor_offsets,dists',[guess(1:D); 0],is2d);
g_iter = iter_guess(1:D)+new_origin;
