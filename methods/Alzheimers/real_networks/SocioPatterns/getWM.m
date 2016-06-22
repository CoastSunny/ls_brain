
nlines=size(HighSchooldata2013,1);

nodes=max(numel(unique(cell2mat(HighSchooldata2013(:,2)))),numel(unique(cell2mat(HighSchooldata2013(:,3)))));
id_stu=unique(cell2mat(HighSchooldata2013(:,2)));
id_class=unique(HighSchooldata2013(:,4));
W=zeros(nodes);
for i=1:nlines
    
    entry=HighSchooldata2013(i,:);
    e1=find(id_stu==entry{2});
    e2=find(id_stu==entry{3});
    c1=find(strcmp(id_class,entry(4)));
    c2=find(strcmp(id_class,entry(5)));
    W(e1,e2)=W(e1,e2)+1;
    if c1==c2
        M(e1,e2)=1;
    else
        M(e1,e2)=0;
    end
    
end
W=W+W.';

A=zeros(nodes);
alines=size(Friendshipnetworkdata2013,1);

for i=1:alines

    entry=Friendshipnetworkdata2013(i,:);
    e1=find(id_stu==entry(1));
    e2=find(id_stu==entry(2));
    A(e1,e2)=1;
end