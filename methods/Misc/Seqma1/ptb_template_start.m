function [slog]=mmn_seqma(ppo)
global snd freq nbits STIM_NAME DEBUG_TRIG port_output dio logstart;
global win waitframes ifi pahandle onset_delay;
%Screen('Preference', 'SkipSyncTests',1); % required if your display drivers are not up to date..
% Simple auditory MMN script using Psychophysics toolbox
% -parallel port output, 20-ms pulses, by default off (ppo=0)
%
% Jaakko Kauramäki 22.11.2007

% generic parameters
HQ_AUDIO=0; % request high-quality, low-latency mode using ASIO 
      % (by default off, as it requires special ASIO-enabled sound drivers)
DEBUG_TRIG=0; % debug: show white screen while the sound should be playing

% optional screen resolution
%SCREEN_RESO=[1024 768 72]; % 1024x768 @ 72 Hz 

%% parallel port output, yes or no
if nargin<1, ppo=0; end;
port_output=ppo;


%%%%
%% pre-defined tables, this is the changing part created by Sequence maker
%%%%
