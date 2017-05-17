%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CNA creation: 25/01/2017, last update: 25/01/2017
% Script that integrates the detection, localization and demodulation of
% signal sources for the MASNET project. It integrates codes from Pat
% Chambers, Heba Shoukry and me.
% The script is organised as follows:

clear all
close all force
clc



%% Choose what operation to carry out:
% [A] Run montecarlo simulations to obtain SNRs for a specific scenario





%% [A] This option calls SNR_generation to generate a file where SNRs of a specific scenario.
% These SNR file contains a 4D matrix where
% (#target_position_x,#target_position_y,#MonteCarlo_runs,#Sensors). This
% file just run Montecarlo simulations of WINNER-II channels so later the
% resulting SNR can be used for other operations

SNR_generation();



