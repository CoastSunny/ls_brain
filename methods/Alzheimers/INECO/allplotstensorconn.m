ncomps=2;
count=1;
for ai=2:9
     
    d1=['/Documents/bb/data/Pair1SNR0' num2str(ai) 'Noise01Norm/EEG/dataset_'];
    d2=['/Documents/bb/data/Pair1SNR0' num2str(ai) 'Noise01Norm/truth/dataset_'];
    testbb
    Res2{count}={EV L A B};
    count=count+1;
    
end
ncomps=10;
count=1;
for ai=2:9
    
    d1=['/Documents/bb/data/Pair1SNR0' num2str(ai) 'Noise01Norm/EEG/dataset_'];
    d2=['/Documents/bb/data/Pair1SNR0' num2str(ai) 'Noise01Norm/truth/dataset_'];
    Res10{count}={EV L A B};
    testbb
    count=count+1;
    
end
ncomps=30;
count=1;
for ai=2:9
    
    d1=['/Documents/bb/data/Pair1SNR0' num2str(ai) 'Noise01Norm/EEG/dataset_'];
    d2=['/Documents/bb/data/Pair1SNR0' num2str(ai) 'Noise01Norm/truth/dataset_'];
    Res30{count}={EV L A B};
    testbb
    count=count+1;
    
end
ncomps=100;
count=1;
for ai=2:9
    
    d1=['/Documents/bb/data/Pair1SNR0' num2str(ai) 'Noise01Norm/EEG/dataset_'];
    d2=['/Documents/bb/data/Pair1SNR0' num2str(ai) 'Noise01Norm/truth/dataset_'];
    Res100{count}={EV L A B};
    testbb
    count=count+1;
    
end