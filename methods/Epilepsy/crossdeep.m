


itest=1:8;
Xtr=[];ytr=[];
Xtst=[];ytst=[];
tst=4;
itrain=setdiff(itest,[tst 1 2 3]);
    
for i=itrain
    
    Xtr=cat(1,data(i).Xtr.^2,Xtr);    
    ytr=cat(2,data(i).ytr,ytr);
    
end
layers=[szf szf/8];
Xtst=data(tst).Xtst.^2;
ytst=data(tst).ytst;

n_examples=size(Xtr,1);
szf=size(Xtr,2);

layers=[szf szf/2 szf/4];
sae=[];
sae=saesetup(layers);
opts.numepochs =  5;
opts.batchsize = n_examples/54;

for i=1:numel(layers)-1
    
    sae.ae{i}.activation_function       = 'tanh_opt';
    sae.ae{i}.learningRate              = 1;
    %sae.ae{i}.nonSparsityPenalty=.1;
    sae.ae{i}.inputZeroMaskedFraction   = 1;
    %sae.ae{i}.weightPenaltyL2=.1;
   % sae.ae{i}.sparsityTarget=0.5;
    %sae.ae{i}.dropoutFraction=0.5;
    
end
rand('state',0)
[sae, t, outxtr]=saetrain(sae,Xtr,opts);

% sae.ae{1}.W{1}=randn(size(sae.ae{1}.W{1}));
% sae.ae{2}.W{1}=randn(size(sae.ae{2}.W{1}));
% sae.ae{3}.W{1}=randn(size(sae.ae{3}.W{1}));

[sae, t, outxtst]=saeff(sae,Xtst);
[sae, t, outxtr]=saeff(sae,Xtr);

[hofclsfrtr, hofrestr]=cvtrainKernelClassifier(outxtr',ytr,[],10,'dim',2,'par1',par1,'par2',par2,'kerType',kerType);
[hofclsfrtst, hofrestst]=cvtrainKernelClassifier(outxtst',ytst,[],10,'dim',2,'par1',par1,'par2',par2,'kerType',kerType);
[f]=applyLinearClassifier(outxtst',hofclsfrtr);
out=fperf(f,ytst');
hperftr=max(hofrestr.tstbin);
hperftst=max(hofrestst.tstbin);
hperfcrs=out.perf
rand('state',0)
nn = nnsetup([layers 1]);
nn.activation_function              = 'tanh_opt';
nn.output='sigm';
nn.learningRate                     = 1;
nn.weightPenaltyL2=0.001;
for i=1:numel(layers)-1
    nn.W{i} = sae.ae{i}.W{1};
end

% Train the FFNN
opts.numepochs =  1;
opts.batchsize = n_examples;
nn = nntrain(nn, Xtr, ytr'==1, opts);
[ertst, bad] = nntest(nn, Xtst, ytst'==1);
[ertr, bad] = nntest(nn, Xtr, ytr'==1);
ertr,ertst