
grid_messages=[];grid_messages_idx=[];
grid_markers=[];grid_markers_idx=[];
grid_phase=[];grid_phase_idx=[];

for i=1:size(trial_cfg.event,1)
    
    if strcmp(trial_cfg.event(i).type,'stimulus.grid.message')
        grid_messages{end+1}=trial_cfg.event(i).value;
        grid_messages_idx(end+1)=i;        
    elseif strcmp(trial_cfg.event(i).type,'stimulus.grid')
        grid_markers{end+1}=trial_cfg.event(i).value;
        grid_markers_idx(end+1)=i;
    elseif strcmp(trial_cfg.event(i).type,'startPhase.cmd')
        grid_phase{end+1}=trial_cfg.event(i).value;
        grid_phase_idx(end+1)=i;
        
    end
        
end

tmp=strmatch('calibrate',grid_phase);
calibrate_idx=grid_phase_idx(tmp);
sliced_data=[];target_markers=[];
calibrate_letters={'q' 's' 'd' 'z' 'i' 'r' 'e' 'y'};
calibrate_target_idx=grid_messages_idx(12:20);

for i=1:numel(calibrate_letters)
    
    target_markers_idx=find(grid_markers_idx>calibrate_target_idx(i) & grid_markers_idx<calibrate_target_idx(i+1));
    target_markers_idx=target_markers_idx(1:50);
    tmp=grid_markers(target_markers_idx);    
    target_row=letter2row(calibrate_letters{i},GRID_LETTERS)+1;
    str_to_match=['Row ' num2str(target_row) ' (block 0)'];
    tmp2=strmatch(str_to_match,tmp);
    tmp=-ones(1,50);tmp(tmp2)=+1;
    target_markers=[target_markers tmp];
    sliced_data=[sliced_data data{1}.trial(target_markers_idx)];
    
end
Xcal=cat(3,sliced_data{:});
Ycal=target_markers;

[clsfr res]=train_erp_clsfr(Xcal,Ycal);
DV1=[];
sliced_data=[];target_markers=[];prediction1=[];
copyspell1_letters={'z' 'o' 'e' 'k' 'e' 'n'};
copyspell1_target_idx=grid_messages_idx(23:29);
for i=1:numel(copyspell1_letters)
    
    target_markers_idx=find(grid_markers_idx>copyspell1_target_idx(i) & grid_markers_idx<copyspell1_target_idx(i+1));
    
    cell_markers=strmatch('Cell',grid_markers(target_markers_idx));
    if (strmatch('Cell (6',grid_markers(target_markers_idx)))
        scan_size=90;
        nocells=6;
    else
        scan_size=75;
        nocells=5;
    end
    
    row_markers=target_markers_idx(1:75);
    column_markers=target_markers_idx(cell_markers(1):cell_markers(1)+scan_size-1);
    target_markers_idx=[target_markers_idx(1:75)...
        target_markers_idx(cell_markers(1):cell_markers(1)+scan_size-1)];        
    
    tmp=grid_markers(target_markers_idx);    
    
    target_row=letter2row(copyspell1_letters{i},GRID_LETTERS)+1;
    target_cell=letter2cell(copyspell1_letters{i},GRID_LETTERS);
    row_str_to_match=['Row ' num2str(target_row) ' (block 0)'];
    cell_str_to_match=['Cell (' num2str(target_cell)];
    tmp2=strmatch(row_str_to_match,tmp);
    tmp3=strmatch(cell_str_to_match,tmp);
    tmp=-ones(1,numel(target_markers_idx));tmp(tmp2)=+1;tmp(tmp3)=+1;
    target_markers=[target_markers tmp];
    sliced_data=[sliced_data data{1}.trial(target_markers_idx)];
    Xr=cat(3,data{1}.trial{row_markers});
    dvr=apply_erp_clsfr(Xr,clsfr);
    DV1=[DV1 dvr'];
    dvr=reshape(dvr,5,15);
    Xc=cat(3,data{1}.trial{column_markers});
    dvc=apply_erp_clsfr(Xc,clsfr);
    DV1=[DV1 dvc'];
    dvc=reshape(dvc,nocells,scan_size/nocells); 
    [mr ir]=max(sum(dvr,2));
    [mc ic]=max(sum(dvc,2));
    prediction1{end+1}=GRID_LETTERS{ir}{ic};
   
end

DV2=[];
sliced_data=[];target_markers=[];prediction2=[];
copyspell2_letters={'j' 'a' 'g' 'u' 'a' 'r'};
copyspell2_target_idx=grid_messages_idx(32:38);
for i=1:numel(copyspell1_letters)
    
    target_markers_idx=find(grid_markers_idx>copyspell2_target_idx(i) & grid_markers_idx<copyspell2_target_idx(i+1));
    
    cell_markers=strmatch('Cell',grid_markers(target_markers_idx));
    if (strmatch('Cell (6',grid_markers(target_markers_idx)))
        scan_size=90;
        nocells=6;
    else
        scan_size=75;
        nocells=5;
    end
    
    row_markers=target_markers_idx(1:75);
    column_markers=target_markers_idx(cell_markers(1):cell_markers(1)+scan_size-1);
    target_markers_idx=[target_markers_idx(1:75)...
        target_markers_idx(cell_markers(1):cell_markers(1)+scan_size-1)];        
    
    tmp=grid_markers(target_markers_idx);    
    
    target_row=letter2row(copyspell1_letters{i},GRID_LETTERS)+1;
    target_cell=letter2cell(copyspell1_letters{i},GRID_LETTERS);
    row_str_to_match=['Row ' num2str(target_row) ' (block 0)'];
    cell_str_to_match=['Cell (' num2str(target_cell)];
    tmp2=strmatch(row_str_to_match,tmp);
    tmp3=strmatch(cell_str_to_match,tmp);
    tmp=-ones(1,numel(target_markers_idx));tmp(tmp2)=+1;tmp(tmp3)=+1;
    target_markers=[target_markers tmp];
    sliced_data=[sliced_data data{1}.trial(target_markers_idx)];
    Xr=cat(3,data{1}.trial{row_markers});
    dvr=apply_erp_clsfr(Xr,clsfr);
    DV2=[DV2 dvr'];
    dvr=reshape(dvr,5,15);
    Xc=cat(3,data{1}.trial{column_markers});
    dvc=apply_erp_clsfr(Xc,clsfr);
    DV2=[DV2 dvc'];
    dvc=reshape(dvc,nocells,scan_size/nocells);
    [mr ir]=max(sum(dvr,2));
    [mc ic]=max(sum(dvc,2));
    prediction2{end+1}=GRID_LETTERS{ir}{ic};
end

sliced_data=[];target_markers=[];
calibrate_letters={'q' 's' 'd' 'z' 'i' 'r' 'e' 'y'};
calibrate_target_idx=grid_messages_idx(45:53);

for i=1:numel(calibrate_letters)
    
    target_markers_idx=find(grid_markers_idx>calibrate_target_idx(i) & grid_markers_idx<calibrate_target_idx(i+1));
    target_markers_idx=target_markers_idx(1:50);
    tmp=grid_markers(target_markers_idx);    
    target_row=letter2row(calibrate_letters{i},GRID_LETTERS)+1;
    str_to_match=['Row ' num2str(target_row) ' (block 0)'];
    tmp2=strmatch(str_to_match,tmp);
    tmp=-ones(1,50);tmp(tmp2)=+1;
    target_markers=[target_markers tmp];
    sliced_data=[sliced_data data{1}.trial(target_markers_idx)];
    
end
Xcal=cat(3,sliced_data{:});
Ycal=target_markers;

[clsfr res]=train_erp_clsfr(Xcal,Ycal);
DV3=[];
sliced_data=[];target_markers=[];prediction3=[];
copyspell3_letters={'z' 'o' 'e' 'k' 'e' 'n'};
copyspell3_target_idx=grid_messages_idx(56:62);
for i=1:numel(copyspell1_letters)
    
    target_markers_idx=find(grid_markers_idx>copyspell3_target_idx(i) & grid_markers_idx<copyspell3_target_idx(i+1));
    
    cell_markers=strmatch('Cell',grid_markers(target_markers_idx));
    if (strmatch('Cell (6',grid_markers(target_markers_idx)))
        scan_size=90;
        nocells=6;
    else
        scan_size=75;
        nocells=5;
    end
    
    row_markers=target_markers_idx(1:75);
    column_markers=target_markers_idx(cell_markers(1):cell_markers(1)+scan_size-1);
    target_markers_idx=[target_markers_idx(1:75)...
        target_markers_idx(cell_markers(1):cell_markers(1)+scan_size-1)];        
    
    tmp=grid_markers(target_markers_idx);    
    
    target_row=letter2row(copyspell1_letters{i},GRID_LETTERS)+1;
    target_cell=letter2cell(copyspell1_letters{i},GRID_LETTERS);
    row_str_to_match=['Row ' num2str(target_row) ' (block 0)'];
    cell_str_to_match=['Cell (' num2str(target_cell)];
    tmp2=strmatch(row_str_to_match,tmp);
    tmp3=strmatch(cell_str_to_match,tmp);
    tmp=-ones(1,numel(target_markers_idx));tmp(tmp2)=+1;tmp(tmp3)=+1;
    target_markers=[target_markers tmp];
    sliced_data=[sliced_data data{1}.trial(target_markers_idx)];
    Xr=cat(3,data{1}.trial{row_markers});
    dvr=apply_erp_clsfr(Xr,clsfr);
    DV3=[DV3 dvr'];
    dvr=reshape(dvr,5,15);
    Xc=cat(3,data{1}.trial{column_markers});
    dvc=apply_erp_clsfr(Xc,clsfr);
    DV3=[DV3 dvc'];
    dvc=reshape(dvc,nocells,scan_size/nocells);
    [mr ir]=max(sum(dvr,2));
    [mc ic]=max(sum(dvc,2));
    prediction3{end+1}=GRID_LETTERS{ir}{ic};
end

ax=[0 1000 -500 500];
figure,
subplot(3,1,1),plot(DV1),axis(ax)
subplot(3,1,2),plot(DV2),axis(ax)
subplot(3,1,3),plot(DV3),axis(ax)