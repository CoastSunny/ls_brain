cfg.layout='/home/lspyrou/Documents/ls_brain/global/biosemi128.lay';
cfg.parameter='powspctrm';
cfg.comment='no';

temp=freq{1};
aaa=[];bbb=[];ccc=[];ddd=[];
faaa=[];fbbb=[];fccc=[];fddd=[];
Pa=[];Pb=[];Pc=[];Pd=[];
reg_pars=numel(Alpha);
comps=10;
for s=1:19
    for i=1:comps
        for j=1:reg_pars
            aaa(s,i,j,:)=Fp{j,s}{2}(:,i);
            faaa(s,i,j,:)=Fp{j,s}{1}(:,i);
        end
    end
end
for s=20:38
    for i=1:comps
        for j=1:reg_pars
            bbb(s-19,i,j,:)=Fp{j,s}{2}(:,i);
            fbbb(s-19,i,j,:)=Fp{j,s}{1}(:,i);
        end
    end
end
for s=39:51
    for i=1:comps
        for j=1:reg_pars
            ccc(s-38,i,j,:)=Fp{j,s}{2}(:,i);
            fccc(s,i,j,:)=Fp{j,s}{1}(:,i);
        end
    end
end
for s=52:64
    for i=1:comps
        for j=1:reg_pars
            ddd(s-51,i,j,:)=Fp{j,s}{2}(:,i);
            fddd(s,i,j,:)=Fp{j,s}{1}(:,i);
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

cfg=rmfield(cfg,'zlim');
reg=5;j=reg;
Sel={1:32 33:64 65:96 97:128 [1:32 65:96]};
figure
for i=1:comps
    subplot(4,comps,i)
    temp.powspctrm=abs(repmat(squeeze(mean(aaa(:,i,reg,:),1)),1,15)).^2;
    if i<6; Pa(i,j)=mean(mean(temp.powspctrm(Sel{i},:))); end;
    ft_topoplotTFR(cfg,temp)    ;
end
% Pa(:,j)=Pa(:,j)/sum(Pa(:,j));
% figure
for i=1:comps
    subplot(4,comps,i+comps)
    temp.powspctrm=abs(repmat(squeeze(mean(bbb(:,i,reg,:),1)),1,15)).^2;
    if i<6;Pb(i,j)=mean(mean(temp.powspctrm(Sel{i},:)));end;
    ft_topoplotTFR(cfg,temp);
end
% Pb(:,j)=Pb(:,j)/sum(Pb(:,j));
% figure
for i=1:comps
    subplot(4,comps,i+(2*comps))
    temp.powspctrm=abs(repmat(squeeze(mean(ccc(:,i,reg,:),1)),1,15)).^2;
    if i<6;Pc(i,j)=mean(mean(temp.powspctrm(Sel{i},:)));end;
    ft_topoplotTFR(cfg,temp);
end
% Pc(:,j)=Pc(:,j)/sum(Pc(:,j));
% figure
for i=1:comps
    subplot(4,comps,i+(3*comps))
    temp.powspctrm=abs(repmat(squeeze(mean(ddd(:,i,reg,:),1)),1,15)).^2;
    if i<6;Pd(i,j)=mean(mean(temp.powspctrm(Sel{i},:)));end;
    ft_topoplotTFR(cfg,temp);
end
% Pd(:,j)=Pd(:,j)/sum(Pd(:,j));
% 
% figure
% for i=1:6
%     subplot(2,3,i)
%     plot(squeeze(mean(faaa(:,i,j,:),1)))
% end
% Pa(:,j)=Pa(:,j)/sum(Pa(:,j));

cfg.zlim=[-180 180];

figure
for i=1:comps
    subplot(4,comps,i)
    temp.powspctrm=angle(repmat(squeeze(mean(aaa(:,i,reg,:),1)),1,15))*180/pi;
    if i<6; Pa(i,j)=mean(mean(temp.powspctrm(Sel{i},:))); end;
    ft_topoplotTFR(cfg,temp)    ;
end
% Pa(:,j)=Pa(:,j)/sum(Pa(:,j));
% figure
for i=1:comps
    subplot(4,comps,i+comps)
    temp.powspctrm=angle(repmat(squeeze(mean(bbb(:,i,reg,:),1)),1,15))*180/pi;
    if i<6;Pb(i,j)=mean(mean(temp.powspctrm(Sel{i},:)));end;
    ft_topoplotTFR(cfg,temp);
end
% Pb(:,j)=Pb(:,j)/sum(Pb(:,j));
% figure
for i=1:comps
    subplot(4,comps,i+(2*comps))
    temp.powspctrm=angle(repmat(squeeze(mean(ccc(:,i,reg,:),1)),1,15))*180/pi;
    if i<6;Pc(i,j)=mean(mean(temp.powspctrm(Sel{i},:)));end;
    ft_topoplotTFR(cfg,temp);
end
% Pc(:,j)=Pc(:,j)/sum(Pc(:,j));
% figure
for i=1:comps
    subplot(4,comps,i+(3*comps))
    temp.powspctrm=angle(repmat(squeeze(mean(ddd(:,i,reg,:),1)),1,15))*180/pi;
    if i<6;Pd(i,j)=mean(mean(temp.powspctrm(Sel{i},:)));end;
    ft_topoplotTFR(cfg,temp);
end