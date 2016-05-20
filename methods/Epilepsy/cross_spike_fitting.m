
for i = 1 : size(spikes,2)
    
   % xx=repop(sEEG(schannels,:,i),'/',std(sEEG(schannels,:,i),[],2));
    xx=(sEEG(schannels,:,i));
    for j = 1 : size(spikes,2)
        
        template=spike(j,:)-mean(spike(j,:));
        template=template/norm(template);
%          if j==5
%              template=100000*template;
%              
%          end
        w=inv(xx*xx'+0*norm(xx,'fro'))*xx*template';
        y=w'*xx;
        r(i,j)=norm(y-template);
        
    end
    
    r(i,:)=r(i,:)/max(r(i,:));
    
end
