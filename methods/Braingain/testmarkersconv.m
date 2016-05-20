test1_idxs=find(S.default.markers==10);
test2_idxs=find(S.default.markers==20);
selections=find(S.default.markers==241);
selections1=selections(1:12);
selections2=selections(13:24);
begtest1=test1_idxs(1);
begtest2=test2_idxs(1);
s1=diff(selections1)-1;
s1=[75 s1'];
s2=diff(selections2)-1;
s2=[75 s2'];

tot_label1=[];
for i=1:12 %i: selection number
    
    if (s1(i)==75)
        tot_label1=[tot_label1 label1{i,1} 0];
    elseif (s1(i)==90)
        tot_label1=[tot_label1 label1{i,2} 0];
    end
    
end


tot_label2=[];
for i=1:12 %i: selection number
    
    if (s2(i)==75)
        tot_label2=[tot_label2 label2{i,1} 0];
    elseif (s2(i)==90)
        tot_label2=[tot_label2 label2{i,2} 0];
    end
    
end

tmp=[];
tmp=S.default.markers(begtest1:begtest1+numel(tot_label1)-1);
tmp(tot_label1==1)=11;
S.default.markers(begtest1:begtest1+numel(tot_label1)-1)=tmp;

tmp=[];
tmp=S.default.markers(begtest2:begtest2+numel(tot_label2)-1);
tmp(tot_label2==1)=21;
S.default.markers(begtest2:begtest2+numel(tot_label2)-1)=tmp;