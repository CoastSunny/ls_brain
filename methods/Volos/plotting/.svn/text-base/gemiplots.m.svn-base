subjects = { 'JPsv02' , 'JPsv04' , 'JPsv05' , 'JPsv08' , 'JPsv09' , 'JPsv11' };
markers = {'21'};
lscfg.averaging = 'yes' ;
lscfg.ica = 'no' ;
t = ( -306:1024 ) / 2048; 
col = { 'r' , 'g' , 'b'  ,'k', 'c' , 'm'} ;

for i=1:length ( subjects )
    
    lscfg.subject=subjects { i };
    
    for j=1:length ( markers )
     
        lscfg.markers = markers { j } ;
        R = ls_subjectanalysis ( lscfg ) ; 
        eval ( [ lscfg.subject , 'E' , lscfg.markers , ' =R.average;' ] ) ;
                              
    end
    figure ( 1 ) , hold on, plot ( t,mean(R.average.avg) ,col{i})%,eval ( [ lscfg.subject , 'E21' ]) , eval ( [ lscfg.subject , 'E22' ]) ) ;   
end

subjects={'NLsv01','NLsv03','NLsv04','NLsv07','NLsv08','NLsv09'};


for i=1:length ( subjects )
    
    lscfg.subject=subjects { i };
    
    for j=1:length ( markers )
     
        lscfg.markers = markers { j } ;
        R = ls_subjectanalysis ( lscfg ) ; 
        eval ( [ lscfg.subject , 'E' , lscfg.markers , ' =R.average;' ] ) ;
                   
    end
    figure ( 2 ) , hold on , plot ( t, mean(R.average.avg) ,col{i} )%,eval ( [ lscfg.subject , 'E21' ]) , eval ( [ lscfg.subject , 'E22' ]) ) ;   
end