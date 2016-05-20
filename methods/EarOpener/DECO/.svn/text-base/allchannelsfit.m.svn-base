t=(1:77)/128;
s_delay=diag( ones( 1 , 77 - 8 ) , 8 );
u60_delay=diag( ones( 1 , 77 - 16 ) , 16 );
u150_delay=diag( ones( 1 , 77 - 27 ) , 27 );
u240_delay=diag( ones( 1 , 77 - 39 ) , 39 );
ax=[0 0.7 -6 6];
time=1:77;
subjects={ 'JP04' 'JP05' 'JP01' 'JP07' 'JP03' 'NJP01' 'NJP04' 'NJP06' 'NJP05' 'NJP02' 'NJP03' };

G=Group;
for i=1:numel(subjects)
    
    G.addprop(subjects{i});
    try G.(subjects{i})=DJP.(subjects{i}).copy;
    catch err
        G.(subjects{i})=DNJP.(subjects{i}).copy;
    end
    
end
members=sort(properties(G));
base={'blocks_in',1:200,'channels',1:32,'vis','off','time',time,'badrem','yes'};
clear X E D LSD60 LSD150 LSD240 A Y B

for i=1:numel(members)
    
    as60u=G.(members{i}).default.plot(  [{'classes',{11}} base] );
    as90u=G.(members{i}).default.plot(  [{'classes',{12}} base] );
    as120u=G.(members{i}).default.plot( [{'classes',{13}} base] );
    as150u=G.(members{i}).default.plot( [{'classes',{14}} base] );
    as180u=G.(members{i}).default.plot( [{'classes',{15}} base] );
    as210u=G.(members{i}).default.plot( [{'classes',{16}} base] );
    as240u=G.(members{i}).default.plot( [{'classes',{17}} base] );
    
    a=G.(members{i}).default.plot( [{'classes',{21}} base]);
    u=G.(members{i}).default.plot( [{'classes',{41}} base]);
    
    s60=G.(members{i}).default.plot( [{'classes',{31}} base]);
    s150=G.(members{i}).default.plot( [{'classes',{32}} base]);
    s240=G.(members{i}).default.plot( [{'classes',{33}} base]);
    
    as60  = G.(members{i}).default.plot( [{'classes',{51}} base]);
    as150 = G.(members{i}).default.plot( [{'classes',{52}} base]);
    as240 = G.(members{i}).default.plot( [{'classes',{53}} base]);
    
    su60  = G.(members{i}).default.plot( [{'classes',{61}} base]);
    su150 = G.(members{i}).default.plot( [{'classes',{62}} base]);
    su240 = G.(members{i}).default.plot( [{'classes',{63}} base]);
    
    sources{i}={a s60 s150 s240 u};
    
    d60  = as60u.full.avg';
    d90  = as90u.full.avg';
    d120 = as120u.full.avg';
    d150 = as150u.full.avg';
    d180 = as180u.full.avg';
    d210 = as210u.full.avg';
    d240 = as240u.full.avg';
    
    %%%%%% construct regressors START %%%%%
    for ch=1:32
        C60apspu{ch}  = [a.full.avg(ch,time)' (s60.full.avg(ch,time)*s_delay)' (u.full.avg(ch,time)*u60_delay)'];
        C150apspu{ch} = [a.full.avg(ch,time)' (s150.full.avg(ch,time)*s_delay)' (u.full.avg(ch,time)*u150_delay)'];
        C240apspu{ch} = [a.full.avg(ch,time)' (s240.full.avg(ch,time)*s_delay)' (u.full.avg(ch,time)*u240_delay)'];
        
        C60aspu{ch}  = [as60.full.avg(ch,time)'  (u.full.avg(ch,time)*u60_delay)'];
        C150aspu{ch} = [as150.full.avg(ch,time)' (u.full.avg(ch,time)*u150_delay)'];
        C240aspu{ch} = [as240.full.avg(ch,time)' (u.full.avg(ch,time)*u240_delay)'];
        
        C60apsu{ch}  = [a.full.avg(ch,time)'  (su60.full.avg(ch,time) * s_delay)'];
        C150apsu{ch} = [a.full.avg(ch,time)' (su150.full.avg(ch,time) * s_delay)'];
        C240apsu{ch} = [a.full.avg(ch,time)' (su240.full.avg(ch,time) * s_delay)'];
        
        C60apu{ch}  = [a.full.avg(ch,time)'  (u.full.avg(ch,time) * u60_delay)'];
        C150apu{ch} = [a.full.avg(ch,time)' (u.full.avg(ch,time) * u150_delay)'];
        C240apu{ch} = [a.full.avg(ch,time)' (u.full.avg(ch,time) * u240_delay)'];
    end
    %%%%%% construct regressors END %%%%%
    
    %% calculate parameters using nonnegative least squares START %%%%%
    for ch=1:32
        x60apspu{ch}  = lsqnonneg(C60apspu{ch},d60(time,ch));
        x150apspu{ch} = lsqnonneg(C150apspu{ch},d150(time,ch));
        x240apspu{ch} = lsqnonneg(C240apspu{ch},d240(time,ch));
        
        x60aspu{ch}  = lsqnonneg(C60aspu{ch},d60(time,ch));
        x150aspu{ch} = lsqnonneg(C150aspu{ch},d150(time,ch));
        x240aspu{ch} = lsqnonneg(C240aspu{ch},d240(time,ch));
        
        x60apsu{ch}  = lsqnonneg(C60apsu{ch},d60(time,ch));
        x150apsu{ch} = lsqnonneg(C150apsu{ch},d150(time,ch));
        x240apsu{ch} = lsqnonneg(C240apsu{ch},d240(time,ch));
        
        x60apu{ch}  = lsqnonneg(C60apu{ch},d60(time,ch));
        x150apu{ch} = lsqnonneg(C150apu{ch},d150(time,ch));
        x240apu{ch} = lsqnonneg(C240apu{ch},d240(time,ch));
        X{ch}{i}={x60apu{ch} x150apu{ch} x240apu{ch} x60apspu{ch} x150apspu{ch} x240apspu{ch} x60aspu{ch} x150aspu{ch} x240aspu{ch} x60apsu{ch} x150apsu{ch} x240apsu{ch} };
    end
    
    %% get estimated ERP START %%%%%%
    for ch=1:32
        E60apspu{ch}  = (C60apspu{ch}*x60apspu{ch});
        E150apspu{ch} = (C150apspu{ch}*x150apspu{ch});
        E240apspu{ch} = (C240apspu{ch}*x240apspu{ch});
        
        E60aspu{ch}  = (C60aspu{ch}*x60aspu{ch});
        E150aspu{ch} = (C150aspu{ch}*x150aspu{ch});
        E240aspu{ch} = (C240aspu{ch}*x240aspu{ch});
        
        E60apsu{ch}  = (C60apsu{ch}*x60apsu{ch});
        E150apsu{ch} = (C150apsu{ch}*x150apsu{ch});
        E240apsu{ch} = (C240apsu{ch}*x240apsu{ch});
        
        E60apu{ch}  = (C60apu{ch}*x60apu{ch});
        E150apu{ch} = (C150apu{ch}*x150apu{ch});
        E240apu{ch} = (C240apu{ch}*x240apu{ch});
        E{ch}{i}={E60apu{ch} E150apu{ch} E240apu{ch} E60apspu{ch} E150apspu{ch} E240apspu{ch}...
            E60aspu{ch} E150aspu{ch} E240aspu{ch} E60apsu{ch} E150apsu{ch} E240apsu{ch} };
        D{ch}{i}={d60(time,ch) d90(time,ch) d120(time,ch) d150(time,ch) d180(time,ch) d210(time,ch) d240(time,ch)};
    end
    %% get estimated ERP END %%%%%%
    
    %% calculate parameters using nonnegative least squares END %%%%%
    
end