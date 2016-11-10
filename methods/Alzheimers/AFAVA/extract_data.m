%% Create 4-dimensional matrix of samples x trials x channels x patients
if isunix==0
    data_folder='D:\Raw\AlzheimerEEG\Multivariate AFAVA artefact free';
    save_folder='D:\Extracted\Alzheimer\Multivariate AFAVA artefact free\AFAVA_1sectrials\';
else
    data_folder='/home/engbiome/AlzheimerEEG/Multivariate AFAVA artefact free';
    save_folder='/home/lspyrou/Documents/results/AFAVA_1sectrials/';
end

patients = dir(data_folder);
patients = patients(3:end);
% EEG=[];
nChannels = 16;
fs = 256;
%
for i = 1:length(patients)
    eval(['cd(''' data_folder '/' patients(i).name ''');'])
    channels = dir;
    channels = channels(3:end);
    for j = 1:length(channels)
        eval(['cd(''' data_folder '/' patients(i).name '/' channels(j).name ''');'])
        times = dir;
        times = times(3:end);
        for k = 1:length(times)
            temp = importdata(times(k).name)';
            for l = 1:5
                EEG{i}(j,:,5*(k-1)+l) = temp((l-1)*fs+1:l*fs);
            end
        end
    end
end
% Data information: 05 has just 1 trial, 07 has just 3 trials and 26 has just 2 trials

%% Create FieldTrip compatible variables and pre-process the data
for i = 1:length(EEG)
    data   = [];
    for x = 1:nChannels
        data.label{x,1} = channels(x).name;
    end
    for k = 1:size(EEG{i},3)
        data.fsample    = fs;
        data.trial{1,k} = EEG{i}(:,:,k);
        data.time{1,k}  = (0:(size(EEG{i},2)-1))/fs;       
    end
        cfg             = [];
        cfg.reref       = 'yes';
        cfg.refchannel  = 'all'; % average reference
        cfg.lpfilter    = 'no';
        cfg.lpfreq      = 40;
        cfg.preproc.demean='yes';
        cfg.preproc.detrend='yes';    
        data            = ft_preprocessing(cfg,data);
        
    eval(['save(''' save_folder 'preproctrials1sectrials' num2str(i) ''', ''data'');'])
end
clear all
