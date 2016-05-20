
clear q
sbfiles=rdir('**/sbefore.*');

for i=1:6
    q{i}=load(sbfiles(i).name);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SB={q{1}.v.data q{2}.v.data q{3}.v.data q{4}.v.data q{5}.v.data q{6}.v.data};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear q
devfiles=rdir('**/deviants.*');

for i=1:6
    q{i}=load(devfiles(i).name);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DEV={q{1}.v.data q{2}.v.data q{3}.v.data q{4}.v.data q{5}.v.data q{6}.v.data};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Xst_st=cat(3, SB{1}{:}, SB{2}{:} , SB{3}{:});
Xst_dev=cat(3, DEV{4}{:} , DEV{5}{:}, DEV{6}{:});

Xst=cat(3,Xst_st,Xst_dev);
Yst=[ones(1,size(Xst_st,3)) -ones(1,size(Xst_dev,3))];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Xdev_st=cat(3, SB{4}{:} , SB{5}{:} ,SB{6}{:});
Xdev_dev=cat(3, DEV{1}{:} , DEV{2}{:}, DEV{1}{:});

Xdev=cat(3,Xdev_st,Xdev_dev);
Ydev=[ones(1,size(Xdev_st,3)) -ones(1,size(Xdev_dev,3))];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
freqband=[1 10];
%%%%

%%%%%STANDARDS CLASSIFIER%%%%%

X=Xst;
labels=Yst;
fs=256;
len=size(X,2);
filt=mkFilter(freqband,floor(len/2),fs/len);
X=fftfilter(X,filt,[0 len],2,0);

[clsfr, res]=cvtrainLinearClassifier(X,labels,[],10,'calibrate',[]);
std_cl=clsfr;
std_res=res;
max(res.tstbin)
save('std_cl','std_cl');

%%%%%DEVIANTS CLASSIFIER%%%%%

X=Xdev;
labels=Ydev;
fs=256;
len=size(X,2);
filt=mkFilter(freqband,floor(len/2),fs/len);
X=fftfilter(X,filt,[0 len],2,0);

[clsfr, res]=cvtrainLinearClassifier(X,labels,[],10,'calibrate',[]);
dev_cl=clsfr;
dev_res=res;
max(res.tstbin)
save('dev_cl','dev_cl');








