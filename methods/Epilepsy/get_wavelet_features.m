function out= get_wavelet_features(x,level,wname)
    
[c l]=wavedec(x,level,wname);
l=[1 cumsum(l)];l(end)=[];

for i=1:numel(l)-1
    

%% get max over sub-bands
MAX(i)=max([c(l(i):l(i+1))]); 

%% get min over sub-bands
MIN(i)=min([c(l(i):l(i+1))]); 

%% get mean over sub-bands
MEAN(i)=mean([c(l(i):l(i+1))]); 

%% get std over sub-bands
STD(i)=std([c(l(i):l(i+1))]); 

end


out=[MAX MIN MEAN STD];



end