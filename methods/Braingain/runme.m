
if (~exist('data'));load badtrcheck;end;
GRID_LETTERS{1}={'a' 'b' 'c' 'd' 'e' 'f'};
GRID_LETTERS{2}={'g' 'h' 'i' 'j' 'k' 'l' };
GRID_LETTERS{3}={'m' 'n' 'o' 'p' 'q' 'r' };
GRID_LETTERS{4}={'s' 't' 'u' 'v' 'w' 'x'};
GRID_LETTERS{5}={'y' 'z' '.' ',' '_' 'we have an issue here'};

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

calibrate_letters={'q' 's' 'd' 'z' 'i' 'r' 'e' 'y'};
calibrate_target_idx=grid_messages_idx(12:20);

[clsfr res]=trgridclsfr(data,grid_markers_idx,grid_markers,calibrate_target_idx,calibrate_letters,GRID_LETTERS);

copyspell_letters={'z' 'o' 'e' 'k' 'e' 'n'};
copyspell_target_idx=grid_messages_idx(23:29);
[prediction1,DV1]=dv2datagridpred(data,clsfr,grid_markers_idx,grid_markers,copyspell_letters,copyspell_target_idx,GRID_LETTERS);

copyspell_letters={'j' 'a' 'g' 'u' 'a' 'r'};
copyspell_target_idx=grid_messages_idx(32:38);
[prediction2,DV2]=dv2gridpred(data,clsfr,grid_markers_idx,grid_markers,copyspell_letters,copyspell_target_idx,GRID_LETTERS);


sliced_data=[];target_markers=[];
calibrate_letters={'q' 's' 'd' 'z' 'i' 'r' 'e' 'y'};
calibrate_target_idx=grid_messages_idx(45:53);

[clsfr res]=trgridclsfr(data,grid_markers_idx,grid_markers,calibrate_target_idx,calibrate_letters,GRID_LETTERS);

sliced_data=[];target_markers=[];prediction=[];DV=[];
copyspell_letters={'z' 'o' 'e' 'k' 'e' 'n'};
copyspell_target_idx=grid_messages_idx(56:62);

[prediction3,DV3]=dv2gridpred(data,clsfr,grid_markers_idx,grid_markers,copyspell_letters,copyspell_target_idx,GRID_LETTERS);


prediction1,prediction2,prediction3
ax=[0 1000 -500 500];
figure,
subplot(3,1,1),plot(DV1),axis(ax)
subplot(3,1,2),plot(DV2),axis(ax)
subplot(3,1,3),plot(DV3),axis(ax)