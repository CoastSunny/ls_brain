 function combine_markers( obj , varargin )
           
            opts = struct(...
                'name' , [] , 'markers' , [] , 'noTrialsPerMarker' , 'all' ) ;           
            [ opts ] = parseOpts( opts , varargin );
            opts2var
            members=properties(obj);
            
            try obj.addprop(name);
                
            catch err
                
                delete(obj.(name));
                
            end
            
            obj.(name)=Dataset;
            
            command='';
            tempcfg.trials=noTrialsPerMarker;
            tempcfg.minlength=0;
            
            for i=1:length(markers)
                
               mrk=strcat('marker',num2str(markers(i)));
               
               temp{i}=ft_redefinetrial(tempcfg,obj.(mrk).data);
               
               command=strcat(command,',temp{',num2str(i),'}');
               
              %  command=strcat(command,',obj.marker',num2str(markers(i)),'.data');                
            end
            
            eval([ 'obj.(name).data=ft_appenddata([]',command,');']);
            
            obj.(name).markers=obj.(name).data.trialinfo;
            
            obj.(name).name=strcat(obj.subject_name,'-',name);
            
        end