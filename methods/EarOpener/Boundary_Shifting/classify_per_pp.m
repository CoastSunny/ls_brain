
run('EO_boundary');

% 
subjects = { 'Daphne' 'Julia' 'Sucty' 'Leora' 'Loek' 'Dominiek' 'Chris' 'Sacha' 'Renout' 'Roel'};
n = numel(subjects);
% p = cell(1,n);
% for i=1:n
%     load(['~/Data/Extracted/bound_shift/' subjects{i}]);
%     p{i} = SUB.default.copy;
%     clear SUB;
% end

%settings
Allchannels = [1:64];
channelsgood = Allchannels;
close all;
time = [1:64];
t = time/128;

root = '~/BCI_code';
addpath(exGenPath(fullfile(root,'external_toolboxes','Psychtoolbox')));
addpath(exGenPath(fullfile(root,'external_toolboxes','eeglab')));
addpath(fullfile(root,'external_toolboxes','Psychtoolbox','PsychBasic','MatlabWindowsFilesR2007a'));
%endof settings

%**************************************************************************
%
%                   train classifier per subject
%
%**************************************************************************

validation_rates = zeros(n,6);
for sub=1:n        
    
    blocks_8_74 = [1:3 7:9];
    blocks_8_41 = [1:6];
    blocks_41_74 = [4:9];
    
    sprintf('pp %d', sub);
    
    out = p{sub}.train_classifier('classes',{dev_74msVOT; sb_d2_74msVOT},'blocks_in',blocks_8_74,'name','74in8-74','channels',channelsgood, 'time', time, 'vis', 'on', 'freqband' , [1 20]);
    validation_ratesI(sub,1) = out.rate;
    train_fI{:,sub,1} = out.f;
    train_lI{:,sub,1} = out.labels;
    
    out = p{sub}.train_classifier('classes',{dev_8msVOT; sb_d2_8msVOT},'blocks_in',blocks_8_74,'name','8in8-74','channels',channelsgood, 'time', time, 'vis', 'on', 'freqband' , [1 20]);
    validation_ratesI(sub,2) = out.rate;
    train_fI{:,sub,2} = out.f;
    train_lI{:,sub,2} = out.labels;
    
    out = p{sub}.train_classifier('classes',{dev_41msVOT; sb_d1_41msVOT},'blocks_in',blocks_8_41,'name','41in8-41','channels',channelsgood, 'time', time, 'vis', 'off', 'freqband' , [1 20]);
    validation_ratesI(sub,3) = out.rate;
    train_fI{:,sub,3} = out.f;
    train_lI{:,sub,3} = out.labels;
    
    out = p{sub}.train_classifier('classes',{dev_8msVOT; sb_d1_8msVOT},'blocks_in',blocks_8_41,'name','8in8-41','channels',channelsgood, 'time', time, 'vis', 'off', 'freqband' , [1 20]);
    validation_ratesI(sub,4) = out.rate;
    train_fI{:,sub,4} = out.f;
    train_lI{:,sub,4} = out.labels;
    
    out = p{sub}.train_classifier('classes',{dev_74msVOT; sb_d2_74msVOT},'blocks_in',blocks_41_74,'name','74in41-74','channels',channelsgood, 'time', time, 'vis', 'off', 'freqband' , [1 20]);
    validation_ratesI(sub,5) = out.rate;
    train_fI{:,sub,5} = out.f;
    train_lI{:,sub,5} = out.labels;
    
    out = p{sub}.train_classifier('classes',{dev_41msVOT; sb_d2_41msVOT},'blocks_in',blocks_41_74,'name','41in41-74','channels',channelsgood, 'time', time, 'vis', 'off', 'freqband' , [1 20]);
    validation_ratesI(sub,6) = out.rate;
    train_fI{:,sub,6} = out.f;
    train_lI{:,sub,6} = out.labels;
    
    %     for k=1:8
    %         if (mod(k,2))
    %             figure(k);
    %             plot(t,   0, 'col', [0 0 0]); hold on;
    %             plot(t,-0.1, 'col', [0 0 0]); hold on;
    %             plot(t,-0.2, 'col', [0 0 0]); hold on;
    %             plot([0.15 0.15], [-10 10], 'col', [0 0 0], 'LineStyle', ':'); hold on;
    %             plot([0.25 0.25], [-10 10], 'col', [0 0 0], 'LineStyle', ':'); hold on;
    %             plot([0.35 0.35], [-10 10], 'col', [0 0 0], 'LineStyle', ':'); hold on;
    %             set(gca, 'xlim', [0 0.5]);
    %             set(gca, 'ylim', [-0.5 0.5]);
    %         end
    %     end
    %     figmerge([1:8], [2 4]);
    %     print(9, sprintf(['..\\results\\experiment\\classification\\train_classif_sub_%d'], sub), '-dpng');
    %     close all;
end

%apply clssifier



%**************************************************************************
%
% Classification rates
%
%**************************************************************************


for sub=1:n
    
    blocks_8_74 = [1:3 7:9];
    blocks_8_41 = [1:6];
    blocks_41_74 = [4:9];
    
    
    out = p{sub}.apply_classifier(p{sub},'classes',{sb_d1_8msVOT}, 'blocks_in', blocks_8_41, 'name', '8in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [1]);
    classification_ratesI(sub,1) = out.rate;
    test_fI{:,sub,1} = out.f;
    
    out = p{sub}.apply_classifier(p{sub},'classes',{dev_41msVOT}, 'blocks_in', blocks_8_41, 'name', '74in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [-1]);
    classification_ratesI(sub,2) = out.rate;
    test_fI{:,sub,2} = out.f;
    
    out = p{sub}.apply_classifier(p{sub},'classes',{sb_d1_41msVOT}, 'blocks_in', blocks_8_41, 'name', '74in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [1]);
    classification_ratesI(sub,3) = out.rate;
    test_fI{:,sub,3} = out.f;
    
    out = p{sub}.apply_classifier(p{sub},'classes',{dev_8msVOT}, 'blocks_in', blocks_8_41, 'name', '8in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [-1]);
    classification_ratesI(sub,4) = out.rate;
    test_fI{:,sub,4} = out.f;
    
    out = p{sub}.apply_classifier(p{sub},'classes',{sb_d2_41msVOT}, 'blocks_in', blocks_41_74, 'name', '8in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [1]);
    classification_ratesI(sub,5) = out.rate;
    test_fI{:,sub,5} = out.f;
    
    out = p{sub}.apply_classifier(p{sub},'classes',{dev_74msVOT}, 'blocks_in', blocks_41_74, 'name', '74in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [1]);
    classification_ratesI(sub,6) = out.rate;
    test_fI{:,sub,6} = out.f;
    
    out = p{sub}.apply_classifier(p{sub},'classes',{sb_d1_74msVOT}, 'blocks_in', blocks_41_74, 'name', '74in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [1]);
    classification_ratesI(sub,7) = out.rate;
    test_fI{:,sub,7} = out.f;
    
    out = p{sub}.apply_classifier(p{sub},'classes',{dev_41msVOT}, 'blocks_in', blocks_41_74, 'name', '8in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [1]);
    classification_ratesI(sub,8) = out.rate; 
    test_fI{:,sub,8} = out.f;
    
    out = p{sub}.apply_classifier(p{sub},'classes',{sb_d2_8msVOT}, 'blocks_in', blocks_8_74, 'name', '8in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [1]);
    classification_ratesI(sub,9) = out.rate;
    test_fI{:,sub,9} = out.f;
    
    out = p{sub}.apply_classifier(p{sub},'classes',{dev_74msVOT}, 'blocks_in', blocks_8_74, 'name', '74in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [-1]);
    classification_ratesI(sub,10) = out.rate;
    test_fI{:,sub,10} = out.f;
    
    out = p{sub}.apply_classifier(p{sub},'classes',{sb_d2_74msVOT}, 'blocks_in', blocks_8_74, 'name', '74in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [1]);
    classification_ratesI(sub,11) = out.rate;
    test_fI{:,sub,11} = out.f;
    
    out = p{sub}.apply_classifier(p{sub},'classes',{dev_8msVOT}, 'blocks_in', blocks_8_74, 'name', '8in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [-1]);
    classification_ratesI(sub,12) = out.rate;
    test_fI{:,sub,12} = out.f;
end
