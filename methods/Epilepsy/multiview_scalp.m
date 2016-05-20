Dm=[];
Ns=1;Nf=1;Nt=1;
sels=Ns;self=1:Nf;selt=1:Nt;
classifiyall_tcv
epilepsy_classifier_tcv
cross_combine_ftNL2classifiers
Dm(end+1,:)=[mean(R(:,2)) mean(diag(rt2))];

Ns=2;Nf=Ns;Nt=Ns;
sels=Ns;self=1:Nf;selt=1:Nt;
classifiyall_tcv
epilepsy_classifier_tcv
cross_combine_ftNL2classifiers
Dm(end+1,:)=[mean(R(:,2)) mean(diag(rt2))];

Ns=3;Nf=Ns;Nt=Ns;
sels=Ns;self=1:Nf;selt=1:Nt;
classifiyall_tcv
epilepsy_classifier_tcv
cross_combine_ftNL2classifiers
Dm(end+1,:)=[mean(R(:,2)) mean(diag(rt2))];

Ns=4;Nf=Ns;Nt=Ns;
sels=Ns;self=1:Nf;selt=1:Nt;
classifiyall_tcv
epilepsy_classifier_tcv
cross_combine_ftNL2classifiers
Dm(end+1,:)=[mean(R(:,2)) mean(diag(rt2))];

Ns=5;Nf=Ns;Nt=Ns;
sels=Ns;self=1:Nf;selt=1:Nt;
classifiyall_tcv
epilepsy_classifier_tcv
cross_combine_ftNL2classifiers
Dm(end+1,:)=[mean(R(:,2)) mean(diag(rt2))];

Ns=6;Nf=Ns;Nt=Ns;
sels=Ns;self=1:Nf;selt=1:Nt;
classifiyall_tcv
epilepsy_classifier_tcv
cross_combine_ftNL2classifiers
Dm(end+1,:)=[mean(R(:,2)) mean(diag(rt2))];
