function [cir] = downsampling_cir(cir,delays,Delay_interval,Num_sensors,Time_samples)

            % Get the number of taps or multipath components obtained in
            % the cir
            
            Num_taps = size(delays,2);
            Num_rx_elements = size(cir{1,1}(:,:,:,:),1);
            Num_tx_elements = size(cir{1,1}(:,:,:,:),2);
            
            % Get the value of the highest delay value obtained
            max_delay_sample = max(max(delays));
            
            % Create a vector with the desired delay values (grid points)
            delay_grid = [0:Delay_interval:max_delay_sample];
            
            % To add an extra delay sample if required
            if delay_grid(end) <= max_delay_sample
                delay_grid = [delay_grid (delay_grid(end) + Delay_interval)];
            end
            
            % Create a temporal cir matrix to store the new CIR values at
            % the new delays as there can be more or less multipath components. Currently only one target is assumed, if more
            % targets, we need to change the 1 for Num_targets
%             cir_temp = zeros(Num_sensors,1,Num_rx_elements,Num_tx_elements,length(delay_grid),Time_samples);
            cir_temp = cir; 
            
            for xx1 = 1:1:Num_sensors   % For each sensor
                for xx2 = 1:1:1         % For each target
                    % Check if there is any NaN values in cir for this
                    % sensor and target link. If there is we set it equal
                    % to zero because we assume the value received was very
                    % small
                    cir{xx1,xx2}(isnan(cir{xx1,xx2}))=0;
                    
                    for xx4 = 1:1:Time_samples      % For each time sample
                        
                        amplitude_tmp = zeros(size(cir{xx1,xx2}(:,:,:,:),1),size(cir{xx1,xx2}(:,:,:,:),2),length(delay_grid));
                        
                        % Get the number of taps or multipath components obtained in
                        % the cir
                        Num_taps = size(cir{xx1,xx2},3);
                        
                        for xx3= 1:1:Num_taps   % For each multipath component
                            [~, delay_ind] = min(abs(delays(xx1,xx3) - delay_grid));    % Here we calculate the distances in time between a specific delay and the desired delay and we take the shortest
                            
                            amplitude_tmp(:,:,delay_ind) = amplitude_tmp(:,:,delay_ind) + cir{xx1,xx2}(:,:,xx3,xx4);     % We store or add (if already a multipath component was placed here) the multipath coefficient to the new delay
                        end
                        
                        for tt=1:1:length(delay_grid)
                            cir_temp{xx1,xx2}(:,:,tt,xx4) = amplitude_tmp(:,:,tt);     % The new multipath coefficients calculated for each new delay are put into the temporal cir matrix
                        end
                    end
                end
            end
            
            % Now the old cir is changed to the temporal cir. The resulting
            % cir now has different delays and multipath coefficient
            % values. The delay matrix does not need to change as long as
            % we keep in mind that the delay_grid vector are the new delays
            % valid for all sensors. 
            
            % *CAUTION: Originally, the delay matrix
            % could have different delay values for each multipath
            % component and for each sensor, but now, we are forcing the
            % delays to be exactly a multiple value of Delay_interval.
            
            cir = cir_temp;
            
           
%             for ii=1:1:Num_sensors
%                 cir{ii,1} = cir_temp(ii,1,:,:,:,:);
%             end
end