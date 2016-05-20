
opts_fields = fields( opts );
varargin=[];
for i = 1 : numel( opts_fields )   
    
    eval( [ opts_fields{ i } , ' = opts.' , opts_fields{ i } , ';' ] ) ;
    varargin{end+1}=opts_fields{i};
    varargin{end+1}=opts.(opts_fields{i});

end