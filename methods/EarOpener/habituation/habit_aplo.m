
fs=256;
smooth_trials=50;

mmn_time=round(0.05+[0.1 0.2]*fs);%% MMN period
p300_time=round(0.05+[0.2 0.3]*fs);%% P3 period

path=uigetdir;

habit_offline=rdir(strcat(path,'/**/mmndata.mat'));
habit_offline=habit_offline(end);
off=load(habit_offline.name);off=off.v;

dev_offline_idx=strmatch('550_dev',off.labels);
dev_offline=(off.data(38,:,dev_offline_idx));


stdb_offline_idx=strmatch('550_standb',off.labels);
stdb_offline=off.data(38,:,stdb_offline_idx);


habit_online=rdir(strcat(path,'/**/mmndataFB.mat'));
habit_online=habit_online(end);
on=load(habit_online.name);on=on.v;

dev_online_idx=strmatch('550_dev',on.labels);
dev_online=(off.data(38,:,dev_online_idx));

stdb_online_idx=strmatch('500_standb',on.labels);
stdb_online=on.data(38,:,stdb_online_idx);



% figure, hold on, plot(mmn_offline),
% plot(filter(1/50*ones(1,50),1,mmn_offline),'r'),title('MMN offline'), xlabel('trial number'),axis(ax_off)
% figure, hold on, plot(p300_offline), plot(filter(1/50*ones(1,50),1,p300_offline),'r'),title('P300 offline'), xlabel('trial number'),axis(ax_off)
% figure, hold on, plot(mmn_online), plot(filter(1/50*ones(1,50),1,mmn_online),'r'),title('MMN online'), xlabel('trial number'),axis(ax_on)
% figure, hold on, plot(p300_online), plot(filter(1/50*ones(1,50),1,p300_online),'r'),title('P300 online'), xlabel('trial number'),axis(ax_on)


MMN_offline=repop(dev_offline,'-',mean(stdb_offline,3));
[tmp idx]=min(MMN_offline(1,mmn_time(1):mmn_time(2),:));
idx=squeeze(idx);
mmnamp_offline=squeeze(mean(MMN_offline(1,mmn_time(1)-1+idx-3:mmn_time(1)-1+idx+3,:),2));
[tmp idx]=max(MMN_offline(1,p300_time(1):p300_time(2),:));
idx=squeeze(idx);
p300amp_offline=squeeze(mean(MMN_offline(1,p300_time(1)-1+idx-3:p300_time(1)-1+idx+3,:),2));

MMN_online=repop(dev_online,'-',mean(stdb_offline,3));
[tmp idx]=min(MMN_online(1,mmn_time(1):mmn_time(2),:));
idx=squeeze(idx);
mmnamp_online=squeeze(mean(MMN_online(1,mmn_time(1)-1+idx-3:mmn_time(1)-1+idx+3,:),2));
[tmp idx]=max(MMN_online(1,p300_time(1):p300_time(2),:));
idx=squeeze(idx);
p300amp_online=squeeze(mean(MMN_online(1,p300_time(1)-1+idx-3:p300_time(1)-1+idx+3,:),2));


figure,plot((-13:size(MMN_offline,2)-14)/fs,mean(MMN_offline,3)), title('offline difference wave'), xlabel('time(sec)')
figure,plot((-13:size(MMN_online,2)-14)/fs,mean(MMN_online,3))  , title('online difference wave') , xlabel('time(sec)')

ax_off=[1 300 -20 20];
ax_on=[1 600 -20 20];

figure,plot(filter(1/smooth_trials*ones(1,smooth_trials),1,mmnamp_offline)),hold on,plot((filter(1/smooth_trials*ones(1,smooth_trials),1,p300amp_offline)),'r')
figure,plot(filter(1/smooth_trials*ones(1,smooth_trials),1,mmnamp_online)),hold on,plot((filter(1/smooth_trials*ones(1,smooth_trials),1,p300amp_online)),'r')

figure,bar([mean(mmnamp_offline) mean(mmnamp_online)]),title('MMN amplitude'),set(gca,'XTickLabel',{'offline' 'online'})
figure,bar([mean(p300amp_offline) mean(p300amp_online)]),title('P300 amplitude'),set(gca,'XTickLabel',{'offline' 'online'})



