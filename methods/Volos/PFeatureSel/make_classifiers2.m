
out=[];
thetap=[];
thetan=[];
Fp=[];
Fn=[];
for i=1:size(channels,2)
    
    for j=1:size(time,2)
    
    out{i,j}=S.default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,'time',j,'channels',i,'filterdat','no','objFn','klr_cg','detrenddat','no');
    thetap{i,j}=[ out{i,j}.rp mean(out{i,j}.f(out{i,j}.labels==1)) std(out{i,j}.f(out{i,j}.labels==1)) ];
    thetan{i,j}=[ out{i,j}.rn mean(out{i,j}.f(out{i,j}.labels==-1)) std(out{i,j}.f(out{i,j}.labels==-1)) ];
    Fp{i,j}=out{i,j}.f(out{i,j}.labels==1)';
    Fn{i,j}=out{i,j}.f(out{i,j}.labels==-1)';
    Rp(i,j)=out{i,j}.rp;
    Rn(i,j)=out{i,j}.rn;
    
    end
    
end

