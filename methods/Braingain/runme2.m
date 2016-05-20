
%if (~exist('data'));load badtrcheck;end;
GRID_LETTERS{1}={'p1' 'p2' 'p3' 'back'};
GRID_LETTERS{2}={'abc' 'def' 'ghi' 'spreken' };
GRID_LETTERS{3}={'jkl' 'mno' 'pqr' 'backspatie' };
GRID_LETTERS{4}={'st' 'uvw' 'xyz' 'spatie'};


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

calibrate_letters={'ghi' 'jkl' 'p2' 'spatie' 'pqr' 'p1' 'spreken' 'uvw' 'jkl' 'ghi'};
calibrate_target_idx=grid_messages_idx(7:17);

[clsfr res]=trgridclsfr(data,grid_markers_idx,grid_markers,calibrate_target_idx,calibrate_letters,GRID_LETTERS);

copyspell_letters={'xyz' 'mno' 'def' 'jkl' 'def' 'mno'};
copyspell_target_idx=grid_messages_idx(20:26);
[prediction1,DV1]=dv2gridpred(data,clsfr,grid_markers_idx,grid_markers,copyspell_letters,copyspell_target_idx,GRID_LETTERS);

copyspell_letters={'jkl' 'abc' 'ghi' 'uvw' 'abc' 'pqr'};
copyspell_target_idx=grid_messages_idx(29:35);
[prediction2,DV2]=dv2gridpred(data,clsfr,grid_markers_idx,grid_markers,copyspell_letters,copyspell_target_idx,GRID_LETTERS);


% sliced_data=[];target_markers=[];
% calibrate_letters={'q' 's' 'd' 'z' 'i' 'r' 'e' 'y'};
% calibrate_target_idx=grid_messages_idx(45:53);
% 
% [clsfr res]=trgridclsfr(data,grid_markers_idx,grid_markers,calibrate_target_idx,calibrate_letters,GRID_LETTERS);
% 
% sliced_data=[];target_markers=[];prediction=[];DV=[];
% copyspell_letters={'z' 'o' 'e' 'k' 'e' 'n'};
% copyspell_target_idx=grid_messages_idx(56:62);
% 
% [prediction3,DV3]=dv2gridpred(data,clsfr,grid_markers_idx,grid_markers,copyspell_letters,copyspell_target_idx,GRID_LETTERS);


prediction1,prediction2%,prediction3
ax=[0 800 -20 20];
figure,
subplot(2,1,1),plot(DV1),axis(ax)
subplot(2,1,2),plot(DV2),axis(ax)
%subplot(3,1,3),plot(DV3),axis(ax)