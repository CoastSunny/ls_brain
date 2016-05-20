ti=(-1250:6249)/250;
ax=[-5 25 -2 2];

NIRS=controls.copy;
members=properties(NIRS);
clear OA DA OI DI OR DR
for i=1:numel(members)
    
    o=NIRS.(members{i}).default.plot('classes',{3},'channels','nirs_o2hbb','blocks_in',1:8,'vis','off');
  %  d=NIRS.(members{i}).default.plot('classes',{3},'channels','nirs_hhbb','blocks_in',1:8,'vis','off');
    
    OA(i,:)=o.avg;
%    DA(i,:)=d.avg;
        
%     o=NIRS.(members{i}).default.plot('classes',{5},'channels','nirs_o2hbb','blocks_in',1:8,'vis','off');
%     d=NIRS.(members{i}).default.plot('classes',{5},'channels','nirs_hhbb','blocks_in',1:8,'vis','off');
%     
%     OI(i,:)=o.avg;
%     DI(i,:)=d.avg;   
%     
    o=NIRS.(members{i}).default.plot('classes',{2},'channels','nirs_o2hbb','blocks_in',1:8,'vis','off');
 %   d=NIRS.(members{i}).default.plot('classes',{2},'channels','nirs_hhbb','blocks_in',1:8,'vis','off');
%     
    OR(i,:)=o.avg;
 %   DR(i,:)=d.avg;   
    
end

figure,hold on,plot(ti',OA','LineWidth',4),plot(ti',OR','--');
xlabel('time');ylabel('concetration change');title('OAC');
axis(ax);

% figure,hold on,plot(ti',OI','LineWidth',4),plot(ti',OR','--');
% xlabel('time');ylabel('concetration change');title('OIC');
% axis(ax);
% figure,hold on,plot(ti',DA','LineWidth',4),plot(ti',DR','--');
% xlabel('time');ylabel('concetration change');title('DAC');
% axis(ax);
% figure,hold on,plot(ti',DI','LineWidth',4),plot(ti',DR','--');
% xlabel('time');ylabel('concetration change');title('DIC');
% axis(ax);

NIRS=patients.copy;
members=properties(NIRS);
clear OA DA OI DI OR DR
for i=1:numel(members)
    
    o=NIRS.(members{i}).default.plot('classes',{3},'channels','nirs_o2hbb','blocks_in',1:8,'vis','off');
   % d=NIRS.(members{i}).default.plot('classes',{3},'channels','nirs_hhbb','blocks_in',1:8,'vis','off');
    
    OA(i,:)=o.avg;
 %   DA(i,:)=d.avg;
        
%     o=NIRS.(members{i}).default.plot('classes',{5},'channels','nirs_o2hbb','blocks_in',1:8,'vis','off');
%     d=NIRS.(members{i}).default.plot('classes',{5},'channels','nirs_hhbb','blocks_in',1:8,'vis','off');
%     
%     OI(i,:)=o.avg;
%     DI(i,:)=d.avg;   
    
    o=NIRS.(members{i}).default.plot('classes',{2},'channels','nirs_o2hbb','blocks_in',1:8,'vis','off');
    %d=NIRS.(members{i}).default.plot('classes',{2},'channels','nirs_hhbb','blocks_in',1:8,'vis','off');
    
    OR(i,:)=o.avg;
  %  DR(i,:)=d.avg;   
    
end

figure,hold on,plot(ti',OA','LineWidth',4),plot(ti',OR','--');
xlabel('time');ylabel('concetration change');title('OAT');
axis(ax);
% figure,hold on,plot(ti',OI','LineWidth',4),plot(ti',OR','--');
% xlabel('time');ylabel('concetration change');title('OIT');
% axis(ax);
% figure,hold on,plot(ti',DA','LineWidth',4),plot(ti',DR','--');
% xlabel('time');ylabel('concetration change');title('DAT');
% axis(ax);
% figure,hold on,plot(ti',DI','LineWidth',4),plot(ti',DR','--');
% xlabel('time');ylabel('concetration change');title('DIT');
% axis(ax);