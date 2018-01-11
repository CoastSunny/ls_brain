
fnames=fieldnames(cfg);
for i=1:numel(fnames)
   eval([ fnames{i} '=cfg.(fnames{' num2str(i) '});'])  
end
