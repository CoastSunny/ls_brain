
Cbmci=[2:6 8:10 12:15 18:19];
Csmci=Cbmci+19;
Pbmci=[39:51];
Psmci=[52:64];

Cbfad=[1:10];
Csfad=[11:20];
Pbfad=[21:30];
Psfad=[31:40];
llmci=[16 48 80 112];
kkmci={'back' 'right' 'front' 'left'};
llfad=[10 30 50];
kkfad={'front' 'central' 'back'};
fadperm=[41:60 21:40 1:20];
kkfad={ 'back' 'central' 'front' };
%%Alpha

PbAmci=squeeze(mean(mean(CxAmci(:,:,Pbmci))));
PsAmci=squeeze(mean(mean(CxAmci(:,:,Psmci))));
CbAmci=squeeze(mean(mean(CxAmci(:,:,Cbmci))));
CsAmci=squeeze(mean(mean(CxAmci(:,:,Csmci))));

PbBmci=squeeze(mean(mean(CxBmci(:,:,Pbmci))));
PsBmci=squeeze(mean(mean(CxBmci(:,:,Psmci))));
CbBmci=squeeze(mean(mean(CxBmci(:,:,Cbmci))));
CsBmci=squeeze(mean(mean(CxBmci(:,:,Csmci))));

PbDmci=squeeze(mean(mean(CxDmci(:,:,Pbmci))));
PsDmci=squeeze(mean(mean(CxDmci(:,:,Psmci))));
CbDmci=squeeze(mean(mean(CxDmci(:,:,Cbmci))));
CsDmci=squeeze(mean(mean(CxDmci(:,:,Csmci))));
clear G1 G2 G3;
y=[PbAmci' PbBmci' PbDmci'  PsAmci' PsBmci' PsDmci'...
    CbAmci' CbBmci' CsDmci' CsAmci' CsBmci' CbDmci' ];
[G1{1:78}]=deal('patient');[G1{79:162}]=deal('control');
[G2{1:39}]=deal('binding');[G2{40:78}]=deal('shape');
[G2{79:120}]=deal('binding');[G2{121:162}]=deal('shape');
[G3{1:13}]=deal('Alpha');[G3{14:26}]=deal('Beta');[G3{27:39}]=deal('Delta');
[G3{ 39+(1:13) }]=deal('Alpha');[G3{39+(14:26)}]=deal('Beta');[G3{39+(27:39)}]=deal('Delta');
[G3{78+(1:14)}]=deal('Alpha');[G3{78+(15:28)}]=deal('Beta');[G3{78+(29:42)}]=deal('Delta');
[G3{78+ 42+(1:14) }]=deal('Alpha');[G3{78+42+(15:28)}]=deal('Beta');[G3{78+42+(29:42)}]=deal('Delta');
[P,~,stats]=anovan(y,{G1 G2 G3},'model','full','varnames',{'condition','task','band'});
results = multcompare(stats,'Dimension',[2 3]);
hB=[];pB=[];
 for i=1:size(CxAmci,1)
     for j=1:size(CxAmci,2)
         [hB(i,j) pB(i,j)]=ttest2(CxAmci(i,j,Cbmci),CxAmci(i,j,Pbmci),'tail','right','alpha',0.01);
     end
 end
 figure,imagesc(hB),
 set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci),
 
PbAfad=squeeze(mean(mean(CxAfad(:,:,Pbfad))));
PsAfad=squeeze(mean(mean(CxAfad(:,:,Psfad))));
CbAfad=squeeze(mean(mean(CxAfad(:,:,Cbfad))));
CsAfad=squeeze(mean(mean(CxAfad(:,:,Csfad))));

PbBfad=squeeze(mean(mean(CxBfad(:,:,Pbfad))));
PsBfad=squeeze(mean(mean(CxBfad(:,:,Psfad))));
CbBfad=squeeze(mean(mean(CxBfad(:,:,Cbfad))));
CsBfad=squeeze(mean(mean(CxBfad(:,:,Csfad))));

PbDfad=squeeze(mean(mean(CxDfad(:,:,Pbfad))));
PsDfad=squeeze(mean(mean(CxDfad(:,:,Psfad))));
CbDfad=squeeze(mean(mean(CxDfad(:,:,Cbfad))));
CsDfad=squeeze(mean(mean(CxDfad(:,:,Csfad))));

hB=[];pB=[];
 for i=1:size(CxAfad,1)
     for j=1:size(CxAfad,2)
         [hB(i,j) pB(i,j)]=ttest2(CxAfad(i,j,Cbfad),CxAfad(i,j,Pbfad),'tail','right','alpha',0.01);
     end
 end
 figure,imagesc(hB),
 set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad),
 
  
 
 
 
 
 
 
 
 