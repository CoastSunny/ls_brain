run('C:\stuff\BCI_code\toolboxes\ls_bci\global\startup.m');
run('C:\stuff\BCI_code\toolboxes\ls_bci\global\EarOpener.m');

load('C:\stuff\BCI_code\mihaela\results\experiment\classification\cross_pp\cross_pp_v2.mat');
run('EO_boundary');

%topoplots
root = 'C:\stuff\BCI_code';
addpath(exGenPath(fullfile(root,'external_toolboxes','Psychtoolbox')));
addpath(exGenPath(fullfile(root,'external_toolboxes','eeglab')));
addpath(fullfile(root,'external_toolboxes','Psychtoolbox','PsychBasic','MatlabWindowsFilesR2007a'));

subjects = { 'Daphne' 'Julia' 'Sucty' 'Leora' 'Loek' 'Dominiek' 'Chris' 'Sacha' 'Renout' 'Roel'};
n = numel(subjects);

DO_FOLDS = 1;

g=Group;
for i=1:n
    propname = ['sub' num2str(i)];
    g.addprop(propname);
    load(['C:\stuff\BCI_code\mihaela\extracted_data\bound_exp_bp\' subjects{i}]);
    g.(propname) = SUB.copy;
    clear SUB;
end

time = [1:64];
channels = [38];

if (DO_FOLDS)
    for sub=1:n % leave one participant out
        % combine the rest into a group
        delete(findprop(g,'all'))
        g.combine_subjects('exclusion',['sub' num2str(sub)]);
        obj = g.all.default.copy;

        %now load the paria
        load(['C:\stuff\BCI_code\mihaela\extracted_data\bound_exp_bp\' subjects{sub}]);
        su = SUB.default.copy;
        clear SUB;

        blocks_8_41_74 = [];
        blocks_41_8_74 = [];
        blocks_74_41_8 = [];
        for i=1:numel(obj.block_idx)
            markers = obj.markers(obj.block_idx{i})';
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
            fs=su.data.fsample;
            t=time/fs;
            dw=obj.diff_wave('classes',classes,'blocks_in',[ blocks_8_41_74 blocks_74_41_8 ],'time',time,'vis','off', 'channels', channels);
            %dw=su.diff_wave('classes',classes,'blocks_in',blocks_in,'time',time,'vis','off');

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
        print(9, sprintf(['C:\\stuff\\BCI_code\\mihaela\\results\\experiment\\classification\\cross_pp\\cross_pp_v2_%d'], sub), '-dpng');
        close all;    
    end
else
    g.combine_subjects();
    obj = g.all.default.copy;
    
    blocks_8_41_74 = [];
    blocks_41_8_74 = [];
    blocks_74_41_8 = [];
    for i=1:numel(obj.block_idx)
        markers = obj.markers(obj.block_idx{i})';
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

    clsf = {'vot74in8_74', 'vot8in8_74'};
    cls = { {d_74msVOT; sb_d2_74msVOT};
            {d_8msVOT; sb_d2_8msVOT} };

    for i=1:2
        name = clsf{i};
        classif = clsfr.(name);
        classes = cls{i};

        W=classif.W;
        [U S V]=svd(W);
        s=diag(S);
        s=s.^2;
        fs=su.data.fsample;
        t=time/fs;
        dw=obj.diff_wave('classes',classes,'blocks_in',[ blocks_8_41_74 blocks_74_41_8 ],'time',time,'vis','off', 'channels', channels);
        %dw=su.diff_wave('classes',classes,'blocks_in',blocks_in,'time',time,'vis','off');

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
    print(9, 'C:\\stuff\\BCI_code\\mihaela\\results\\experiment\\classification\\cross_pp\\cross_pp_one_clsfr_v2', '-dpng');
    close all;
end