% Stimuli Presentationia varten?

function y = sequencefile(seq, format, filename, wbar)

% SEQUENCEFILE Writes the sequence into a file
%
% SEQUENCEFILE(sequence, format, filename, waitbar)
%
%    seq         a cell matrix containing the sequence information
%    format      1 for Stim, 2 for BrainStim, 3 for Presentation, 4 for Psychtoolbox
%    filename    the sequence file name
%    wbar        waitbar from the calling function
%
%    Returns the path and filename of the created file (as one string)
%
% History
%  22.11.2007 edited by Jaakko Kauram?ki <jkaurama@lce.hut.fi>
%             rudimentary support for Psychophysics toolbox (a.k.a. Psychtoolbox)
%  10.11.2006 edited by Jaakko Kauram?ki <jkaurama@lce.hut.fi>
%             fixed and improved Presentation file output
%
%    CBRU / University of Helsinki, Finland

switch format

    case 1  % Stim

        file_out = [cd '\' filename, '.seq'];
        file_out='roving.txt';
        fid = fopen(lower(file_out),'wt');

        fprintf(fid,'%10s %5d\n', 'Numevents', length(seq));
        fprintf(fid,'%63s\n', 'event mode duration window SOA/ISI xpos ypos resp type filename');
        fprintf(fid,'%63s\n', '----- ---- -------- ------ ------- ---- ---- ---- ---- --------');

        for j=1:length(seq)
            waitbar(0.5 + j/length(seq));
            fprintf(fid,'%6ld %5d %5d %5d %4.3f %5d %5d %5d %5d %s\n', ...
                seq{j,1}, seq{j,2}, seq{j,3}, seq{j,4}, seq{j,5}, seq{j,6}, seq{j,7}, seq{j,8}, seq{j,9}, seq{j,10});
        end
        fclose(fid);


    case 2 % BrainStim

        file_out = [cd '\' filename, '.nsq'];
        fid = fopen(lower(file_out),'wt');

        for j=1:length(seq)
            waitbar(0.5 + j/length(seq));
            fprintf(fid,'%4.3f     %5d             %s\n', seq{j,5}, seq{j,9}, ...
                seq{j,10});
        end
        fclose(fid);

    case 3 % Presentation
        file_out = [cd '\' filename, '.sce'];
        fid = fopen(lower(file_out),'wt');
        fprintf(fid,['scenario = "EEG scenario";\n',...
            'write_codes=true; # write all codes to parallel port (for EEG acquisition)\n',...
            'pulse_width=100; # seems to be ok\n\n']);
        fprintf(fid,'begin;\n');
        fprintf(fid,'picture {} default;\n');
        %keyboard;

        % find how many unique stimuli & sort them by trigger number
        stim_tmp=unique(char(seq{:,10}),'rows'); 
        stimuli=stim_tmp; stimuli(1:end)=' ';% same size, but the order is fixed in following loops
        for i = 1:size(stim_tmp,1),
            for j=1:length(seq),
                if strmatch(strtrim(seq{j,10}),strtrim(stim_tmp(i,:))) & seq{j,9}>0,
                    trig_tmp(i)=seq{j,9};
                    break
                end
            end
        end
        
        trig_tmp2=sort(trig_tmp);
        for i=1:size(stim_tmp,1),
            [foo,idx]=find(trig_tmp==trig_tmp2(i));
            idx=idx(1); % in case multiple ones found
             stimuli(i,:)=stim_tmp(idx,:);
        end
        
        for k = 1:size(stimuli,1),
            fprintf(fid,['sound { wavefile { filename = "%s.wav"; }; }   ', ...
                ' %s   ;\n'], strtrim(stimuli(k,:)), ...
                strtrim(stimuli(k,:)));
        end

        fprintf(fid,'\n');
        %  fprintf(fid,'\n\ntrial {\n\n');

        for j=1:length(seq)
            waitbar(0.5 + j/length(seq));
            fprintf(fid,'trial { trial_duration = %d; sound %s  ;  code = %5d; port_code = %5d ; };\n', round(seq{j,5}*1000), seq{j,10}, seq{j,9},seq{j,9});
        end
        %  fprintf(fid, '\n } sequence ;\n');
        fclose(fid);

    case 4 % Psychtoolbox
        file_out = [cd '\' filename, '.m'];
        fid = fopen(lower(file_out),'wt');

        % find how many unique stimuli & sort them by trigger number
        stim_tmp=unique(char(seq{:,10}),'rows'); 
        stimuli=stim_tmp; stimuli(1:end)=' ';% same size, but the order is fixed in following loops
        for i = 1:size(stim_tmp,1),
            for j=1:length(seq),
                if strmatch(strtrim(seq{j,10}),strtrim(stim_tmp(i,:))) & seq{j,9}>0,
                    trig_tmp(i)=seq{j,9};
                    break
                end
            end
        end
        
        trig_tmp2=sort(trig_tmp);
        for i=1:size(stim_tmp,1),
            [foo,idx]=find(trig_tmp==trig_tmp2(i));
             stimuli(i,:)=stim_tmp(idx,:);
        end
        
        fprintf(fid,'N_SND=%d;\n',size(stimuli,1));
        fprintf(fid,'wav=cell(N_SND,1); freq=cell(N_SND,1); nbits=cell(N_SND,1); snd=cell(N_SND,1);\n');
        fprintf(fid,'STIM_NAME={');
        for i=1:size(stimuli,1),
            fprintf(fid,'\''%s\''',strtrim(stimuli(i,:)));
            if i<size(stimuli,1), fprintf(fid,','); end;
        end
        fprintf(fid,'};\n');

        for i=1:size(stimuli,1),
            fprintf(fid,'WAV_NAME{%d}=\''%s.wav\''; ',i,strtrim(stimuli(i,:)));
        end
        fprintf(fid,'\n\n');
        
        fprintf(fid,'for i=1:N_SND,\n');
        fprintf(fid,'   [wav{i}, freq{i}, nbits{i}] = wavread(WAV_NAME{i}); snd{i} = wav{i}\'';\n');
        fprintf(fid,'   %%snd{1}(2,:)=snd{1}(1,:); %%make stereo sound\n');
        fprintf(fid,'   nrchannels{i} = size(snd{i},1); %% Number of rows == number of channels.\n');
        fprintf(fid,'end\n\n');

%            fprintf(fid,'trial { trial_duration = %d; sound %s  ;  code = %5d; port_code = %5d ; };\n', round(seq{j,5}*1000), seq{j,10}, seq{j,9},seq{j,9});
        
        fprintf(fid,'stim_table=[ '); % stimulus order
        for j=1:length(seq),
            waitbar(0.5 + j/(length(seq)*3));
            fprintf(fid,'%d', strmatch(seq{j,10},stimuli)); % notice that stim_table values refer to stimulus order in STIM_NAME array
            if j<length(seq), fprintf(fid,' '); end;
            if mod(j,20)==0, fprintf(fid,' ...\n'); end
        end
        fprintf(fid,']\'';\n\n');

        fprintf(fid,'trig_table=[ '); % triggers
        for j=1:length(seq),
            waitbar(0.5 + (j+1*length(seq))/(length(seq)*3));
            fprintf(fid,'%d', seq{j,9}); 
            if j<length(seq), fprintf(fid,' '); end;
            if mod(j,20)==0, fprintf(fid,' ...\n'); end
        end
        fprintf(fid,']\'';\n\n');

        fprintf(fid,'isi_table=[ '); % length of each trial
        for j=1:length(seq),
            waitbar(0.5 + (j+2*length(seq))/(length(seq)*3));
            fprintf(fid,'%1.4f', seq{j,5}); 
            if j<length(seq), fprintf(fid,' '); end;
            if mod(j,10)==0, fprintf(fid,' ...\n'); end
        end
        fprintf(fid,']\'';\n\n');
        fclose(fid);

        % copy start, middle and end to one file
        f_1 = fopen('ptb_template_start.m', 'r');
        ptb_1 = fread(f_1, '*char');
        fclose(f_1);        
        f_2 = fopen([cd '\' filename, '.m'], 'r');
        ptb_2 = fread(f_2, '*char');
        fclose(f_2);        
        f_3 = fopen(['ptb_template_end.m'], 'r');
        ptb_3 = fread(f_3, '*char');
        fclose(f_3);        
        fid = fopen([cd '\' filename, '.m'], 'wb');
        fwrite(fid,ptb_1,'char');
        fwrite(fid,ptb_2,'char');
        fwrite(fid,ptb_3,'char');
        fclose(fid);
end
close(wbar);
y = file_out;