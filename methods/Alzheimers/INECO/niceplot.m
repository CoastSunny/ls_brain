temp=freq{1};
aaa=[];
reg_pars=1;
for s=1:19
    for i=1:5        
        for j=1:reg_pars
        aaa(s,i,j,:)=Fp{j,s}{2}(:,i);
        end
    end
end
for s=20:38
    for i=1:5        
        for j=1:reg_pars
        bbb(s,i,j,:)=Fp{j,s}{2}(:,i);
        end
    end
end
for i=1:5
    figure
    for j=1:reg_pars
%     temp.powspctrm=repmat(Fp{j,1}{2}(:,i),1,15);
      temp.powspctrm=repmat(squeeze(mean(aaa(:,i,j,:),1)),1,15);
      subplot(1,reg_pars,j)
      ft_topoplotTFR(cfg,temp)
      Pa(i,j)=mean(mean(temp.powspctrm));
    end
%       saveaspdf(gcf,['S42Net' num2str(i)])
end

for i=1:5
    figure
    for j=1:reg_pars
%     temp.powspctrm=repmat(Fp{j,1}{2}(:,i),1,15);
      temp.powspctrm=repmat(squeeze(mean(bbb(:,i,j,:),1)),1,15);
      subplot(1,reg_pars,j)
      ft_topoplotTFR(cfg,temp)
      Pb(i,j)=mean(mean(temp.powspctrm));
    end
%       saveaspdf(gcf,['S42Net' num2str(i)])
end
      
      