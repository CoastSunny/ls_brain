%%Controls
winde=[1 1 1 1 1];
windn=[0 1 1 1 1];


%%%%%%%%%%%%%% BOTH O+R ==f , Actual %%%%%%%%%%%%%%%%%%%%%%%%%%%%
scores_nirs = getwindowscoresR(Nf(:,6,co_subj),[],'+');

scores_eeg = getwindowscoresR(Ef(:,2,co_subj),[],'-');

scores_comb = getwindowscoresR(Ef(:,2,co_subj),Nf(:,6,co_subj),'-','+');

Ciaverage_nirsAMf = mean(scores_nirs.rate,2);
Ciaverage_eegAM  = mean(scores_eeg.rate,2);
Ciaverage_combAMf = mean(scores_comb.rate,2);

Ccaverage_nirsAMf = scores_nirs.comb_rate;
Ccaverage_eegAM = scores_eeg.comb_rate;
Ccaverage_combAMf = scores_comb.comb_rate;

Cgaverage_nirsAMf = mean(scores_nirs.rate,3);
Cgaverage_eegAM  = mean(scores_eeg.rate,3);
Cgaverage_combAMf = mean(scores_comb.rate,3);
sCgaverage_nirsAMf = std(scores_nirs.rate,0,3);
sCgaverage_eegAM  = std(scores_eeg.rate,0,3);
sCgaverage_combAMf = std(scores_comb.rate,0,3);
%2nd window
scores_nirs = getwindowscoresR(Nf(:,6,co_subj),[],'+',[],windn,[]);
scores_eeg = getwindowscoresR(Ef(:,2,co_subj),[],'-',[],winde,[]);
scores_comb = getwindowscoresR(Ef(:,2,co_subj),Nf(:,6,co_subj),'-','+',winde,windn);

Cnaverage_nirsAMf = scores_nirs.comb_rate;
Cnaverage_eegAM = scores_eeg.comb_rate;
Cnaverage_combAMf = scores_comb.comb_rate;

CdivAMf = getdiversity(fnirsAMf,-feegAM);
%%%%%%%%%%%%%%%%%%%%%%%%% Imaginary %%%%%%%%%%%%%%%%%%
scores_nirs = getwindowscoresR(Nf(:,5,co_subj),[],'+');

scores_eeg = getwindowscoresR(Ef(:,1,co_subj),[],'-');

scores_comb = getwindowscoresR(Ef(:,1,co_subj),Nf(:,5,co_subj),'-','+');

Ciaverage_nirsIMf = mean(scores_nirs.rate,2);
Ciaverage_eegIM  = mean(scores_eeg.rate,2);
Ciaverage_combIMf = mean(scores_comb.rate,2);

Ccaverage_nirsIMf = scores_nirs.comb_rate;
Ccaverage_eegIM = scores_eeg.comb_rate;
Ccaverage_combIMf = scores_comb.comb_rate;

Cgaverage_nirsIMf = mean(scores_nirs.rate,3);
Cgaverage_eegIM  = mean(scores_eeg.rate,3);
Cgaverage_combIMf = mean(scores_comb.rate,3);
sCgaverage_nirsIMf = std(scores_nirs.rate,0,3);
sCgaverage_eegIM   = std(scores_eeg.rate,0,3);
sCgaverage_combIMf = std(scores_comb.rate,0,3);
%2nd window
scores_nirs = getwindowscoresR(Nf(:,5,co_subj),[],'+',[],windn,[]);
scores_eeg = getwindowscoresR(Ef(:,1,co_subj),[],'-',[],winde,[]);
scores_comb = getwindowscoresR(Ef(:,1,co_subj),Nf(:,5,co_subj),'-','+',winde,windn);

Cnaverage_nirsIMf = scores_nirs.comb_rate;
Cnaverage_eegIM = scores_eeg.comb_rate;
Cnaverage_combIMf = scores_comb.comb_rate;

CdivIMf = getdiversity(fnirsIMf,-feegIM);

%%%%%%%%%%%%%% R ==d %%%%%%%%%%%%%%%%%%%%%%%%%%%%
scores_nirs = getwindowscoresR(Nf(:,4,co_subj),[],'+');

scores_eeg = getwindowscoresR(Ef(:,2,co_subj),[],'-');

scores_comb = getwindowscoresR(Ef(:,2,co_subj),Nf(:,4,co_subj),'-','+');

Ciaverage_nirsAMd = mean(scores_nirs.rate,2);
Ciaverage_eegAM  = mean(scores_eeg.rate,2);
Ciaverage_combAMd = mean(scores_comb.rate,2);

Ccaverage_nirsAMd = scores_nirs.comb_rate;
Ccaverage_eegAM = scores_eeg.comb_rate;
Ccaverage_combAMd = scores_comb.comb_rate;

Cgaverage_nirsAMd = mean(scores_nirs.rate,3);
Cgaverage_eegAM  = mean(scores_eeg.rate,3);
Cgaverage_combAMd = mean(scores_comb.rate,3);
sCgaverage_nirsAMd = std(scores_nirs.rate,0,3);
sCgaverage_eegAM  = std(scores_eeg.rate,0,3);
sCgaverage_combAMd = std(scores_comb.rate,0,3);
%2nd window
scores_nirs = getwindowscoresR(Nf(:,4,co_subj),[],'+',[],windn,[]);
scores_eeg = getwindowscoresR(Ef(:,2,co_subj),[],'-',[],winde,[]);
scores_comb = getwindowscoresR(Ef(:,2,co_subj),Nf(:,4,co_subj),'-','+',winde,windn);

Cnaverage_nirsAMd = scores_nirs.comb_rate;
Cnaverage_eegAM = scores_eeg.comb_rate;
Cnaverage_combAMd = scores_comb.comb_rate;


CdivAMd = getdiversity(fnirsAMd,-feegAM);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scores_nirs = getwindowscoresR(Nf(:,3,co_subj),[],'+');

scores_eeg = getwindowscoresR(Ef(:,1,co_subj),[],'-');

scores_comb = getwindowscoresR(Ef(:,1,co_subj),Nf(:,3,co_subj),'-','+');

Ciaverage_nirsIMd = mean(scores_nirs.rate,2);
Ciaverage_eegIM  = mean(scores_eeg.rate,2);
Ciaverage_combIMd = mean(scores_comb.rate,2);

Ccaverage_nirsIMd = scores_nirs.comb_rate;
Ccaverage_eegIM = scores_eeg.comb_rate;
Ccaverage_combIMd = scores_comb.comb_rate;

Cgaverage_nirsIMd = mean(scores_nirs.rate,3);
Cgaverage_eegIM  = mean(scores_eeg.rate,3);
Cgaverage_combIMd = mean(scores_comb.rate,3);
sCgaverage_nirsIMd = std(scores_nirs.rate,0,3);
sCgaverage_eegIM  = std(scores_eeg.rate,0,3);
sCgaverage_combIMd = std(scores_comb.rate,0,2);
%2nd window
scores_nirs = getwindowscoresR(Nf(:,3,co_subj),[],'+',[],windn,[]);
scores_eeg = getwindowscoresR(Ef(:,1,co_subj),[],'-',[],winde,[]);
scores_comb = getwindowscoresR(Ef(:,1,co_subj),Nf(:,3,co_subj),'-','+',winde,windn);

Cnaverage_nirsIMd = scores_nirs.comb_rate;
Cnaverage_eegIM = scores_eeg.comb_rate;
Cnaverage_combIMd = scores_comb.comb_rate;

CdivIMd = getdiversity(fnirsIMd,-feegIM);

%%%%%%%%%%%%%%  Oxy == o   %%%%%%%%%%%%%%%%%%%%%%%%%%%%

scores_nirs = getwindowscoresR(Nf(:,2,co_subj),[],'+');

scores_eeg = getwindowscoresR(Ef(:,2,co_subj),[],'-');

scores_comb = getwindowscoresR(Ef(:,2,co_subj),Nf(:,2,co_subj),'-','+');

Ciaverage_nirsAMo = mean(scores_nirs.rate,2);
Ciaverage_eegAM  = mean(scores_eeg.rate,2);
Ciaverage_combAMo = mean(scores_comb.rate,2);

Ccaverage_nirsAMo = scores_nirs.comb_rate;
Ccaverage_eegAM = scores_eeg.comb_rate;
Ccaverage_combAMo = scores_comb.comb_rate;

Cgaverage_nirsAMo = mean(scores_nirs.rate,3);
Cgaverage_eegAM  = mean(scores_eeg.rate,3);
Cgaverage_combAMo = mean(scores_comb.rate,3);
sCgaverage_nirsAMo = std(scores_nirs.rate,0,3);
sCgaverage_eegAM  = std(scores_eeg.rate,0,3);
sCgaverage_combAMo = std(scores_comb.rate,0,3);
%2nd window
scores_nirs = getwindowscoresR(Nf(:,2,co_subj),[],'+',[],windn,[]);
scores_eeg = getwindowscoresR(Ef(:,2,co_subj),[],'-',[],winde,[]);
scores_comb = getwindowscoresR(Ef(:,2,co_subj),Nf(:,2,co_subj),'-','+',winde,windn);

Cnaverage_nirsAMo = scores_nirs.comb_rate;
Cnaverage_eegAM = scores_eeg.comb_rate;
Cnaverage_combAMo = scores_comb.comb_rate;

CdivAMo = getdiversity(fnirsAMo,-feegAM);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scores_nirs = getwindowscoresR(Nf(:,1,co_subj),[],'+');

scores_eeg = getwindowscoresR(Ef(:,1,co_subj),[],'-');

scores_comb = getwindowscoresR(Ef(:,1,co_subj),Nf(:,1,co_subj),'-','+');

Ciaverage_nirsIMo = mean(scores_nirs.rate,2);
Ciaverage_eegIM  = mean(scores_eeg.rate,2);
Ciaverage_combIMo = mean(scores_comb.rate,2);

Ccaverage_nirsIMo = scores_nirs.comb_rate;
Ccaverage_eegIM = scores_eeg.comb_rate;
Ccaverage_combIMo = scores_comb.comb_rate;

Cgaverage_nirsIMo = mean(scores_nirs.rate,3);
Cgaverage_eegIM  = mean(scores_eeg.rate,3);
Cgaverage_combIMo = mean(scores_comb.rate,3);
sCgaverage_nirsIMo = std(scores_nirs.rate,0,3);
sCgaverage_eegIM  = std(scores_eeg.rate,0,3);
sCgaverage_combIMo = std(scores_comb.rate,0,3);
%2nd window
scores_nirs = getwindowscoresR(Nf(:,1,co_subj),[],'+',[],windn,[]);
scores_eeg = getwindowscoresR(Ef(:,1,co_subj),[],'-',[],winde,[]);
scores_comb = getwindowscoresR(Ef(:,1,co_subj),Nf(:,1,co_subj),'-','+',winde,windn);

Cnaverage_nirsIMo = scores_nirs.comb_rate;
Cnaverage_eegIM = scores_eeg.comb_rate;
Cnaverage_combIMo = scores_comb.comb_rate;

CdivIMo = getdiversity(fnirsIMo,-feegIM);


