
%example with names 
DJP.JP01.default.plot('classes',{11},'blocks_in',1:30,'channels', { 'Fz' 'Cz' 'Pz' } )
%example  with numbers
DJP.JP01.default.plot('classes',{11},'blocks_in',1:30,'channels', [ 1:4 13:25 ] )

%combine
DJP.combine_subjects
DJP.combine_subjects('exclusion',{'JP01'})%name all
DJP.combine_subjects('exclusion',{'JP01'},'name','eJP01')
DJP.combine_subjects('exclusion',{'JP02' 'eJP01'},'name','eJP01')%%<<<<=----careful!!!

%delete
delete(findprop(DJP,'eJP01'))