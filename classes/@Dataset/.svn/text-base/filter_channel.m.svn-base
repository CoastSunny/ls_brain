function filter_channel(obj,channel,freqband)

no_trials=numel(obj.markers);
%tic
for i = 1 : no_trials
    
    Y = obj.data.trial{ i }(channel,:);
    
    X(:,:,i)=Y;
    
end

fs=obj.data.fsample;
len=size(X,2);
filt=mkFilter(freqband,floor(len/2),fs/len);
X=fftfilter(X,filt,[0 len],2,1);

%X=detrend(X,2); % detrend over time

for i = 1 : no_trials
    
    obj.data.trial{ i }(channel,:)=X(:,:,i);
    
end
%toc
end