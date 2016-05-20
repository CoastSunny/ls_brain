function z=preproc_anthesia(z)
% idx=subsrefDimInfo(z.di,'dim','ch','idx',[z.di(n2d(z.di,'ch')).extra.iseeg]);
% % % sub-set down to 6 channels
% % z=jf_retain(z,'dim','ch','vals',{'C3' 'C4' 'Cz' 'CP3' 'CP4' 'CPz'});
% z=jf_linDetrend(z,'dim','time','subIdx',idx); % remove slow drifts -- and make fftfilter work
% z=jf_rmOutliers(z,'dim','ch','idx',[z.di(n2d(z.di,'ch')).extra.iseeg]); % bad-ch rm
% z=jf_reref(z,'dim','ch','summary','CAR','idx',[z.di(n2d(z.di,'ch')).extra.iseeg],'wght','robust'); % CAR
% idx=subsrefDimInfo(z.di,'dim','ch','idx',[z.di(n2d(z.di,'ch')).extra.iseeg]); 
% %z=jf_rmOutliers(z,'dim','epoch','subIdx',idx,'thresh',3.5,'mode','reject'); % bad-epoch rm
% z=jf_rmOutliers(z,'dim','ch','idx',[z.di(n2d(z.di,'ch')).extra.iseeg],'thresh',3.5); % bad-ch rm
% if ( ~isempty(z.prep(end).info.rejectidx) ) % only bother if something changed
%   z=jf_reref(z,'dim','ch','summary','CAR','idx',[z.di(n2d(z.di,'ch')).extra.iseeg],'wght','robust'); % CAR
%   idx=subsrefDimInfo(z.di,'dim','ch','idx',[z.di(n2d(z.di,'ch')).extra.iseeg]);
%   z=jf_rmOutliers(z,'dim','epoch','subIdx',idx,'thresh',3.5,'mode','reject');
% end
% z=jf_spatdownsample(z,'dim','ch','method','slap','capFile','cap64');
% 
% if ( ~exist(fullfile(z.rootdir,z.expt,z.subj,z.session,'figs'),'dir') )
%    mkdir(fullfile(z.rootdir,z.expt,z.subj,z.session,'figs'));
% end


% % sub-set down to 6 channels (6a)
% z=jf_retain(z,'dim','ch','vals',{'C3' 'C4' 'Cz' 'CP3' 'CP4' 'CPz'});
% (6b)
% z=jf_retain(z,'dim','ch','vals',{'C3' 'C4' 'Cz' 'P3' 'P4' 'Pz'});
% (9a)
% z=jf_retain(z,'dim','ch','vals',{'C3' 'C4' 'CP3' 'CP4' 'Cz' 'C5' 'C6' 'FC3' 'FC4'});
% (9b)
%z=jf_retain(z,'dim','ch','vals',{'C3' 'C4' 'P3' 'P4' 'Cz' 'T7' 'T8' 'F3' 'F4'});%<<correct
if (numel(z.di(1).vals)==32)
idxch32=[13 15 24 26 14 12 16 4 6];
idxch=idxch32;
else
    idxch64=[13 50 21 58 48 15 52 5 40];
    idxch=idxch64;
end

z=jf_retain(z,'dim','ch','idx',idxch);%<<correct

%z=jf_retain(z,'dim','ch','vals',{z.di(1).vals(1:32)});
% (9c)
% z=jf_retain(z,'dim','ch','vals',{'C3' 'C4' 'CP3' 'CP4' 'Cz' 'T7' 'T8' 'FC3' 'FC4'});
% (9d)
% z=jf_retain(z,'dim','ch','vals',{'C3' 'C4' 'P3' 'P4' 'Cz' 'T7' 'T8' 'FC3' 'FC4'});
% % sub-set down to 10 channels (10a)
% z=jf_retain(z,'dim','ch','vals',{'C3' 'C4' 'CP3' 'CP4' 'C1' 'C2' 'C5' 'C6' 'FC3' 'FC4'});
% (10b)
% z=jf_retain(z,'dim','ch','vals',{'C3' 'C4' 'CP3' 'CP4' 'Cz' 'T7' 'T8' 'FC3' 'FC4' 'CPz'});
% laplacian C3
% z=jf_retain(z,'dim','ch','vals',{'C3' 'Cz' 'P3' 'F3'});
% 18 channels (Tam et al. 2011)
% z=jf_retain(z,'dim','ch','vals',{'FC5' 'FC3' 'FC1' 'C5' 'C3' 'C1' 'CP5' 'CP3' 'CP1' 'FC2' 'FC4' 'FC6' 'C2' 'C4' 'C6' 'CP2' 'CP4' 'CP6'});
% 12 channels
% z=jf_retain(z,'dim','ch','vals',{'FC3' 'C5' 'C3' 'C1' 'CP3' 'FC4' 'C2' 'C4' 'C6' 'CP4' 'T7' 'T8'});
% z=jf_retain(z,'dim','ch','vals',{'FC3' 'C5' 'C3' 'C1' 'CP3' 'FC4' 'C2' 'C4' 'C6' 'CP4' 'Cz' 'CPz'});
% z=jf_retain(z,'dim','ch','vals',{'F3' 'C5' 'C3' 'C1' 'P3' 'F4' 'C2' 'C4' 'C6' 'P4' 'Cz' 'CPz'});
% map to 32 channels when running out of memory
% z=jf_retain(z, 'dim', 'ch', 'vals', {'Fp1' 'AF3' 'F7' 'F3' 'FC1' 'FC5' 'T7' 'C3' 'CP1' 'CP5' 'P7' 'P3' 'Pz' 'PO3' 'O1' 'Oz' 'O2' 'PO4' 'P4' 'P8' 'CP6' 'CP2' 'C4' 'T8' 'FC6' 'FC2' 'F4' 'F8' 'AF4' 'Fp2' 'Fz' 'Cz'});
% for combined NIRS/EEG study
% z=jf_retain(z,'dim','ch','vals',{'C3' 'C5' 'FC3' 'CP3' 'C4' 'C6' 'FC4' 'CP4'});


idx=subsrefDimInfo(z.di,'dim','ch','idx',[z.di(n2d(z.di,'ch')).extra.iseeg]);
z=jf_linDetrend(z,'dim','time','subIdx',idx); % remove slow drifts -- and make fftfilter work
% z=jf_rmOutliers(z,'dim','ch','idx',[z.di(n2d(z.di,'ch')).extra.iseeg]); %
% bad-ch rm

z=jf_reref(z,'dim','ch','summary','CAR','idx',[z.di(n2d(z.di,'ch')).extra.iseeg],'wght','robust'); % CAR
% z=jf_reref(z,'dim','ch','vals',{'T7' 'T8'},'wght','robust');
%idxwhiten=[1:7 9];
%z=jf_retain(z,'dim','ch','idx',idxwhiten);%<<correct

idx=subsrefDimInfo(z.di,'dim','ch','idx',[z.di(n2d(z.di,'ch')).extra.iseeg]); 
%z=jf_rmOutliers(z,'dim','epoch','subIdx',idx,'thresh',3.5,'mode','reject'); % bad-epoch rm
z=jf_rmOutliers(z,'dim','ch','idx',[z.di(n2d(z.di,'ch')).extra.iseeg],'thresh',3.5); % bad-ch rm
if ( ~isempty(z.prep(end).info.rejectidx) ) % only bother if something changed
z=jf_reref(z,'dim','ch','summary','CAR','idx',[z.di(n2d(z.di,'ch')).extra.iseeg],'wght','robust'); % CAR
end
% z=jf_reref(z,'dim','ch','wght',{'P9' 'P10'});

% % % % % % idx=subsrefDimInfo(z.di,'dim','ch','idx',[z.di(n2d(z.di,'ch')).extra.iseeg]);
% % % % % %  
% % % % % % louk 5/11/13 
% % % % % % z=jf_rmOutliers(z,'dim','epoch','subIdx',idx,'thresh',3.5,'mode','reject'); 

% instead of above: for aussiedata
% z=jf_rmOutliers(z,'dim','window','subIdx',idx,'thresh',3.5,'mode','reject');

end



% do EOG removal
% z=jf_artChRm(z,'dim','ch','vals',{'EOG_HR' 'EOG_HL' 'EOG_VU' 'EOG_VL'});

%z=jf_spatdownsample(z,'dim','ch','method','slap','capFile','cap64');
% z=jf_spatdownsample(z,'dim','ch','method','slap','capFile','cap32');

% for combined NIRS/EEG with TMSi 8 channel setup:
% z=jf_spatdownsample(z,'dim','ch','method','sphericalSplineInterpolate','capFile','cap8_tmsi');


% when not using all channels:
% z=jf_spatdownsample(z,'dim','ch','method','slap');
% z=jf_spatdownsample(z,'dim','ch','method','hjorth');

% if ( ~exist(fullfile(z.rootdir,z.expt,z.subj,z.session,'figs'),'dir') )
%    mkdir(fullfile(z.rootdir,z.expt,z.subj,z.session,'figs'));
% end
