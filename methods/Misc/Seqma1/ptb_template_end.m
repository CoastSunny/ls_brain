
%%%%
%% end of pre-defined tables, start of actual code
%%%%

if ppo, % if parallel port output is enabled
    % initialize parallel port output (requires Data Acquisition Toolbox)
    dio = digitalio('parallel','LPT1');
    addline(dio,0:7,'out');
end

% Force GetSecs and WaitSecs into memory to avoid latency later on:
dummy=GetSecs;
WaitSecs(0.1);

% psychophysics toolbox stuff (code initially from BasicSoundOutputDemo.m)

%%%% 
%% audio initialization
%%%%

% Perform basic initialization of the sound driver:
deviceid=-1;

% Open the default audio device [], with default mode [] (==Only playback),
% and a required latencyclass of zero 0 == no low-latency mode, as well as
% a frequency of freq and nrchannels sound channels.
% This returns a handle to the audio device:
if HQ_AUDIO, % high-quality ASIO enabled
    InitializePsychSound(1);
    reqlatencyclass=2; sugglatency=0.005;  onset_delay=0.05; %50-ms onset delay
else % no high-quality ASIO sound output, much longer onset delays
    InitializePsychSound(0);
    reqlatencyclass=0; sugglatency=0.6; onset_delay=0.7;
end
pahandle = PsychPortAudio('Open', deviceid, [], reqlatencyclass, freq{1}, nrchannels{1},[],sugglatency);

% Fill the audio playback buffer with the audio data 'wavedata':
PsychPortAudio('FillBuffer', pahandle, snd{stim_table(1)});

%%%% 
%% screen initialization
%%%%

AssertOpenGL; % continue script only if opengl is found

% Get the list of Screens and choose the one with the highest screen number.
% Screen 0 is, by definition, the display with the menu bar. Often when
% two monitors are connected the one without the menu bar is used as
% the stimulus display.  Chosing the display with the highest dislay number is
% a best guess about where you want the stimulus displayed.
screens=Screen('Screens');
screenid=max(screens);
if exist('SCREEN_RESO'), % optionally, set screen resolution
    Screen('Resolution',screenid,SCREEN_RESO(1),SCREEN_RESO(2),SCREEN_RESO(3)); 
end 
screensize=Screen('Rect', screenid);

% Query size of screen:
screenwidth=screensize(3);
screenheight=screensize(4);
win = Screen('OpenWindow', screenid, 0);
ifi = Screen('GetFlipInterval', win);

fprintf('Press enter to start playback. While playing, press any key for about 1 second to quit.\n');
pause;

% Wait for release of all keys on keyboard:
while KbCheck; end;

i=1;
waitframes=1;

% rudimentary log structure: start time, portcode & event name
slog=struct('start',[],'portcode',[],'event',[]);
slog(size(stim_table,1)).event=[]; % reserve memory for the log log

Priority(MaxPriority(win));

logstart=GetSecs;

% Stay in a little loop until keypress or after stimulus table has been gone through:
while (~KbCheck && i<size(stim_table,1)+1)
    if i<size(stim_table,1),
        next_stim=stim_table(i+1);
    else
        next_stim=[];
    end
    [slog(i).start slog(i).portcode slog(i).event]=audtrial(stim_table(i),trig_table(i),isi_table(i),next_stim);
    i=i+1;
end

Priority(0);

% Close the devices:
PsychPortAudio('Close', pahandle);
Screen('CloseAll');

% go through the log struct, delete empty entries
while isempty(slog(end).start),
    slog(end)=[];
end
%keyboard % useful for debugging
return


%%%%
%% auditory-only trial
%%%%
function [stimstart,portcode,event]=audtrial(sndnum,portcode,trial_duration,nextsnd)
% present auditory wav file and preload the next wav file to memory
global snd freq nbits STIM_NAME DEBUG_TRIG port_output dio logstart;
global win waitframes ifi pahandle onset_delay;
global img img_bg scr scr_bg rect; 

[vbl1 visonset1]= Screen('Flip', win);

PsychPortAudio('Start', pahandle, 1, visonset1 + waitframes * ifi + onset_delay, 0);
[vbl visual_onset t1] = Screen('Flip', win, vbl1 + (waitframes - 0.5) * ifi,1);

offset = 0;
% Spin-Wait until hw reports the first sample is played...
while offset == 0
    status = PsychPortAudio('GetStatus', pahandle);
    offset = status.PositionSecs;
    t(4)=GetSecs;
    plat = status.PredictedLatency;
    if offset>0
        break;
    end
    WaitSecs(0.001);
end

if port_output, % if parallel port output is enabled
    WaitSecs(plat-0.001);
    putvalue(dio,portcode); 
    if DEBUG_TRIG,
        Screen('FillRect', win, 255); Screen('DrawingFinished', win); 
        [vbl t2]=Screen('Flip', win,0,1);
    end
    WaitSecs(0.02); % 20-ms pulses
    putvalue(dio,0);
else
    WaitSecs(plat-0.001);
    if DEBUG_TRIG,
        Screen('FillRect', win, 200); Screen('DrawingFinished', win); 
        [vbl t2]=Screen('Flip', win,0,1);
    end
    WaitSecs(0.02); % simulate 20-ms pulse, without real output
end

audio_onset = status.StartTime;
stimstart = status.StartTime-logstart; % delta_t from beginning of logfile

snd_len=length(snd{sndnum})/freq{sndnum};
WaitSecs(snd_len-0.02); % wait for duration of sound
if DEBUG_TRIG,
    % back in black
    Screen('FillRect', win, 0 ); Screen('DrawingFinished', win); 
    Screen('Flip', win,0,1);
end
PsychPortAudio('Stop', pahandle,0);

% preload the next sound file
if size(nextsnd,1)>0,
    PsychPortAudio('FillBuffer', pahandle, snd{nextsnd});
else
    PsychPortAudio('FillBuffer', pahandle, zeros(size(snd{sndnum},1),1));
end

event=STIM_NAME{sndnum};

WaitSecs(trial_duration-(GetSecs-t(1))); % wait for rest of ISI


