function out = auc( obj , varargin )

opts = struct( ...
    'name'    , 'test' , ...
    'classes' , [] , ...
    'blocks_in'  , 'all' , ...
    'channels' , 'all' , ...
    'time' , 'all' , ...
    'trials' , 'all', ...
    'vis', 'on' ) ;
[ opts ] = parseOpts( opts , varargin ) ;
if (nargin>1)
    
    opts2var
    
    [time channels]=convertall2var(obj,time,channels);
    [blocks_in blocks_excluded]=getBlocks(obj,blocks_in);
    [indices classlength labels]=getIndices(obj,classes,blocks_excluded,trials);
    X=cat(3,obj.data.trial{indices});
    X=X(channels,time,:);
    dim=ndims(X);
    out = dv2auc(labels,X,dim);
    if(strcmp(vis,'on'))
    figure,imagesc(out),xlabel('time'),ylabel('channel');
    end
    
end

end
