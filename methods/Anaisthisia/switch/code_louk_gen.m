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
bciroot = {'/Users/louk/Data/Raw/' '/home/louk/Data'  '/media/LoukStorage/Raw'};
expt    = 'trial_based/offline';
%expt    = 'own_experiments/motor_imagery/movement_detection/trial_based/offline';
subjects= {'linsey' 'Jorgen' 'makiko' 'lucinda' 'jason' 'moniek' 'chris' 'nienke' 'yvonne' 'rutger'}; % subj{
sessions= {{'20110112'} {'20110114'} {'20110118'} {'20110120'} {'20110131'} {'20110323'} {'20110323'} {'20110330'} {'20110406'} {'20110413'}}; % subj{ session{
labels  ={'trn'}; %condition{
clear zz zall
for si=1:numel(subjects)
    
    sessi=1; ci=1; % session and condition are always the 1st
    
    %get the info for this subject
    subj=subjects{si};
    session=sessions{si}{sessi};
    label=labels{ci};
    
    %load the sliced data
    z=jf_load(expt,subj,label,session,-1);
    
   % reject all epochs which came from the 5th source file, i.e. block 5. We
   % used this because some of the subjects only did 4 experiment blocks instead of 5.
    z=jf_reject(z,'dim','epoch','idx',[z.di(3).extra.src]==5);
    
   % run the pre-processing (file attached)
    z=preproc_anthesia(z);        
    
   % save copy of the data before we do more stuff to it..
    oz=z; % N.B. use z=oz; to get back to 'clean' version of data to try alternative pre-processings    
    
    z=jf_addClassInfo(z,...
        'spType',{...%{{'rest3' 'rest4' 'rest5'} {'rh3' 'rh4' 'rh5'}}...
        {{'rest3' 'rest4' 'rest5'} {'any3' 'any4' 'any5'}}},'summary','rest vs move');       
    
   % remove everything but the eeg channels
    z=jf_retain(z,'dim','ch','idx',[z.di(1).extra.iseeg],'summary','eeg-only');      
%   X=z.X;
%   epsilon=10^-3;
%   L=1;
%   for i=L:size(X,3)
%     
%         Y=X(:,:,i);
% %         for j=1:9
% %          Y(j,:)=Y(j,:)/norm(Y(j,:));
% %         end
% %         M=cov(Y');
%         % X(:,:,i)=zca(Y);
%          M=cov(Y');
%          [eigvec eigval]=eig(M);
%          epsilon=-min(min(eigval));
%          M=cov(Y')+epsilon;%
%          M=inv(sqrtm(double(M)));
%          X(:,:,i)=M*Y;
%        % X(:,:,i)=Y;
% %          R=whiten(X(:,:,i-L+1:i),1,1,0,0,1); % symetric whiten
% %        X(:,:,i)=tprod(X(:,:,i),[-1 2 3],R,[1 -1]);
%       
%   end
%   z.X=X;
   % use spectrogram instead of Welch when using multiple time windows: compute a spectrum every 250ms with a freq resolution of 4hz
    z = jf_spectrogram(z,'width_ms',250,'log',0,'detrend',1);
    
  %  keep only the frequencies we're interested in
    z = jf_retain(z,'dim','freq','range','between','vals',[8 24]);    
    
    % Use several time windows
%    average this spectrum in 2 different phases of time
    tD=n2d(z,'time',0,0); if ( tD==0 ) tD=n2d(z,'window'); end;
 %   make a filter (weighting over time) for each of the 2 phases we care about
    w=mkFilter(size(z.X,tD),{{[0 250 2750 3000]} {[3000 3250 5750 6000]}},z.di(tD).vals);
    w=repop(w,'./',sum(w)); % make into means
  %  apply this filter to the data to compute the average power in each phase
    z=jf_linMapDim(z,'dim',tD,'mx',w,'di',mkDimInfo(size(w,2),1,'movementperiods',[],{'ERD' 'ERS'}));
    
    zz(si)=z;
    
    
end
zall=jf_cat(zz,'dim','epoch');
% expt    = 'own_experiments/motor_imagery/movement_detection/long_movements/';
% subjects= {'yvonne' 'jeroen' 'alex' 'hans' 'linsey' 'marjolein' 'fatma' 'jason' 'betul' 'rik' 'makiko'}; % subj{
% sessions= {{'20110719'} {'20110720'} {'20110721'} {'20111115'} {'20111121'} {'20111124'} {'20111212'} {'20111214'} {'20111216'} {'20111222'}}; % subj{ session{
% labels  ={'1sec'}; %condition{
%%%%%%RESULTS FOR WORST CASE SUBJECT
% for si=1:numel(subjects)
%     % si=1; % pick a subject number
%     z=zall;
%     % setup 1st block only folding. This was used to simulate a 'preoperative
%     % calibration session' or simply an online study in general. So, the first
%     % block of data is used for training of the classifier and the remaining
%     % blocks are used for testing.
%     
%     z.foldIdxs=zeros(size(z.Y,1),9);
%     trnInd=floor([z.di(n2d(z,'epoch')).extra.src])~=si;% | [z.di(n2d(z,'epoch')).extra.src]==2;% | [z.di(n2d(z,'epoch')).extra.src]==3;
%     z.foldIdxs(trnInd,1:10)=gennFold(z.Y(trnInd,:),10); % 10-fold
%     z.outfIdxs=zeros(size(z.Y,1),1); z.outfIdxs(trnInd)=-1; z.outfIdxs(~trnInd)=1; % outer-fold
%         
%     % show the current state of the data
%     jf_disp(z)   
%                 
%     z=jf_cvtrain(z,'mcPerf',0,'objFn','lr_cg');
%     % z.prep(end).info.res.opt.soln{1}(end)
%     
%     % in case of 1st block folding: compute the test blocks performance
%     if ( isfield(z,'outfIdxs') ) % compute outer fold performance info
%         z.prep(end).info.res.opt.res = cvPerf(z.Y,z.prep(end).info.res.opt.f,[1 2 3],z.outfIdxs);
%         z.prep(end).info.res.opt.res.di(2) = z.prep(end).info.res.di(2); % update subprob info
%     end
%     % print the resulting test set performances
%     ores=z.prep(end).info.res.opt.res;
%     for spi=1:size(ores.trnbin,n2d(ores.di,'subProb')); % loop over sub-problems
%         fprintf('(out/%2d*)\t%.2f/%.2f\n',spi,ores.trnbin(:,spi),ores.tstbin(:,spi));
%     end
%      Res2_in(si,:)=z.prep(end).info.res.tstbin(:,:,z.prep(end).info.res.opt.Ci);
%     Res2_out(si,:)=ores.tstbin;
%     %cs_gen{si}=constant_shifts(z,9,-1);
%     %ms_gen{si}=monte_shifts(z,9,-1);
%     %res{si}=z;
%     
% end

% persubject

    fprintf('full');
    z=zall;
    z.foldIdxs=zeros(size(z.Y,1),10);
    trnInd=ones(1,size(z.Y,1))>0;% | [z.di(n2d(z,'epoch')).extra.src]==2;% | [z.di(n2d(z,'epoch')).extra.src]==3;
    z.foldIdxs(trnInd,1:10)=gennFold(z.Y(trnInd,:),10); % 10-fold
    z.outfIdxs=-ones(size(z.Y,1),1);  z.outfIdxs(~trnInd)=1; % outer-fold
    
    %z=jf_cvtrain(jf_compKernel(z),'mcPerf',0);
    z=jf_cvtrain(z,'mcPerf',0,'objFn','lr_cg');        
    
    zfull2=z;
    genclsfr2=zfull2;
    clsfr2.W=reshape(genclsfr2.prep(end).info.res.opt.soln{1}(1:end-1),9,5,2);