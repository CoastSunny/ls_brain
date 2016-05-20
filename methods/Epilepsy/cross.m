addpath ~/Dropbox/ls_bci/methods/Epilepsy/

subj={'A_S' 'B_G' 'E_N' 'C_R' 'D_L'};

R=[];

for ci=2:numel(subj)
    ci
    try cd /media/louk/Storage/Raw/Epilepsy/ 
    catch err
        cd ~/Documents/Epilepsy/
    end
    load(subj{ci})
    eval(['X=' subj{ci} ';'])
    eval(['spikes=' subj{ci} '_spikes;']);
    slicespikes
    
    for cj=2:numel(subj)
        
        train_epilepsy_classifier
        idx1=min(200,round(size(spikes,2)/2));
        idx2=min(201,round(size(spikes,2)/2+1));
        idx3=size(spikes,2);
        
        if ci~=cj                    
            eval(['sclsfr=' subj{cj} 'sclsfr;'])
            eval(['fsclsfr=' subj{cj} 'fsclsfr;'])
            eval(['fsclsfr2=' subj{cj} 'fsclsfr2;'])
        end
        
        apply_epilepsy_classifier
        
        R(ci,:,cj)=Res;
%         if ci==cj
%             qweqwe
%             On{ci}=sRw;
%         end
        
    end
end