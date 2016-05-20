cd ~/MATLAB/results/gemi/offline/classification/plots/
%1) apply_big_on_smaller_contrast
clear rates

for i=1:length(JPsv.apply_big_on_small)
        
    rates.jps(:,i)=JPsv.apply_big_on_small{i};
    
end
rates.jps(:,end+1)=mean(rates.jps');
figure(1),bar(rates.jps'),axis([0.2 9 0 1]),xlabel('participant');ylabel('ratio');title('JP single');
set(gca,'XTickLabel',{'1','2','3','4','5','6','7','av'}),legend('big on big','big on medium','big on small')

saveas(figure(1),'clr:bigonsmall:jpsv.jpg');

for i=1:length(NLsv.apply_big_on_small)
        
    rates.nls(:,i)=NLsv.apply_big_on_small{i};
    
end
rates.nls(:,end+1)=mean(rates.nls');
figure(2),bar(rates.nls'),axis([0.2 10 0 1]),xlabel('participant');ylabel('ratio');title('NL single');
set(gca,'XTickLabel',{'1','2','3','4','5','6','7','8','av'}),legend('big on big','big on medium','big on small')
saveas(figure(2),'clr:bigonsmall:nlsv.jpg');

for i=1:length(JPv.apply_big_on_small)
        
    rates.jpv(:,i)=JPv.apply_big_on_small{i};
    
end
rates.jpv(:,end+1)=mean(rates.jpv');
figure(3),bar(rates.jpv'),axis([0.2 9 0 1]),xlabel('participant');ylabel('ratio');title('JP variable');
set(gca,'XTickLabel',{'1','2','3','4','5','6','7','av'}),legend('big on big','big on medium','big on small')
saveas(figure(3),'clr:bigonsmall:jpv.jpg');

for i=1:length(NLv.apply_big_on_small)
        
    rates.nlv(:,i)=NLv.apply_big_on_small{i};
    
end
rates.nlv(:,end+1)=mean(rates.nlv');
figure(4),bar(rates.nlv'),axis([0.2 7 0 1]),xlabel('participant');ylabel('ratio');title('NL variable');
set(gca,'XTickLabel',{'1','2','3','4','5','av'}),legend('big on big','big on medium','big on small')
saveas(figure(4),'clr:bigonsmall:nlv.jpg');

%2) multitrial classification

clear rates
temp=properties(JPsv);


for i=1:length(temp)

    if (strcmp( class( JPsv.( temp{i} ) ) , 'Subject' ) )
       
        for j=1:20
       
            rates.jps(j,i)=JPsv.(temp{i}).multitrial_classifier('big',20,j);
           
        end
       
    end

end
figure(5),plot(rates.jps),xlabel('no of trials'),ylabel('ratio'),title('JP single');
saveas(figure(5),'clr:multi20:jpsv.jpg');
temp=properties(NLsv);


for i=1:length(temp)

    if (strcmp( class( NLsv.( temp{i} ) ) , 'Subject' ) )
       
        for j=1:20
       
            rates.nls(j,i)=NLsv.(temp{i}).multitrial_classifier('big',20,j);
           
        end
       
    end

end
figure(6),plot(rates.nls),xlabel('no of trials'),ylabel('ratio'),title('NL single');
saveas(figure(6),'clr:multi20:nlsv.jpg');
temp=properties(JPv);


for i=1:length(temp)

    if (strcmp( class( JPv.( temp{i} ) ) , 'Subject' ) )
       
        for j=1:20
       
            rates.jpv(j,i)=JPv.(temp{i}).multitrial_classifier('big',[15 25 35 45],j);
           
        end
       
    end

end
figure(7),plot(rates.jpv),xlabel('no of trials'),ylabel('ratio'),title('JP variable');
saveas(figure(7),'clr:multi20:jpv.jpg');
temp=properties(NLv);


for i=1:length(temp)

    if (strcmp( class( NLv.( temp{i} ) ) , 'Subject' ) )
       
        for j=1:20
       
            rates.nlv(j,i)=NLv.(temp{i}).multitrial_classifier('big',[15 25 35 45],j);
           
        end
       
    end

end
figure(8),plot(rates.nlv),xlabel('no of trials'),ylabel('ratio'),title('NL variable');
saveas(figure(8),'clr:multi20:nlv.jpg');
