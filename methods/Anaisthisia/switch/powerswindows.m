baseperiod=[0000 29000];
markerdict=struct('marker',[31 34 37 ],...
    'label', {{'seq_NO1', 'seq_AM1',  'seq_IM1', }});

labels  ={{{'seq1'}}};
varwindows=20+( 1:16:16*6 );
winsummary='1sec windows of 1sec movements baselined';
sliceraw_anthesia_power

labels  ={{{'s_seq1'}}};
varwindows=20+([5:4:14 21:4:30 37:4:46 53:4:62 69:4:78 85:4:94] );
sliceraw_anthesia_power

markerdict=struct('marker',[32 35 38 ],...
    'label', {{'seq_NO3', 'seq_AM3',  'seq_IM3', }});

labels  ={{{'seq3'}}};
varwindows=20+([1:4:9 25:4:34 49:4:58 73:4:82] );
winsummary='1sec windows of 3sec movements baselined';
sliceraw_anthesia_power

labels={{{'s_seq3'}}};
varwindows=20+([13:4:22 37:4:46 61:4:70 85:4:94] );
sliceraw_anthesia_power

markerdict=struct('marker',[33 36 39 ],...
    'label', {{'seq_NO9', 'seq_AM9',  'seq_IM9', }});

labels={{{'seq9'}}};
varwindows=20+([1:4:36 49:4:84 ] );
winsummary='1sec windows of 9sec movements baselined';
sliceraw_anthesia_power

labels={{{'s_seq9'}}};
varwindows=20+([37:4:46 85:4:94] );
sliceraw_anthesia_power



labels={'seq1'};
code_louk_2ds_baseline
mNOM1=mNOM;mIM1=mIM;mAM1=mAM;
paNOM1=paNOM;paIM1=paIM;paAM1=paAM;

labels={'s_seq1'};
code_louk_2ds_baseline
mNOM1s=mNOM;mIM1s=mIM;mAM1s=mAM;
paNOM1s=paNOM;paIM1s=paIM;paAM1s=paAM;

labels={'seq3'};
code_louk_2ds_baseline
mNOM3=mNOM;mIM3=mIM;mAM3=mAM;
paNOM3=paNOM;paIM3=paIM;paAM3=paAM;

labels={'s_seq3'};
code_louk_2ds_baseline
mNOM3s=mNOM;mIM3s=mIM;mAM3s=mAM;
paNOM3s=paNOM;paIM3s=paIM;paAM3s=paAM;

labels={'seq9'};
code_louk_2ds_baseline
mNOM9=mNOM;mIM9=mIM;mAM9=mAM;
paNOM9=paNOM;paIM9=paIM;paAM9=paAM;

labels={'s_seq9'};
code_louk_2ds_baseline
mNOM9s=mNOM;mIM9s=mIM;mAM9s=mAM;
paNOM9s=paNOM;paIM9s=paIM;paAM9s=paAM;

D=[ mNOM1 mIM1 mAM1;
    mNOM3 mIM3 mAM3;
    mNOM9 mIM9 mAM9];


S=[ mNOM1s mIM1s mAM1s;
    mNOM3s mIM3s mAM3s;
    mNOM9s mIM9s mAM9s];

Db=[D(:,2)-D(:,1) D(:,3)-D(:,1)];
Sb=[S(:,2)-S(:,1) S(:,3)-S(:,1)];