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
    % tmp=S.default.train_classifier('classes',{{0};{1}},'channels',1:10,'freqband',[0.1 10],'vis','off','balYs',0,'calibrate',[]);
    % rate(j,k)=tmp.rate;
    
    
    %      tmp=S.default.plot('classes',{1},'blocks_in',1,'channels',5,'vis','off');
    %      [tmp2 start_samp,freqs]=spectrogram(mean(tmp.avg),2,'fs',250,'nwindows',1);
    %      target=squeeze(tmp2);
    %      tmp=S.default.plot('classes',{0},'blocks_in',1,'channels',5,'vis','off');
    %      [tmp2 start_samp,freqs]=spectrogram(mean(tmp.avg),2,'fs',250,'nwindows',1);
    %      nontarget=squeeze(tmp2);
    %      figure,hold on,plot(tf,target),title([members{j} ' ' num2str(rate(j,k))]),plot(tf,nontarget,'-.'),xlabel('frequency Hz');ylabel('power')
    %
    % S.default.plot('classes',{0},'blocks_in',1,'channels',3:6,'vis','on','trials',1),title([members{j} ' ' num2str(rate(j,k))])
    
    %     tmp1=S.default.plot('classes',{0},'blocks_in',1,'channels',1:10,'vis','off');
    %     tmp2=S.default.plot('classes',{1},'blocks_in',1,'channels',1:10,'vis','off');
    %     tmp3=S.default.plot('classes',{10},'blocks_in',1,'channels',1:10,'vis','off');
    %     tmp4=S.default.plot('classes',{11},'blocks_in',1,'channels',1:10,'vis','off');
    %     tmp5=S.default.plot('classes',{20},'blocks_in',1,'channels',1:10,'vis','off');
    %     tmp6=S.default.plot('classes',{21},'blocks_in',1,'channels',1:10,'vis','off');
    ftmp1=S.default.plot('classes',{0},'blocks_in',1,'channels',1:10,'vis','off','method','spectro');
    %  ftmp2=S.default.plot('classes',{1},'blocks_in',1,'channels',1:10,'vis','off','method','spectro');
    ftmp3=S.default.plot('classes',{10},'blocks_in',1,'channels',1:10,'vis','off','method','spectro');
    % ftmp4=S.default.plot('classes',{11},'blocks_in',1,'channels',1:10,'vis','off','method','spectro');
    ftmp5=S.default.plot('classes',{20},'blocks_in',1,'channels',1:10,'vis','off','method','spectro');
    a=ftmp1;b=ftmp3;c=ftmp5;f1=[];f2=[];f3=[];
    for i=1:10
       
        if(a(i,:)==0)
            f1(end+1)=i;
        end
        if(b(i,:)==0)
            f2(end+1)=i;
        end
        if(c(i,:)==0)
            f3(end+1)=i; 
        end
        
    end
    ftmp1(f1,:)=[];
    ftmp3(f2,:)=[];
    ftmp5(f3,:)=[];
        P50(j,:)=[mean(ftmp1(:,31))/mean(mean(ftmp1(:,1:6))) mean(ftmp3(:,31))/mean(mean(ftmp3(:,1:6))) mean(ftmp5(:,31))/mean(mean(ftmp5(:,1:6)))];
        Pm50(j,:)=[max(ftmp1(:,31)) max(ftmp3(:,31)) max(ftmp5(:,31))];
        Pall(j,:)=[mean(mean(ftmp1)) mean(mean(ftmp3)) mean(mean(ftmp5))];
        Perp(j,:)=[mean(mean(ftmp1(:,1:6))) mean(mean(ftmp3(:,1:6))) mean(mean(ftmp5(:,1:6))) ];
        %ftmp6=S.default.plot('classes',{21},'blocks_in',1,'channels',1:10,'vis','off','method','spectro');
        %     ftmp1=S.default.plot('classes',{0},'blocks_in',1,'channels',1:10,'vis','off','method','spectro');
        %     ftmp2=S.default.plot('classes',{1},'blocks_in',1,'channels',1:10,'vis','off','method','spectro');
        %     atemp=S.default.auc('classes',{{0};{1}},'blocks_in',1,'channels',1:10,'vis','off');
        
        %figure,hold on,plot(t,tmp1.avg(:,timein),'r'),plot(t,tmp2.avg(:,timein),'g'),title([members{i} ' ' num2str(rate(i,j))])
        %figure,hold on,plot(t,mean(tmp1.avg(:,timein)),'r','Linewidth',4),plot(t,mean(tmp2.avg(:,timein)),'g','Linewidth',4),title([members{i} ' ' num2str(rate(i,j))])
        %figure,hold on,shadedErrorBar(t,tmp1.avg(:,timein),tmp1.var(:,timein).^.5,'r',1),shadedErrorBar(t,tmp2.avg(:,timein),tmp2.var(:,timein).^.5,'g',1)
        %  title([members{j} ' perf: ' num2str(rate(j,k)) '  r1: '  num2str(r1) '  r2: ' num2str(r2) ])
        % figure,hold on,shadedErrorBar(t,mean(tmp1.avg(:,timein)),mean(tmp1.var(:,timein).^.5),'r',1),shadedErrorBar(t,mean(tmp2.avg(:,timein)),mean(tmp2.var(:,timein).^.5),'g',1),
        %title([members{j} ' perf: ' num2str(rate(j,k)) '  r1: '  num2str(r1) '  r2: ' num2str(r2) ])
        %title(members{j})
        %     figure
        %     count=1
        %     for i=1:10
        %
        %         subplot(2,5,count),xlabel('time in seconds'),ylabel('amplitude'),title(['channel: ' num2str(i)]),,xlim(txlim),count=count+1,hold on,plot(t,tmp1.avg(i,:),'r')%,plot(t,tmp2.avg(i,:),'g'),count=count+1;
        %        % subplot(5,6,count),xlim(txlim),hold on,plot(t,tmp3.avg(i,:),'r'),plot(t,tmp4.avg(i,:),'g'),count=count+1;
        %        % subplot(5,6,count),xlim(txlim),hold on,plot(t,tmp5.avg(i,:),'r'),plot(t,tmp6.avg(i,:),'g'),count=count+1;
        %         %       if (count==4),title([members{j} ' perf:    ' num2str(rate(j,k)) ]),end;
        %
        %     end
        % %     jFrame = get(handle(gcf),'JavaFrame')
        % %     pause(0.5)
        % %     jFrame.setMaximized(true);
        % %     pause(1)
        % %     saveaspdf(gcf,[members{j} 'erpblocks'],'closef')
        % %     pause(1)
        %     figure
        %     count=1
        %     for i=1:10
        %
        %         subplot(2,5,count),title(['channel: ' num2str(i)]),xlim(fxlim),hold on,plot(tf,ftmp1(i,:),'r'),count=count+1;%,plot(tf,ftmp2(i,:),'g')
        %         set(gca,'XTick',[0 10 25 50 75 125]),xlabel('frequency'),ylabel('power')
        %         %subplot(5,6,count),xlim(fxlim),hold on,plot(tf,ftmp3(i,:),'r'),plot(tf,ftmp4(i,:),'g'),count=count+1;
        %         %set(gca,'XTick',[0 10 25 50 75 125]),
        %         %subplot(5,6,count),xlim(fxlim),hold on,plot(tf,ftmp5(i,:),'r'),plot(tf,ftmp6(i,:),'g'),count=count+1;
        %         %set(gca,'XTick',[0 10 25 50 75 125]),
        %            %    if (count==4),title([members{j} ' perf:    ' num2str(rate(j,k)) ]),end;
        %
        %     end
        %     figure
        %     for i=1:10
        %
        %         subplot(2,5,i),xlim(fxlim),hold on,plot(tf,ftmp1(i,:),'r'),plot(tf,ftmp2(i,:),'g'),if (i==3),title(['Spectrum  ' members{j}]),end
        %         set(gca,'XTick',[0 10 20 30 40 50  75 100  125])
        %
        %     end
        %     figure
        %     for i=1:10
        %
        %         subplot(2,5,i),imagesc(atemp(i,:)),if (i==3),title(['AUC  ' members{j}]),end
        %
        %     end
        %     jFrame = get(handle(gcf),'JavaFrame')
        %     pause(0.5)
        %     jFrame.setMaximized(true);
        %     pause(1)
        %     saveaspdf(gcf,[members{j} 'spblocks'],'closef')
        %
    end
    %end