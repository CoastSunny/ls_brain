
layers=[65 65 65];
sae=saesetup(layers);
opts.numepochs =   10;
opts.batchsize = 520;

for i=1:numel(layers)-1
    
    sae.ae{i}.activation_function       = 'tanh_opt';
    sae.ae{i}.learningRate              = 1;
    sae.ae{i}.inputZeroMaskedFraction   = 0.5;
    
end

[sae t outx]=saetrain(sae,x,opts);

