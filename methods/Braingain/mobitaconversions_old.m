
clear target_idx test1_idx test2_idx
target_idx=find(S.default.markers==51 | S.default.markers==52 | S.default.markers==53 | S.default.markers==54 | S.default.markers==55 | S.default.markers==56);
target_idx(end+1)=target_idx(end)+36;
for i=1:numel(target_idx)-1
    
    S.default.markers(target_idx(i)+1:target_idx(i+1)-1)=S.default.markers(target_idx(i)+1:target_idx(i+1)-1)==S.default.markers(target_idx(i))+50;

end

z=[105 102];
o=[103 102];
e=[101 104];
k=[102 104];
n=[103 101];
sel=[z(1) z(2) o(1) o(2) e(1) e(2) k(1) k(2) e(1) e(2) n(1) n(2)];

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
j=[102 102];
a=[101 106];
g=[102 106];
u=[104 102];
r=[103 105 ];
sel=[j(1) j(2) a(1) a(2) g(1) g(2) u(1) u(2) a(1) a(2) r(1) r(2)];
%test2 12 selections
for i=1:12
    
    S.default.markers(test2_idx(i)+1:test2_idx(i+1)-1)=20;%S.default.markers(test2_idx(i)+1:test2_idx(i+1)-1)==sel(i);
    %S.default.markers(test2_idx(i)+1:test2_idx(i+1)-1)=S.default.markers(test2_idx(i)+1:test2_idx(i+1)-1)+20;
end
