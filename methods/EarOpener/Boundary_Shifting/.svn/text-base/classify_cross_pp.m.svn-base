
run('EO_boundary');
data_path = '~/Data/Extracted/bound_shift/';

subjects = { 'Daphne' 'Julia' 'Sucty' 'Leora' 'Loek' 'Dominiek' 'Chris' 'Sacha' 'Renout' 'Roel'};
n = numel(subjects);

classification_rates_ctrl = zeros(n, 12);
classification_rates_exp = zeros(n, 12);

Allchannels = [1:64];
channelsgood = Allchannels;
close all;
time = [1:64];
t = time/128;

blocks_8_74 = [1:3 7:9];
blocks_8_41 = [1:6];
blocks_41_74 = [4:9];
g=Group;
for i=1:n
    propname = ['sub' num2str(i)];
    g.addprop(propname);
    load([data_path subjects{i}]);
    g.(propname) = SUB.copy;
    clear SUB;
end

for sub=1:n % leave one participant out
    % combine the rest into a group
    delete(findprop(g,'all'))
    g.combine_subjects('exclusion',['sub' num2str(sub)]);
    q = g.all.default.copy;
    
    %now load the paria
    load([data_path subjects{sub}]);
    su = SUB.default.copy;
    clear SUB;
    
    blocks_8_41_74 = [];
    blocks_41_8_74 = [];
    blocks_74_41_8 = [];
    for i=1:numel(q.block_idx)
        markers = q.markers(q.block_idx{i})';
        if (numel(find(markers == sb_d1_8msVOT{1}))>0)
            len = numel(blocks_8_41_74);
            blocks_8_41_74(len+1) = i;
        elseif (numel(find(markers == sb_d1_41msVOT{1}))>0)
            len = numel(blocks_41_8_74);
            blocks_41_8_74(len+1) = i;
        elseif (numel(find(markers == sb_d1_74msVOT{1}))>0)
            len = numel(blocks_74_41_8);
            blocks_74_41_8(len+1) = i;
        end
    end
    
    %settings
    
    
    q.train_classifier('classes',{d_74msVOT; sb_d2_74msVOT},'blocks_in',[blocks_8_41_74 blocks_74_41_8],'name','74in8-74','channels',channelsgood, 'time', time, 'vis', 'off', 'freqband' , [1 20]);
    validation_ratesG(sub,1) = out.rate;
    train_fG{:,sub,1} = out.f;
    train_lG{:,sub,1} = out.labels;
    %%save classifier clsfr=S.default.('74in8-74');
    
    q.train_classifier('classes',{d_8msVOT; sb_d2_8msVOT},'blocks_in',[blocks_8_41_74 blocks_74_41_8],'name','8in8-74','channels',channelsgood, 'time', time, 'vis', 'off', 'freqband' , [1 20]);
    validation_ratesG(sub,2) = out.rate;
    train_fG{:,sub,2} = out.f;
    train_lG{:,sub,2} = out.labels;
    %save classifier clsfr=S.default.('8in8-74');
    
    
    %let's classify the paria now
    
    out = q.apply_classifier(su,'classes',{sb_d1_8msVOT}, 'blocks_in', blocks_8_41, 'name', '8in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [1]);
    classification_ratesG(sub,1) = out.rate;
    test_fG{:,sub,1} = out.f;
    
    
    out = q.apply_classifier(su,'classes',{dev_41msVOT}, 'blocks_in', blocks_8_41, 'name', '74in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [-1]);
    classification_ratesG(sub,2) = out.rate;
    test_fG{:,sub,2} = out.f;
    
    out = q.apply_classifier(su,'classes',{sb_d1_41msVOT}, 'blocks_in', blocks_8_41, 'name', '74in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [1]);
    classification_ratesG(sub,3) = out.rate;
    test_fG{:,sub,3} = out.f;
    
    out = q.apply_classifier(su,'classes',{dev_8msVOT}, 'blocks_in', blocks_8_41, 'name', '8in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [-1]);
    classification_ratesG(sub,4) = out.rate;
    test_fG{:,sub,4} = out.f;
    
    out = q.apply_classifier(su,'classes',{sb_d2_41msVOT}, 'blocks_in', blocks_41_74, 'name', '8in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [1]);
    classification_ratesG(sub,5) = out.rate;
    test_fG{:,sub,5} = out.f;
    
    out = q.apply_classifier(su,'classes',{dev_74msVOT}, 'blocks_in', blocks_41_74, 'name', '74in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [1]);
    classification_ratesG(sub,6) = out.rate;
    test_fG{:,sub,6} = out.f;
    
    out = q.apply_classifier(su,'classes',{sb_d1_74msVOT}, 'blocks_in', blocks_41_74, 'name', '74in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [1]);
    classification_ratesG(sub,7) = out.rate;
    test_fG{:,sub,7} = out.f;
    
    out = q.apply_classifier(su,'classes',{dev_41msVOT}, 'blocks_in', blocks_41_74, 'name', '8in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [1]);
    classification_ratesG(sub,8) = out.rate;
    test_fG{:,sub,8} = out.f;
    
    out = q.apply_classifier(su,'classes',{sb_d2_8msVOT}, 'blocks_in', blocks_8_74, 'name', '8in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [1]);
    classification_ratesG(sub,9) = out.rate;
    test_fG{:,sub,9} = out.f;
    
    out = q.apply_classifier(su,'classes',{dev_74msVOT}, 'blocks_in', blocks_8_74, 'name', '74in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [-1]);
    classification_ratesG(sub,10) = out.rate;
    test_fG{:,sub,10} = out.f;
    
    out = q.apply_classifier(su,'classes',{sb_d2_74msVOT}, 'blocks_in', blocks_8_74, 'name', '74in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [1]);
    classification_ratesG(sub,11) = out.rate;
    test_fG{:,sub,11} = out.f;
    
    out = q.apply_classifier(su,'classes',{dev_8msVOT}, 'blocks_in', blocks_8_74, 'name', '8in8-74', 'channels', channelsgood, 'time', time, 'target_labels', [-1]);
    classification_ratesG(sub,12) = out.rate;
    test_fG{:,sub,12} = out.f;
    
end