fullpsp=[];
for si=1:numel(subj)
    
    try cd /media/louk/Storage/Raw/Epilepsy/
    catch err
        cd ~/Documents/Epilepsy/
    end
    
    eval(['pSP=' subj{si} '_pSP;']);
    fullpsp=[fullpsp pSP];
end
yyy=hist(fullpsp);

