
train_f=train_fG;
test_f=test_fG;
train_l=train_lG;

c_labels=[1 -1 1 -1 1 1 1 1 1 -1 1 -1];
cut_off=0.3:0.05:1;

for sub=1:10
    
    ftrain74=train_f{:,sub,1};
    Mftrain74s=mean(ftrain74(train_l{:,sub,1}==1));    
    Mftrain74d=-mean(ftrain74(train_l{:,sub,1}==-1));
    ftrain8=train_f{:,sub,2};
    Mftrain8s=mean(ftrain8(train_l{:,sub,2}==1));    
    Mftrain8d=-mean(ftrain8(train_l{:,sub,2}==-1));
    CalCut=1./(1+exp(-[Mftrain8s Mftrain74d Mftrain74s Mftrain8d Mftrain8s Mftrain74s ...
        Mftrain74s Mftrain8s Mftrain8s Mftrain74d Mftrain74s Mftrain8d]));
    
    for cl=1:12
        
        f=c_labels(cl)*test_f{:,sub,cl};
        fb=1./(1+exp(-f));
        
        AvFb(sub,cl) = mean(fb)';
        CalibratedRatio(sub,cl) = sum(fb>CalCut(cl))/numel(fb);
        for i=1:numel(cut_off)
            
            RewardRatio(i,sub,cl) = sum(fb>cut_off(i))/numel(fb);
            
        end
        
    end
    
end   

for i=1:12
   
    figure,imagesc(1:10,0.3:0.1:1,RewardRatio(:,:,i))
    title(['classifier' num2str(i)]);
    colorbar
end

figmerge([1 2 3 4 5 6 7 8 9 10 11 12]);