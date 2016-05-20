run('C:\stuff\BCI_code\toolboxes\ls_bci\global\startup.m');
run('C:\stuff\BCI_code\toolboxes\ls_bci\global\EarOpener.m');

load('C:\stuff\BCI_code\mihaela\results\experiment\classification\per_pp\per_pp.mat');
run('EO_boundary');

%topoplots
root = 'C:\stuff\BCI_code';
addpath(exGenPath(fullfile(root,'external_toolboxes','Psychtoolbox')));
addpath(exGenPath(fullfile(root,'external_toolboxes','eeglab')));
addpath(fullfile(root,'external_toolboxes','Psychtoolbox','PsychBasic','MatlabWindowsFilesR2007a'));

%global settings
blocks_in = [1:3 7:9];
time = [1:64];
channels = [38];

subjects = { 'Daphne' 'Julia' 'Sucty' 'Leora' 'Loek' 'Dominiek' 'Chris' 'Sacha' 'Renout' 'Roel'};
n = numel(subjects);

for sub=1:n
    load(['C:\stuff\BCI_code\mihaela\extracted_data\bound_exp_bp\' subjects{sub}]);
    obj = SUB.default.copy;
    clear SUB;
    
    clsf = {'vot74in8_74', 'vot8in8_74'};
    cls = { {d_74msVOT; sb_d2_74msVOT};
            {d_8msVOT; sb_d2_8msVOT} };
    
    
    for i=1:2
        name = clsf{i};
        classif = clsfr(sub).(name);
        classes = cls{i};
        
        W=classif.W;
        [U S V]=svd(W);
        s=diag(S);
        s=s.^2;
        fs=obj.data.fsample;
        t=time/fs;
        dw=obj.diff_wave('classes',classes,'blocks_in',blocks_in,'time',time,'vis','off', 'channels', channels);

        %PC1
        figure,
        hold on, plot(t,V(:,1),'r'),plot(t,dw/norm(dw),'b');
        title([num2str(s(1)/sum(s))]),xlabel('time')
        legend(['PC1 ' num2str(s(1)/sum(s))], 'MMN');    % display the amount of variance explained

        %and its topoplot
        figure;
        electrodelocs = 'cap64.txt'; 
        eloc=readlocs(electrodelocs, 'filetype', 'besa');
        topoplot(U(:,1),eloc);
        legend(num2str(s(1)/sum(s)));

        %reversed PC1
        figure,
        hold on, plot(t,-V(:,1),'r'),plot(t,dw/norm(dw),'b');
        title('PC1'),xlabel('time')
        legend(['PC1 ' num2str(s(1)/sum(s))], 'MMN');    % display the amount of variance explained

        %and topoplot for reversed PC1
        figure;
        electrodelocs = 'cap64.txt'; 
        eloc=readlocs(electrodelocs, 'filetype', 'besa');
        topoplot(-U(:,1),eloc);
        legend(num2str(s(1)/sum(s)));
    end
    
    %to prevent ending up with 80 figs
    for k=1:8
        if (mod(k,2))
            figure(k);
            plot(t,   0, 'col', [0 0 0]); hold on;
            plot(t,-0.1, 'col', [0 0 0]); hold on;
            plot(t,-0.2, 'col', [0 0 0]); hold on;
            plot([0.15 0.15], [-10 10], 'col', [0 0 0], 'LineStyle', ':'); hold on;
            plot([0.25 0.25], [-10 10], 'col', [0 0 0], 'LineStyle', ':'); hold on;
            plot([0.35 0.35], [-10 10], 'col', [0 0 0], 'LineStyle', ':'); hold on;
            set(gca, 'xlim', [0 0.5]);
            set(gca, 'ylim', [-0.5 0.5]);
        end
    end
    figmerge([1:8], [4 2]);
    print(9, sprintf(['C:\\stuff\\BCI_code\\mihaela\\results\\experiment\\classification\\per_pp\\per_pp_Fz_%d'], sub), '-dpng');
    close all;
 end