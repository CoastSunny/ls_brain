
% %%% extract data %%%
% load bound_cfg
% load BOUND_NAMES
% load BOUND_PATHS
% BOUNDPILOT=Group('names',BOUND_NAMES,'subjects_paths',BOUND_PATHS,'cfg',cfg);
% save('BOUNDPILOT','BOUNDPILOT','-v7.3');%%%save%%%
% %%%%%%%%%%%%%%%%%%%%

%%%%example: plot%%%% (expdefs)
%%%group_name.subject_name.dataset_name.function_name(parameter names)%%%

%plot erp
BOUNDPILOT.boundpilot01.default.plot('classes',{166},'channels',{'Fz' 'Cz' 'Fpz'},'blocks_in',1:10);

%plot difference wave
BOUNDPILOT.boundpilot04.default.diff_wave('classes',{{156};{165}},'channels',{'Fz' 'Cz' 'Fpz'},'blocks_in',1:10);

%%%train classifier, name is for the classifier
BOUNDPILOT.boundpilot03.default.train_classifier('name','classifier_name','classes',{{156};{166}},'blocks_in',1:10)

%%%statistics function
BOUNDPILOT.boundpilot03.default.run_stats('');






