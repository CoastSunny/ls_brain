sEEG=[];cEEG=[];rcEEG=[];ciEEG=[];rciEEG=[];fwsEEG=[];fwrsEEG=[];
fsEEG=[];frsEEG=[];fiEEG=[];friEEG=[];
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
pre_samples=32;
post_samples=32;
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
X(sEEG_idx,:)=repop(X(sEEG_idx,:),'-',mean(X(sEEG_idx,:),1));
X(iEEG_idx,:)=repop(X(iEEG_idx,:),'-',mean(X(iEEG_idx,:),1));
% X=repop(X,'-',mean(X([20 21],:),1));

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
    catch err
        fprintf('slice error')
        spikes(:,i)=[];
    end
    %     sEEG(:,:,i)=X(sEEG_idx,SP(1,i)-1*pre_samples:SP(1,i)+post_samples-0*pre_samples);
    %     iEEG(:,:,i)=X(iEEG_idx,SP(1,i)-1*pre_samples:SP(1,i)+post_samples-0*pre_samples);
    
 
    %     [u s v]=svd(sEEG(:,:,i));
    %     s(4:end,4:end)=0;
    %     sEEG(:,:,i)=u*s*v';
    %     for cci=1:size(sEEG,1)
    %         nsE(cci)=norm(sEEG(cci,:,i));
    %     end
    %     for cci=1:size(iEEG,1)
    %         niE(cci)=norm(iEEG(cci,:,i));
    %     end
    %
    %     sEEG(:,:,i)=repop(sEEG(:,:,i),'/',nsE');
    %     iEEG(:,:,i)=repop(iEEG(:,:,i),'/',niE');
    
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
    % bsEEG=0;biEEG=0;
    rsEEG(:,:,count)=repop(X(sEEG_idx,idx_set),'-',bsEEG);
    riEEG(:,:,count)=repop(X(iEEG_idx,idx_set),'-',biEEG);
    %     [u s v]=svd(rsEEG(:,:,count));
    %     s(4:end,4:end)=0;
    %     rsEEG(:,:,count)=u*s*v';
    [dummy1 idx2remove]=intersect(NSP,idx_set);
    NSP(idx2remove)=[];
    
end



% ss=ls_whiten(cat(3,sEEG,rsEEG),6,0);
% ii=ls_whiten(cat(3,iEEG,riEEG),6,0);
% sEEG=ss(:,:,1:size(sEEG,3));
% rsEEG=ss(:,:,size(sEEG,3)+1:size(sEEG,3)+size(rsEEG,3));
% iEEG=ii(:,:,1:size(iEEG,3));
% riEEG=ii(:,:,size(iEEG,3)+1:size(iEEG,3)+size(riEEG,3));
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



% for i=1:size(sEEG,3); for ch=1:size(sEEG,1); fwsEEG(ch,:,i)=get_wavelet_features(sEEG(ch,:,i),4,'db4');end;end;
% for i=1:size(iEEG,3); for ch=1:size(iEEG,1); fwiEEG(ch,:,i)=get_wavelet_features(iEEG(ch,:,i),4,'db4');end;end;
% for i=1:size(rsEEG,3); for ch=1:size(rsEEG,1); fwrsEEG(ch,:,i)=get_wavelet_features(rsEEG(ch,:,i),4,'db4');end;end;
% for i=1:size(riEEG,3); for ch=1:size(riEEG,1); fwriEEG(ch,:,i)=get_wavelet_features(riEEG(ch,:,i),4,'db4');end;end;




[badtr,vars]=idOutliers(sEEG,3,2);
sEEG=sEEG(:,:,~badtr);iEEG=iEEG(:,:,~badtr);idx_iEEG=idx_iEEG(~badtr);
%cEEG=cEEG(:,:,~badtr);ciEEG=ciEEG(:,:,~badtr);
spikes=spikes(:,~badtr);
sidx1=min(num_examples,round(size(sEEG,3)/2));
% 
% [tmp idx]=sort(spikes(2,:),'descend');
% spikes=spikes(:,idx);
sidx1=size(sEEG,3);%%**%%
sidx2=sidx1+1;
tr_examples=1:sidx1;
tst_examples=sidx2:round(size(spikes,2));
[badtr,vars]=idOutliers(rsEEG,3,2);
rsEEG=rsEEG(:,:,~badtr);riEEG=riEEG(:,:,~badtr);
%rcEEG=rcEEG(:,:,~badtr);rciEEG=rciEEG(:,:,~badtr);
ridx1=min(rnum_examples,round(size(rsEEG,3)/2));
ridx1=size(rsEEG,3);%%**%%
ridx2=ridx1+1;
rtr_examples=1:ridx1;
rtst_examples=ridx2:size(rsEEG,3);

fs=200;
pp=1;
fsEEG=spectrogram(sEEG,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
frsEEG=spectrogram(rsEEG,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
% fsEEG=fsEEG(:,:,5:12,:);
% frsEEG=frsEEG(:,:,5:12,:);
% fsEEG=mean(spectrogram(sEEG,2,'fs',fs,'width_ms',width_ms,'overlap',overlap),2);
% frsEEG=mean(spectrogram(rsEEG,2,'fs',fs,'width_ms',width_ms,'overlap',overlap),2);
% fsEEG2=spectrogram(sy,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
% frsEEG2=spectrogram(rsy,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
% tmps=mean(sEEG(:,30:35,:),2);
% tmpr=mean(rsEEG(:,30:35,:),2);

% fsEEG(:,6,19,:)=10*tmps;
% frsEEG(:,6,19,:)=10*tmpr;
fiEEG=spectrogram(iEEG,2,'fs',fs,'width_ms',width_ms,'overlap',overlap).^pp;
friEEG=spectrogram(riEEG,2,'fs',fs,'width_ms',width_ms,'overlap',overlap).^pp;
% fiEEG=mean(spectrogram(iEEG,2,'fs',fs,'width_ms',width_ms,'overlap',overlap),2);
% friEEG=mean(spectrogram(riEEG,2,'fs',fs,'width_ms',width_ms,'overlap',overlap),2);
Cs=cov(reshape(fsEEG,[],size(fsEEG,4))');
Crs=cov(reshape(frsEEG,[],size(frsEEG,4))');
% for tri=1:size(sEEG,3)
%     for cha=1:20
%         fsEEG(cha,:,tri)=dct(sEEG(cha,:,tri));
%     end
%     for cha=1:12
%         fiEEG(cha,:,tri)=dct(iEEG(cha,:,tri));
%     end    
% end
% for tri=1:size(rsEEG,3)
%     for cha=1:20
%         frsEEG(cha,:,tri)=dct(rsEEG(cha,:,tri));
%     end
%     for cha=1:12
%         friEEG(cha,:,tri)=dct(riEEG(cha,:,tri));
%     end
%     
% end





