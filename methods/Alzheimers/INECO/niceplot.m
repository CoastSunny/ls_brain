temp=freq{1};
aaa=[];bbb=[];ccc=[];ddd=[];
Pa=[];Pb=[];
reg_pars=6;
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
for s=39:51
    for i=1:5
        for j=1:reg_pars
            ccc(s,i,j,:)=Fp{j,s}{2}(:,i);
        end
    end
end
for s=52:64
    for i=1:5
        for j=1:reg_pars
            ddd(s,i,j,:)=Fp{j,s}{2}(:,i);
        end
    end
end
% for i=1:5
%     figure
%     for j=1:reg_pars
%         %     temp.powspctrm=repmat(Fp{j,1}{2}(:,i),1,15);
%         temp.powspctrm=repmat(squeeze(mean(aaa(:,i,j,:),1)),1,15);
%         subplot(1,reg_pars,j)
%         ft_topoplotTFR(cfg,temp)
%         Pa(i,j)=mean(mean(temp.powspctrm));
%     end
%     %       saveaspdf(gcf,['S42Net' num2str(i)])
% end
% 
% for i=1:5
%     figure
%     for j=1:reg_pars
%         %     temp.powspctrm=repmat(Fp{j,1}{2}(:,i),1,15);
%         temp.powspctrm=repmat(squeeze(mean(bbb(:,i,j,:),1)),1,15);
%         subplot(1,reg_pars,j)
%         ft_topoplotTFR(cfg,temp)
%         Pb(i,j)=mean(mean(temp.powspctrm));
%     end
%     %       saveaspdf(gcf,['S42Net' num2str(i)])
% end

figure
reg=3;
for i=1:5
    subplot(2,3,i)
    temp.powspctrm=repmat(squeeze(mean(aaa(:,i,reg,:),1)),1,15);
    ft_topoplotTFR(cfg,temp)
end

figure
for i=1:5
    subplot(2,3,i)
    temp.powspctrm=repmat(squeeze(mean(bbb(:,i,reg,:),1)),1,15);
    ft_topoplotTFR(cfg,temp)
end

figure
for i=1:5
    subplot(2,3,i)
    temp.powspctrm=repmat(squeeze(mean(ccc(:,i,reg,:),1)),1,15);
    ft_topoplotTFR(cfg,temp)
end

figure
for i=1:5
    subplot(2,3,i)
    temp.powspctrm=repmat(squeeze(mean(ddd(:,i,reg,:),1)),1,15);
    ft_topoplotTFR(cfg,temp)
end