function [Sensors] = sensor_positioning_v2(Type_Scenario,Size_Scenario,Size_FZ1_x,Size_FZ1_y,Size_FZ2_x,Size_FZ2_y,Num_sensors,hs)

    if Type_Scenario == 0
        
           
        Start_FZ1_x = Size_Scenario - Size_FZ1_x;
        Start_FZ1_y = 0;
        
        Start_FZ2_x = 0;
        Start_FZ2_y = Size_Scenario - Size_FZ2_y;
        
        if mod(Num_sensors,2) == 0  % Check if Number of sensors is even or odd. If it is even, then the same amount of sensors will go to FZ1 that in FZ2, but if it is odd, then 1 more sensor will go into FZ1
            Sep_sensors_1 = ceil(Size_FZ1_y/(floor(Num_sensors/2)));
        else
            Sep_sensors_1 = ceil(Size_FZ1_y/(ceil(Num_sensors/2)));
        end
        
        Sep_sensors_2 = ceil(Size_FZ2_x/(floor(Num_sensors/2)));


        Sensors = zeros(Num_sensors,3);


        % Positioning the sensors with origin of coordinates on the left lower
        % corner of the scenario. The data stored is the distance of the sensor to
        % the origin of coordinates in metres.
        indx = 0;
        if Num_sensors == 2;
            
            Sensors(1,:) = [round(Start_FZ1_x + (Size_Scenario - Start_FZ1_x)/2),round(Start_FZ1_y+Sep_sensors_1/2),hs];
        
        else
        
        
            if Start_FZ1_x+Sep_sensors_1/2 > Size_Scenario
                        p_x = Start_FZ1_x + (Size_Scenario - Start_FZ1_x)/2;
                for p_y=Start_FZ1_y+Sep_sensors_1/2:Sep_sensors_1:Size_Scenario-Sep_sensors_1/2

                    indx = indx + 1;

                    Sensors(indx,:)=[round(p_x);round(p_y);hs];
                end

            else

                for p_x=Start_FZ1_x+Sep_sensors_1/2:Sep_sensors_1:Size_Scenario-Sep_sensors_1/2
                    for p_y=Start_FZ1_y+Sep_sensors_1/2:Sep_sensors_1:Size_Scenario-Sep_sensors_1/2

                        indx = indx + 1;

                        Sensors(indx,:)=[round(p_x);round(p_y);hs];
                    end
                end

            end
        end
        
        if Num_sensors == 2;
            
            Sensors(2,:) = [round(Start_FZ2_x+Sep_sensors_2/2),round(Start_FZ2_y + (Size_Scenario - Start_FZ2_y)/2),hs];
        
        else

            if Start_FZ2_y+Sep_sensors_2/2 > Size_Scenario
                p_y = Start_FZ2_y + (Size_Scenario - Start_FZ2_y)/2;

                    for p_x=Start_FZ2_x+Sep_sensors_2/2:Sep_sensors_2:Start_FZ1_x-Sep_sensors_2/2

                        indx = indx + 1;

                        Sensors(indx,:)=[round(p_x);round(p_y);hs];
                    end
            else

                for p_x=Start_FZ2_x+Sep_sensors_2/2:Sep_sensors_2:Start_FZ1_x-Sep_sensors_2/2
                    for p_y=Start_FZ2_y+Sep_sensors_2/2:Sep_sensors_2:Start_FZ1_y-Sep_sensors_2/2

                        indx = indx + 1;
                        Sensors(indx,:)=[round(p_x);round(p_y);hs];
                    end
                end
            end
        end
        
        
        
    else

        % If type of Scenario is 1, the enemy and friend areas are mixed and
        % cover all the scenario area
        
        % First we need to know how the sensors will be distributed in the
        % scenario. This is done by first checking if the residual of the
        % sqrt(number of sensors) is 0. This means that the sensors can be
        % placed in a squared distribution. If not, we need to know the
        % number of columns and rows where the sensors are placed, and
        % then, finally the separation between each of them in the columns
        % and rows.
        
        odd = false;
        
        Sensors = zeros(Num_sensors,3);
        
        if Num_sensors <= 3
            if Num_sensors == 2
                Sep_sensors = Size_Scenario/2;
                Sensors(1,:) = [round(Size_Scenario/2),round(Sep_sensors/2),hs];
                Sensors(2,:) = [round(Size_Scenario/2),round(Sep_sensors/2+Sep_sensors),hs];
            else
                Sep_sensors = Size_Scenario/3;
                Sensors(1,:) = [round(Size_Scenario/2),round(Sep_sensors/2),hs];
                Sensors(2,:) = [round(Size_Scenario/2),round(Sep_sensors/2+Sep_sensors),hs];
                Sensors(3,:) = [round(Size_Scenario/2),round(Sep_sensors/2+2*Sep_sensors),hs];
            end
        else
        
        [X,residual] = sqrtm(Num_sensors);
            
            if residual == 0
                rows = X;
                cols = X;
            else
                f = factor(Num_sensors);    % Check what numbers can be multiplied to obtain the Number of sensors
                
                if length(f) == 1     % If there is only one, then it is likely to be an odd number or a prime number
                    
                    f = factor(Num_sensors-1);   % This will give us how to get the even distribution and then we just add an extra sensor right in the middle
                    odd = true;
                    
                    if length(f) == 2     % If it is size 2 then rows and cols are first and second dimension
                        
                    	rows = f(1);
                        cols = f(2);
                        
                    else        % If size is larger than 2 we need to converge the higher dimensions into just 2 dimensions 1 for rows and 1 for cols
                        
                        if mod(length(f),2) == 0      % If the size of the f vector is even, then the rows are the product of half of the first factors and the cols are the product of the other half.
                            rows = prod(f(1:end/2));
                            cols = prod(f((end/2)+1:end));
                        else
                            rows = prod(f(1:(end/2)+1));
                            cols = prod(f((end/2)+2:end));
                        end
                        
                    end
                    
                elseif length(f) == 2     % If the size is 2 take the values as rows and columns
                    
                    rows = f(1);
                    cols = f(2);
                        
                elseif length(f) > 2      % Here, probably it is larger than 2 because contains repeated factors therefor just need to multiply them
                    
                    if mod(length(f),2) == 0      % If the size of the f vector is even, then the rows are the product of half of the first factors and the cols are the product of the other half.
                        rows = prod(f(1:end/2));
                        cols = prod(f((end/2)+1:end));
                    else
                        rows = prod(f(1:(end/2)+1));
                        cols = prod(f((end/2)+2:end));
                    end
                    
                end
                
            end

        Sep_sensors_1 = Size_Scenario/rows;
        Sep_sensors_2 = Size_Scenario/cols;
                           
        indx = 0;
        for p_x=0+Sep_sensors_1/2:Sep_sensors_1:Size_Scenario-Sep_sensors_1/2
            for p_y=0+Sep_sensors_2/2:Sep_sensors_2:Size_Scenario-Sep_sensors_2/2

                indx = indx + 1;

                Sensors(indx,:)=[round(p_x);round(p_y);hs];
            end
        end
        
        if odd == true
            Sensors(indx+1,:) = [round(Size_Scenario/2);round(Size_Scenario/2);hs];
            
        end

        end
                
    end

end
