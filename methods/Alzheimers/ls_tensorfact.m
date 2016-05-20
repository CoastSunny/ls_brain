if isunix==0
    data_folder='D:\Raw\AlzheimerEEG\Multivariate AFAVA artefact free';
    save_folder='D:\Extracted\Alzheimer\Multivariate AFAVA artefact free\AFAVA_1sectrials\';
else
    data_folder='/home/engbiome/AlzheimerEEG/Multivariate AFAVA artefact free/';
    save_folder='/home/lspyrou/Documents/results/AFAVA_1sectrials/';
end

%%

for q = 1:length(DirCon)
      
    Y=Conn{q};
    Options=1;
    [Fp{q},Ip(q),Ep(q),Concp(q)]=parafac(Y,4,Options,[6 3 0]);
    [Ft{q},Gt{q}]=tucker(Y,[4 4 -1],Options,[1 4 -1]);
    
    
end



