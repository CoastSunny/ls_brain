function gi = group_idx(data,g1,g2,g3)

g1=~isempty(findstr(data.cfg.datafile,g1{1}));
g2=~isempty(findstr(data.cfg.datafile,g2{1}));
g3=~isempty(findstr(data.cfg.datafile,g3{1}));

gi=[g1 g2 g3];
end