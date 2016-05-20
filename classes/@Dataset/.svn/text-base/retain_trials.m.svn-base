function retain_trials(obj,varargin)

if ( nargin > 0 )
    
    opts = struct( ...     
        'markers' , []  ) ;
    [ opts ] = parseOpts( opts , varargin ) ;
    opts2var
    
    for i=1:numel(markers)
        
        idxs{i} = find(obj.markers==markers{i});
        
    end
    
    cfg.trials=cell2mat(idxs(:));
    obj.data=ft_preprocessing(cfg,obj.data);
    obj.markers = obj.data.trialinfo;
    obj.markers_list = unique(obj.markers);
    
    
end

end
