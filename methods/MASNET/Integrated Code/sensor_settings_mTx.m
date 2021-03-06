function [layoutpar,distance] = sensor_settings_mTx(layoutpar,Sensors,Num_sensors,Type_Environment,Pos_target,Vel_sensors)

    distance = zeros(Num_sensors,1);

                for i=1:1:Num_sensors
                    % Set the position of the sensor i in the structure
                    layoutpar.Stations(i+2).Pos = [Sensors(i,1,1);Sensors(i,2,1);Sensors(i,3,1)];

                    % Set the velocity of the sensor i in the structure
                    layoutpar.Stations(i+2).Velocity = [Vel_sensors(i,1,1);Vel_sensors(i,2,1);Vel_sensors(i,3,1)];

                    % Calculate the 2D distance between target and sensor i
                    distance(i) = sqrt((Sensors(i,1,1)-Pos_target(1))^2+(Pos_target(2)-Sensors(i,2,1))^2);

                    % Check what environment is the scenario (Urban or rural) and then
                    % calculate the corresponding probability of the sensor i being in NLOS
                    % or LOS
                    if Type_Environment == 0
                        if (18/distance(i))>=1
                            PLOS = 1;
                        else
                            PLOS = (18/distance(i))*(1-exp(-distance(i)/63))+exp(-distance(i)/63);
                        end
                    else
                        PLOS = exp(-distance(i)/1000);
                    end

                    % Variable to store temp whether the link is NLOS or LOS (NLOS=0, LOS=1)
                    % depending on the PLOS
                    env = randsrc(1,1,[0 1; (1-PLOS) PLOS]);

                    % Change for the specific sensor its link condition NLOS or LOS

                    layoutpar.PropagConditionVector(i) = env;

                end
end