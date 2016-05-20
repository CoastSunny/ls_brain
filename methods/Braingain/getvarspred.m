function [s1 s2]  = getvarspred(S)

test1_idxs=find(S.default.markers==10 | S.default.markers==11);
test2_idxs=find(S.default.markers==20 | S.default.markers==21);

selections=find(S.default.markers==241);
selections1=selections(1:12);
selections2=selections(13:24);

s1=diff(selections1)-1;
s1=[75 s1'];
s2=diff(selections2)-1;
s2=[75 s2'];

end
