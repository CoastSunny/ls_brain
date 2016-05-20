load gJPv,load gJPsv,load gNLv, load gNLsv
% %%% N.B INDICES
% %%% rows are source
% %%% columns are target
% %%% jpv=1,jpsv=2,nlv=3,nlsv=4
% %%% e.g. res{2,4} means train on jpsv apply on nlsv
res{1,1}=gemi_mself(gJPv);
res{2,2}=gemi_sself(gJPsv);
res{3,3}=gemi_mself(gNLv);
res{4,4}=gemi_sself(gNLsv);

gJPv.combine_subjects;
gJPv.all.default.train_classifier('name','groupL','classes',{{50 51 52 53};{15 25 35 45}});
gJPsv.combine_subjects;
gJPsv.all.default.train_classifier('name','groupL','classes' , {{12};{20}});
gNLv.combine_subjects;
gNLv.all.default.train_classifier('name','groupL','classes',{{50 51 52 53};{15 25 35 45}});
gNLsv.combine_subjects;
gNLsv.all.default.train_classifier('name','groupL','classes' , {{12};{20}});

%%%%%% TARGET gJPv %%%%%%

res{4,1}=gemi_mcl(gNLv.all,gJPv);
res{3,1}=gemi_mcl(gNLsv.all,gJPv);
res{2,1}=gemi_mcl(gJPsv.all,gJPv);
save('res','res')

%%%%%% TARGET gJPsv %%%%%%

res{3,2}=gemi_scl(gNLv.all,gJPsv);
res{1,2}=gemi_scl(gJPv.all,gJPsv);
res{4,2}=gemi_scl(gNLsv.all,gJPsv);
save('res','res')

%%%%%% TARGET gNLv %%%%%%

res{4,3}=gemi_mcl(gNLsv.all,gNLv);
res{1,3}=gemi_mcl(gJPv.all,gNLv);
res{2,3}=gemi_mcl(gJPsv.all,gNLv);
save('res','res')

%%%%%% TARGET gNLsv %%%%%%

res{3,4}=gemi_scl(gNLv.all,gNLsv);
res{1,4}=gemi_scl(gJPv.all,gNLsv);
res{2,4}=gemi_scl(gJPsv.all,gNLsv);
save('res','res')

%%%%% MULTIPLE SOURCES %%%%%%
clear all
load res
load gJPv,load gJPsv,load gNLv, load gNLsv
gJPv.combine_subjects;
gJPsv.combine_subjects;
gNLv.combine_subjects;
gNLsv.combine_subjects;

gnlsvnlv=Group;
tmp1=gNLv.all.default;tmp1.retain_trials('markers',{15 25 35 45 50 51 52 53});
tmp2=gNLsv.all.default;tmp2.retain_trials('markers',{12 20});
gnlsvnlv.addprop('g1');gnlsvnlv.addprop('g2');gnlsvnlv.g1=Subject;gnlsvnlv.g2=Subject;
gnlsvnlv.g1.addprop('default');gnlsvnlv.g2.addprop('default');
gnlsvnlv.g1.default=tmp1;gnlsvnlv.g2.default=tmp2;
gnlsvnlv.combine_subjects
gnlsvnlv.all.default.train_classifier('name','groupL','classes',{{12 50 51 52 53};{20 15 25 35 45}});


gjpsvjpv=Group;
tmp1=gJPv.all.default;tmp1.retain_trials('markers',{15 25 35 45 50 51 52 53});
tmp2=gJPsv.all.default;tmp2.retain_trials('markers',{12 20});
gjpsvjpv.addprop('g1');gjpsvjpv.addprop('g2');gjpsvjpv.g1=Subject;gjpsvjpv.g2=Subject;
gjpsvjpv.g1.addprop('default');gjpsvjpv.g2.addprop('default');
gjpsvjpv.g1.default=tmp1;gjpsvjpv.g2.default=tmp2;
gjpsvjpv.combine_subjects
gjpsvjpv.all.default.train_classifier('name','groupL','classes',{{12 50 51 52 53};{20 15 25 35 45}});

clear gNLsv gNLv gJPsv gJPv
load gJPv,load gJPsv,load gNLv, load gNLsv

res{5,4}=gemi_scl(gjpsvjpv.all,gNLsv);
res{6,4}=gemi_scl(gnlsvnlv.all,gNLsv);
res{5,3}=gemi_mcl(gjpsvjpv.all,gNLv);
res{6,3}=gemi_mcl(gnlsvnlv.all,gNLv);

save('res','res')
