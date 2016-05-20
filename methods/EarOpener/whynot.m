block_idx=q.block_idx(1:4);
block_idx=cell2mat(block_idx);
markers=q.markers(block_idx);
dev_markers=find(markers==20);
std_markers=find(markers==14);
time=1:64;
channels=1:4:64;
mmn=dev.avg(time);
Reg=0;
Yd=dev.full.avg(channels,time);
Cd=Yd*Yd';
hd=Yd*mmn';
wd=inv(hd'*inv(Cd)*hd)*hd'*inv(Cd);wd=wd';
erp=std.avg(time);
Ys=std.full.avg(channels,time);
Cs=Ys*Ys';
hs=Ys*erp';
ws=inv(hs'*inv(Cs)*hs)*hs'*inv(Cs);ws=ws';

for i=1:numel(dev_markers)
   
    X=q.data.trial{dev_markers(i)}(channels,time);
   
    %w=inv(X*X')*X*mmn';
%     for j=1:100
%         
%         ww=w+norm(w)*randn;
%         ee(j)=norm(ww'*X-mmn);
%         
%     end    
    %e_dev(i)=mean(ee);
    
    ed_dev(i)=norm(wd'*X/norm(wd'*X)-mmn/norm(mmn));
    es_dev(i)=norm(ws'*X/norm(ws'*X)-erp/norm(erp));
    
end

for i=1:numel(std_markers)
   
    X=q.data.trial{std_markers(i)}(channels,time);
   
    %w=inv(X*X')*X*mmn';
%     for j=1:100
%         
%         ww=w+norm(w)*randn;
%         ee(j)=norm(ww'*X-mmn);
%         
%     end    
%     e_std(i)=mean(ee);

    ed_std(i)=norm(wd'*X/norm(wd'*X)-mmn/norm(mmn));
    es_std(i)=norm(ws'*X/norm(ws'*X)-erp/norm(erp));
    
end