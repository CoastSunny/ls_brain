if isunix==0
    home='C:/Users/Loukianos';
    home_bci='D:\';
else
    home='~';
    home_bci='~';
end
if ~exist('sa')
    load([home '/Documents/bb/data/sa'])
end
if ~exist('inds_roi_outer_2K')
    load([home '/Documents/bb/data/miscdata'])
end

data=[];

for i=1:1000
    fprintf(num2str(i))
    d1='/Documents/bb/data/deepml_conn/EEG/dataset_';
    d2='/Documents/bb/data/deepml_conn/truth/dataset_';

    load([home d1 num2str(i) '/data']),
    load([home d2 num2str(i) '/truth']),
    
    
    fs=100;
    len=180;
    bandpass=[8 13];
 
    
    data(i).y=truth.interaction;
    data(i).SNR=truth.snr;       
%     data(i).fsample    = fs;
%     data(i).label      = sa.EEG_clab_electrodes;           
    data(i).X=EEG_data(:,1001:2000);
    
end