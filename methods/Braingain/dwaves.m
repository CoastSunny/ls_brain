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
   
    
    tmp1=S.default.plot('classes',{0},'blocks_in',1,'channels',1:10,'vis','off','badrem','yes');
    tmp2=S.default.plot('classes',{1},'blocks_in',1,'channels',1:10,'vis','off','badrem','yes');
    tmp3=S.default.plot('classes',{10},'blocks_in',1,'channels',1:10,'vis','off','badrem','yes');
    tmp4=S.default.plot('classes',{11},'blocks_in',1,'channels',1:10,'vis','off','badrem','yes');
    tmp5=S.default.plot('classes',{20},'blocks_in',1,'channels',1:10,'vis','off','badrem','yes');
    tmp6=S.default.plot('classes',{21},'blocks_in',1,'channels',1:10,'vis','off','badrem','yes');
    
    figure
    count=1
    for i=1:10
        
        subplot(5,6,count),plot(t,tmp2.avg(i,:)-tmp1.avg(i,:),'r'),count=count+1;set(gca,'XLim',[0 0.6]);              
        subplot(5,6,count),plot(t,tmp4.avg(i,:)-tmp3.avg(i,:),'r'),count=count+1;set(gca,'XLim',[0 0.6]);              
        subplot(5,6,count),plot(t,tmp6.avg(i,:)-tmp5.avg(i,:),'r'),count=count+1;set(gca,'XLim',[0 0.6]);              
               if (count==4),title([members{j} ]),end;
        
    end
    jFrame = get(handle(gcf),'JavaFrame')
    pause(0.5)
    jFrame.setMaximized(true);
    pause(1)
    saveaspdf(gcf,[members{j} 'dwaveblocks'],'closef')
    pause(1)
    
    
end
%end