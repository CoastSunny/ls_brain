cd([home '/Dropbox/Alzheimer/results/Descriptive/INECO/TENSOR'])
save=0;
delta=[1];
theta=[2 3];
alpha=[4 5 6];
beta1=[7:10];
beta2=[11:15];
periods=5;
close all
g1={'PATIENTS' 'CONTROLS'};g2={'SHAPE' 'BINDING'};g3={'ENCOD' 'TEST'};

bands(1).x=delta;bands(2).x=theta;bands(3).x=alpha;bands(4).x=beta1;bands(5).x=beta2;
bands(1).y='delta';bands(2).y='theta';bands(3).y='alpha';bands(4).y='beta1';bands(5).y='beta2';
metrics=[];

temp=conn_full{1,1};
ch=temp.label;
parameter='wpli_debiasedspctrm';

fidx_patients=find(gc_idx(:,1)==1);
fidx_controls=find(gc_idx(:,1)==0);
comps=2;

for q=1:numel(Conn_full)
    
    Conn_mode=Fp{q,comps}{1};
    Freq_mode=Fp{q,comps}{2};
    Period_mode=Fp{q,comps}{3};
    
    for j=1:size(Conn_mode,2)
        
        tmp=abs(v2G(Conn_mode(:,j)));
        tmp=weight_conversion(tmp,'normalize');
        tmp=CST(tmp);
        
        metrics(q,j,:)=[transitivity_bu(tmp) ...
            mean(clustering_coef_bu(tmp)) ...
            mean(degrees_und(tmp)) ...
            density_und(tmp) ...
            efficiency_bin(tmp) ];
        
    end
    
end

fPmetrics=metrics(fidx_patients,:,:);
fCmetrics=metrics(fidx_controls,:,:);
clear metrics

for q=1:numel(Conn_full)
    
    for period=1:periods
        Conn_mode=Fp{q,comps}{1};
        Freq_mode=Fp{q,comps}{2};
        Period_mode=Fp{q,comps}{3};
        Net=0;
        for comp=1:size(Conn_mode,2)
            Net=Net+Conn_mode(:,comp)*Period_mode(period,comp);
        end
        
        
        
            tmp=abs(v2G(Net));
            tmp=weight_conversion(tmp,'normalize');
            tmp=CST(tmp);
            
            metrics(q,period,:)=[transitivity_bu(tmp) ...
                mean(clustering_coef_bu(tmp)) ...
                mean(degrees_und(tmp)) ...
                density_und(tmp) ...
                efficiency_bin(tmp) ];
            
        
    end
    
end

tPmetrics=metrics(fidx_patients,:,:);
tCmetrics=metrics(fidx_controls,:,:);
clear metrics


for q=1:numel(Conn_full)
    
    for period=1:periods
        Conn_mode=Fp{q,comps}{1};
        Freq_mode=Fp{q,comps}{2};
        Period_mode=Fp{q,comps}{3};
        Net=0;
        for comp=1:size(Conn_mode,2)
            Net=Net+Conn_mode(:,comp)*Freq_mode(:,comp)'*Period_mode(period,comp);
        end
        
        for j=1:numel(bands)
        
            tmp=mean(Net(:,bands(j).x),2);
            tmp=abs(v2G(tmp));
            tmp=weight_conversion(tmp,'normalize');
            tmp=CST(tmp);
            
            metrics(q,period,j,:)=[transitivity_bu(tmp) ...
                mean(clustering_coef_bu(tmp)) ...
                mean(degrees_und(tmp)) ...
                density_und(tmp) ...
                efficiency_bin(tmp) ];
        end
            
        
    end
    
end

tfPmetrics=metrics(fidx_patients,:,:);
tfCmetrics=metrics(fidx_controls,:,:);

