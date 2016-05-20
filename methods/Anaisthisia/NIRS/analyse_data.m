global bciroot;
bciroot = { '/Volumes/BCI_Data/' '/media/LoukStorage/' '~/Data/'};

expt='Raw/combined_eeg_nirs_2011';
subjects={ 'C4' 'C6' 'C7' 'C8' 'C9' 'C10' 'C11' 'C12' 'T2' 'T3' 'T5' 'T6' 'T7' 'T9' 'T10' };
%subjects={'C8'};

clear folds
clear decisionvalues

for si=1:numel(subjects);
   
   subj=subjects{si};
   
   z=jf_load(expt,subj,'control');
   z=jf_reref(z,'dim','time'); % remove DC offset

%    figure;jf_plot(z,'disptype','plott');
%    mkdir(fullfile(z.rootdir,z.subjdir,'figs'));
%    saveaspdf(fullfile(z.rootdir,z.subjdir,'figs','rawTime'));

%    z=jf_reref(z,'dim','ch');

   z=jf_reref(z,'dim','ch','wght','robust'); 
   z=jf_detrend(z,'dim','time');
 
% % select class for spectrogram or power values   
   % rest
%    z = jf_retain(z,'dim','epoch','idx',1:12);
   % actual/attempted
%    z = jf_retain(z,'dim','epoch','idx',13:24);
   % imagined
%    z = jf_retain(z,'dim','epoch','idx',25:36);

   
%    z=jf_rmOutliers(z,'dim','epoch');

% % % % % %  z=jf_rmOutliers(z,'dim','ch','thresh',3.5);
   
%    z=jf_spatdownsample(z,'dim','ch','method','sphericalSplineInterpolate','capFile','cap8_tmsi');
% 
%    clf;jf_plot(z,'disptype','plott');
%    saveaspdf(fullfile(z.rootdir,z.subjdir,'figs','rawTime_badEpochRm'));
%    
%    figure;jf_plotERP(z,'disptype','plott');
%    saveaspdf(fullfile(z.rootdir,z.subjdir,'figs','class_ERPs'));
%    
%    z = jf_retain(z,'dim','epoch','idx',13:24);
%    z = jf_spectrogram(z,'width_ms',250,'log',0,'detrend',1);
%    z = jf_baseline(z,'dim','time','period',[-3000 -2000],'op','-');
% 
%    z =jf_retain(z,'dim','time','range','between','vals',[-1000 20000],'valmatch','nearest','summary','1s win');
% 
% 
%    % keep only the frequencies we're interested in
%    z=jf_retain(z,'dim','freq','range','between','vals',[0 45], 'valmatch','nearest');
%    z =rmfield(z,{'Y','Ydi'});
%    z=jf_addPosInfo(z);
% 
%    figure;
%    jf_plotERP(z, 'disptype', 'image', 'clim',[-20 20]); colormap ikelvin
%    saveaspdf(fullfile(z.rootdir,z.subjdir,'figs','tfr'));

% -------------------------------------------------------------------------
% compute spectral power values

z=jf_retain(z,'dim','time','range','between','vals',[0 15000],'valmatch','nearest','summary','1s win');

% z=jf_welchpsd(z,'width_ms',250,'log',1,'detrend',1);
% z=jf_retain(z,'dim','freq','range','between','idx',4);
% %
% % z = jf_retain(z,'dim','ch','vals','C3');
% %
% csvwrite([subj '_powervalues_IM.csv'],z.X);
% -------------------------------------------------------------------------

% % classification

z=jf_addClassInfo(z,'markerdict',struct('marker',[1 2 3],'label',{{'rest' 'AM' 'IM'}}));
z=jf_addClassInfo(z,'spType',{{{'rest'} {'AM'}}...
                    {{'rest'} {'IM'}}},'summary','rest vs move'); 
                
% % cut up data into 3-sec epochs 

if strcmp(subjects{si},'C8')

    z=jf_reject(z,'dim','epoch','range','between','vals',[20 21]);

end
if strcmp(subjects{si},'T3')
    z=jf_reject(z,'dim','ch','idx',[3 4]);
end

z=jf_windowData(z,'dim','time','width_ms',3000,'overlap',0);
z.Y=repmat(reshape(z.Y,[size(z.Y,1) 1 size(z.Y,2)]),[1,size(z.X,n2d(z,'window'))]);
z.Ydi=mkDimInfo(size(z.Y),{'epoch','window','subProb'});

% % remove outliers after cutting up data

% % % % z=jf_permute(z,'dim',{'ch' 'time' 'epoch' 'window'});
% % % % z=jf_compressDims(z,'dim',{'epoch' 'window'});
% % % % z=jf_rmOutliers(z,'dim','epoch_window');
                
% % 10-fold CV

%z.foldIdxs=gennFold(z.Y,12);
%% custom fIdxs
nfolds=12;
z.foldIdxs=-ones(36,5,nfolds);
if strcmp(subjects{si},'C8')
    z.foldIdxs=-ones(34,5,nfolds);
end
for i=1:nfolds
    
    if strcmp(subjects{si},'C8')
    
    z.foldIdxs([i i+12 i+22],:,i)=ones(3,5);

    else
    
    z.foldIdxs([i i+12 i+24],:,i)=ones(3,5);
    
    end    

end
% nfolds=6;
% z.foldIdxs=-ones(36,5,nfolds);
% if strcmp(subjects{si},'C8')
%     z.foldIdxs=-ones(34,5,nfolds);
% end
% count=0;
% for i=[1 3 5 7 9 11]%:nfolds
%     
%     if strcmp(subjects{si},'C8')
%     
%     z.foldIdxs([i:i+1 i+12:i+13 i+22:i+23],:,count)=ones(6,5);
% 
%     else
%     
%     z.foldIdxs([i:i+1 i+12:i+13 i+24:i+25],:,count)=ones(6,5);
%     
%     end    
% count=count+1;
% end


%%
% leave-one-out folding
% z.foldIdxs=gennFold(z.Y,'loo');
% 
% % map to frequency domain, with 4hz frequency resolution

z=jf_welchpsd(z,'width_ms',250,'log',1,'detrend',1);

% % 
% z=jf_retain(z,'dim','freq','range','between','vals',[0 45], 'valmatch','nearest');
% % 
% clf;jf_plotERP(z,'disptype','plott');
% saveaspdf(fullfile(z.rootdir,z.subjdir,'figs',[subj '_welchERP']));
% clf;jf_plotAUC(z);
% saveaspdf(fullfile(z.rootdir,z.subjdir,'figs',[subj '_welchAUC']));
% %
% %

z=jf_retain(z,'dim','freq','range','between','vals',[8 24], 'valmatch','nearest');

% %
% % 
% % 

jf_disp(z)

% %
% % if ( 0 ) 
% % run the classifier (training set specified above (10-fold/1st block))

z=jf_cvtrain(jf_compKernel(z),'mcPerf',0);

% 
% 
%    % plot classifier weights, per frequency bin, per condition
%     wghts = jf_clsfrWeights(z);
%     figure;jf_topoplot(wghts,'clim','cent0','layout',[5 2]);colormap ikelvin

% compute decision values
% decisionvalues = z.prep(end).info.res.opt.f;
% save([subj '_decValues_3sec'], 'decisionvalues');

% compute decision values outer fold 
decisionvalues{si} = z.prep(end).info.res.tstf(:,:,z.prep(end).info.res.opt.Ci);
% 

fIdxs=z.foldIdxs;
clear fI

for fu=1:nfolds
    
    temp=fIdxs(:,:,fu)';
    temp=temp(:);
    fI(:,fu)=temp';
    
end

folds{si} = fI;

try
G.(subjects{si}).default.addprop('eeg');
catch err
end
dv=decisionvalues{si};

am=dv(:,1);
am=reshape(am,size(fIdxs,1),size(fIdxs,2));
im=dv(:,2);
im=reshape(im,size(fIdxs,1),size(fIdxs,2));
markers=cell2mat(squeeze(struct2cell(z.di(1).extra)));
restnumidx=find(markers==1);
amnumidx=find(markers==2);
imnumidx=find(markers==3);
G.(subjects{si}).default.eeg.fam=am([restnumidx' amnumidx'],:);
G.(subjects{si}).default.eeg.fim=im([restnumidx' imnumidx'],:);
tmp=squeeze(z.prep(end).info.res.tstbin(1,:,:));
G.(subjects{si}).default.eeg.perf=max(tmp');
G.(subjects{si}).default.eeg.fI=fI;

% save([subj '_decValues_3sec'], 'decisionvalues');


% % % % get the test-set only decision values.
% dvout = [];
% Yout = [];
% if ( isfield(z,'outfIdxs') )
%     for spi=1:size(z.Y,2);
%         fIdxs= z.outfIdxs>0 & z.Y(:,spi)~=0;
%         Yout{spi} = z.Y(fIdxs,spi);
%         dvout{spi}= z.prep(end).info.res.opt.f(fIdxs,spi);
%     end
% end
% % % save([subj '_decValues_3sec'],'Yout','dvout');

end
   