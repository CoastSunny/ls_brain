
fSAV=0;fWAV=0;
tSAV=0;tWAV=0;

for i=1:numel(cs)
    
fWAV=fWAV+cs{i}.out.fpr.wav;
fSAV=fSAV+cs{i}.out.fpr.sav;
tWAV=tWAV+cs{i}.out.tpr.wav;
tSAV=tSAV+cs{i}.out.tpr.sav;

end
fWAV=fWAV/numel(cs);
fSAV=fSAV/numel(cs);
tWAV=tWAV/numel(cs);
tSAV=tSAV/numel(cs);
