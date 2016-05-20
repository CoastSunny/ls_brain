% Code to cut up all data trials into 1-second windows, and concatenate
% them into a single z-stucture (saved as labels 'windows')

global bciroot; 
% N.B. add the directory where the BCI_Data is mounted to this list for the
% system to find the raw data files and the saved files,
% e.g. bciroot={bciroot{:} '/Volumes/BCI_Data2'};

bciroot={'/Users/louk/Data/Raw/'};
expt    = 'long_movements/';
subjects= {'yvonne' 'jeroen' 'alex' 'hans' 'linsey' 'marjolein' 'fatma' 'jason' 'betul' 'rik'}; % subj{
sessions= {{'20110719'} {'20110720'} {'20110721'} {'20111115'} {'20111121'} {'20111124'} {'20111212'} {'20111214'} {'20111216'} {'20111222'}}; % subj{ session{
% labels  ={'1sec'}; %condition{
labels  ={'1sec' '3sec' '9sec' 'async'}; %condition{
% labels = {'async'};

clear z;
for si=1:numel(subjects)
% si=1; % pick a subject number
sessi=1; 
% ci=1; % session and condition are always the 1st

% get the info for this subject
subj=subjects{si};
session=sessions{si}{sessi};

for ci=1:numel(labels)
    label=labels{ci};    

% load the sliced data
zs(ci)=jf_load(expt,subj,label,session,-1);
% if ( ~isempty(zs(ci)) && isempty(strmatch('~/data',zs(ci).rootdir)) ) % cache
%   jf_save(zs(ci),[],1,'~/data/bci',1);
% end  

% oz=z;

switch ci
    case 1
    
% setup 2 sub-problems
zs(ci)=jf_addClassInfo(zs(ci),...
                  'spType',{{{'NO1'} {'IM1'}}...
                            {{'NO1'} {'AM1'}}},'summary','rest vs move'); 
% cut the data into 128 sample bits every 1000ms
zs(ci)=jf_windowData(zs(ci),'dim','time','start_ms',0,'width_samp',384);

    case 2
        
% setup 2 sub-problems
zs(ci)=jf_addClassInfo(zs(ci),...
                  'spType',{{{'NO3'} {'IM3'}}...
                            {{'NO3'} {'AM3'}}},'summary','rest vs move'); 
% cut the data into 128 sample bits every 1000ms
zs(ci)=jf_windowData(zs(ci),'dim','time','start_ms',0,'width_samp',768);

    case 3
        
% setup 2 sub-problems
zs(ci)=jf_addClassInfo(zs(ci),...
                  'spType',{{{'NO9'} {'IM9'}}...
                            {{'NO9'} {'AM9'}}},'summary','rest vs move'); 
% cut the data into 128 sample bits every 1000ms
zs(ci)=jf_windowData(zs(ci),'dim','time','start_ms',0,'width_samp',1536);

  case 4
        
% for 60sec async data
% setup 2 sub-problems
% cut the data into 128 sample bits every 1000ms
zs(ci)=jf_windowData(zs(ci),'dim','time','start_ms',0:1000:59000,'width_samp',128);
% add the sub-problem info
tmp=[bciroot{1} expt subj '/' session '/jf_prep/' subj '_trueValues.mat'];
load(tmp);
Y=classInfo;
zs(ci)=jf_addClassInfo(zs(ci),'Y',Y,'Ydi',{'window' 'epoch' 'subProb'})
zs(ci).Ydi(n2d(zs(ci).Ydi,'subProb')).vals={'im' 'act'};

end
% concatenate the windows into the epoch dim rather than a separate window x epoch pair of dims.
zs(ci)=jf_compressDims(zs(ci),'dim',{'window' 'epoch'});

end

z = jf_cat(zs, 'dim', 'window_epoch');
z.di(3).name = 'epoch';
z.Ydi(1).name= 'epoch';

z=jf_save(z,'which_windows');

end


