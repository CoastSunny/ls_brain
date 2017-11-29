function [Sensors,Num_sensors] = sensor_positioning(Type_Scenario,Size_Scenario,Size_FZ1_x,Size_FZ1_y,Size_FZ2_x,Size_FZ2_y,Num_sensors,hs)

    if Type_Scenario == 0

        % Select type of the scenario: 0 for separate zones for enemies and
        % friends and 1 for all mixed.
        
          % Select type of the scenario: 0 for separate zones for enemies and
        % friends and 1 for all mixed.
        % Type_Scenario = 0;

        % Type of environment in the scenario 0=urban, 1=rural
        % Type_Environment = 0;


        % Size of the scenario= Size_Scenario x Size_scenario (metres)
        % Size_Scenario = 2000;

        % Size of the enemy zone = Size_EZ_x x Size_EZ_y (metres)
        % Size_EZ_x = 200;
        % Size_EZ_y = 200;

        % Size of the friend zone 1 = Size_FZ1_x x Size_FZ1_y (metres). This is the
        % first of the zones. Also, the starting coordinates of the FZ1 are
        % defined.
        % Size_FZ1_x = 200;
        % Size_FZ1_y = 2000;
        Sep_sensors=78;
        Start_FZ1_x = Size_Scenario - Size_FZ1_x;
        Start_FZ1_y = 0;
        Area_FZ1 = Size_FZ1_x*Size_FZ1_y;

        % Size of the friend zone 2 = Size_FZ2_x x Size_FZ2_y (metres). This is the
        % second of the zones. Also, the starting coordinates of the FZ2 are
        % defined.
        % Size_FZ2_x = 1800;
        % Size_FZ2_y = 200;
        Start_FZ2_x = 0;
        Start_FZ2_y = Size_Scenario - Size_FZ2_y;
        Area_FZ2 = Size_FZ2_x*Size_FZ2_y;

        % Separation between sensors in metres. There are as many sensors in the
        % friend zones FZ1 and FZ2 as they fit.
        % Sep_sensors = 200;
        Num_sensors = floor((Area_FZ1+Area_FZ2)/(Sep_sensors)^2);

        % Define height of sensors and target in metres
        % hs = 1.5;
        % ht = 3;

        % Initialise the matrix of positions (coordinates) where the sensors are
        % located.
        %Pos_sensors_x = zeros(Size_Scenario/Sep_sensors);
        %Pos_sensors_y = zeros(Size_Scenario/Sep_sensors);
        Sensors = zeros(Num_sensors,3);


        % Positioning the sensors with origin of coordinates on the left lower
        % corner of the scenario. The data stored is the distance of the sensor to
        % the origin of coordinates in metres.
        indx = 0;
        for p_x=Start_FZ1_x+Sep_sensors/2:Sep_sensors:Size_Scenario-Sep_sensors/2
            for p_y=Start_FZ1_y+Sep_sensors/2:Sep_sensors:Start_FZ2_y-Sep_sensors/2
        %         ind_pos_x = p_x/Sep_sensors + 1;
        %         ind_pos_y = p_y/Sep_sensors + 1;
                indx = indx + 1;
        %         Pos_sensors_x(ind_pos_y,ind_pos_x) = p_x; 
        %         Pos_sensors_y(ind_pos_y,ind_pos_x) = p_y; 
                Sensors(indx,:)=[round(p_x);round(p_y);hs];
            end
        end

        for p_x=Start_FZ2_x+Sep_sensors/2:Sep_sensors:Size_Scenario-Sep_sensors/2
            for p_y=Start_FZ2_y+Sep_sensors/2:Sep_sensors:Size_Scenario-Sep_sensors/2
        %         ind_pos_x = p_x/Sep_sensors + 1;
        %         ind_pos_y = p_y/Sep_sensors + 1;
        %         Pos_sensors_x(ind_pos_y,ind_pos_x) = p_x; 
        %         Pos_sensors_y(ind_pos_y,ind_pos_x) = p_y; 
                indx = indx + 1;
                Sensors(indx,:)=[round(p_x);round(p_y);hs];
            end
        end
    else

        % If type of Scenario is 1, the enemy and friend areas are mixed and
        % cover all the scenario area

        Area_FZ = Size_Scenario*Size_Scenario;
        side=Size_Scenario;
        ceilpower=ceil(sqrt(Num_sensors));
        Sep_sensors_x = side/(ceilpower);
        Sep_sensors_y = side/(ceilpower);

        Sensors = zeros(Num_sensors,3);

        indx = 0;
        for p_x=Sep_sensors_x:Sep_sensors_x:Size_Scenario
            for p_y=Sep_sensors_y:Sep_sensors_x:Size_Scenario
        %         ind_pos_x = p_x/Sep_sensors + 1;
        %         ind_pos_y = p_y/Sep_sensors + 1;
                indx = indx + 1;
        %         Pos_sensors_x(ind_pos_y,ind_pos_x) = p_x; 
        %         Pos_sensors_y(ind_pos_y,ind_pos_x) = p_y; 
                Sensors(indx,:)=[round(p_x);round(p_y);hs];
            end
        end
        rand_perm=randperm(ceilpower^2);
        Sensors(rand_perm(1:(ceilpower^2-Num_sensors)),:,:)=[];
    end
end
