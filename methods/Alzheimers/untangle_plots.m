
for i=1:numel(SIMCOOL)

    e_orig(i)=mean(SIMCOOL{i}{1}{1});
    e_opt(i,:)=mean(SIMCOOL{i}{2}{1},2);
    re_opt(i,:)=(SIMCOOL{i}{3}{1});
    
end