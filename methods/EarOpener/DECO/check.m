JA=0;JB=0;JC=0;JD=0;JE=0;JF=0;JG=0;
NJA=0;NJB=0;NJC=0;NJD=0;NJE=0;NJF=0;NJG=0;
for i=1:4
    
    JA=JA+X{i}{8};
    JB=JA+X{i}{9};
    JC=JC+X{i}{10};
    JD=JD+X{i}{11};
    JE=JE+X{i}{12};
    JF=JF+X{i}{13};
    JG=JG+X{i}{7};
    
end
JA=JA/4;JB=JB/4;JC=JC/4;JD=JD/4;JE=JE/4;JF=JF/4;JG=JG/4;
for i=5:10

    NJA=NJA+X{i}{8};
    NJB=NJA+X{i}{9};
    NJC=NJC+X{i}{10};
    NJD=NJD+X{i}{11};
    NJE=NJE+X{i}{12};
    NJF=NJF+X{i}{13};
    NJG=NJG+X{i}{7};

end
NJA=NJA/6;NJB=NJB/6;NJC=NJC/6;NJD=NJD/6;NJE=NJE/6;NJF=NJF/6;NJG=NJG/14;

JA2=0;JB2=0;JC2=0;JD2=0;JE2=0;JF2=0;JG2=0;
NJA2=0;NJB2=0;NJC2=0;NJD2=0;NJE2=0;NJF2=0;NJG2=0;

for i=1:4
    
    JA2=JA2+X{i}{14};
    JB2=JB2+X{i}{15};
    JC2=JC2+X{i}{16};
    JD2=JD2+X{i}{17};
    JE2=JE2+X{i}{18};
    JF2=JF2+X{i}{19};
    JG2=JG2+X{i}{20};
    
end
JA2=JA2/4;JB2=JB2/4;JC2=JC2/4;JD2=JD2/4;JE2=JE2/4;JF2=JF2/4;JG2=JG2/4;
for i=5:10

    NJA2=NJA2+X{i}{14};
    NJB2=NJB2+X{i}{15};
    NJC2=NJC2+X{i}{16};
    NJD2=NJD2+X{i}{17};
    NJE2=NJE2+X{i}{18};
    NJF2=NJF2+X{i}{19};
    NJG2=NJG2+X{i}{20};

end
NJA2=NJA2/6;NJB2=NJB2/6;NJC2=NJC2/6;NJD2=NJD2/6;NJE2=NJE2/6;NJF2=NJF2/6;NJG2=NJG2/4;