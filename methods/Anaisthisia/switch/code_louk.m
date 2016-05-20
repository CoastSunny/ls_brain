% The first dataset was used to determine the optimal settings of a
% movement-based brain switch for use during surgery. In this experiment,
% auditory cues were played for subjects instructing them to perform a
% certain type of movement: 1) right-hand movement, 2) movement of both
% arms or 3) no movement. After each instruction, a sequence of nine 3-second trials
% followed (each of the same movement type). 
% Initially, we compared the classification results between 'right hand
% movement' and 'both arms movement' (both using 'no movement' as the
% baseline class). We didn't find any major differences but nevertheless
% 'both arms movement' performed slightly better so we chose to use only this
% condition for further analysis. 

% The data for this experiment can be found in
% '/Volumes/BCI_Data/own_experiments/motor_imagery/movement_detection/trial
% _based/offline/'

% To load use the following loop (preprocessing steps etc. are within the loop):

% 
% First, make sure you have the following folders added to your matlab path:
% 
% 'BCI_code/toolboxes/jf_bci/'
% 'BCI_code/toolboxes/classification/'
% 'BCI_code/toolboxes/eeg_analysis/'
% 'BCI_code/toolboxes/numerical_tools'
% 'BCI_code/toolboxes/plotting'
% 'BCI_code/toolboxes/signal_processing/'
% 'BCI_code/toolboxes/utilities/'

global bciroot;
% N.B. add the directory where the BCI_Data is mounted to this list for the
% system to find the raw data files and the saved files,
% e.g. bciroot={bciroot{:} '/Volumes/BCI_Data/'};
% bciroot = '/Users/louk/Data/Raw/'; 
bciroot = {'/Users/louk/Data/Raw/' '/home/louk/Data/' '/media/LoukStorage/Raw'};
expt    = 'trial_based/offline';
%expt    = 'own_experiments/motor_imagery/movement_detection/trial_based/offline';
subjects= {'linsey' 'Jorgen' 'makiko' 'lucinda' 'jason' 'moniek' 'chris' 'nienke' 'yvonne' 'rutger'}; % subj{
sessions= {{'20110112'} {'20110114'} {'20110118'} {'20110120'} {'20110131'} {'20110323'} {'20110323'} {'20110330'} {'20110406'} {'20110413'}}; % subj{ session{
labels  ={'trn'}; 
%condition{

% expt    = 'own_experiments/motor_imagery/movement_detection/long_movements/';
% subjects= {'yvonne' 'jeroen' 'alex' 'hans' 'linsey' 'marjolein' 'fatma' 'jason' 'betul' 'rik' 'makiko'}; % subj{
% sessions= {{'20110719'} {'20110720'} {'20110721'} {'20111115'} {'20111121'} {'20111124'} {'20111212'} {'20111214'} {'20111216'} {'20111222'}}; % subj{ session{
% labels  ={'1sec'}; %condition{
%%%%%%RESULTS FOR WORST CASE SUBJECT
for si=1:numel(subjects)
% si=1; % pick a subject number
sessi=1; ci=1; % session and condition are always the 1st

% get the info for this subject
subj=subjects{si};
session=sessions{si}{sessi};
label=labels{ci};

% load the sliced data
z=jf_load(expt,subj,label,session,-1);

% reject all epochs which came from the 5th source file, i.e. block 5. We
% used this because some of the subjects only did 4 experiment blocks instead of 5. 
z=jf_reject(z,'dim','epoch','idx',[z.di(3).extra.src]==5);

% run the pre-processing (file attached)
z=preproc_anthesia(z);
 
% setup 1st block only folding. This was used to simulate a 'preoperative
% calibration session' or simply an online study in general. So, the first
% block of data is used for training of the classifier and the remaining
% blocks are used for testing. 

z.foldIdxs=zeros(size(z.Y,1),8);
trnInd=[z.di(n2d(z,'epoch')).extra.src]==1;% | [z.di(n2d(z,'epoch')).extra.src]==2;% | [z.di(n2d(z,'epoch')).extra.src]==3;
z.foldIdxs(trnInd,1:8)=gennFold(z.Y(trnInd,:),8); % 10-fold     
z.outfIdxs=zeros(size(z.Y,1),1); z.outfIdxs(trnInd)=-1; z.outfIdxs(~trnInd)=1; % outer-fold

% 10-fold CV. Alternatively, use 10-fold cross validation (generally higher
% performance, but less relevant for eventual application than '1-st block
% only' folding).
% z.foldIdxs=gennFold(z.Y,10);

% save copy of the data before we do more stuff to it..
oz=z; % N.B. use z=oz; to get back to 'clean' version of data to try alternative pre-processings

% setup 2 sub-problems, rest vs rh, and rest vs. any (to only look at 'both
% arms movement' results: just take the second one (rest vs. any)). 'rest
% 3', 'rest4', 'rest5' etc. were combined because they are the same type of trial, 
% just with a different baseline duration (something we didn't use for analysis in the end). 
z=jf_addClassInfo(z,...
                  'spType',{...%{{'rest3' 'rest4' 'rest5'} {'rh3' 'rh4' 'rh5'}}...
                    {{'rest3' 'rest4' 'rest5'} {'any3' 'any4' 'any5'}}},'summary','rest vs move'); 

% % % setup 2 sub-problems, rest vs im, and rest vs. am
% z=jf_addClassInfo(z,...
%                   'spType',{{{'NO1'} {'IM1'}}...
%                     {{'NO1'} {'AM1'}}},'summary','rest vs move'); 


% remove everything but the eeg channels
z=jf_retain(z,'dim','ch','idx',[z.di(1).extra.iseeg],'summary','eeg-only');

% For analysis, we used two different time periods, the 'ERD period' during
% movement (0-4 seconds, movement officially ends at t=3 but subjects
% needed some response time) and the 'ERS period' (4-6 seconds). 

% % For analysis using only the ERD period, simply remove the rest of the data using:
% 
%     % sub-set down to 4s of data from time 0-4 after the marker
%     z=jf_retain(z,'dim','time','range','between','vals',[0 4000],'valmatch','nearest','summary','1s win');
% 
%     %and then 
%     % map to frequency domain, with 4hz frequency resolution using Welch's method
%     z=jf_welchpsd(z,'width_ms',250,'log',1,'detrend',1);
%     
%     % keep only the frequencies we're interested in
%     z=jf_retain(z,'dim','freq','range','between','vals',[8 24]);
            
%   For analysis using the combined ERD and ERS periods, use the following lines instead:    

    % use spectrogram instead of Welch when using multiple time windows: compute a spectrum every 250ms with a freq resolution of 4hz
    z = jf_spectrogram(z,'width_ms',250,'log',0,'detrend',1);

    % keep only the frequencies we're interested in
    z = jf_retain(z,'dim','freq','range','between','vals',[8 24]);


    % % Use several time windows
    % average this spectrum in 2 different phases of time
    tD=n2d(z,'time',0,0); if ( tD==0 ) tD=n2d(z,'window'); end;
    % make a filter (weighting over time) for each of the 2 phases we care about
    w=mkFilter(size(z.X,tD),{{[0 250 3750 4000]} {[4000 4250 5750 6000]}},z.di(tD).vals);
    w=repop(w,'./',sum(w)); % make into means
    % apply this filter to the data to compute the average power in each phase
    z=jf_linMapDim(z,'dim',tD,'mx',w,'di',mkDimInfo(size(w,2),1,'movementperiods',[],{'ERD' 'ERS'}));
%     tmp=z.Y==1;
%     a=z.X(38,:,1,tmp);
%     b=mean(a,4);
%     c=mean(b,3);
%     d=mean(c,2);
%     e=mean(d);
%     p(si)=e;
%     p(si)
% show the current state of the data
jf_disp(z)

% %Sequence decoding
% % create a new sequence dimension, by grouping epochs into sequences
% z=jf_splitDim(z,'dim','epoch','seqLen', 3, 'seqFold',1);
% % Then setup to automatically do sequence decoding
% spD=n2d(z.Ydi,'subProb');
% z.Ydi(spD).info.mcSp=1; % treat as multiclass problem
% z.Ydi(spD).info.spMx=repmat(shiftdim(z.Ydi(spD).info.spMx,-1),[size(z.X,n2d(z,'epoch')),1,1]);
% z.Ydi(spD).info.spD ={'subProb' 'epoch'};

% run the classifier (mcPerf 1: multi-class for sequence decoding)

    %z=jf_cvtrain(jf_compKernel(z),'mcPerf',0,'fpr',0.5,'tpr',0.1);
    z=jf_cvtrain(jf_compKernel(z),'mcPerf',0,'Cs',[5.^(3:-1:-3)]);%,'fpr',0.03);
   % z.prep(end).info.res.opt.soln{1}(end)
    
% in case of 1st block folding: compute the test blocks performance
 if ( isfield(z,'outfIdxs') ) % compute outer fold performance info
   z.prep(end).info.res.opt.res = cvPerf(z.Y,z.prep(end).info.res.opt.f,[1 2 3],z.outfIdxs);
   z.prep(end).info.res.opt.res.di(2) = z.prep(end).info.res.di(2); % update subprob info
 end
% print the resulting test set performances
ores=z.prep(end).info.res.opt.res;
for spi=1:size(ores.trnbin,n2d(ores.di,'subProb')); % loop over sub-problems
  fprintf('(out/%2d*)\t%.2f/%.2f\n',spi,ores.trnbin(:,spi),ores.tstbin(:,spi));
end
a(si)=ores.tstbin(:,spi);
% 
% 
%     try 
%         
%     bias_change=z.prep(end).info.res.roc.bias_change;
%     odv_out=z.prep(end).info.res.tstf(z.outfIdxs==1,1,z.prep(end).info.res.opt.Ci)-bias_change;
%     cdv_out=z.prep(end).info.res.tstf(z.outfIdxs==1,1,z.prep(end).info.res.opt.Ci);
%     Y_out          = z.Y( z.outfIdxs == 1 );
%     Y_out_pos_indx = Y_out  == -1  ;
%     Y_out_neg_indx = Y_out  == 1   ; 
%     out_oFPR=sum(odv_out(Y_out_neg_indx)<0)/length(odv_out(Y_out_neg_indx)); 
%     out_oTPR=sum(odv_out(Y_out_pos_indx)<0)/length(odv_out(Y_out_neg_indx));
%     out_cFPR=sum(cdv_out(Y_out_neg_indx)<0)/length(cdv_out(Y_out_neg_indx)); 
%     out_cTPR=sum(cdv_out(Y_out_pos_indx)<0)/length(cdv_out(Y_out_neg_indx));
%     scores=-odv_out(Y_out~=0);
%     labelss=-Y_out(Y_out~=0);
%     posclass=1;
%     cl{si}=[out_oFPR;out_oTPR;out_cFPR;out_cTPR;...
%         z.prep(end).info.res.roc.ovldFPR;z.prep(end).info.res.roc.ovldTPR;...
%         z.prep(end).info.res.roc.cvldFPR;z.prep(end).info.res.roc.cvldTPR;...
%         z.prep(end).info.res.roc.evldFPR;z.prep(end).info.res.roc.evldTPR];
%     [fpr,tpr,bias,AUC,OPTROCPT,SUBY,SUBYNAMES] = perfcurve(labelss,scores,posclass);  
%     hold on,plot(fpr,tpr,'-');xlabel('FPR'),ylabel('TPR');title('ROC curve by varying classifier bias'),grid;
%     legend('validation set','outer fold','Location','southeast');
%     % saveas(gcf,strcat(subjects{si},'_roc.jpg'),'jpg');
%       
%      %close all
%     
%     % A=[out_oFPR out_oTPR out_cFPR out_cTPR z.prep(end).info.res.roc.ovldFPR z.prep(end).info.res.roc.ovldTPR z.prep(end).info.res.roc.cvldFPR z.prep(end).info.res.roc.cvldTPR];
%     % A
% 
%      fprintf('Outer fold original       FPR: %.3f , TPR: %.3f \n',out_oFPR,out_oTPR);
%      fprintf('Outer fold calibrated     FPR: %.3f , TPR: %.3f \n',out_cFPR,out_cTPR);
%      
%      fprintf('Validation set original   FPR: %.3f , TPR: %.3f \n',z.prep(end).info.res.roc.ovldFPR,z.prep(end).info.res.roc.ovldTPR);
%      fprintf('Validation set calibrated FPR: %.3f , TPR: %.3f \n',z.prep(end).info.res.roc.cvldFPR,z.prep(end).info.res.roc.cvldTPR);
%      fprintf('Validation set estimated  FPR: %.3f , TPR: %.3f \n',z.prep(end).info.res.roc.evldFPR,z.prep(end).info.res.roc.evldTPR);
%      
%     catch err
%     end   
%     seq{si}=seq_classify(z.prep(end).info.res,z.Y,z.outfIdxs);
%     FPRtable=[seq{si}.fpr.sav;seq{si}.fpr.pro;seq{si}.fpr.sav_nc];
%     a=num2cell(FPRtable);b=cell(3,1);c=[b a];c{1}='sav';c{2}='nrow';c{3}='sav-nc';
%      for i = 1:numel(c);c{i}=num2str(c{i});end;
%     d={'#trials','1','2','3','4','5','6','7','8'};e=[d' c']';
%     s=sym(e,'d');latex_table1{si}=latex(s);
%     TPRtable=[seq{si}.tpr.sav;seq{si}.tpr.pro;seq{si}.tpr.sav_nc];
%     a=num2cell(TPRtable);b=cell(3,1);c=[b a];c{1}='sav';c{2}='nrow';c{3}='sav-nc';
%     d={'#trials','1','2','3','4','5','6','7','8'};e=[d' c']';
%     for i = 1:numel(e);e{i}=num2str(e{i});end;
%     s=sym(e,'d');latex_table2{si}=latex(s);
%     
 %   cs{si}=constant_shifts(z,9,-1);
%     ms{si}=monte_shifts(z,9,-1);
end

%    persubject

