sEEG=[];cEEG=[];rcEEG=[];ciEEG=[];rciEEG=[];fwsEEG=[];fwrsEEG=[];
fsEEG=[];frsEEG=[];fiEEG=[];friEEG=[];
clear Feature* rFeature*
iEEG=[];fwriEEG=[];
rsEEG=[];
riEEG=[];fwiEEG=[];
sy=[];
iy=[];
rsy=[];
riy=[];
Rs=[];Rrs=[];
spike=[];
Ws=[];Nwls=[];Wsr=[];Ns=[];Nr=[];s=[];r=[];
Wr=[];Nwrls=[];Wrs=[];nI=[];nR=[];
schannels=[1:20];
ichannels=[1:12];
%sEEG_idx=[1:6 8:14 16:18 ];%20 21] ;
sEEG_idx=[1:18 20 21] ;
ch={'Fp1' 'F3' 'F7' 'C3' 'T3' 'T5' 'O1' 'Fp2' 'F4' 'F8' 'C4' 'T4' 'T6' 'O2' 'Fz' 'Cz'};
iEEG_idx=[19 22:32];
pre_samples=100;
post_samples=100;
nchirp=1;

spikes=spikes(:,spikes(2,:)>4);
% spikes=spikes(:,spikes(3,:)==3 | spikes(3,:)==4);
if isempty(spikes)
    load([subj{ci} 'data'])
    spikes=spikes(:,spikes(2,:)>6);
end
if isempty(spikes)
    load([subj{ci} 'data'])
    spikes=spikes(:,spikes(2,:)>5);
end
if (ci~=14)
    SVIS(ci,:)=[...
        sum(spikes(3,:)==1)/size(spikes,2)...
        sum(spikes(3,:)==2)/size(spikes,2)...
        sum(spikes(3,:)==3)/size(spikes,2)...
        sum(spikes(3,:)==4)/size(spikes,2)...
        sum(spikes(3,:)==4)...
        sum(spikes(3,:)==3)...
        (sum(spikes(3,:)==4)+sum(spikes(3,:)==1))/size(spikes,2)];
       
        iSP2=spikes(3,:)==2;
        iSP3=spikes(3,:)==3;
        pSP=spikes(2,:);
end

SP=round(spikes(1,:)*200);

NSP=setdiff(1:size(X,2),SP);
numel(SP)
if (SP(1)<98)
    SP(1)=[];
    spikes(:,1)=[];
end
if (SP(1)<98)
    SP(1)=[];
    spikes(:,1)=[];
end
%X=A_S;
freqband=[1 45];
fs=200;
len=size(X,2);
filt=mkFilter(freqband,floor(len/2),fs/len);
X=fftfilter(X,filt,[0 len],2,1);
l=pre_samples+post_samples+1;
nwindows=12;
width_ms=80;
overlap=0.5;
num_examples=200;
extra_rest=0;
rnum_examples=num_examples+extra_rest;
%%%CAR%%%
% X(sEEG_idx,:)=repop(X(sEEG_idx,:),'-',mean(X(sEEG_idx,:),1));
% X(iEEG_idx,:)=repop(X(iEEG_idx,:),'-',mean(X(iEEG_idx,:),1));
X=repop(X,'-',mean(X([20 21],:),1));

for i=1:size(spikes,2)
    try
    bsEEG=mean(X(sEEG_idx,SP(1,i)-2*pre_samples-1*post_samples-1:SP(1,i)-1*pre_samples-1),2);
    biEEG=mean(X(iEEG_idx,SP(1,i)-2*pre_samples-1*post_samples-1:SP(1,i)-1*pre_samples-1),2);
    catch err
        bsEEG=0;biEEG=0;fprintf('slice pre error')
    end
    % bsEEG=0;biEEG=0;
    try
    sEEG(:,:,i)=repop(X(sEEG_idx,SP(1,i)-1*pre_samples:SP(1,i)+post_samples-0*pre_samples),'-',...
        bsEEG);
    iEEG(:,:,i)=repop(X(iEEG_idx,SP(1,i)-1*pre_samples:SP(1,i)+post_samples-0*pre_samples),'-',...
        biEEG);
       mid_idx=ceil((pre_samples+post_samples)/2);
       [sp i_sp]=max(abs(iEEG(:,mid_idx-5:mid_idx+5,i)));
      [sp_2 i_sp2]=max(sp);
       spike(i,:)=iEEG(i_sp(i_sp2),:,i);
       %spike(i,:)=iEEG(1,:,i);
      idx_iEEG(i)=i_sp(i_sp2);
    fiEEG(:,:,:,i)=spectrogram(iEEG(:,:,i),2,'fs',fs,'width_ms',width_ms,'overlap',overlap).^pp;
%     iEEG(:,:,i)=ls_whiten(iEEG(:,:,i),5,0);
    Feature1(:,i)=mean(iEEG(:,:,i).^2,2); 
    Feature2(:,i)=mean(iEEG(:,68:132,i).^2,2);
    Feature3(:,:,i)=iEEG(:,68:132,i);
    [U S V]=svd(iEEG(:,:,i));
    Feature4(:,i)=U(:,1);
    Feature5(:,:,:,i)=fiEEG(:,:,:,i);
    catch err
        fprintf('slice error')
        spikes(:,i)=[];
    end
    

    
end

count=0;

while count<size(spikes,2)+extra_rest
    
    
    %x    idx_set=SP(count)-4*pre_samples-pre_samples:SP(count)-4*pre_samples+post_samples;
    
    idx=datasample(NSP,1);
    if (idx<2*(pre_samples+post_samples+2)); continue; end;if (idx>size(X,2)-post_samples-1); continue; end;
    idx_set=idx-1*pre_samples:idx+1*post_samples;
    if ( sum(ismember(idx_set,SP)) > 0 )
        continue;
    end
    idx_set=idx-pre_samples:idx+post_samples;
    count=count+1;
    
    
    bsEEG=mean(X(sEEG_idx,idx_set-post_samples-pre_samples-1),2);
    biEEG=mean(X(iEEG_idx,idx_set-post_samples-pre_samples-1),2);
    rsEEG(:,:,count)=repop(X(sEEG_idx,idx_set),'-',bsEEG);
    riEEG(:,:,count)=repop(X(iEEG_idx,idx_set),'-',biEEG);  
    
%     riEEG(:,:,count)=ls_whiten(iEEG(:,:,count),5,0);
    friEEG(:,:,:,count)=spectrogram(riEEG(:,:,count),2,'fs',fs,'width_ms',width_ms,'overlap',overlap).^pp;
    rFeature1(:,count)=mean(riEEG(:,:,count).^2,2); 
    rFeature2(:,count)=mean(riEEG(:,68:132,count).^2,2);
    rFeature3(:,:,count)=riEEG(:,68:132,count);
    [U S V]=svd(riEEG(:,:,count));
    rFeature4(:,count)=U(:,1);
    rFeature5(:,:,:,count)=friEEG(:,:,:,count);
    [dummy1 idx2remove]=intersect(NSP,idx_set);
    NSP(idx2remove)=[];
    
end

p=1;
sEEG=detrend(sEEG.^p,2);
iEEG=detrend(iEEG.^p,2);
rsEEG=detrend(rsEEG.^p,2);
riEEG=detrend(riEEG.^p,2);
% 
ss=ls_whiten(cat(3,sEEG,rsEEG),5,0);
ii=ls_whiten(cat(3,iEEG,riEEG),5,0);
sEEG=ss(:,:,1:size(sEEG,3));
rsEEG=ss(:,:,size(sEEG,3)+1:size(sEEG,3)+size(rsEEG,3));
iEEG=ii(:,:,1:size(iEEG,3));
riEEG=ii(:,:,size(iEEG,3)+1:size(iEEG,3)+size(riEEG,3));
% % 
fprintf('done');

ftiEEG=cat(1,Feature1./Feature2,...
    Feature4,reshape(Feature3,12*65,size(Feature3,3)),reshape(Feature5,12*9*24,size(Feature5,4)));
rftiEEG=cat(1,rFeature1./rFeature2,...
    rFeature4,reshape(rFeature3,12*65,size(rFeature3,3)),reshape(rFeature5,12*9*24,size(rFeature5,4)));

[badtr,vars]=idOutliers(sEEG,3,2);
sEEG=sEEG(:,:,~badtr);iEEG=iEEG(:,:,~badtr);idx_iEEG=idx_iEEG(~badtr);
ftiEEG=ftiEEG(:,~badtr);
%cEEG=cEEG(:,:,~badtr);ciEEG=ciEEG(:,:,~badtr);
spikes=spikes(:,~badtr);
sidx1=min(num_examples,round(size(sEEG,3)/2));
% 
% [tmp idx]=sort(spikes(2,:),'descend');
% spikes=spikes(:,idx);
sidx1=round(size(sEEG,3)/2);%%**%%
sidx2=sidx1+1;
tr_examples=1:sidx1;
tst_examples=sidx2:round(size(spikes,2));
[badtr,vars]=idOutliers(rsEEG,3,2);
rsEEG=rsEEG(:,:,~badtr);riEEG=riEEG(:,:,~badtr);
rftiEEG=rftiEEG(:,~badtr);
%rcEEG=rcEEG(:,:,~badtr);rciEEG=rciEEG(:,:,~badtr);
% ridx1=min(rnum_examples,round(size(rsEEG,3)/2));
ridx1=round(size(rsEEG,3)/2);%%**%%
ridx2=ridx1+1;
rtr_examples=1:ridx1;
rtst_examples=ridx2:size(rsEEG,3);

fs=200;
pp=1;
a=tic;
fsEEG=spectrogram(sEEG,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
b(ci)=toc(tic);
frsEEG=spectrogram(rsEEG,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
fiEEG=spectrogram(iEEG,2,'fs',fs,'width_ms',width_ms,'overlap',overlap).^pp;
friEEG=spectrogram(riEEG,2,'fs',fs,'width_ms',width_ms,'overlap',overlap).^pp;
