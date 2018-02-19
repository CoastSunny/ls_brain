cd ~/Desktop
for i=1:9
    
    res.(['metric' num2str(i)])=load(['Res0' num2str(i) '.mat']);
    P2(i,:)=res.(['metric' num2str(i)]).Result(1,:);
    P1(i,:)=res.(['metric' num2str(i)]).Result(2,:);
    MV(i,:)=res.(['metric' num2str(i)]).Result(3,:);
    
end

for i=1:9
    
    res.(['metric' num2str(i)])=load(['Res0' num2str(i) 'n2.mat']);
    P2n2(i,:)=res.(['metric' num2str(i)]).Result(1,:);
    P1n2(i,:)=res.(['metric' num2str(i)]).Result(2,:);
    MVn2(i,:)=res.(['metric' num2str(i)]).Result(3,:);
    
end



