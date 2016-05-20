%%Tetra



%%%%%%%%%%%%%% BOTH O+R ==f , Actual %%%%%%%%%%%%%%%%%%%%%%%%%%%%
scores_nirs = getwindowscoresR(Nf(:,6,pa_subj),[],'+');

scores_eeg = getwindowscoresR(Ef(:,2,pa_subj),[],'-');

scores_comb = getwindowscoresR(Ef(:,2,pa_subj),Nf(:,6,pa_subj),'-','+');

Tiaverage_nirsAMf = mean(scores_nirs.rate,2);
Tiaverage_eegAM  = mean(scores_eeg.rate,2);
Tiaverage_combAMf = mean(scores_comb.rate,2);

Tcaverage_nirsAMf = scores_nirs.comb_rate;
Tcaverage_eegAM = scores_eeg.comb_rate;
Tcaverage_combAMf = scores_comb.comb_rate;

Tgaverage_nirsAMf = mean(scores_nirs.rate,3);
Tgaverage_eegAM  = mean(scores_eeg.rate,3);
Tgaverage_combAMf = mean(scores_comb.rate,3);
sTgaverage_nirsAMf = std(scores_nirs.rate,0,3);
sTgaverage_eegAM  = std(scores_eeg.rate,0,3);
sTgaverage_combAMf = std(scores_comb.rate,0,3);

TdivAMf = getdiversity(fnirsAMf,-feegAM);
%%%%%%%%%%%%%%%%%%%%%%%%% Imaginary %%%%%%%%%%%%%%%%%%
scores_nirs = getwindowscoresR(Nf(:,5,pa_subj),[],'+');

scores_eeg = getwindowscoresR(Ef(:,1,pa_subj),[],'-');

scores_comb = getwindowscoresR(Ef(:,1,pa_subj),Nf(:,5,pa_subj),'-','+');

Tiaverage_nirsIMf = mean(scores_nirs.rate,2);
Tiaverage_eegIM  = mean(scores_eeg.rate,2);
Tiaverage_combIMf = mean(scores_comb.rate,2);

Tcaverage_nirsIMf = scores_nirs.comb_rate;
Tcaverage_eegIM = scores_eeg.comb_rate;
Tcaverage_combIMf = scores_comb.comb_rate;

Tgaverage_nirsIMf = mean(scores_nirs.rate,3);
Tgaverage_eegIM  = mean(scores_eeg.rate,3);
Tgaverage_combIMf = mean(scores_comb.rate,3);
sTgaverage_nirsIMf = std(scores_nirs.rate,0,3);
sTgaverage_eegIM   = std(scores_eeg.rate,0,3);
sTgaverage_combIMf = std(scores_comb.rate,0,3);

TdivIMf = getdiversity(fnirsIMf,-feegIM);

%%%%%%%%%%%%%% R ==d %%%%%%%%%%%%%%%%%%%%%%%%%%%%
scores_nirs = getwindowscoresR(Nf(:,4,pa_subj),[],'+');

scores_eeg = getwindowscoresR(Ef(:,2,pa_subj),[],'-');

scores_comb = getwindowscoresR(Ef(:,2,pa_subj),Nf(:,4,pa_subj),'-','+');

Tiaverage_nirsAMd = mean(scores_nirs.rate,2);
Tiaverage_eegAM  = mean(scores_eeg.rate,2);
Tiaverage_combAMd = mean(scores_comb.rate,2);

Tcaverage_nirsAMd = scores_nirs.comb_rate;
Tcaverage_eegAM = scores_eeg.comb_rate;
Tcaverage_combAMd = scores_comb.comb_rate;

Tgaverage_nirsAMd = mean(scores_nirs.rate,3);
Tgaverage_eegAM  = mean(scores_eeg.rate,3);
Tgaverage_combAMd = mean(scores_comb.rate,3);
sTgaverage_nirsAMd = std(scores_nirs.rate,0,3);
sTgaverage_eegAM  = std(scores_eeg.rate,0,3);
sTgaverage_combAMd = std(scores_comb.rate,0,3);

TdivAMd = getdiversity(fnirsAMd,-feegAM);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scores_nirs = getwindowscoresR(Nf(:,3,pa_subj),[],'+');

scores_eeg = getwindowscoresR(Ef(:,1,pa_subj),[],'-');

scores_comb = getwindowscoresR(Ef(:,1,pa_subj),Nf(:,3,pa_subj),'-','+');

Tiaverage_nirsIMd = mean(scores_nirs.rate,2);
Tiaverage_eegIM  = mean(scores_eeg.rate,2);
Tiaverage_combIMd = mean(scores_comb.rate,2);

Tcaverage_nirsIMd = scores_nirs.comb_rate;
Tcaverage_eegIM = scores_eeg.comb_rate;
Tcaverage_combIMd = scores_comb.comb_rate;

Tgaverage_nirsIMd = mean(scores_nirs.rate,3);
Tgaverage_eegIM  = mean(scores_eeg.rate,3);
Tgaverage_combIMd = mean(scores_comb.rate,3);
sTgaverage_nirsIMd = std(scores_nirs.rate,0,3);
sTgaverage_eegIM  = std(scores_eeg.rate,0,3);
sTgaverage_combIMd = std(scores_comb.rate,0,2);

TdivIMd = getdiversity(fnirsIMd,-feegIM);

%%%%%%%%%%%%%%  Oxy == o   %%%%%%%%%%%%%%%%%%%%%%%%%%%%

scores_nirs = getwindowscoresR(Nf(:,2,pa_subj),[],'+');

scores_eeg = getwindowscoresR(Ef(:,2,pa_subj),[],'-');

scores_comb = getwindowscoresR(Ef(:,2,pa_subj),Nf(:,2,pa_subj),'-','+');

Tiaverage_nirsAMo = mean(scores_nirs.rate,2);
Tiaverage_eegAM  = mean(scores_eeg.rate,2);
Tiaverage_combAMo = mean(scores_comb.rate,2);

Tcaverage_nirsAMo = scores_nirs.comb_rate;
Tcaverage_eegAM = scores_eeg.comb_rate;
Tcaverage_combAMo = scores_comb.comb_rate;

Tgaverage_nirsAMo = mean(scores_nirs.rate,3);
Tgaverage_eegAM  = mean(scores_eeg.rate,3);
Tgaverage_combAMo = mean(scores_comb.rate,3);
sTgaverage_nirsAMo = std(scores_nirs.rate,0,3);
sTgaverage_eegAM  = std(scores_eeg.rate,0,3);
sTgaverage_combAMo = std(scores_comb.rate,0,3);


TdivAMo = getdiversity(fnirsAMo,-feegAM);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scores_nirs = getwindowscoresR(Nf(:,1,pa_subj),[],'+');

scores_eeg = getwindowscoresR(Ef(:,1,pa_subj),[],'-');

scores_comb = getwindowscoresR(Ef(:,1,pa_subj),Nf(:,1,pa_subj),'-','+');

Tiaverage_nirsIMo = mean(scores_nirs.rate,2);
Tiaverage_eegIM  = mean(scores_eeg.rate,2);
Tiaverage_combIMo = mean(scores_comb.rate,2);

Tcaverage_nirsIMo = scores_nirs.comb_rate;
Tcaverage_eegIM = scores_eeg.comb_rate;
Tcaverage_combIMo = scores_comb.comb_rate;

Tgaverage_nirsIMo = mean(scores_nirs.rate,3);
Tgaverage_eegIM  = mean(scores_eeg.rate,3);
Tgaverage_combIMo = mean(scores_comb.rate,3);
sTgaverage_nirsIMo = std(scores_nirs.rate,0,3);
sTgaverage_eegIM  = std(scores_eeg.rate,0,3);
sTgaverage_combIMo = std(scores_comb.rate,0,3);

TdivIMo = getdiversity(fnirsIMo,-feegIM);


