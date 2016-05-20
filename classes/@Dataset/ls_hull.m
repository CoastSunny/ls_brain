function out = ls_hull(obj,varargin)

opts = struct( ...
    'name'    , 'test' , ...
    'classes' , [] , ...
    'blocks_in'  , 'all' , ...
    'blocks_outer', 'none' , ...
    'channels' , 'all' , ...
    'time' , 'all' , ...
    'dim' , 3, ...
    'trials' , 'all') ;
[ opts ] = parseOpts( opts , varargin ) ;
opts2var

[time channels]=convertall2var(obj,time,channels);
[blocks_in blocks_excluded]=getBlocks(obj,blocks_in);
[indices classlength labels]=getIndices(obj,classes,blocks_excluded,trials);

X=cat(3,obj.data.trial{indices});
X=X(channels,time,:);
for i=1:numel(indices)
    
    tmp=X(:,:,i)';
    Y(:,i)=tmp(:);
    
end

[hull volume]=convhulln(Y);


out.hull=hull;
out.volume=volume;

end
