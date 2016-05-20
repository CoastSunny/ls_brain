
Subjects={'VPP1' 'VPP2' 'VPP3' 'VPP6' 'VPP7' 'VPP8' };
res=[];
for i=Subjects
   
    load(char(i))
    test
    res(end+1,:)=Rfull-min(Rfull);
    
end