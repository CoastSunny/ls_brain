% The data for experiment 2 can be found in
% '/Volumes/BCI_Data/own_experiments/motor_imagery/movement_detection/long_
% movements/'

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

% To load use the following loop (preprocessing steps etc. are within the loop):

global bciroot;
% N.B. add the directory where the BCI_Data is mounted to this list for the
% system to find the raw data files and the saved files,
% e.g. bciroot={bciroot{:} '/Volumes/BCI_Data/'};
%bciroot = '/Volumes/BCI_Data/';
bciroot = {'/Users/louk/Data/Raw' '~/Data/Raw' '/media/LoukStorage/Raw'};
%expt    = 'own_experiments/motor_imagery/movement_detection/long_movements/';
expt    = 'long_movements';
subjects= {'yvonne' 'jeroen' 'alex' 'hans' 'linsey' 'marjolein' 'fatma' 'jason' 'betul' 'rik'}; % subj{
sessions= {{'20110719'} {'20110720'} {'20110721'} {'20111115'} {'20111121'} {'20111124'} {'20111212'} {'20111214'} {'20111216'} {'20111222'}}; % subj{ session{
% choose which condition to use: either '1sec', '3sec', '9sec' or 'async'
%labels  ={'3sec'}; %condition{

for si=4:numel(subjects);
    % si=1; % pick a subject number
    sessi=1; ci=1; % session and condition are always the 1st
    
    % get the info for this subject
    subj=subjects{si};
    session=sessions{si}{sessi};
    label=labels{ci};
    
    % load the sliced data
    z=jf_load(expt,subj,label,session,-1);
    
    % run the pre-processing (file attached)
   % z=preproc_anthesia(z);
    
    % setup 1st block only folding. This was used to simulate a 'preoperative
    % calibration session' or simply an online study in general. So, the first
    % block of data is used for training of the classifier and the remaining
    % blocks are used for testing.
%     z.foldIdxs=zeros(size(z.Y,1),10);
%     trnInd=[z.di(n2d(z,'epoch')).extra.src]==1 | [z.di(n2d(z,'epoch')).extra.src]==2 | [z.di(n2d(z,'epoch')).extra.src]==3 | [z.di(n2d(z,'epoch')).extra.src]==4;
%     %trnInd=[z.di(n2d(z,'epoch')).extra.src]==1;
%     z.foldIdxs(trnInd,1:10)=gennFold(z.Y(trnInd,:),10); % 10-fold
%     z.outfIdxs=zeros(size(z.Y,1),1); z.outfIdxs(trnInd)=-1; z.outfIdxs(~trnInd)=1; % outer-fold
    % size(z.Y,1)
    % 10-fold CV. Alternatively, use 10-fold cross validation (generally higher
    % performance, but less relevant for eventual application than '1-st block
    % only' folding).
    %z.foldIdxs=gennFold(z.Y,10);
    
    % save copy of the data before we do more stuff to it..
    oz=z; % N.B. use z=oz; to get back to 'clean' version of data to try alternative pre-processings
    %z.Ydi(1).name = 'epoch';
    z
    % % setup 2 sub-problems, rest vs im, and rest vs. am
%     z.Ydi(1).name='epoch';
%     z=jf_addClassInfo(z,...
%         'spType',{{{nomove} {immove}}...
%         {{nomove} {ammove}}},'summary','rest vs move');
    
    
    % remove everything but the eeg channels
     %z=jf_retain(z,'dim','ch','idx',[z.di(1).extra.iseeg],'summary','eeg-only');
     %z=jf_retain(z,'dim','ch','vals',{'C3' 'C4' 'P3' 'P4' 'Cz' 'T7' 'T8' 'F3' 'F4'},'summary','eeg-only');
     z=jf_retain(z,'dim','ch','vals',{ 'C3'},'summary','eeg-only');
     z=jf_retain(z,'dim','freq','range','between','vals',[8 24], 'valmatch','nearest');
     noM = [z.Y(:,1)==1];
     tfrNOM=jf_retain(z,'dim','epoch','idx', noM); % keep only these epochs
     AM = [z.Y(:,2)==1];
     tfrAM=jf_retain(z,'dim','epoch','idx', AM); % keep only these epochs
     IM = [z.Y(:,3.)==1];
     tfrIM=jf_retain(z,'dim','epoch','idx', IM); % keep only these epochs
     
%      figure,jf_plotERP(tfrNOM,'disptype','image','clim',[-5 5]);
%      figure,jf_plotERP(tfrAM,'disptype','image','clim',[-5 5]);
%      figure,jf_plotERP(tfrIM,'disptype','image','clim',[-5 5]);
    TFRNOM(si-3)=tfrNOM;
    TFRAM(si-3)=tfrAM;
    TFRIM(si-3)=tfrIM;
    
    % For analysis using the combined ERD and ERS periods, use the following lines instead:
    
    % use spectrogram instead of Welch when using multiple time windows: compute a spectrum every 250ms with a freq resolution of 4hz
    
    
    
    
end


gaNOM = jf_cat({TFRNOM(1) TFRNOM(2) TFRNOM(3) TFRNOM(4) TFRNOM(5) TFRNOM(6) TFRNOM(7) }, 'dim', 'epoch');
gaAM = jf_cat({TFRAM(1) TFRAM(2) TFRAM(3) TFRAM(4) TFRAM(5) TFRAM(6) TFRAM(7) }, 'dim', 'epoch');
gaIM = jf_cat({TFRIM(1) TFRIM(2) TFRIM(3) TFRIM(4) TFRIM(5) TFRIM(6) TFRIM(7) }, 'dim', 'epoch');

mNOM=mean(mean(mean(mean(gaNOM.X))));
mAM=mean(mean(mean(mean(gaAM.X))));
mIM=mean(mean(mean(mean(gaIM.X))));
clims=[-2 2];
% figure,jf_plotERP(gaNOM,'disptype','image','clim',clims);
% figure,jf_plotERP(gaAM,'disptype','image','clim',clims);
% figure,jf_plotERP(gaIM,'disptype','image','clim',clims);

for si=1:7

    paNOM(si)=mean(mean(mean(TFRNOM(si).X)));
    paAM(si)=mean(mean(mean(TFRAM(si).X)));
    paIM(si)=mean(mean(mean(TFRIM(si).X)));

end
