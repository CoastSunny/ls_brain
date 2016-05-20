clear G W a out lsout
G=Group;
G.addprop('APLO1');
G.addprop('APLO2');
G.addprop('APLO3');
G.APLO1=APLO1;
G.APLO2=APLO2;
G.APLO3=APLO3;

cl1=14;
cl2=20;

subjects={'APLO1' 'APLO2' 'APLO3'};
days={'d1' 'd2' 'd3'};
day=1;
width=5;
trials='all';
tmpa=randperm(300);
tmpb=randperm(300);
trials=[tmpa(1:50) 300+tmpb(1:50)];
t=1:64;
g=@(x,y)(exp(-(x-t).^2/y.^2));
options=optimset('Algorithm','interior-point');
channels=38;
clear lsw a Wcl W 
for i=1:numel(subjects)
    
    G.(subjects{i}).(days{day}).default.train_classifier('classes',{{cl1};{cl2}},...
        'blocks_in',1:4,'channels',channels,'time',1:64,'trials',trials,'Cs',0)
    W{i}=G.(subjects{i}).(days{day}).default.test.W;
    
    %     a{i}=fminsearch(@(theta)...
    %         norm(W{i}-theta(1)*g(theta(2),width)-theta(3)*g(theta(4),width)),...
    %         [0 15 0 30]);
    %
    %     lsw{i}=a{i}(1)*g(a{i}(2),width)+a{i}(3)*g(a{i}(4),width);
    %
    %      a{i}=fminsearch(@(theta)...
    %         norm(W{i}-theta(1)*g(theta(2),theta(3))-theta(4)*g(theta(5),theta(6))),...
    %         [0 20 4 1 35 4])
     
        
        Wcl=W{i};
        lb=[-0.1 14 4 0.00 25 4 .6*ones(1,numel(channels))];
        ub=[-0.00 25 8 0.1 40 8 1.4*ones(1,numel(channels))];
        
        lossf=@(x)( norm( Wcl - x(7:7+numel(channels)-1)' * (x(1)*g(x(2),x(3)) + x(4)*(g(x(5),x(6))) )) );
        a{i}=fmincon(lossf,[-0.05 14 5 0.05 30 5 ones(1,numel(channels))],[],[],[],[],...
            lb,ub,...
            [],options);
        
        lsw{i}=a{i}(7:7+numel(channels)-1)'*(a{i}(1)*g(a{i}(2),a{i}(3))+a{i}(4)*g(a{i}(5),a{i}(6)));
    

    
%     for ch=1:numel(channels)
%         
%         Wcl=W{i}(ch,:);
%         lb=[2*min(Wcl) 10 4 0.00 25 4];
%         ub=[-0.00 25 8 2*max(Wcl) 40 8];
%         
%         lossf=@(x)( norm( Wcl - x(1)*g(x(2),x(3)) - x(4)*(g(x(5),x(6)) )) );
%         a{i}{ch}=fmincon(lossf,[-0.05 12 5 0.05 30 5],[],[],[],[],...
%             lb,ub,...
%             [],options);
%         
%         lsw{i}(ch,:)=a{i}{ch}(1)*g(a{i}{ch}(2),a{i}{ch}(3))+a{i}{ch}(4)*g(a{i}{ch}(5),a{i}{ch}(6));
%     end
    %     dw{i}=G.(subjects{i}).(days{day}).default.diff_wave('classes',{{cl1};{cl2}},...
    %         'blocks_in',1:4,'channels',38,'time',1:64)
    
end

for j=1:numel(subjects)
    for i=2:3
        
        lsout{j,i-1}=G.(subjects{j}).(days{day}).default.apply_classifier(G.(subjects{j}).(days{i}).default,...
            'classes',{{cl1};{cl2}},'blocks_in',1:4,'channels',channels,'time',1:64,'W',lsw{j});
        
    end
end

for j=1:numel(subjects)
    for i=2:3
        
        randout{j,i-1}=G.(subjects{j}).(days{day}).default.apply_classifier(G.(subjects{j}).(days{i}).default,...
            'classes',{{cl1};{cl2}},'blocks_in',1:4,'channels',channels,'time',1:64,'W',rand(numel(channels),64));
        
    end
end

for j=1:numel(subjects)
    for i=2:3
        
        out{j,i-1}=G.(subjects{j}).(days{day}).default.apply_classifier(G.(subjects{j}).(days{i}).default,...
            'classes',{{cl1};{cl2}},'blocks_in',1:4,'channels',channels,'time',1:64)
        
    end
end

% for j=1:numel(subjects)
%     for i=2:3
%         
%         dwout{j,i-1}=G.(subjects{j}).(days{day}).default.apply_classifier(G.(subjects{j}).(days{i}).default,...
%             'classes',{{cl1};{cl2}},'blocks_in',1:4,'channels',channels,'time',1:64,'W',-dw{i})
%         
%     end
% end

for i=1:numel(subjects)
    
    G.(subjects{i}).(days{day}).default.train_classifier('classes',{{cl1};{cl2}},...
        'blocks_in',1:4,'channels',channels,'time',1:64,'trials',trials);
    Wreg{i}=G.(subjects{i}).(days{day}).default.test.W;
    
end

for j=1:numel(subjects)
    for i=2:3
        
        regout{j,i-1}=G.(subjects{j}).(days{day}).default.apply_classifier(G.(subjects{j}).(days{i}).default,...
            'classes',{{cl1};{cl2}},'blocks_in',1:4,'channels',channels,'time',1:64);
        
    end
end

for i=1:numel(lsout)
    
    perf1(i)=lsout{i}.rate(3)-regout{i}.rate(3);
    perf2(i)=lsout{i}.rate(3)-out{i}.rate(3);
    perf3(i)=randout{i}.rate(3)-out{i}.rate(3);
    %     perf3(i)=dwout{i}.rate(3)-out{i}.rate(3);
  %  perf4(i)=dwout{i}.rate(3)-regout{i}.rate(3);
    
end

mean(perf1),mean(perf2),mean(perf3)%,mean(perf4)
