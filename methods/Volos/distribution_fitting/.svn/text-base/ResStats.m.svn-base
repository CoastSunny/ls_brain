% subjects={'JPsv02', 'JPsv04', 'JPsv05', 'JPsv08','JPsv09','JPsv11'};
% group='JP';
% markers={'20', '21','22'};
% lscfg.averaging='yes';
% lscfg.ica='no';
% ncol={'or','og','ob'};
% jcol={'+r','+g','+b'};
% count=1;
% trans=0.13;
% scale=0.04;
% for i=1:length(subjects)
%     
%     for j=1:length(markers)
%         
%         lscfg.subject=subjects{i};
%         lscfg.markers=markers{j};
%         R=ls_subjectanalysis(lscfg);
%         eval([ lscfg.subject, 'E', lscfg.markers , ' = R.appended ;' ]);
%         [D,y,r,w]=ls_tracking( eval([ lscfg.subject, 'E', lscfg.markers]),'LS',trans, scale);
%             
%             for k=1:length(eval([lscfg.subject, 'E', lscfg.markers , '.trial']))
%                 eval([ lscfg.subject, 'E', lscfg.markers , 'res(k) = D(k).res ; '])
%             end
%         x=eval([ lscfg.subject, 'E', lscfg.markers , 'res;']); 
%         %figure,hist(eval([ lscfg.subject, 'E', lscfg.markers , 'res']),10)
%         y=ksdensity(x,'width',0.05);
%         eval([ 'pd', lscfg.subject, 'E', lscfg.markers ,' =y;']);
%         
%         eval([ 'par', group,'(count,:)' ,' =[mean(x) std(x) skewness(x) kurtosis(x)];']);
%         count=count+1;
%     end
% end
subjects={'NLsv01','NLsv03','NLsv04','NLsv07','NLsv08','NLsv09'};
lscfg.averaging='yes';
lscfg.ica='no';
group='NL';
count=1;
for i=1:length(subjects)
    
    for j=1:length(markers)
        
        lscfg.subject=subjects{i};
        lscfg.markers=markers{j};
        R=ls_subjectanalysis(lscfg);
        eval([ lscfg.subject, 'E', lscfg.markers , ' =R.appended;' ]);
        [D,y,r,w]=ls_tracking( eval([ lscfg.subject, 'E', lscfg.markers]),'LS',trans,scale);
            
            for k=1:length(eval([lscfg.subject, 'E', lscfg.markers , '.trial']))
                eval([ lscfg.subject, 'E', lscfg.markers , 'res(k)=D(k).res;'])
            end
        x=eval([ lscfg.subject, 'E', lscfg.markers , 'res;']); 
        %figure,hist(eval([ lscfg.subject, 'E', lscfg.markers , 'res']),10)
        y=ksdensity(x,'width',0.05);
        eval([ 'pd', lscfg.subject, 'E', lscfg.markers ,' =y;']);
        
        eval([ 'par', group,'(count,:)' ,' =[mean(x) std(x) skewness(x) kurtosis(x)];']);
        count=count+1;
    end
end
