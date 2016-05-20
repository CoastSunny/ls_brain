global bciroot;
%expt    = 'own_experiments/motor_imagery/anthesia';
bciroot={'/Users/louk/Data/Raw/'};
expt    = 'long_movements/';
dtype   = 'raw_bdf';
fileregexp='.*\.bdf';

subjects= {'yvonne' 'jeroen' 'alex' 'hans' 'linsey' 'marjolein' 'fatma' 'jason' 'betul' 'rik'}; % subj{
sessions= {{'20110719'} {'20110720'} {'20110721'} {'20111115'} {'20111121'} {'20111124'} {'20111212'} {'20111214'} {'20111216'} {'20111222'}}; % subj{ session{
blocks  = {{{'dv'}}}; %subj{  session{ condition{
% blocks  = {{{'async'}}}; %subj{  session{ condition{
 labels  ={{{'b1sec'}}}; %subj{  session{ condition{
% labels  ={{{'async'}}}; %subj{  session{ condition{
%labels  ={{{'seq'}}}; %subj{  session{ condition{
blkdirregexp='(.*)';

markerdict=struct('marker',[2 5 8],...
                  'label',{{'NO1' 'AM1' 'IM1'}});
% markerdict=struct('marker',[3 6 9],...
%                   'label',{{'NO3' 'AM3' 'IM3'}});
% markerdict=struct('marker',[4 7 10],...
%                   'label',{{'NO9' 'AM9' 'IM9'}});
% markerdict=struct('marker',[15 16],...
%                   'label',{{'start_AM' 'start_IM'}});
              
% markerdict=struct('marker',[31 32 33 34 35 36 37 38 39],...
%                     'label', {{'seq_NO1', 'seq_NO3', 'seq_NO9', 'seq_AM1', 'seq_AM3', 'seq_AM9', 'seq_IM1', 'seq_IM3', 'seq_IM9'}}); 
              

trlen_ms =4000;     % length of trial from the start marker
offset_ms=[-1000 0]; % offset from start/end of trial to actually record, shift back by 2000ms
subsampleOpts = struct('fs',128); % downsample while reading to 256Hz
si=1;sessi=1;ci=1;
for si=1:numel(subjects);
subjlabs=labels{min(numel(labels),si)};
for sessi=1:numel(sessions{min(numel(sessions),si)});
for ci=1:numel(subjlabs{min(numel(subjlabs),sessi)});
   subj=subjects{si}; 
   session=sessions{min(numel(sessions),si)};session=session{min(numel(sessions),sessi)}; 
   block=blocks{min(numel(blocks),si)};block=block{min(numel(block),sessi)};block=block{min(numel(block),ci)}; 
   label=labels{min(numel(labels),si)};label=label{min(numel(label),sessi)};label=label{min(numel(label),ci)};
   filelst=findFiles(expt,subj,session,block,'dtype',dtype,'fileregexp',fileregexp,'blkdirregexp',blkdirregexp);

   z = raw2jf({filelst.fname},...
              'blocks',[filelst.block],'sessions',{filelst.session},...
              'expt',expt,'subj',subj,...
              'label',label,'RecPhaseLimits',markerdict.marker,...
              'trlen_ms',trlen_ms,'offset_ms',offset_ms,'capFile','cap64','subsample',subsampleOpts);
   if ( isempty(z) ) continue; end;  % nothing loaded!
   z.di(n2d(z,'epoch')).info.markerdict=markerdict; % record the marker dictionary
   z=jf_addClassInfo(z,'markerdict',markerdict); % add the label info for this subset of classes

   % setup the channel info more nicely
   iseeg=false(size(z.X,n2d(z.di,'ch')),1); iseeg(1:64)=true; [z.di(1).extra.iseeg]=num2csl(iseeg);   
   z.di(1).vals{strmatch('EXG1',z.di(1).vals)}='EMG_RH';
   z.di(1).vals{strmatch('EXG2',z.di(1).vals)}='EMG_RH2';
   z.di(1).vals{strmatch('EXG3',z.di(1).vals)}='EOG_HR';
   z.di(1).vals{strmatch('EXG4',z.di(1).vals)}='EOG_HL';
   z.di(1).vals{strmatch('EXG5',z.di(1).vals)}='EOG_VU';
   z.di(1).vals{strmatch('EXG6',z.di(1).vals)}='EOG_VL';
   z.di(1).vals{strmatch('EXG7',z.di(1).vals)}='EMG_LH';
   z.di(1).vals{strmatch('EXG8',z.di(1).vals)}='EMG_LH2';      
   z=jf_reject(z,'dim','ch','vals',{'Ana*' 'EXG*'},'valmatch','regexp','summary','unused');
   
   % save the sliced stuff
   z = jf_save(z,1);
end
end
end
