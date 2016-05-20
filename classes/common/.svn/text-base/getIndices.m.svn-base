function [indices classlength labels] = getIndices(obj,classes,blocks_out,trials)

classlength = zeros( size( classes , 1 ) , 1 ) ;
labels = [] ;

for i = 1 : size( classes , 1 )
    
    for j = 1 : numel( classes{ i } )
        
        try
            indices{ i , j } = find( obj.markers == classes{ i }{ j } ) ;
        catch err
            indices{ i , j } = find( obj.markers == classes{ i } ) ;
        end
       
        
        for k=1:numel(blocks_out)
            
            indices{i,j}=setdiff(indices{i,j},obj.block_idx{blocks_out(k)});
            
        end
        
        indices{ i , j } = reshape( indices{ i , j } , 1 , numel( indices{ i , j } ) ) ;
        classlength( i ) = classlength( i ) + numel( indices{ i , j } ) ;
    end
    
    labels = [labels (-1)^i*ones( 1 , classlength(i) ) ];%change for >2 classes?????
    
end

indices=indices';
indices=indices(:);
emptyCells = cellfun(@isempty,indices);
indices(emptyCells) = [];
indices=cell2mat(indices');
if ( ~strcmp(trials,'all') )
            indices=indices(trials);
            labels=labels(trials);
            classlength(1)=numel(labels)/2;
            classlength(2)=numel(labels)/2;
end
