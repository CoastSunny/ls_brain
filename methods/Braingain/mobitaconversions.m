
clear target_idx test1_idx test2_idx
target_idx=find(S.default.markers==51 | S.default.markers==52 | S.default.markers==53 | S.default.markers==54 | S.default.markers==55 | S.default.markers==56);
target_idx(end+1)=target_idx(end)+36;

for i=1:numel(target_idx)-1
    
    S.default.markers(target_idx(i)+1:target_idx(i+1)-1)=S.default.markers(target_idx(i)+1:target_idx(i+1)-1)==S.default.markers(target_idx(i))+50;

end

beg_test1=target_idx(end);
test1_idx(1)=beg_test1-1;
temp=find(S.default.markers==241);
test1_idx=[test1_idx temp(1:12)'];

%test1 12 selections
for i=1:12
    
    S.default.markers(test1_idx(i)+1:test1_idx(i+1)-1)=10;%S.default.markers(test1_idx(i)+1:test1_idx(i+1)-1)==sel(i);
    %S.default.markers(test1_idx(i)+1:test1_idx(i+1)-1)=S.default.markers(test1_idx(i)+1:test1_idx(i+1)-1)+10;
end

beg_test2=test1_idx(end);
test2_idx(1)=beg_test2;
temp=find(S.default.markers==241);
test2_idx=[test2_idx temp(13:24)'];

%test2 12 selections
for i=1:12
    
    S.default.markers(test2_idx(i)+1:test2_idx(i+1)-1)=20;%S.default.markers(test2_idx(i)+1:test2_idx(i+1)-1)==sel(i);
    %S.default.markers(test2_idx(i)+1:test2_idx(i+1)-1)=S.default.markers(test2_idx(i)+1:test2_idx(i+1)-1)+20;
end
