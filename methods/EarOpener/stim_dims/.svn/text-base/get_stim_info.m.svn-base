function stim_info = get_stim_info(dataset)
f_stim_dims = '~/BCI_code/toolboxes/ls_bci/methods/EarOpener/stim_dims/stim_dims.mat';
load(f_stim_dims);
f_seq = 'brainstream/variables/sequence.mat';
nBlocks = length(dataset.paths);
sb_marker = 'sb';
dev_marker = 'dev';
stim_info = [];
%% fill stim_info for a given sequence
for iBlock = 1:nBlocks
    curr_gdf_path = dataset.paths{iBlock};
    path_idx = regexp(curr_gdf_path,'raw_bdf','start');
    curr_seq_path = [curr_gdf_path(1:path_idx-1) f_seq];
    load(curr_seq_path);
    
    sb_idx = find(strcmp(v.type, sb_marker));
    dev_idx = sb_idx+1;
    nDev = length(dev_idx);
    curr_stim_info = zeros(nDev,2);
    
    for iDev = 1:nDev
        curr_sb = strtok(v.seq{sb_idx(iDev)},'.');
        curr_dev = strtok(v.seq{dev_idx(iDev)},'.');
        curr_vec = [stim_dims.(curr_dev).p_height/stim_dims.(curr_sb).p_height,...
            stim_dims.(curr_dev).p_slope-stim_dims.(curr_sb).p_slope];
        curr_stim_info(iDev,1)=curr_vec(1); %height
        curr_stim_info(iDev,2)=curr_vec(2); %slope
      %  curr_stim_info(iDev,3)=sqrt(curr_vec*curr_vec'); %might need to be normalized
    end
    stim_info = [stim_info;curr_stim_info];
end
% 
% 'seuclidean'  - Standardized Euclidean distance. Each
%                                   coordinate difference between X and a
%                                   query point is scaled by dividing by a
%                                   scale value S. The default value of S is
%                                   the standard deviation computed from X,
%                                   S=NANSTD(X). To specify another value for
%                                   S, use the 'Scale' argument.