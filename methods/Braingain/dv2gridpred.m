function [prediction,DV]=dv2gridpred(data,clsfr,grid_markers_idx,grid_markers,copyspell_letters,copyspell_target_idx,GRID_LETTERS)  

sliced_data=[];target_markers=[];prediction=[];DV=[];

for i=1:numel(copyspell_letters)
    
    target_markers_idx=find(grid_markers_idx>copyspell_target_idx(i) & grid_markers_idx<copyspell_target_idx(i+1));
    
%     cell_markers=strmatch('Cell',grid_markers(target_markers_idx));
%     if (strmatch('Cell (6',grid_markers(target_markers_idx)))
%         scan_size=90;
%         nocells=6;
%     else
%         scan_size=75;
%         nocells=5;
%     end
    scan_size=64;
    nocells=4;
    cell_markers=strmatch('Cell',grid_markers(target_markers_idx));
    row_markers=target_markers_idx(1:scan_size);
    column_markers=target_markers_idx(cell_markers(1):cell_markers(1)+scan_size-1);
    target_markers_idx=[target_markers_idx(1:64)...
        target_markers_idx(cell_markers(1):cell_markers(1)+scan_size-1)];        
    
    tmp=grid_markers(target_markers_idx);    
    
    target_row=letter2row(copyspell_letters{i},GRID_LETTERS)+1;
    target_cell=letter2cell(copyspell_letters{i},GRID_LETTERS);
    row_str_to_match=['Row ' num2str(target_row) ' (block 0)'];
    cell_str_to_match=['Cell (' num2str(target_cell)];
    tmp2=strmatch(row_str_to_match,tmp);
    tmp3=strmatch(cell_str_to_match,tmp);
    tmp=-ones(1,numel(target_markers_idx));tmp(tmp2)=+1;tmp(tmp3)=+1;
    target_markers=[target_markers tmp];
    sliced_data=[sliced_data data{1}.trial(target_markers_idx)];
    Xr=cat(3,data{1}.trial{row_markers});
    dvr=apply_erp_clsfr(Xr,clsfr);
    DV=[DV dvr'];
    dvr=reshape(dvr,nocells,scan_size/nocells);
    Xc=cat(3,data{1}.trial{column_markers});
    dvc=apply_erp_clsfr(Xc,clsfr);
    DV=[DV dvc'];
    dvc=reshape(dvc,nocells,scan_size/nocells); 
    [mr ir]=max(sum(dvr,2));
    [mc ic]=max(sum(dvc,2));
    prediction{end+1}=GRID_LETTERS{ir}{ic};
   
end