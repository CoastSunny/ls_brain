classdef Group < dynamicprops
    %GROUP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       
    end
    
    methods
        
        function obj = Group( varargin  )
            
            if ( nargin > 0 )
                
                opts = struct(...
                    'names' , [] , 'subjects_paths' , [] , ...
                    'markers' , {{'?'}} , 'cfg' , [] ,'dataset_name' , 'default' ) ;
                
                [ opts  ] = parseOpts( opts , varargin );
                opts2var
                
                fclose('all');
                
                for i=1:length( names )
                    
                    names{ i }
                    obj.addprop( names{ i } );
                    obj.( names{ i } ) = Subject( 'name', names{ i } ,...
                        'subject_path', subjects_paths{ i } , 'bdf_files_paths', [] ,...
                        'markers' , markers , 'cfg' , cfg  );
                    
                end
                
            end
            
        end
        
        function train_classifiers( obj , varargin )
            
            opts = struct( ...
                'name'    , 'test' , ...
                'classes' , [] , ...
                'classes_outer', [] , ...
                'target_labels', [-1 +1] , ...
                'blocks_in'  , 'all' , ...
                'blocks_outer', 'none' , ...
                'channels' , 'all' , ...
                'time' , 'all' , ...
                'freqband' , [0.1 20] , ...
                'frequency_transform' , 'none' , ...
                'times_in', [] , ...
                'freqs_in' , [] , ...
                'nfolds' , 10 , ...
                'vis' , 'off' , ...
                'cleverstuff' , 'stupid' , ...
                'method' , 'time', ...
                'dim' , 3, ...
                'trials' , 'all' , ...
                'dataset_name' , 'default' ) ;
            [ opts ] = parseOpts( opts , varargin ) ;
            opts2var
            members=properties( obj );
            for i=1:length( members )
                
                try
                    obj.( members{ i } ).(dataset_name).train_classifier( varargin );
                    
                    temp=strcat( name , '_res' );
                    try obj.addprop( temp );
                    catch err
                    end
                    obj.( temp )( i )=max( obj.( members{ i } ).( dataset_name ).(name).res.tstbin );
                    
                catch err
                end
                
            end
            
        end               
        
        function new = copy(obj)
            
            new = feval(class(obj));
            
            members = properties(obj);
            for i = 1:length(members)
                try new.addprop(members{i})
                catch err
                end
                new.(members{i}) = obj.(members{i});
            end
        end
        
        
    end
    
end

