function combine_subjects( obj , varargin)

     if ( nargin > 0 )
            
            opts = struct( ...
                'name' , 'all' , ...
                'dataset_name' , 'default' , 'exclusion' , {'all'} , 'markers', []) ;
            [ opts ] = parseOpts( opts , varargin ) ;
            opts2var
            
            members = properties( obj );           
            members = sort_nat( members );
            
            if( ~isempty( exclusion ) )                                
                
                if ( iscell(exclusion) && numel( exclusion ) >1 )
                    
                    for i = 1 : numel( exclusion )

                        idx = strmatch( exclusion{ i } , members ,'exact') ;
                        members( idx ) = [] ;

                    end 
                    
                else
                    
                    idx = strmatch( exclusion , members ,'exact') ;
                    members( idx ) = [] ;
                    
                end
                
            end
            
            try obj.addprop( name ) 
                
                obj.( name ) = Subject;
                
            catch err
                 obj.( name ) = Subject;
            end
            
            try obj.( name ).addprop( dataset_name );
                
                obj.( name ).( dataset_name ) = Dataset;
                
            catch err
                obj.( name ).( dataset_name ) = Dataset;
            end
            
            command='';
            for i = 1 : numel( members )
                
                if ( strcmp( class( obj.( members{ i } ) ) , 'Subject' ) ) 
                   
                   command = strcat( command , ',obj.',members{ i },'.',dataset_name,'.data');
                    
                end
            
            end
            
            eval([ 'obj.(name).(dataset_name).data=ft_appenddata([]',command,');']);
            obj.(name).(dataset_name).markers=obj.(name).(dataset_name).data.trialinfo;
            obj.(name).(dataset_name).markers_list = unique(obj.(name).(dataset_name).markers);
                       
            for i=1:numel(members)
                try temp=obj.(name).(dataset_name).block_idx{end}(end);
                catch err
                    temp=0;
                end
                temp2=numel(obj.(name).(dataset_name).block_idx);
                for j=1+temp2:numel(obj.(members{i}).default.block_idx)+temp2
                    obj.(name).(dataset_name).block_idx{j}=obj.(members{i}).default.block_idx{j-temp2}+temp;
                end
            end                                    
            
     end

end