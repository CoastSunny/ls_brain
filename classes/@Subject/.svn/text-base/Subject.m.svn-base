classdef Subject < dynamicprops
    
    %GROUP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties ( GetAccess = public , SetAccess = private )
        subject_name
    end
    
    methods
        
        function delete(obj)
            % obj is always scalar
            ...
        end
    
    function obj = Subject( varargin )
        
        if (nargin>0)
            
            opts = struct(...
                'name' , [] , 'subject_path' , [] , 'bdf_files_paths' , [] , ...
                'markers' , '?' , 'cfg' , [] , 'store' , 'no' , 'dataset_name', 'default' ) ;
            [ opts ] = parseOpts( opts , varargin );
            opts2var
            
            if (isempty(bdf_files_paths)) %%%fext etccccc
                bdf_files_paths=rdir(strcat(subject_path,'**/*.bdf'));
               
                if (isempty(bdf_files_paths))
                    bdf_files_paths=rdir(strcat(subject_path,'**/*.gdf'));
                    
                end
                if (isempty(bdf_files_paths))
                    bdf_files_paths=rdir(strcat(subject_path,'**/*/samples'));
                    
                end
                for i=1:length(bdf_files_paths)
                    paths{i}=bdf_files_paths(i).name;
                end
            end
            paths = sort_nat( paths );
            paths(:)
            fclose('all');
            %            here=pwd;
            %             cd(subject_path);
            %
            %             if (exist('./ls_bci')==0)
            %                 mkdir ls_bci;
            %             end
            %
            %             cd ls_bci;
            
            if (nargin>0)
                
                        obj.addprop(dataset_name);
                        q = Dataset( 'paths', paths , 'marker' , markers , 'cfg', cfg );
                        obj.( dataset_name ) = q;
                        obj.( dataset_name ).full_name = strcat( name , '-dataset-', dataset_name );
                        obj.( dataset_name ).dataset_name = dataset_name;
                        obj.subject_name = name;              
                
            end
            
            %    cd(here)
            
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

