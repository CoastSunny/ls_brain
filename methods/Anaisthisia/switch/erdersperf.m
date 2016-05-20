for si=1:10
    fprintf(num2str(si));
    
    dmdsav1{si}=dec_methods(zerd1{si},60,-1,1,'asynch_dec_sav',1);
    dmdsav2{si}=dec_methods(zerd2{si},60,-1,1,'asynch_dec_sav',1);
    dmdsav3{si}=dec_methods(zerd3{si},60,-1,1,'asynch_dec_sav',1);
    dmdnrow1{si}=dec_methods(zerd1{si},60,-1,1,'asynch_dec_nrow',1);
    dmdnrow2{si}=dec_methods(zerd2{si},60,-1,1,'asynch_dec_nrow',1);
    dmdnrow3{si}=dec_methods(zerd3{si},60,-1,1,'asynch_dec_nrow',1);
    
end

outsav1=calperf(dmdsav1,'out','dec');
outsav2=calperf(dmdsav2,'out','dec');
outsav3=calperf(dmdsav3,'out','dec');

outnrow1=calperf(dmdnrow1,'out','dec');
outnrow2=calperf(dmdnrow2,'out','dec');
outnrow3=calperf(dmdnrow3,'out','dec');