
Cbmci=[2:6 8:10 12:15 18:19];
Csmci=Cbmci+19;
Pbmci=[39:51];
Psmci=[52:64];

Cbfad=[1:10];
Csfad=[11:20];
Pbfad=[21:30];
Psfad=[31:40];
llmci=[12 37 62 87 112];
kkmci={'cen' 'back' 'right' 'front' 'left'};
O1=[1 2 3 32+1 32+3 32+20 64+1 64+2 64+23 96+1 96+15 96+2 96+14 96+15 96+16];
O2=setdiff(1:32,O1);O3=setdiff(33:64,O1);O4=setdiff(65:96,O1);O5=setdiff(97:128,O1);
idcs=[O1 O2 O3 O4 O5];
llfad=[10 30 50];
kkfad={'front' 'central' 'back'};
fadperm=[41:60 21:40 1:20];
kkfad={ 'back' 'central' 'front' };
%%Alpha
% idcs=[O2 O3 O4];
PbAmci=squeeze(mean(mean(CxAmci(idcs,idcs,Pbmci))));
PsAmci=squeeze(mean(mean(CxAmci(idcs,idcs,Psmci))));
CbAmci=squeeze(mean(mean(CxAmci(idcs,idcs,Cbmci))));
CsAmci=squeeze(mean(mean(CxAmci(idcs,idcs,Csmci))));
[h p]=ttest2(PbAmci,CbAmci)
PbBmci=squeeze(mean(mean(CxBmci(idcs,idcs,Pbmci))));
PsBmci=squeeze(mean(mean(CxBmci(idcs,idcs,Psmci))));
CbBmci=squeeze(mean(mean(CxBmci(idcs,idcs,Cbmci))));
CsBmci=squeeze(mean(mean(CxBmci(idcs,idcs,Csmci))));
[h p]=ttest2(PbBmci,CbBmci)
PbDmci=squeeze(mean(mean(CxDmci(idcs,idcs,Pbmci))));
PsDmci=squeeze(mean(mean(CxDmci(idcs,idcs,Psmci))));
CbDmci=squeeze(mean(mean(CxDmci(idcs,idcs,Cbmci))));
CsDmci=squeeze(mean(mean(CxDmci(idcs,idcs,Csmci))));
[h p]=ttest2(PbDmci,CbDmci)

clear G1 G2 G3 G4;
y=[PbAmci' PbBmci' PbDmci'  PsAmci' PsBmci' PsDmci'...
    CbAmci' CbBmci' CbDmci' CsAmci' CsBmci' CsDmci' ];
[G1{1:78}]=deal('patient');[G1{79:162}]=deal('control');
[G2{1:39}]=deal('binding');[G2{40:78}]=deal('shape');
[G2{79:120}]=deal('binding');[G2{121:162}]=deal('shape');
[G3{1:13}]=deal('Alpha');[G3{14:26}]=deal('Beta');[G3{27:39}]=deal('Delta');
[G3{ 39+(1:13) }]=deal('Alpha');[G3{39+(14:26)}]=deal('Beta');[G3{39+(27:39)}]=deal('Delta');
[G3{78+(1:14)}]=deal('Alpha');[G3{78+(15:28)}]=deal('Beta');[G3{78+(29:42)}]=deal('Delta');
[G3{78+ 42+(1:14) }]=deal('Alpha');[G3{78+42+(15:28)}]=deal('Beta');[G3{78+42+(29:42)}]=deal('Delta');
G4=repmat(1:13,1,6);G4=[G4 repmat(13+(1:14),1,6)];
[P,~,stats]=anovan(y,{G1 G2 G3},'model','full',...
    'varnames',{'condition','task','band'},'sstype',3);...
%     'random', [2 4],'nested', [0 0 0 0; 0 0 0 0; 0 0 0 0; 1 0 0 0]);
figure,results = multcompare(stats,'Dimension',[1 2  ],...
    'ctype','tukey-kramer dunn-sidak bonferroni scheffe');
% hB=[];pB=[];
%  for i=1:size(CxAmci,1)
%      for j=1:size(CxAmci,2)
%          [hB(i,j) pB(i,j)]=ttest2(CxBmci(i,j,Cbmci),CxBmci(i,j,Pbmci),'alpha',0.01);
%      end
%  end
%  fdr=mafdr(pB(:));
%  fdr=reshape(fdr,size(pB,1),size(pB,2));
%  figure,imagesc(fdr>0.0005),
%  set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci),
%  
PbAfad=squeeze(mean(mean(CxAfad(:,:,Pbfad))));
PsAfad=squeeze(mean(mean(CxAfad(:,:,Psfad))));
CbAfad=squeeze(mean(mean(CxAfad(:,:,Cbfad))));
CsAfad=squeeze(mean(mean(CxAfad(:,:,Csfad))));
[h p]=ttest2(PbAfad,CbAfad)
PbBfad=squeeze(mean(mean(CxBfad(:,:,Pbfad))));
PsBfad=squeeze(mean(mean(CxBfad(:,:,Psfad))));
CbBfad=squeeze(mean(mean(CxBfad(:,:,Cbfad))));
CsBfad=squeeze(mean(mean(CxBfad(:,:,Csfad))));
[h p]=ttest2(PbBfad,CbBfad)
PbDfad=squeeze(mean(mean(CxDfad(:,:,Pbfad))));
PsDfad=squeeze(mean(mean(CxDfad(:,:,Psfad))));
CbDfad=squeeze(mean(mean(CxDfad(:,:,Cbfad))));
CsDfad=squeeze(mean(mean(CxDfad(:,:,Csfad))));
[h p]=ttest2(PbDfad,CbDfad)
clear G1 G2 G3;
y2=[PbAfad' PbBfad' PbDfad'  PsAfad' PsBfad' PsDfad'...
    CbAfad' CbBfad' CbDfad' CsAfad' CsBfad' CsDfad' ];
[G1{1:60}]=deal('patient');[G1{61:120}]=deal('control');
[G2{1:30}]=deal('binding');[G2{31:60}]=deal('shape');
[G2{61:90}]=deal('binding');[G2{91:120}]=deal('shape');
[G3{1:10}]=deal('Alpha');[G3{11:20}]=deal('Beta');[G3{21:30}]=deal('Delta');
[G3{ 30+(1:10) }]=deal('Alpha');[G3{30+(11:20)}]=deal('Beta');[G3{30+(21:30)}]=deal('Delta');
[G3{60+(1:10)}]=deal('Alpha');[G3{60+(11:20)}]=deal('Beta');[G3{60+(21:30)}]=deal('Delta');
[G3{90++(1:10) }]=deal('Alpha');[G3{90+(11:20)}]=deal('Beta');[G3{90+(21:30)}]=deal('Delta');
[P2,~,stats2]=anovan(y2,{G1 G2 G3},'model','full','varnames',{'condition','task','band'},'sstype',3);
figure,results2 = multcompare(stats2,'Dimension',[ 1 2 3]);
% 
% hB=[];pB=[];
%  for i=1:size(CxAfad,1)
%      for j=1:size(CxAfad,2)
%          [hB(i,j) pB(i,j)]=ttest2(CxAfad(i,j,Cbfad),CxAfad(i,j,Pbfad),'tail','right','alpha',0.01);
%      end
%  end
%  figure,imagesc(hB),
%  set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad),
%  
  %%
PbpAmci=squeeze(mean(mean(CxpAmci(idcs,idcs,Pbmci))));
PspAmci=squeeze(mean(mean(CxpAmci(idcs,idcs,Psmci))));
CbpAmci=squeeze(mean(mean(CxpAmci(idcs,idcs,Cbmci))));
CspAmci=squeeze(mean(mean(CxpAmci(idcs,idcs,Csmci))));
[h p]=ttest2(PbAmci,CbAmci)
PbpBmci=squeeze(mean(mean(CxpBmci(idcs,idcs,Pbmci))));
PspBmci=squeeze(mean(mean(CxpBmci(idcs,idcs,Psmci))));
CbpBmci=squeeze(mean(mean(CxpBmci(idcs,idcs,Cbmci))));
CspBmci=squeeze(mean(mean(CxpBmci(idcs,idcs,Csmci))));
[h p]=ttest2(PbBmci,CbBmci)
PbpDmci=squeeze(mean(mean(CxpDmci(idcs,idcs,Pbmci))));
PspDmci=squeeze(mean(mean(CxpDmci(idcs,idcs,Psmci))));
CbpDmci=squeeze(mean(mean(CxpDmci(idcs,idcs,Cbmci))));
CspDmci=squeeze(mean(mean(CxpDmci(idcs,idcs,Csmci))));
[h p]=ttest2(PbDmci,CbDmci)

clear G1 G2 G3 G4;
y=[PbpAmci' PbpBmci' PbpDmci'  PspAmci' PspBmci' PspDmci'...
    CbpAmci' CbpBmci' CbpDmci' CspAmci' CspBmci' CspDmci' ];
[G1{1:78}]=deal('patient');[G1{79:162}]=deal('control');
[G2{1:39}]=deal('binding');[G2{40:78}]=deal('shape');
[G2{79:120}]=deal('binding');[G2{121:162}]=deal('shape');
[G3{1:13}]=deal('Alpha');[G3{14:26}]=deal('Beta');[G3{27:39}]=deal('Delta');
[G3{ 39+(1:13) }]=deal('Alpha');[G3{39+(14:26)}]=deal('Beta');[G3{39+(27:39)}]=deal('Delta');
[G3{78+(1:14)}]=deal('Alpha');[G3{78+(15:28)}]=deal('Beta');[G3{78+(29:42)}]=deal('Delta');
[G3{78+ 42+(1:14) }]=deal('Alpha');[G3{78+42+(15:28)}]=deal('Beta');[G3{78+42+(29:42)}]=deal('Delta');
G4=repmat(1:13,1,6);G4=[G4 repmat(13+(1:14),1,6)];
[Pp,~,statsp]=anovan(y,{G1 G2 G3},'model','full',...
    'varnames',{'condition','task','band'},'sstype',3);...
%     'random', [2 4],'nested', [0 0 0 0; 0 0 0 0; 0 0 0 0; 1 0 0 0]);
figure,resultsp = multcompare(statsp,'Dimension',[1 2  ],...
    'ctype','tukey-kramer dunn-sidak bonferroni scheffe');
% hB=[];pB=[];
%  for i=1:size(CxAmci,1)
%      for j=1:size(CxAmci,2)
%          [hB(i,j) pB(i,j)]=ttest2(CxBmci(i,j,Cbmci),CxBmci(i,j,Pbmci),'alpha',0.01);
%      end
%  end
%  fdr=mafdr(pB(:));
%  fdr=reshape(fdr,size(pB,1),size(pB,2));
%  figure,imagesc(fdr>0.0005),
%  set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci),
%%
PbpAfad=squeeze(mean(mean(CxpAfad(:,:,Pbfad))));
PspAfad=squeeze(mean(mean(CxpAfad(:,:,Psfad))));
CbpAfad=squeeze(mean(mean(CxpAfad(:,:,Cbfad))));
CspAfad=squeeze(mean(mean(CxpAfad(:,:,Csfad))));
[h p]=ttest2(PbAfad,CbAfad)
PbpBfad=squeeze(mean(mean(CxpBfad(:,:,Pbfad))));
PspBfad=squeeze(mean(mean(CxpBfad(:,:,Psfad))));
CbpBfad=squeeze(mean(mean(CxpBfad(:,:,Cbfad))));
CspBfad=squeeze(mean(mean(CxpBfad(:,:,Csfad))));
[h p]=ttest2(PbBfad,CbBfad)
PbpDfad=squeeze(mean(mean(CxpDfad(:,:,Pbfad))));
PspDfad=squeeze(mean(mean(CxpDfad(:,:,Psfad))));
CbpDfad=squeeze(mean(mean(CxpDfad(:,:,Cbfad))));
CspDfad=squeeze(mean(mean(CxpDfad(:,:,Csfad))));
[h p]=ttest2(PbDfad,CbDfad)
clear G1 G2 G3;
y2=[PbpAfad' PbpBfad' PbpDfad'  PspAfad' PspBfad' PspDfad'...
    CbpAfad' CbpBfad' CbpDfad' CspAfad' CspBfad' CspDfad' ];
[G1{1:60}]=deal('patient');[G1{61:120}]=deal('control');
[G2{1:30}]=deal('binding');[G2{31:60}]=deal('shape');
[G2{61:90}]=deal('binding');[G2{91:120}]=deal('shape');
[G3{1:10}]=deal('Alpha');[G3{11:20}]=deal('Beta');[G3{21:30}]=deal('Delta');
[G3{ 30+(1:10) }]=deal('Alpha');[G3{30+(11:20)}]=deal('Beta');[G3{30+(21:30)}]=deal('Delta');
[G3{60+(1:10)}]=deal('Alpha');[G3{60+(11:20)}]=deal('Beta');[G3{60+(21:30)}]=deal('Delta');
[G3{90++(1:10) }]=deal('Alpha');[G3{90+(11:20)}]=deal('Beta');[G3{90+(21:30)}]=deal('Delta');
[Pp2,~,statsp2]=anovan(y2,{G1 G2 G3},'model','full','varnames',{'condition','task','band'},'sstype',3);
figure,resultsp2 = multcompare(statsp2,'Dimension',[1 2 ]);

%%
y3=[y y2];
clear G1 G2 G3 G4; 
[G1{1:78}]=deal('patient');[G1{79:162}]=deal('control');
[G2{1:39}]=deal('binding');[G2{40:78}]=deal('shape');
[G2{79:120}]=deal('binding');[G2{121:162}]=deal('shape');
[G3{1:13}]=deal('Alpha');[G3{14:26}]=deal('Beta');[G3{27:39}]=deal('Delta');
[G3{ 39+(1:13) }]=deal('Alpha');[G3{39+(14:26)}]=deal('Beta');[G3{39+(27:39)}]=deal('Delta');
[G3{78+(1:14)}]=deal('Alpha');[G3{78+(15:28)}]=deal('Beta');[G3{78+(29:42)}]=deal('Delta');
[G3{78+ 42+(1:14) }]=deal('Alpha');[G3{78+42+(15:28)}]=deal('Beta');[G3{78+42+(29:42)}]=deal('Delta');
[G1{162+(1:60)}]=deal('patient');[G1{162+(61:120)}]=deal('control');
[G2{162+(1:30)}]=deal('binding');[G2{162+(31:60)}]=deal('shape');
[G2{162+(61:90)}]=deal('binding');[G2{162+(91:120)}]=deal('shape');
[G3{162+(1:10)}]=deal('Alpha');[G3{162+(11:20)}]=deal('Beta');[G3{162+(21:30)}]=deal('Delta');
[G3{ 162+30+(1:10) }]=deal('Alpha');[G3{162+30+(11:20)}]=deal('Beta');[G3{162+30+(21:30)}]=deal('Delta');
[G3{162+60+(1:10)}]=deal('Alpha');[G3{162+60+(11:20)}]=deal('Beta');[G3{162+60+(21:30)}]=deal('Delta');
[G3{162+90+(1:10) }]=deal('Alpha');[G3{162+90+(11:20)}]=deal('Beta');[G3{162+90+(21:30)}]=deal('Delta');
[G4{1:162}]=deal('MCI');[G4{163:282}]=deal('MCI-FAD');
[P3,~,stats3]=anovan(y3,{G1 G2 G3 G4},'model','full',...
    'varnames',{'condition','task','band','dataset'},'sstype',3);
figure,results3 = multcompare(stats3,'Dimension',[1 2]);

%%
clear G1 G2 G3 G4;
y=[OAmci(Pbmci) OBmci(Pbmci) ODmci(Pbmci)  OAmci(Psmci) OBmci(Psmci) ODmci(Psmci)...
    OAmci(Cbmci) OBmci(Cbmci) ODmci(Cbmci) OAmci(Csmci) OBmci(Csmci) ODmci(Csmci) ];
[G1{1:78}]=deal('patient');[G1{79:162}]=deal('control');
[G2{1:39}]=deal('binding');[G2{40:78}]=deal('shape');
[G2{79:120}]=deal('binding');[G2{121:162}]=deal('shape');
[G3{1:13}]=deal('Alpha');[G3{14:26}]=deal('Beta');[G3{27:39}]=deal('Delta');
[G3{ 39+(1:13) }]=deal('Alpha');[G3{39+(14:26)}]=deal('Beta');[G3{39+(27:39)}]=deal('Delta');
[G3{78+(1:14)}]=deal('Alpha');[G3{78+(15:28)}]=deal('Beta');[G3{78+(29:42)}]=deal('Delta');
[G3{78+ 42+(1:14) }]=deal('Alpha');[G3{78+42+(15:28)}]=deal('Beta');[G3{78+42+(29:42)}]=deal('Delta');
G4=repmat(1:13,1,6);G4=[G4 repmat(13+(1:14),1,6)];
[Po,~,statso]=anovan(y,{G1 G2 G3},'model','full',...
    'varnames',{'condition','task','band'},'sstype',3);...
%     'random', [2 4],'nested', [0 0 0 0; 0 0 0 0; 0 0 0 0; 1 0 0 0]);
figure,resultso = multcompare(statso,'Dimension',[1 2  ],...
    'ctype','tukey-kramer dunn-sidak bonferroni scheffe');

clear G1 G2 G3 G4;
y2=[OAfad(Pbfad) OBfad(Pbfad) ODfad(Pbfad)  OAfad(Psfad) OBfad(Psfad) ODfad(Psfad)...
    OAfad(Cbfad) OBfad(Cbfad) ODfad(Cbfad) OAfad(Csfad) OBfad(Csfad) ODfad(Csfad) ];
[G1{1:60}]=deal('patient');[G1{61:120}]=deal('control');
[G2{1:30}]=deal('binding');[G2{31:60}]=deal('shape');
[G2{61:90}]=deal('binding');[G2{91:120}]=deal('shape');
[G3{1:10}]=deal('Alpha');[G3{11:20}]=deal('Beta');[G3{21:30}]=deal('Delta');
[G3{ 30+(1:10) }]=deal('Alpha');[G3{30+(11:20)}]=deal('Beta');[G3{30+(21:30)}]=deal('Delta');
[G3{60+(1:10)}]=deal('Alpha');[G3{60+(11:20)}]=deal('Beta');[G3{60+(21:30)}]=deal('Delta');
[G3{90++(1:10) }]=deal('Alpha');[G3{90+(11:20)}]=deal('Beta');[G3{90+(21:30)}]=deal('Delta');
[Po2,~,statso2]=anovan(y2,{G1 G2 G3},'model','full',...
    'varnames',{'condition','task','band'},'sstype',3);...
%     'random', [2 4],'nested', [0 0 0 0; 0 0 0 0; 0 0 0 0; 1 0 0 0]);
figure,resultso2 = multcompare(statso2,'Dimension',[1 2  ],...
    'ctype','tukey-kramer dunn-sidak bonferroni scheffe');

y3=[y y2];
clear G1 G2 G3 G4; 
[G1{1:78}]=deal('patient');[G1{79:162}]=deal('control');
[G2{1:39}]=deal('binding');[G2{40:78}]=deal('shape');
[G2{79:120}]=deal('binding');[G2{121:162}]=deal('shape');
[G3{1:13}]=deal('Alpha');[G3{14:26}]=deal('Beta');[G3{27:39}]=deal('Delta');
[G3{ 39+(1:13) }]=deal('Alpha');[G3{39+(14:26)}]=deal('Beta');[G3{39+(27:39)}]=deal('Delta');
[G3{78+(1:14)}]=deal('Alpha');[G3{78+(15:28)}]=deal('Beta');[G3{78+(29:42)}]=deal('Delta');
[G3{78+ 42+(1:14) }]=deal('Alpha');[G3{78+42+(15:28)}]=deal('Beta');[G3{78+42+(29:42)}]=deal('Delta');
[G1{162+(1:60)}]=deal('patient');[G1{162+(61:120)}]=deal('control');
[G2{162+(1:30)}]=deal('binding');[G2{162+(31:60)}]=deal('shape');
[G2{162+(61:90)}]=deal('binding');[G2{162+(91:120)}]=deal('shape');
[G3{162+(1:10)}]=deal('Alpha');[G3{162+(11:20)}]=deal('Beta');[G3{162+(21:30)}]=deal('Delta');
[G3{ 162+30+(1:10) }]=deal('Alpha');[G3{162+30+(11:20)}]=deal('Beta');[G3{162+30+(21:30)}]=deal('Delta');
[G3{162+60+(1:10)}]=deal('Alpha');[G3{162+60+(11:20)}]=deal('Beta');[G3{162+60+(21:30)}]=deal('Delta');
[G3{162+90+(1:10) }]=deal('Alpha');[G3{162+90+(11:20)}]=deal('Beta');[G3{162+90+(21:30)}]=deal('Delta');
[G4{1:162}]=deal('MCI');[G4{163:282}]=deal('MCI-FAD');
[P3,~,stats3]=anovan(y3,{G1 G2 G3 G4},'model','full',...
    'varnames',{'condition','task','band','dataset'},'sstype',3);
figure,results3 = multcompare(stats3,'Dimension',[1 4]);

OCbmci=[OAmci(Cbmci) OBmci(Cbmci) ODmci(Cbmci)];
OCsmci=[OAmci(Csmci) OBmci(Csmci) ODmci(Csmci)];
OPbmci=[OAmci(Pbmci) OBmci(Pbmci) ODmci(Pbmci)];
OPsmci=[OAmci(Psmci) OBmci(Psmci) ODmci(Psmci)];

[h p]=corrcoef(OCbmci, [CbpAmci' CbpBmci' CbpDmci'])
[h p]=corrcoef(OPbmci, [PbpAmci' PbpBmci' PbpDmci'])

[h p]=corrcoef(OCsmci, [CspAmci' CspBmci' CspDmci'])
[h p]=corrcoef(OPsmci, [PspAmci' PspBmci' PspDmci'])

OCbfad=[OAfad(Cbfad) OBfad(Cbfad) ODfad(Cbfad)];
OCsfad=[OAfad(Csfad) OBfad(Csfad) ODfad(Csfad)];
OPbfad=[OAfad(Pbfad) OBfad(Pbfad) ODfad(Pbfad)];
OPsfad=[OAfad(Psfad) OBfad(Psfad) ODfad(Psfad)];

[h p]=corrcoef(OCbfad, [CbpAfad' CbpBfad' CbpDfad'])
[h p]=corrcoef(OPbfad, [PbpAfad' PbpBfad' PbpDfad'])

[h p]=corrcoef(OCsfad, [CspAfad' CspBfad' CspDfad'])
[h p]=corrcoef(OPsfad, [PspAfad' PspBfad' PspDfad'])


SNRCbmci=[SNRAmci(Cbmci) SNRBmci(Cbmci) SNRDmci(Cbmci)];
SNRCsmci=[SNRAmci(Csmci) SNRBmci(Csmci) SNRDmci(Csmci)];
SNRPbmci=[SNRAmci(Pbmci) SNRBmci(Pbmci) SNRDmci(Pbmci)];
SNRPsmci=[SNRAmci(Psmci) SNRBmci(Psmci) SNRDmci(Psmci)];
 
 
[h p]=corrcoef(OCbmci, SNRCbmci)
[h p]=corrcoef(OPbmci, SNRPbmci)

[h p]=corrcoef(OCsmci, SNRCsmci)
[h p]=corrcoef(OPsmci, SNRPsmci)


SNRCbfad=[SNRAfad(Cbfad) SNRBfad(Cbfad) SNRDfad(Cbfad)];
SNRCsfad=[SNRAfad(Csfad) SNRBfad(Csfad) SNRDfad(Csfad)];
SNRPbfad=[SNRAfad(Pbfad) SNRBfad(Pbfad) SNRDfad(Pbfad)];
SNRPsfad=[SNRAfad(Psfad) SNRBfad(Psfad) SNRDfad(Psfad)];
 
 
[h p]=corrcoef(OCbfad, SNRCbfad)
[h p]=corrcoef(OPbfad, SNRPbfad)

[h p]=corrcoef(OCsfad, SNRCsfad)
[h p]=corrcoef(OPsfad, SNRPsfad)
 
 
 