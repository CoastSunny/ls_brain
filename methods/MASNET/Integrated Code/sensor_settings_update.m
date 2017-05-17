function [layoutpar,distance] = sensor_settings_update(layoutpar,Sensors,Num_sensors,Type_Environment,target,Vel_sensors,nt)

%distance = zeros(Num_sensors,1);
distance = zeros(Num_sensors,nt);
PLOS = zeros(Num_sensors,1);
for ii=1:1:Num_sensors
    % Set the position of the sensor i in the structure
    layoutpar.Stations(ii+nt).Pos = [Sensors(ii,1,1);Sensors(ii,2,1);Sensors(ii,3,1)];
    
    % Set the velocity of the sensor i in the structure
    layoutpar.Stations(ii+nt).Velocity = [Vel_sensors(ii,1,1);Vel_sensors(ii,2,1);Vel_sensors(ii,3,1)];
    
    % Calculate the 2D distance between target and sensor i
    distance(ii,:)= sqrt((Sensors(ii,1)-target(1,:)).^2+(Sensors(ii,2)-target(2,:)).^2);%+(Sensors(ii,3)-target(3,:)).^2).';
    %(Sensors(jj,1,1)-Sensors(:,1,1)).^2
    
    
    % Check what environment is the scenario (Urban or rural) and then
    % calculate the corresponding probability of the sensor i being in NLOS
    % or LOS
    %for jj = 1:size(distance,2)
    if Type_Environment == 0
        if distance(ii,:)<=1
            PLOS(ii,:) = (18/1)*(1-exp(-distance(ii,:)/63))+exp(-distance(ii,:)/63);
        else
            PLOS(ii,:) = (18/distance(ii,:))*(1-exp(-distance(ii,:)/63))+exp(-distance(ii,:)/63);
        end
        %PLOS(ii,:)= PLOS;
    else
        PLOS(ii,:) = exp(-distance(ii,:)/1000);
    end
end
PLOS = reshape(PLOS,nt*Num_sensors,1);
for jj= 1:size(PLOS,1)
% Variable to store temp whether the link is NLOS or LOS (NLOS=0, LOS=1)
% depending on the PLOS
env(jj) = randsrc(1,1,[0  1; (1-PLOS(jj)) PLOS(jj)]);
end


% Change for the specific sensor its link condition NLOS or LOS

layoutpar.PropagConditionVector = env;


end