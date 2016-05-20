
loadvarnamesE={'PP1v1Day1','PP2v1','PP3v1','PP4v1','PP5v1','PP6v1','PP7v1','PP8v1'...
    'PP1v2Day1','PP2v2','PP3v2','PP4v2','PP5v2','PP7v2','PP8v2'};
varnamesEproper={'PP1v1','PP2v1','PP3v1','PP4v1','PP5v1','PP6v1','PP7v1','PP8v1'...
    'PP1v2','PP2v2','PP3v2','PP4v2','PP5v2','PP7v2','PP8v2'};
addpath /media/louk/Storage/Extracted/APLO/Day1

nosubj=15;
G=Group;
channels=1:64;
time=1:64;

for i=1:nosubj%numel(loadvarnamesE)
   
    S=load(loadvarnamesE{i});
    S=S.(varnamesEproper{i});
    if i<16
    G.addprop(varnamesEproper{i});
    G.(varnamesEproper{i})=S;
    end
end

% 
for i=1:numel(loadvarnamesE)   
    S=load(loadvarnamesE{i});
    S=S.(varnamesEproper{i});
    out1{i}=S.default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,'time',time,'channels',channels,'freqband',[.5 13]);
    R1(i)=out1{i}.rate;
    R1l(i)=0.5*(out1{i}.rn+out1{i}.rp);
end

for i=1:numel(loadvarnamesE)   
    S=load(loadvarnamesE{i});
    S=S.(varnamesEproper{i});
    out2{i}=S.default.train_classifier('classes',{{16};{22}},'blocks_in',1:4,'time',time,'channels',channels,'freqband',[.5 13]);
    R2(i)=out2{i}.rate;
    R2l(i)=0.5*(out2{i}.rn+out2{i}.rp);
end

% channels=1:64;
% time=1:64;
% Ct=[];
% classes={{14};{20}};
% delete(findprop(G,'all'))
% for i=1:nosubj
%    G.combine_subjects('exclusion',varnamesEproper{i});
%    G.all.default.train_classifier('Cs',Ct,'nfolds',10,...
%         'classes',classes,'blocks_in','all','time',time,'channels',channels,...
%         'freqband',[0.5 13],'objFn','klr_cg');
%    gen_normal=G.all.default.apply_classifier(G.(varnamesEproper{i}).default,...
%             'trials','all','classes',classes,'blocks_in',1:4,...
%             'freqband',[0.5 13],'time',time,'channels',channels);
%    Gen_normal(i)=gen_normal.rate(3);
%    delete(findprop(G,'all'));     
% end
