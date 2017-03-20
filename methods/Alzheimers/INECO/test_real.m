
tcount=0;FF=[];EE=[];
for ncomps=5:5:25
    tcount=tcount+1;
    INECO_tensorfact_complex_noep
    FF{tcount}=FT;
    EE{tcount}=EV;    
end