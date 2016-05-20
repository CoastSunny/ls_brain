addpath D:/Extracted/DECO/


t=(1:307)/512;
s_delay=diag( ones( 1 , 307 - 32 ) , 32 );
s_L_delay=diag( ones(1, 307 - 47 ), 47 );
u60_delay=diag( ones( 1 , 307 - 63 ) , 63 );
u150_delay=diag( ones( 1 , 307 - 109 ) , 109 );
u240_delay=diag( ones( 1 , 307 - 155 ) , 155 );
u240_L_delay=diag( ones( 1 , 307 - 170 ) , 170 );
ax=[0 0.7 -6 6];
included_chan=[4 5 8 23 26 27 31 32];
%subjects={ 'JP04' 'JP05' 'JP01' 'JP07' 'JP03' 'NJP01' 'NJP04' 'NJP06' 'NJP05' 'NJP02' 'NJP03' };
subjects={ 'JP03' 'JP04' 'JP05' 'JP07' 'JP10' 'JP11' 'JP12' 'JP13' ...
    'NJP01' 'NJP02' 'NJP03' 'NJP04' 'NJP05' 'NJP06' 'NJP10' 'NJP11'};
subjects_gdf={'JP10' 'JP11' 'JP12' 'JP13' 'NJP10' 'NJP11'};
%load channlabels

% G=Group;
% for i=1:numel(subjects)
%
%     G.addprop(subjects{i});
%     try G.(subjects{i})=DJP.(subjects{i}).copy;
%     catch err
%         G.(subjects{i})=DNJP.(subjects{i}).copy;
%     end
%
% end
% members=sort(properties(G));


clear X E D LSD60 LSD150 LSD240 A Y B
clear LSD60 LSD150 LSD240 LSD240M LSD240L LSDL240 LSDk

for i=1:numel(subjects)
    clear S
    load(subjects{i})
    if ( isempty(strmatch(subjects{i},subjects_gdf)))
        channlabels=included_chan;
    else channlabels=included_chan+1;
    end
    base={'blocks_in',1:200,'channels',channlabels,'vis','off','time',1:307,'badrem','yes'};
    as60u=S.default.plot(  [{'classes',{11}} base] );
    as90u=S.default.plot(  [{'classes',{12}} base] );
    as120u=S.default.plot( [{'classes',{13}} base] );
    as150u=S.default.plot( [{'classes',{14}} base] );
    as180u=S.default.plot( [{'classes',{15}} base] );
    as210u=S.default.plot( [{'classes',{16}} base] );
    as240u=S.default.plot( [{'classes',{17}} base] );
    as240Mu=S.default.plot( [{'classes',{18}} base] );
    as240Lu=S.default.plot( [{'classes',{19}} base] );
    aLs240u=S.default.plot( [{'classes',{20}} base] );
    aku=S.default.plot( [{'classes',{21}} base]);
    
    a=S.default.plot( [{'classes',{71}} base]);
    u=S.default.plot( [{'classes',{41}} base]);
    
    s60=S.default.plot( [{'classes',{31}} base]);
    s150=S.default.plot( [{'classes',{32}} base]);
    s240=S.default.plot( [{'classes',{33}} base]);
    
    as60  = S.default.plot( [{'classes',{51}} base]);
    as150 = S.default.plot( [{'classes',{52}} base]);
    as240 = S.default.plot( [{'classes',{53}} base]);
    
    su60  = S.default.plot( [{'classes',{61}} base]);
    su150 = S.default.plot( [{'classes',{62}} base]);
    su240 = S.default.plot( [{'classes',{63}} base]);
    
    sources{i}={a s60 s150 s240 u};
    
    ApS60pU = a.avg + s60.avg * s_delay + u.avg * u60_delay;
    ApS150pU = a.avg + s150.avg * s_delay + u.avg * u150_delay;
    ApS240pU = a.avg + s240.avg * s_delay + u.avg * u240_delay;
    
    AS60pU  = as60.avg   + u.avg * u60_delay;
    AS150pU = as150.avg  + u.avg * u150_delay;
    AS240pU = as240.avg  + u.avg * u240_delay;
    
    ApS60U  = a.avg + su60.avg * s_delay;
    ApS150U  = a.avg + su150.avg * s_delay;
    ApS240U  = a.avg + su240.avg * s_delay;
    
    ApU60 = a.avg + u.avg * u60_delay;
    ApU150 = a.avg + u.avg * u150_delay;
    ApU240 = a.avg + u.avg * u240_delay;
    
    D60(i,:) = [norm(ApU60-as60u.avg) norm(ApS60pU-as60u.avg) norm(AS60pU-as60u.avg) norm(ApS60U-as60u.avg)].^2;
    C60(i,:) = [xcorr(ApU60,as60u.avg,0,'coeff') xcorr(ApS60pU,as60u.avg,0,'coeff') xcorr(AS60pU,as60u.avg,0,'coeff') xcorr(ApS60U,as60u.avg,0,'coeff')];
    D150(i,:) = [norm(ApU150-as150u.avg) norm(ApS150pU-as150u.avg) norm(AS150pU-as150u.avg) norm(ApS150U-as150u.avg)].^2;
    C150(i,:) = [xcorr(ApU150,as150u.avg,0,'coeff') xcorr(ApS150pU,as150u.avg,0,'coeff') xcorr(AS150pU,as150u.avg,0,'coeff') xcorr(ApS150U,as150u.avg,0,'coeff')];
    D240(i,:) = [norm(ApU240-as240u.avg) norm(ApS240pU-as240u.avg) norm(AS240pU-as240u.avg) norm(ApS240U-as240u.avg)].^2;
    C240(i,:) = [xcorr(ApU240,as240u.avg,0,'coeff') xcorr(ApS240pU,as240u.avg,0,'coeff') xcorr(AS240pU,as240u.avg,0,'coeff') xcorr(ApS240U,as240u.avg,0,'coeff')];
    
    ND60(i,:) = [norm(ApU60/norm(ApU60)-as60u.avg/norm(as60u.avg)) norm(ApS60pU/norm(ApS60pU)-as60u.avg/norm(as60u.avg)) norm(AS60pU/norm(AS60pU)-as60u.avg/norm(as60u.avg)) norm(ApS60U/norm(ApS60U)-as60u.avg/norm(as60u.avg))].^2;
    ND150(i,:) = [norm(ApU150/norm(ApU150)-as150u.avg/norm(as150u.avg)) norm(ApS150pU/norm(ApS150pU)-as150u.avg/norm(as150u.avg)) norm(AS150pU/norm(AS150pU)-as150u.avg/norm(as150u.avg)) norm(ApS150U/norm(ApS150U)-as150u.avg/norm(as150u.avg))].^2;
    ND240(i,:) = [norm(ApU240/norm(ApU240)-as240u.avg/norm(as240u.avg)) norm(ApS240pU/norm(ApS240pU)-as240u.avg/norm(as240u.avg)) norm(AS240pU/norm(AS240pU)-as240u.avg/norm(as240u.avg)) norm(ApS240U/norm(ApS240U)-as240u.avg/norm(as240u.avg))].^2;
    
    
    for channidx=1:numel(included_chan)
        d60  = as60u.full.avg(channidx,:)';       
        d90  = as90u.full.avg(channidx,:)';
        d120 = as120u.full.avg(channidx,:)';
        d150 = as150u.full.avg(channidx,:)';
        d180 = as180u.full.avg(channidx,:)';
        d210 = as210u.full.avg(channidx,:)';
        d240 = as240u.full.avg(channidx,:)';
        d240M=as240Mu.full.avg(channidx,:)';
        d240L=as240Lu.full.avg(channidx,:)';
        dL240=aLs240u.full.avg(channidx,:)';
        dk=aku.full.avg(channidx,:)';
        
        v60  = as60u.full.var(channidx,:);
        v90  = as90u.full.var(channidx,:);
        v120 = as120u.full.var(channidx,:);
        v150 = as150u.full.var(channidx,:);
        v180 = as180u.full.var(channidx,:);
        v210 = as210u.full.var(channidx,:);
        v240 = as240u.full.var(channidx,:);
        v240M=as240Mu.full.var(channidx,:);
        v240L=as240Lu.full.var(channidx,:);
        vL240=aLs240u.full.var(channidx,:);
        vk=aku.full.var(channidx,:);
        
        k60  = as60u.full.kurt;
        k90  = as90u.full.kurt;
        k120 = as120u.full.kurt;
        k150 = as150u.full.kurt;
        k180 = as180u.full.kurt;
        k210 = as210u.full.kurt;
        k240 = as240u.full.kurt;
        k240M=as240Mu.full.kurt;
        k240L=as240Lu.full.kurt;
        kL240=aLs240u.full.kurt;
        kk=aku.full.kurt;
        %%%%%% construct regressors START %%%%%
        C60apspu  = [a.full.avg(channidx,:)' (s60.full.avg(channidx,:)*s_delay)' (u.full.avg(channidx,:)*u60_delay)'];
        C150apspu = [a.full.avg(channidx,:)' (s150.full.avg(channidx,:)*s_delay)' (u.full.avg(channidx,:)*u150_delay)'];
        C240apspu = [a.full.avg(channidx,:)' (s240.full.avg(channidx,:)*s_delay)' (u.full.avg(channidx,:)*u240_delay)'];
        
        C60aspu  = [as60.full.avg(channidx,:)'  (u.full.avg(channidx,:)*u60_delay)'];
        C150aspu = [as150.full.avg(channidx,:)' (u.full.avg(channidx,:)*u150_delay)'];
        C240aspu = [as240.full.avg(channidx,:)' (u.full.avg(channidx,:)*u240_delay)'];
        
        C60apsu  = [a.full.avg(channidx,:)'  (su60.full.avg(channidx,:) * s_delay)'];
        C150apsu = [a.full.avg(channidx,:)' (su150.full.avg(channidx,:) * s_delay)'];
        C240apsu = [a.full.avg(channidx,:)' (su240.full.avg(channidx,:) * s_delay)'];
        
        C60apu  = [a.full.avg(channidx,:)'  (u.full.avg(channidx,:) * u60_delay)'];
        C150apu = [a.full.avg(channidx,:)' (u.full.avg(channidx,:) * u150_delay)'];
        C240apu = [a.full.avg(channidx,:)' (u.full.avg(channidx,:) * u240_delay)'];
        
        CL240apspu= [a.full.avg(channidx,:)' (s240.full.avg(channidx,:)*s_L_delay)' (u.full.avg(channidx,:)*u240_L_delay)'];
        CL240aspu= [as240.full.avg(channidx,:)' (u.full.avg(channidx,:)*u240_L_delay)'];%%dummy, nuisance, dont use!
        CL240apsu= [a.full.avg(channidx,:)' (su240.full.avg(channidx,:)*s_L_delay)'];
        CL240apu= [a.full.avg(channidx,:)' (u.full.avg(channidx,:)*u240_L_delay)'];
        %%%%%% construct regressors END %%%%%
        
        %% calculate parameters using nonnegative least squares START %%%%%
        x60apspu  = lsqnonneg(C60apspu,d60);
        x150apspu = lsqnonneg(C150apspu,d150);
        x240apspu = lsqnonneg(C240apspu,d240);
        x240Mapspu = lsqnonneg(C240apspu,d240M);
        x240Lapspu = lsqnonneg(C240apspu,d240L);
        xL240apspu = lsqnonneg(CL240apspu,dL240);
        xkapspu = lsqnonneg(C240apspu,dk);
        
        x60aspu  = lsqnonneg(C60aspu,d60);
        x150aspu = lsqnonneg(C150aspu,d150);
        x240aspu = lsqnonneg(C240aspu,d240);
        x240Maspu = lsqnonneg(C240aspu,d240M);
        x240Laspu = lsqnonneg(C240aspu,d240L);
        xL240aspu = lsqnonneg(CL240aspu,dL240);
        xkaspu = lsqnonneg(C240aspu,dk);
        
        x60apsu  = lsqnonneg(C60apsu,d60);
        x150apsu = lsqnonneg(C150apsu,d150);
        x240apsu = lsqnonneg(C240apsu,d240);
        x240Mapsu = lsqnonneg(C240apsu,d240M);
        x240Lapsu = lsqnonneg(C240apsu,d240L);
        xL240apsu = lsqnonneg(CL240apsu,dL240);
        xkapsu = lsqnonneg(C240apsu,dk);
        
        x60apu  = lsqnonneg(C60apu,d60);
        x150apu = lsqnonneg(C150apu,d150);
        x240apu = lsqnonneg(C240apu,d240);
        x240Mapu = lsqnonneg(C240apu,d240M);
        x240Lapu = lsqnonneg(C240apu,d240L);
        xL240apu = lsqnonneg(CL240apu,dL240);
        xkapu = lsqnonneg(C240apu,dk);
        
        X{i}{channidx}={x60apu x150apu x240apu x240Mapu x240Lapu xL240apu xkapu...
            x60apspu x150apspu x240apspu x240Mapspu x240Lapspu xL240apspu xkapspu...
            x60aspu x150aspu x240aspu x240Maspu x240Laspu xL240aspu xkaspu...
            x60apsu x150apsu x240apsu x240Mapsu x240Lapsu xL240apsu xkapsu...
            };
        
        %% get estimated ERP START %%%%%%
        E60apspu  = (C60apspu*x60apspu);
        E150apspu = (C150apspu*x150apspu);
        E240apspu = (C240apspu*x240apspu);
        E240Mapspu = (C240apspu*x240Mapspu);
        E240Lapspu = (C240apspu*x240Lapspu);
        EL240apspu = (C240apspu*xL240apspu);
        Ekapspu = (C240apspu*xkapspu);
        
        E60aspu  = (C60aspu*x60aspu);
        E150aspu = (C150aspu*x150aspu);
        E240aspu = (C240aspu*x240aspu);
        E240Maspu = (C240aspu*x240Maspu);
        E240Laspu = (C240aspu*x240Laspu);
        EL240aspu = (C240aspu*xL240aspu);
        Ekaspu = (C240aspu*xkaspu);
        
        E60apsu  = (C60apsu*x60apsu);
        E150apsu = (C150apsu*x150apsu);
        E240apsu = (C240apsu*x240apsu);
        E240Mapsu = (C240apsu*x240Mapsu);
        E240Lapsu = (C240apsu*x240Lapsu);
        EL240apsu = (C240apsu*xL240apsu);
        Ekapsu = (C240apsu*xkapsu);
        
        E60apu  = (C60apu*x60apu);
        E150apu = (C150apu*x150apu);
        E240apu = (C240apu*x240apu);
        E240Mapu = (C240apu*x240Mapu);
        E240Lapu = (C240apu*x240Lapu);
        EL240apu = (C240apu*xL240apu);
        Ekapu = (C240apu*xkapu);
        
        E{i}{channidx}={E60apu E150apu E240apu E240Mapu E240Lapu EL240apu Ekapu...
            E60apspu E150apspu E240apspu E240Mapspu E240Lapspu EL240apspu Ekapspu...
            E60aspu E150aspu E240aspu E240Maspu E240Laspu EL240aspu Ekaspu...
            E60apsu E150apsu E240apsu E240Mapsu E240Lapsu EL240apsu Ekapsu};
        D{i}{channidx}={d60 d90 d120 d150 d180 d210 d240 d240M d240L dL240 dk};
        V{i}{channidx}={v60 v90 v120 v150 v180 v210 v240 v240M v240L vL240 vk};
        K{i}={k60 k90 k120 k150 k180 k210 k240 k240M k240L kL240 kk};
        
        LSD60(i,channidx,:) = [norm(E60apu-d60) norm(E60apspu-d60) norm(E60aspu-d60) norm(E60apsu-d60)];
        LSD150(i,channidx,:) = [norm(E150apu-d150) norm(E150apspu-d150) norm(E150aspu-d150) norm(E150apsu-d150)];
        LSD240(i,channidx,:) = [norm(E240apu-d240) norm(E240apspu-d240) norm(E240aspu-d240) norm(E240apsu-d240)];
        LSD240M(i,channidx,:) = [norm(E240Mapu-d240) norm(E240Mapspu-d240) norm(E240Maspu-d240) norm(E240Mapsu-d240)];
        LSD240L(i,channidx,:) = [norm(E240Lapu-d240) norm(E240Lapspu-d240) norm(E240Laspu-d240) norm(E240Lapsu-d240)];
        LSDL240(i,channidx,:) = [norm(EL240apu-d240) norm(EL240apspu-d240) norm(EL240aspu-d240) norm(EL240apsu-d240)];
        LSDk(i,channidx,:) = [norm(Ekapu-d240) norm(Ekapspu-d240) norm(Ekaspu-d240) norm(Ekapsu-d240)];
        
    end
    %% get estimated ERP END %%%%%%
    
    %% calculate parameters using nonnegative least squares END %%%%%
    
    % NMF START
%     clusters=3;
%     [A60,Y60,numIter,tElapsed,finalResidual]=sparseseminmfnnls(as60u.full.avg(:,1:307)',clusters,[]);
%     [A90,Y90,numIter,tElapsed,finalResidual]=sparseseminmfnnls(as90u.full.avg(:,1:307)',clusters,[]);
%     [A120,Y120,numIter,tElapsed,finalResidual]=sparseseminmfnnls(as120u.full.avg(:,1:307)',clusters,[]);
%     [A150,Y150,numIter,tElapsed,finalResidual]=sparseseminmfnnls(as150u.full.avg(:,1:307)',clusters,[]);
%     [A180,Y180,numIter,tElapsed,finalResidual]=sparseseminmfnnls(as180u.full.avg(:,1:307)',clusters,[]);
%     [A210,Y210,numIter,tElapsed,finalResidual]=sparseseminmfnnls(as210u.full.avg(:,1:307)',clusters,[]);
%     [A240,Y240,numIter,tElapsed,finalResidual]=sparseseminmfnnls(as240u.full.avg(:,1:307)',clusters,[]);
%     A{i}={A60 A90 A120 A150 A180 A210 A240};
%     Y{i}={Y60 Y90 Y120 Y150 Y180 Y210 Y240};
    % NMF END
    
    
    
    %% BEAMFORMING START
    %     Xb=as150u.full.avg;
    %     Xb=Xb(1:4:end,:);Xb=repop(Xb,'-',mean(Xb,2));
    %
    %     C=Xb*Xb';
    %     ha=Xb(:,1:40)*a.avg(1:40)';%ha=ha/norm(ha);
    %    % ha=std(a.full.avg,0,2);
    %     hs=Xb(:,8:47)*s150.avg(1:40)';%hs=hs/norm(hs);
    %     hu=Xb(:,27:66)*u.avg(1:40)';%hu=hu/norm(hu);
    %     wa=inv(ha'*inv(C)*ha)*ha'*inv(C);
    %     ws=inv(hs'*inv(C)*hs)*hs'*inv(C);
    %     wu=inv(hu'*inv(C)*hu)*hu'*inv(C);
    %     B{i}={wa*Xb ws*Xb wu*Xb};
    %% BEAMFORMING END
    
    
    %    figure,hold on,plot(E{i}{1},'r'),plot(E{i}{4},'g'),plot(E{i}{7},'b'),plot(E{i}{10},'m'),plot(D{i}{1},'k','LineWidth',2),title([members{i} ' 60'])
    %    figure,hold on,plot(E{i}{2},'r'),plot(E{i}{5},'g'),plot(E{i}{8},'b'),plot(E{i}{11},'m'),plot(D{i}{2},'k','LineWidth',2),title([members{i} ' 150'])
    %    figure,hold on,plot(E{i}{3},'r'),plot(E{i}{6},'g'),plot(E{i}{9},'b'),plot(E{i}{12},'m'),plot(D{i}{3},'k','LineWidth',2),title([members{i} ' 240'])
   
    %% LSFIT start
%    lx=as60u.full.avg; 
%    R{i}{1}=norm( ((lx*lx'+10*eye(size(lx,1)))*lx*(s60.avg*s_delay)')'*lx-s60.avg*s_delay);
%    lx=as150u.full.avg;
%    R{i}{2}=norm( ((lx*lx'+10*eye(size(lx,1)))*lx*(s150.avg*s_delay)')'*lx-s150.avg*s_delay);
%    lx=as240u.full.avg;
%    R{i}{3}=norm( ((lx*lx'+10*eye(size(lx,1)))*lx*(s240.avg*s_delay)')'*lx-s240.avg*s_delay);   
%    %% LSFIT end
   
   
end

hypotablechann
