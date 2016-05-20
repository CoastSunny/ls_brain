
for ss=1:numel(subj)

  eval(['X=' subj{ss} '_sEEG;']) 
  eval(['sp=' subj{ss} 'spikes;']) 
  
  X=X(:,:,sp(2,:)>6);
  ax=TPfX{ss};arx=TPfRX{ss};b=cat(3,TPX{ss},TPRX{ss});
  a=cat(4,ax,arx);[idx c]=kmeans(reshape(a,[],size(a,4))',2);
  figure,subplot(3,2,1)
  plot_ep(X)
  subplot(3,2,2)
  plot_ep(b)
  subplot(3,2,3)
  plot_ep(b(:,:,idx==1))
  subplot(3,2,4)
  plot_ep(b(:,:,idx==2))
  subplot(3,2,5)
  plot_ep(TPX{ss})
  subplot(3,2,6)
  plot_ep(TPRX{ss})
% drawnow;
 set(get(handle(gcf),'JavaFrame'),'Maximized',1);
% pause(1)
%   saveaspdf(gcf,['s' num2str(ss)])
end