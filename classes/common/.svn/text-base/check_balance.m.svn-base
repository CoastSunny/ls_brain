function out=check_balance(source_object,target_object,name,classes,target_labels,blocks_in,channels,time,W)
S=source_object;
T=target_object;
c1_rate=[];c2_rate=[];
b=-4:.1:4;
for bias=b

%tmp=S.apply_classifier( T,'name',name,'classes',classes,'target_labels',target_labels,'blocks_in',blocks_in,'channels',channels,'time',time,'bias',bias);
tmp=S.apply_classifier( T,'name',name,'classes',classes,'target_labels',target_labels,'blocks_in',blocks_in,'channels',channels,'time',time,'bias',bias,'W',W);
c1_rate(end+1)=tmp.rate(1);
c2_rate(end+1)=tmp.rate(2);

end

out.c1_rate=c1_rate;
out.c2_rate=c2_rate;
out.bias=b;

end