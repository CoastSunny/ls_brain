function [clsfr res] =trgridclsfr(data,grid_markers_idx,grid_markers,calibrate_target_idx,calibrate_letters,GRID_LETTERS)

sliced_data=[];target_markers=[];

for i=1:numel(calibrate_letters)
    
    target_markers_idx=find(grid_markers_idx>calibrate_target_idx(i) & grid_markers_idx<calibrate_target_idx(i+1));
    target_markers_idx=target_markers_idx(1:40);
    tmp=grid_markers(target_markers_idx);    
    target_row=letter2row(calibrate_letters{i},GRID_LETTERS)+1;
    str_to_match=['Row ' num2str(target_row) ' (block 0)'];
    tmp2=strmatch(str_to_match,tmp);
    tmp=-ones(1,40);tmp(tmp2)=+1;
    target_markers=[target_markers tmp];
    sliced_data=[sliced_data data{1}.trial(target_markers_idx)];
    
end

Xcal=cat(3,sliced_data{:});
Ycal=target_markers;

[clsfr res]=train_erp_clsfr(Xcal,Ycal);
