k=1;
members=sort(properties(GRID));
timein=1:150;
t=timein./250;
tf=(0:75)/150*250;
txlim=[0 0.6];
fxlim=[0 125];
%for j=1:100
for j=1:numel(members)
    
    S=GRID.(members{j}).copy;   
    
    tmp1=S.default.trial_amp('classes',{0},'blocks_in',1,'channels',1:10,'vis','off','badrem','yes');
    
    tmp3=S.default.trial_amp('classes',{10},'blocks_in',1,'channels',1:10,'vis','off','badrem','yes');
   
    tmp5=S.default.trial_amp('classes',{20},'blocks_in',1,'channels',1:10,'vis','off','badrem','yes');
    
    M{j}={tmp1.m tmp3.m tmp5.m};

    figure
    count=1
    for i=1:10
        
        subplot(5,6,count),hold on,plot(tmp1.m(i,:),'r'),count=count+1;ylim=get(gca,'YLim');              
        subplot(5,6,count),hold on,plot(tmp3.m(i,:),'r'),count=count+1;set(gca,'YLim',ylim);              
        subplot(5,6,count),hold on,plot(tmp5.m(i,:),'r'),count=count+1;set(gca,'YLim',ylim);              
               if (count==4),title([members{j} ]),end;
        
    end
    jFrame = get(handle(gcf),'JavaFrame')
    pause(0.5)
    jFrame.setMaximized(true);
    pause(1)
    saveaspdf(gcf,[members{j} 'tramp'],'closef')
    pause(1)
   
%   
end
%end