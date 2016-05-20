clear col_gof col_dur col_comb col_wei tmp col_subj
for i=1:11
col_gof(i,:)=[LSD60(i,1) LSD60(i,1) LSD60(i,2) LSD60(i,2) LSD60(i,2) LSD60(i,3) LSD60(i,3) LSD60(i,4) LSD60(i,4) LSD150(i,1) LSD150(i,1) LSD150(i,2) LSD150(i,2) LSD150(i,2) LSD150(i,3) LSD150(i,3) LSD150(i,4) LSD150(i,4) LSD240(i,1) LSD240(i,1) LSD240(i,2) LSD240(i,2) LSD240(i,2) LSD240(i,3) LSD240(i,3) LSD240(i,4) LSD240(i,4)];
end

col_gof=col_gof';
col_gof=col_gof(:);

col_dur=[60 60 60 60 60 60 60 60 60 150 150 150 150 150 150 150 150 150 240 240 240 240 240 240 240 240 240];
col_dur=repmat(col_dur,1,11);

col_comb=[1 1 2 2 2 3 3 4 4];
col_comb=repmat(col_comb,1,33);

for i=1:11
Y(i,:)=[X{i}{1};X{i}{4};X{i}{7};X{i}{10};X{i}{2};X{i}{5};X{i}{8};X{i}{11};X{i}{3};X{i}{6};X{i}{9};X{i}{12}];
end
Z=Y';

col_wei=Z(:);

for i=1:11
tmp(i,:)=repmat(i,1,27);
end
tmp=tmp';
col_subj=tmp(:);
BIGTABLE(:,1)=col_gof;
BIGTABLE(:,2)=col_wei;
BIGTABLE(:,3)=col_dur;
BIGTABLE(:,4)=col_comb;
BIGTABLE(:,5)=col_subj;
wA60=BIGTABLE(3:27:end,2);
wS60=BIGTABLE(4:27:end,2);
wU60=BIGTABLE(5:27:end,2);
wA150=BIGTABLE(12:27:end,2);
wS150=BIGTABLE(13:27:end,2);
wU150=BIGTABLE(14:27:end,2);
wA240=BIGTABLE(21:27:end,2);
wS240=BIGTABLE(22:27:end,2);
wU240=BIGTABLE(23:27:end,2);