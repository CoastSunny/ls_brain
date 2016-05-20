

timeperiod=[0 1000];
label_win={'1s_windows_shifted'};


trblocks=[1];
exblocks=[2 3];
outblocks=[4 5];
n_con_ex=60;
clear dm Res_in Res_out ztype
code_louk_asynch
% awd1sav=dmsav;
% awd1nrow=dmnrow;
% awd1perfsav=perfcomp(awd1sav,'out','dec',1);
% awd1calsav=calperf(awd1sav,'out','dec');
% awd1perfnrow=perfcomp(awd1nrow,'out','dec',1);
% awd1calnrow=calperf(awd1nrow,'out','dec');
awdR1o=Res_out;
awdR1i=Res_in;
zerd1=ztype;


trblocks=[2];
exblocks=[1 3];
outblocks=[4 5];
n_con_ex=60;
clear dm Res_in Res_out ztype
code_louk_asynch
 awd2sav=dmsav;
% awd2nrow=dmnrow;
% awd2perfsav=perfcomp(awd2sav,'out','dec',1);
% awd2calsav=calperf(awd2sav,'out','dec');
% awd2perfnrow=perfcomp(awd2nrow,'out','dec',1);
% awd2calnrow=calperf(awd2nrow,'out','dec');
awdR2o=Res_out;
awdR2i=Res_in;
zerd2=ztype;


trblocks=[3];
exblocks=[1 2];
outblocks=[4 5];
n_con_ex=60;
clear dm Res_in Res_out ztype
code_louk_asynch
% awd3sav=dmsav;
% awd3nrow=dmnrow;
% awd3perfsav=perfcomp(awd3sav,'out','dec',1);
% awd3calsav=calperf(awd3sav,'out','dec');
% awd3perfnrow=perfcomp(awd3nrow,'out','dec',1);
% awd3calnrow=calperf(awd3nrow,'out','dec');
awdR3o=Res_out;
awdR3i=Res_in;
zerd3=ztype;


% trblocks=[1 2 3];
% exblocks=[];
% outblocks=[4 5];
% n_con_ex=60;
% clear dm Res_in Res_out 
% code_louk_asynch
% awd=dm;
% awdRo=Res_out;
% awdRi=Res_in;
% awdperf=perfcomp(awd,'out','dec',1);
% awdcal=calperf(awd,'out','dec');

