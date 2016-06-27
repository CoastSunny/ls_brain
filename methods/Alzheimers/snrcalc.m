Nodes=[16 32 64 128 256 512 1024];
snr=[];

rng('shuffle');

for n=1:numel(Nodes)
    nodes=Nodes(n);
  
for i=1:100
      [W,We]=wRand(nodes,.5);
      snr(n,i)=norm(W,'fro')/norm(W-We,'fro');
end
end