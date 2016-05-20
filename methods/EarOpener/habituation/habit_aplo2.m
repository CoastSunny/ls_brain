
addpath ~/BCI_code/toolboxes/ls_bci/global/
addpath ~/BCI_code/toolboxes/numerical_tools/repop/

fs=128;
smooth_trials=25;
nfb_blocks=4;
channel=38; % Fz
mmn_time=round([0.075 0.15]*fs);%% MMN period
p300_time=round([0.2 0.3]*fs);%% P3 period

path=uigetdir;
dev=[];
sb=[];
p=[];
clear tmp;
aplo_dev=rdir(strcat(path,'/**/deviants.mat'));
aplo_dev=aplo_dev(1:nfb_blocks);
for i=1:length(aplo_dev)
    tmp(i)=load(aplo_dev(i).name);dev{i}=tmp(i).v.data;
end

dev=cat(2,dev{:});
dev=cat(3,dev{:});

aplo_sb=rdir(strcat(path,'/**/sbefore.mat'));
aplo_sb=aplo_sb(1:nfb_blocks);
for i=1:length(aplo_sb)
    tmp(i)=load(aplo_sb(i).name);sb{i}=tmp(i).v.data;
end

sb=cat(2,sb{:});
sb=cat(3,sb{:});


tmp=[];
DW=repop(dev,'-',mean(sb,3));
[tmp idx]=min(DW(channel,mmn_time(1):mmn_time(2),:));
idx=squeeze(idx);
mmnamp=squeeze(mean(DW(channel,mmn_time(1)-1+idx-3:mmn_time(1)-1+idx+3,:),2));
mmnamp=squeeze(mean(DW(channel,mmn_time(1):mmn_time(2),:),2));

[tmp idx]=max(DW(channel,p300_time(1):p300_time(2),:));
idx=squeeze(idx);
p300amp=squeeze(mean(DW(channel,p300_time(1)-1+idx-3:p300_time(1)-1+idx+3,:),2));
p300amp=squeeze(mean(DW(channel,p300_time(1):p300_time(2),:),2));

clear tmp;
fsb=[];
fdev=[];
aplo_p=rdir(strcat(path,'/**/prediction.mat'));
aplo_p=aplo_p(1:nfb_blocks);
for i=1:length(aplo_p)
    tmp(i)=load(aplo_p(i).name);
    fsb{i}=tmp(i).v.sbefore.f;
    fdev{i}=tmp(i).v.deviant.f;
end

fsb=cat(2,fsb{:});
fdev=cat(2,fdev{:});

for i=1:nfb_blocks
    
    clsb(i)=sum(fsb( (i-1)*150+1:i*150 )<0)/150;
    cldev(i)=sum(fdev( (i-1)*150+1:i*150 )>0)/150;
    clperf(i)= clsb(i) + ...
               cldev(i);
    clperf(i)=clperf(i)/2;
    
end

figure, hold on
plot((1:64)/128,mean(DW(channel,:,:),3),'Linewidth',4)
plot((1:64)/128,mean(dev(channel,:,:),3),'r')
plot((1:64)/128,mean(sb(channel,:,:),3),'g')
xlabel('time (sec')
ylabel('amplitude')
title('ERP')
legend({'Difference wave','deviant','standard before'})

figure, hold on
plot(1/smooth_trials*filter(ones(1,smooth_trials),1,mmnamp))
plot(1/smooth_trials*filter(ones(1,smooth_trials),1,p300amp),'r')
xlabel('trial')
ylabel('amplitude')
title(['single trial mmn and p3 amplitudes smoothed with a ' num2str(smooth_trials) ' moving average filter'])
legend({'MMN','P300'})

figure
cl=([clperf; clsb; cldev]');
cl=[cl;mean(cl)];
bar(cl)
legend({'total' 'sbefore' 'deviant'})
axis([0 6 0 1])
xlabel('block number')
ylabel('classification rate')
set(gca,'XtickLabel',{1 2 3 4 'mean' })
grid

