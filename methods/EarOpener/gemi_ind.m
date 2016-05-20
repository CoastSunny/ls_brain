function [res]=gemi_ind( target , name, classes)

members=properties(target);
idx=strmatch('all',members);
members(idx)=[];
for i=1:numel(members)
if ( strcmp( class( target.( members{ i } ) ) , 'Subject' ) && ~strcmp( members{ i } , 'all' ) )
    
    target.(members{i}).default.train_classifier('name',name,'classes',classes);
    rate(i)=max(target.(members{i}).default.(name).res.tstbin);
    
end
end

res.rate=rate;

end