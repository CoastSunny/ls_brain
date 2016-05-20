Ns=size(fXs,1);Ni=size(fXi,1);
trn=1:round(size(fx,4)/2);tst=trn(end)+1:size(fx,4);
rtrn=(2*numel(trn)+1):(2*numel(trn)+1)+round(size(frx,4)/2);rtst=rtrn(end)+1:(size(fx,4)+size(frx,4));

dictsize=15;

sparsitythres = 10; % sparsity prior
sqrt_alpha = 1; % weights for label constraint term
sqrt_beta = 1; % weights for classification err term
iterations = 100; % iteration number
iterations4ini = 20; % iteration number for initialization

H_train=zeros(2,numel(trn)+numel(rtrn));
H_train(1,trn)=1;
H_train(2,numel(trn)+1:end)=1;
fprintf('\nLC-KSVD initialization... ');
[Dinit,Tinit,Winit,Q_train] = initialization4LCKSVD(fXs(:,[trn rtrn]),H_train,dictsize,iterations4ini,sparsitythres);
fprintf('done!');

fprintf('\nDictionary learning by LC-KSVD1...');
[D1,X1,T1,W1] = labelconsistentksvd1(fXs(:,[trn rtrn]),Dinit,Q_train,Tinit,H_train,iterations,sparsitythres,sqrt_alpha);
save('.\trainingdata\dictionarydata1.mat','D1','X1','W1','T1');
fprintf('done!');

% run LC k-svd training (reconstruction err + class penalty + classifier err)
fprintf('\nDictionary and classifier learning by LC-KSVD2...')
[D2,X2,T2,W2] = labelconsistentksvd2(fXs(:,[trn rtrn]),Dinit,Q_train,Tinit,H_train,Winit,iterations,sparsitythres,sqrt_alpha,sqrt_beta);
save('.\trainingdata\dictionarydata2.mat','D2','X2','W2','T2');
fprintf('done!');

H_test=zeros(2,numel(tst)+numel(rtst));
H_test(1,1:numel(tst))=1;
H_test(2,numel(tst)+1:end)=1;
[prediction1,accuracy1] = classification(D1, W1, fXs(:,[tst rtst]), H_test, sparsitythres);
fprintf('\nFinal recognition rate for LC-KSVD1 is : %.03f ', accuracy1);

[prediction2,accuracy2] = classification(D2, W2, fXs(:,[tst rtst]), H_test, sparsitythres);
fprintf('\nFinal recognition rate for LC-KSVD2 is : %.03f ', accuracy2);
%%
% H_test=zeros(2,size(fx,4)+size(frx,4));
% H_test(1,1:size(fx,4))=1;
% H_test(2,size(fx,4)+1:end)=1;
% [prediction1,accuracy1] = classification(D1, W1, fXs, H_test, sparsitythres);
% fprintf('\nFinal recognition rate for LC-KSVD1 is : %.03f ', accuracy1);
% 
% [prediction2,accuracy2] = classification(D2, W2, fXs, H_test, sparsitythres);
% fprintf('\nFinal recognition rate for LC-KSVD2 is : %.03f ', accuracy2);