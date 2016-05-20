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
timeperiod={{[0 250 2750 3000]} {[3000 3250 5750 6000]}};

%timeperiod={{[0 250 3750 4000]} {[4000 4250 5750 6000]}};

%timeperiod={{[0 250 3250 3500]} {[3500 3750 5750 6000]}};

% expt    = 'own_experiments/motor_imagery/movement_detection/long_movements/';
% subjects= {'yvonne' 'jeroen' 'alex' 'hans' 'linsey' 'marjolein' 'fatma' 'jason' 'betul' 'rik' 'makiko'}; % subj{
% sessions= {{'20110719'} {'20110720'} {'20110721'} {'20111115'} {'20111121'} {'20111124'} {'20111212'} {'20111214'} {'20111216'} {'20111222'}}; % subj{ session{
% labels  ={'1sec'}; %condition{
%%%%%%RESULTS FOR WORST CASE SUBJECT
clear out out_trans
for si=[9 5 1 2 3 4 6 7 8 10]
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
z=preproc_anthesia(z);
z=jf_addClassInfo(z,...
                  'spType',{...%{{'rest3' 'rest4' 'rest5'} {'rh3' 'rh4' 'rh5'}}...
                    {{'rest3' 'rest4' 'rest5'} {'any3' 'any4' 'any5'}}},'summary','rest vs move'); 
% run the pre-processing (file attached)
 z=jf_retain(z,'dim','ch','vals',{ 'C4'},'summary','eeg-only');
   z = jf_spectrogram(z,'width_ms',250,'log',0,'detrend',1);
    z = jf_retain(z,'dim','freq','range','between','vals',[8 24]);
    tD=n2d(z,'time',0,0); if ( tD==0 ) tD=n2d(z,'window'); end;
    w=mkFilter(size(z.X,tD),timeperiod,z.di(tD).vals);
    w=repop(w,'./',sum(w));
    z=jf_linMapDim(z,'dim',tD,'mx',w,'di',mkDimInfo(size(w,2),1,'movement periods',[],{'ERD' 'ERS'}));
   
     noM = [z.Y(:,1)==1];
     tfrNOM=jf_retain(z,'dim','epoch','idx', noM); % keep only these epochs
     AM = [z.Y(:,1)==-1];
     tfrAM=jf_retain(z,'dim','epoch','idx', AM); % keep only these epochs
    TFRNOM(si)=tfrNOM;
    TFRAM(si)=tfrAM;
    

end
gaNOM = jf_cat({TFRNOM(1) TFRNOM(2) TFRNOM(3) TFRNOM(4) TFRNOM(5) TFRNOM(6) TFRNOM(7) TFRNOM(8) TFRNOM(9) TFRNOM(10) }, 'dim', 'epoch');
gaAM = jf_cat({TFRAM(1) TFRAM(2) TFRAM(3) TFRAM(4) TFRAM(5) TFRAM(6) TFRAM(7) TFRAM(8) TFRAM(9) TFRAM(10)}, 'dim', 'epoch');


plotopts='-.';
for iplot=1:10
   
    figure,
    jf_plotERP(TFRNOM(iplot),'plotopts',plotopts)
    jf_plotERP(TFRAM(iplot))
    
end
