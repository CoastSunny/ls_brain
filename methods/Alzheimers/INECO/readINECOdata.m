%% Create 4-dimensional matrix of samples x trials x channels x patients
if isunix==0
    data_folder='D:\Raw\AlzheimerEEG\Multivariate AFAVA artefact free';
    save_folder='D:\Extracted\Alzheimer\Multivariate AFAVA artefact free\AFAVA_1sectrials\';
else
    data_folder='/home/engbiome/INECO/SING CASES/MCI/';
    save_folder='/home/lspyrou/Documents/results/INECO/';
end

cd(data_folder)
subjects = rdir( '**/*.set' );

cfg             = [];
cfg.reref       = 'yes';
cfg.refchannel  = 'all'; % average reference
cfg.lpfilter    = 'no';
cfg.lpfreq      = 40;
cfg.preproc.demean='yes';
cfg.preproc.detrend='yes';

for i = 1:length(subjects)
    
    cd(data_folder)
    cfg.dataset=subjects(i).name;
    try
        data            = ft_preprocessing(cfg);
        old_data=data;        
        
        for j=1:numel(old_data.trial)
            for k=1:5
                data.trial{ 5 * ( j - 1 ) + k  } = ...
                    old_data.trial{j}( : , ( ( k - 1 ) * 57 + 1 ) : ( k - 1 ) * 57 + 128 );
                data.time{ 5 * ( j - 1 ) + k } = (0:127)/data.fsample;
            end
        end
        cd(save_folder)
        save([save_folder 'subject' num2str(i)], 'data','old_data')
    catch err
    end
end