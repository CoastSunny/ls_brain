

for i=1:size(spikes,2)
  
    sY=sEEG(:,:,i);
    iY=iEEG(:,:,i);
    
    W = inv(iY*iY')*iY*sY';
    Wfm(:,:,i)=W;

end