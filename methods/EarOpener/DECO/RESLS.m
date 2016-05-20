
jp=1:8;
nl=9:16;

RJ1=0;RJ2=0;RJ3=0;
for i=jp
    RJ1=RJ1+R{i}{1};
    RJ2=RJ2+R{i}{2};
    RJ3=RJ3+R{i}{3};
end

RE1=0;RE2=0;RE3=0;
for i=nl
    RE1=RE1+R{i}{1};
    RE2=RE2+R{i}{2};
    RE3=RE3+R{i}{3};
end
    