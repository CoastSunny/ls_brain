clear wA60 wA150 wA240 wS60 wS150 wS240 wU150 wU240 wU60 wU150 BIGTABLE
for channidx=1:numel(included_chan)

clear col_gof col_dur col_comb col_wei tmp col_subj Y  Z
nSubj=16;
separation=7*9;
for i=1:nSubj
col_gof(i,:)=[LSD60(i,channidx,1) LSD60(i,channidx,1) LSD60(i,channidx,2) LSD60(i,channidx,2) LSD60(i,channidx,2) LSD60(i,channidx,3) LSD60(i,channidx,3) LSD60(i,channidx,4) LSD60(i,channidx,4)...
    LSD150(i,channidx,1) LSD150(i,channidx,1) LSD150(i,channidx,2) LSD150(i,channidx,2) LSD150(i,channidx,2) LSD150(i,channidx,3) LSD150(i,channidx,3) LSD150(i,channidx,4) LSD150(i,channidx,4) ...
    LSD240(i,channidx,1) LSD240(i,channidx,1) LSD240(i,channidx,2) LSD240(i,channidx,2) LSD240(i,channidx,2) LSD240(i,channidx,3) LSD240(i,channidx,3) LSD240(i,channidx,4) LSD240(i,channidx,4) ...
    LSD240M(i,channidx,1) LSD240M(i,channidx,1) LSD240M(i,channidx,2) LSD240M(i,channidx,2) LSD240M(i,channidx,2) LSD240M(i,channidx,3) LSD240M(i,channidx,3) LSD240M(i,channidx,4) LSD240M(i,channidx,4) ...
    LSD240L(i,channidx,1) LSD240L(i,channidx,1) LSD240L(i,channidx,2) LSD240L(i,channidx,2) LSD240L(i,channidx,2) LSD240L(i,channidx,3) LSD240L(i,channidx,3) LSD240L(i,channidx,4) LSD240L(i,channidx,4) ...    
    LSDL240(i,channidx,1) LSDL240(i,channidx,1) LSDL240(i,channidx,2) LSDL240(i,channidx,2) LSDL240(i,channidx,2) LSDL240(i,channidx,3) LSDL240(i,channidx,3) LSDL240(i,channidx,4) LSDL240(i,channidx,4) ...
    LSDk(i,channidx,1) LSDk(i,channidx,1) LSDk(i,channidx,2) LSDk(i,channidx,2) LSDk(i,channidx,2) LSDk(i,channidx,3) LSDk(i,channidx,3) LSDk(i,channidx,4) LSDk(i,channidx,4) ...
    ];
end

col_gof=col_gof';
col_gof=col_gof(:);

col_dur=[repmat(60,1,9) repmat(150,1,9) repmat(240,1,9)...
repmat(241,1,9) repmat(242,1,9) repmat(243,1,9)...
repmat(250,1,9)];
col_dur=repmat(col_dur,1,nSubj);

col_comb=[1 1 2 2 2 3 3 4 4];
col_comb=repmat(col_comb,1,nSubj*7);

% X{i}={x60apu x150apu x240apu x240Mapu x240Lapu xL240apu xkapu...
%         x60apspu x150apspu x240apspu x240Mapspu x240Lapspu xL240apspu xkapspu...
%         x60aspu x150aspu x240aspu x240Maspu x240Laspu xL240aspu xkaspu...
%         x60apsu x150apsu x240apsu x240Mapsu x240Lapsu xL240apsu xkapsu...
%         };
    
for i=1:nSubj
Y(i,:)=[X{i}{channidx}{1};X{i}{channidx}{8};X{i}{channidx}{15};X{i}{channidx}{22};...
    X{i}{channidx}{2};X{i}{channidx}{9};X{i}{channidx}{16};X{i}{channidx}{23};...
    X{i}{channidx}{3};X{i}{channidx}{10};X{i}{channidx}{17};X{i}{channidx}{24};...
    X{i}{channidx}{4};X{i}{channidx}{11};X{i}{channidx}{18};X{i}{channidx}{25};...
    X{i}{channidx}{5};X{i}{channidx}{12};X{i}{channidx}{19};X{i}{channidx}{26};...
    X{i}{channidx}{6};X{i}{channidx}{13};X{i}{channidx}{20};X{i}{channidx}{27};...
    X{i}{channidx}{7};X{i}{channidx}{14};X{i}{channidx}{21};X{i}{channidx}{28}];
end
Z=Y';

col_wei=Z(:);

for i=1:nSubj
tmp(i,:)=repmat(i,1,63);
end
tmp=tmp';
col_subj=tmp(:);
BIGTABLE(channidx,:,1)=col_gof;
BIGTABLE(channidx,:,2)=col_wei;
BIGTABLE(channidx,:,3)=col_dur;
BIGTABLE(channidx,:,4)=col_comb;
BIGTABLE(channidx,:,5)=col_subj;
wA60(:,channidx)=BIGTABLE(channidx,3:separation:end,2)';
wS60(:,channidx)=BIGTABLE(channidx,4:separation:end,2)';
wU60(:,channidx)=BIGTABLE(channidx,5:separation:end,2)';
wA150(:,channidx)=BIGTABLE(channidx,12:separation:end,2)';
wS150(:,channidx)=BIGTABLE(channidx,13:separation:end,2)';
wU150(:,channidx)=BIGTABLE(channidx,14:separation:end,2)';
wA240(:,channidx)=BIGTABLE(channidx,21:separation:end,2)';
wS240(:,channidx)=BIGTABLE(channidx,22:separation:end,2)';
wU240(:,channidx)=BIGTABLE(channidx,23:separation:end,2)';

end


% %%% get locs
% import data from biosemi32.lay
% for i=1:32
% q=biosemi32{i};
% Q(i,:)=q(3:20);
% end
% Q=str2num(Q);
% %%% get locs