
 subjects_paths={'~/Data/Raw/Variance/VPP1/','~/Data/Raw/Variance/VPP2/','~/Data/Raw/Variance/VPP3/'...
        '~/Data/Raw/Variance/VPP4/','~/Data/Raw/Variance/VPP5/','~/Data/Raw/Variance/VPP6/'...
        '~/Data/Raw/Variance/VPP7/','~/Data/Raw/Variance/VPP8/'};

for i=1:numel(subjects_paths)
    load var_cfg
    subjects_paths={'~/Data/Raw/Variance/VPP1/','~/Data/Raw/Variance/VPP2/','~/Data/Raw/Variance/VPP3/'...
        '~/Data/Raw/Variance/VPP4/','~/Data/Raw/Variance/VPP5/','~/Data/Raw/Variance/VPP6/'...
        '~/Data/Raw/Variance/VPP7/','~/Data/Raw/Variance/VPP8/'};
    names={'VPP1','VPP2','VPP3','VPP4','VPP5','VPP6','VPP7','VPP8','VPP9','VPP10'};
    S=Subject('subject_path',subjects_paths{i},'cfg',cfg,'markers',[20 22]);
    save(names{i},'S')
    clear all
    
end
