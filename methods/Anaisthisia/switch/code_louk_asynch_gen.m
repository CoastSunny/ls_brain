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
bciroot = {'/Users/louk/Data/Raw' '~/Data/Raw' '/media/louk/Storage/Raw' '/media/F2786FA2786F63F7/loukstorage/Raw'};
%expt    = 'own_experiments/motor_imagery/movement_detection/long_movements';
expt    = 'long_movements';
subjects= {'yvonne' 'jeroen' 'alex' 'hans' 'linsey' 'marjolein' 'fatma' 'jason' 'betul' 'rik'}; % subj{
sessions= {{'20110719'} {'20110720'} {'20110721'} {'20111115'} {'20111121'} {'20111124'} {'20111212'} {'20111214'} {'20111216'} {'20111222'}}; % subj{ session{
% choose which condition to use: either '1sec', '3sec', '9sec' or 'async'
labels  = label_win; %condition{

for si=1:10;
    
    sessi=1; ci=1;
    
    subj=subjects{si};
    session=sessions{si}{sessi};
    label=labels{ci};
    
    % load the sliced data
    z=jf_load(expt,subj,label,session,-1);
    if ( isempty(z) ) continue; end;
    
    % run the pre-processing (file attached)
    z=preproc_anthesia(z);
    z=jf_retain(z,'dim','ch','idx',[z.di(1).extra.iseeg],'summary','eeg-only');
    z.X=ls_whiten(z.X,wmethod,L,T);
    z = jf_spectrogram(z,'width_ms',250,'log',0,'detrend',1);
    z = jf_retain(z,'dim','freq','range','between','vals',[8 24]);
    tD=n2d(z,'time',0,0); if ( tD==0 ) tD=n2d(z,'window'); end;
    w=mkFilter(size(z.X,tD),timeperiod,z.di(tD).vals);
    w=repop(w,'./',sum(w)); % make into means
    z=jf_linMapDim(z,'dim',tD,'mx',w,'di',mkDimInfo(size(w,2),1,'movement periods',[],{'1swin'}));
    
    zz(si)=z;
    
end

zall=jf_cat(zz,'dim','epoch');
clear z
%siexcl=[2 3 4 7 9 10];
siexcl=[];
for si=1:10
    fprintf(num2str(si));
    z=zall;
    nfolds=9;
    out=foldstuff_gen(z,si,si,trblocks,exblocks,outblocks,nfolds);
    z.foldIdxs=out.foldIdxs;
    z.outfIdxs=out.outfIdxs;
    
    z=jf_cvtrain(z,'mcPerf',0,'objFn','lr_cg');
    
    if ( isfield(z,'outfIdxs') ) % compute outer fold performance info
        res = cvPerf([z.Y z.Y(:,1)],...
            [z.prep(end).info.res.opt.f z.prep(end).info.res.opt.f(:,2)],...
            [1 2 3],z.outfIdxs,'bal');
        res.di(2) = z.prep(end).info.res.di(2); % update subprob info
    end
    % print the resulting test set performances
    for spi=1:size(res.trnbin,n2d(res.di,'subProb')); % loop over sub-problems
        fprintf('(out/%2d*)\t%.2f/%.2f\n',spi,res.trnbin(:,spi),res.tstbin(:,spi));
    end
    Ci=z.prep(end).info.res.opt.Ci;
    tstbin=squeeze(z.prep(end).info.res.tstbin);
    Res_in(si,:)=tstbin(:,Ci);
    Res_out(si,:)=res.tstbin;
    fA=z.prep(end).info.res.opt.f(:,2);
    f=fA(z.outfIdxs==1 & z.Y(:,2)~=0);
    FpA{si}=fA(z.Y(:,2)==-1 & z.outfIdxs==1);
    FnA{si}=fA(z.Y(:,2)==1  & z.outfIdxs==1);
    fp=FpA{si};
    fn=FnA{si};
    Y=z.Y(z.Y(:,2)~=0 & z.outfIdxs==1,2);
    
    r2_A(si,:)= [ sum(fp<0)/numel(fp) sum(fn>=0)/numel(fn) (sum(fp<0)/numel(fp)+sum(fn>=0)/numel(fn))/2];
%     dmsavA_switch{si}=dec_methods_f( f , Y , 60 , -1  ,'asynch_dec_sav', 16,1,0,0);
%     dmsavAnrow_switch{si}=dec_methods_f( f , Y , 60 , -1  ,'asynch_dec_nrow', 16,1,0,0);
%     pos_sel=31:numel(fp);neg_sel=61:numel(fn); 
%     dmsavA{si}=dec_methods_f( f , Y , 'all' , -1  ,'sav', 16,1,pos_sel,neg_sel);
%     pos_sel=1:30;neg_sel=1:60; 
%     dmsavA2{si}=dec_methods_f( f , Y , 'all' , -1  ,'sav', 16,1,pos_sel,neg_sel);
%     pos_sel=31:numel(fp);neg_sel=61:numel(fn); 
%     dmsavA_nrow{si}=dec_methods_f( f , Y , 'all' , -1  ,'nrow', 16,1,pos_sel,neg_sel);
%     pos_sel=1:30;neg_sel=1:60; 
%     dmsavA2_nrow{si}=dec_methods_f( f , Y , 'all' , -1  ,'nrow', 16,1,pos_sel,neg_sel);
    %dmnrow{si}=dec_methods_f( f , Y , 'all' , -1  ,'nrow', 32,1,0,0);
    %dmsav{si}=dec_methods( z , n_con_ex , -1 , 1 ,'withinclass_sav' , 1);

    
    
end


