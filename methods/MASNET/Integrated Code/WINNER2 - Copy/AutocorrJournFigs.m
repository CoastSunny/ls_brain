%% Loading an plotting of figures for paper on SKAB algorithm.

clear

%% Paths for loading
cdir = cd;
Figures_path1 = 'H:\MATLAB\DSTL\MASNET_Project\WINNER2';
Figures_path2 = 'C:\Users\pc202\Desktop\PatChambers\Autocorr\Results';

%% Load data
cd(Figures_path1);
AutoFigs = load('AutoFigs.mat');
R_auto_sim = AutoFigs.R_auto_sim;
R_auto_meas = AutoFigs.R_auto_meas;
SNRdB2 = AutoFigs.SNRdB2;
SNR_inds = [1,6,13];

AutoFigs2 = load('AutoFigs2.mat');
dec_auto_cor_n = AutoFigs2.dec_auto_cor_n;
test_stat_cor_n = AutoFigs2.test_stat_cor_n;
R_auto_cor_n =  AutoFigs2.R_auto_cor_n;
dec_auto_cor_TBn = AutoFigs2.dec_auto_cor_TBn;
test_stat_cor_TBn = AutoFigs2.test_stat_cor_TBn;
R_auto_cor_TBn = AutoFigs2.R_auto_cor_TBn;
R_sim_angle = AutoFigs2.R_sim_angle;

cd(Figures_path2);
AutoFigs4p1 = load('SKAB_analysis6.mat','SNR_vec_dB','K_fac_mean','rho2','R_auto_sim_abs_mean','T_c','T_d','M_in_algo',...
    'bins_R_auto_sim_real_n','binsfit_R_auto_sim_real_n','pdf_R_auto_sim_real_n','pdffit_R_auto_sim_real_n','bins_fit_cor2_G_n','pdf_fit_cor2_G_n','test_stat_cor_n');
SNR_vec_dB = AutoFigs4p1.SNR_vec_dB;
K_fac_mean = AutoFigs4p1.K_fac_mean;
rho2 = AutoFigs4p1.rho2;
R_auto_sim_abs_mean = AutoFigs4p1.R_auto_sim_abs_mean;
T_c =  AutoFigs4p1.T_c;
T_d =  AutoFigs4p1.T_d;

M_in_algo = AutoFigs4p1.M_in_algo; 
bins_R_auto_sim_real_n =  AutoFigs4p1.bins_R_auto_sim_real_n;
binsfit_R_auto_sim_real_n = AutoFigs4p1.binsfit_R_auto_sim_real_n;
pdf_R_auto_sim_real_n  =  AutoFigs4p1.pdf_R_auto_sim_real_n;
pdffit_R_auto_sim_real_n  = AutoFigs4p1.pdffit_R_auto_sim_real_n;
bins_fit_cor2_G_n  =  AutoFigs4p1.bins_fit_cor2_G_n;
pdf_fit_cor2_G_n  =   AutoFigs4p1.pdf_fit_cor2_G_n;
test_stat_cor_n = AutoFigs4p1.test_stat_cor_n;

AutoFigs4p2 = load('CAB&SKAB_AWGN_anyl.mat');
%SKAB
bins_R_auto_sim_real_n = AutoFigs4p2.bins_R_auto_sim_real_n;
binsfit_R_auto_sim_real_n = AutoFigs4p2.binsfit_R_auto_sim_real_n;
pdf_R_auto_sim_real_n = AutoFigs4p2.pdf_R_auto_sim_real_n;
pdffit_R_auto_sim_real_n  = AutoFigs4p2.pdffit_R_auto_sim_real_n;

bins_R_auto_sim_real_TBn = AutoFigs4p2.bins_R_auto_sim_real_TBn;
binsfit_R_auto_sim_real_TBn = AutoFigs4p2.binsfit_R_auto_sim_real_TBn;
pdf_R_auto_sim_real_TBn = AutoFigs4p2.pdf_R_auto_sim_real_TBn;
pdffit_R_auto_sim_real_TBn = AutoFigs4p2.pdffit_R_auto_sim_real_TBn;

binsfit_R_auto_sim_real_ev  =  AutoFigs4p2.binsfit_R_auto_sim_real_ev;
pdffit_R_auto_sim_real_ev    = AutoFigs4p2.pdffit_R_auto_sim_real_ev;
binsfit_R_auto_sim_real_TBev  = AutoFigs4p2.binsfit_R_auto_sim_real_TBev;
pdffit_R_auto_sim_real_TBev   = AutoFigs4p2.pdffit_R_auto_sim_real_TBev

binsfit_R_auto_sim_real_ev = -1*binsfit_R_auto_sim_real_ev(end:-1:1);
binsfit_R_auto_sim_real_TBev = -1*binsfit_R_auto_sim_real_TBev(end:-1:1);
pdffit_R_auto_sim_real_ev = pdffit_R_auto_sim_real_ev(end:-1:1);
pdffit_R_auto_sim_real_TBev = pdffit_R_auto_sim_real_TBev(end:-1:1);


       



%CAB
bins_R_auto_sim_real_n_stan = AutoFigs4p2.bins_R_auto_sim_real_n_stan;
binsfit_R_auto_sim_real_n_stan = AutoFigs4p2.binsfit_R_auto_sim_real_n_stan; 
pdf_R_auto_sim_real_n_stan  = AutoFigs4p2.pdf_R_auto_sim_real_n_stan;
pdffit_R_auto_sim_real_n_stan  = AutoFigs4p2.pdffit_R_auto_sim_real_n_stan;

bins_R_auto_sim_real_TBn_stan = AutoFigs4p2.bins_R_auto_sim_real_TBn_stan;
binsfit_R_auto_sim_real_TBn_stan = AutoFigs4p2.binsfit_R_auto_sim_real_TBn_stan;
pdf_R_auto_sim_real_TBn_stan  = AutoFigs4p2.pdf_R_auto_sim_real_TBn_stan;
pdffit_R_auto_sim_real_TBn_stan = AutoFigs4p2.pdffit_R_auto_sim_real_TBn_stan;


AutoFigs4p3 = load('SKAB_analysisTB6.mat','bins_cor2','bins_fit_cor2','pdf_cor2','pdf_fit_cor2','bins_fit_cor2_G','pdf_fit_cor2_G','R_auto_meas2','test_stat_meas2');
bins_cor2  = AutoFigs4p3.bins_cor2;
bins_fit_cor2 = AutoFigs4p3.bins_fit_cor2;
pdf_cor2 = AutoFigs4p3.pdf_cor2;
pdf_fit_cor2 =  AutoFigs4p3.pdf_fit_cor2;
bins_fit_cor2_G =  AutoFigs4p3.bins_fit_cor2_G;
pdf_fit_cor2_G =  AutoFigs4p3.pdf_fit_cor2_G;
R_auto_meas_SKAB_TB =  AutoFigs4p3.R_auto_meas2;
test_stat_meas2 = AutoFigs4p3.test_stat_meas2;

%[bins_cor2{snr_index,1},bins_fit_cor2{snr_index,1}, pdf_cor2{snr_index,1},pdf_fit_cor2{snr_index,1}] = distfit(test_stat_meas2(snr_index,:),Nbins,'pdf','normal');
%[~,bins_fit_cor2_G{snr_index,1}, ~,pdf_fit_cor2_G{snr_index,1}] = distfit(-1*test_stat_meas2(snr_index,:),Nbins,'pdf','extreme value');


Autocorr_ROC_TB = load('SKAB_analysisTB_ROC.mat','Pd_auto_meas','Pd_auto_meas2','Pfa_vec');
Pd_CAB_TB_ROC = Autocorr_ROC_TB.Pd_auto_meas(1:10:end);
Pd_SKAB_TB_ROC = Autocorr_ROC_TB.Pd_auto_meas2(1:10:end);
Pfa_vec = Autocorr_ROC_TB.Pfa_vec(1:10:end);

Autocorr_ROC_TB = load('SKAB_analysisROC6.mat','Pd_SKAB','P_D_SKA2','P_D','Pd_auto_rho','SNR_vec_dB');
Pd_SKAB_theo_ROC = Autocorr_ROC_TB.Pd_SKAB(1:10:end);
Pd_SKAB_sim_ROC = Autocorr_ROC_TB.P_D_SKA2(1:10:end);
Pd_CAB_sim_ROC =  Autocorr_ROC_TB.P_D(1:10:end);
Pd_CAB_theo_ROC = Autocorr_ROC_TB.Pd_auto_rho(1:10:end);
SNR_ROC =  Autocorr_ROC_TB.SNR_vec_dB(1:10:end);

SKAB4 = load('SKAB_analysis4.mat','P_D_SKA2','P_D','Pd_SKAB','Pd_auto_rho','P_D_SKA_WC1','P_D_WC1','R_auto_sim_WC1','SNR_vec_dB','P_D_abs');
Pd_SKAB4_sim = SKAB4.P_D_SKA2;
Pd_CAB4_sim = SKAB4.P_D;
Pd_SKAB4_theo = SKAB4.Pd_SKAB;
Pd_CAB4_theo = SKAB4.Pd_auto_rho; 
Pd_SKAB4_WC_sim = SKAB4.P_D_SKA_WC1;
Pd_CAB4_WC_sim = SKAB4.P_D_WC1;
Pd_abs4 = SKAB4.P_D_abs;
SNR_vec_dB = SKAB4.SNR_vec_dB;


SKAB4TB = load('SKAB_analysisTB4.mat','Pd_auto_meas','Pd_auto_meas2');
Pd_SKAB4_TB = SKAB4TB.Pd_auto_meas2;
Pd_CAB4_TB = SKAB4TB.Pd_auto_meas;

SKAB6 = load('SKAB_analysis6.mat','P_D_SKA2','P_D','Pd_SKAB','Pd_auto_rho','P_D_SKA_WC1','P_D_WC1','R_auto_sim_WC1','P_D_abs');
Pd_SKAB6_sim = SKAB6.P_D_SKA2;
Pd_CAB6_sim = SKAB6.P_D;
Pd_SKAB6_theo = SKAB6.Pd_SKAB;
Pd_CAB6_theo = SKAB6.Pd_auto_rho; 
Pd_SKAB6_WC_sim = SKAB6.P_D_SKA_WC1;
Pd_CAB6_WC_sim = SKAB6.P_D_WC1;
Pd_abs6 = SKAB6.P_D_abs;
R6_WC = SKAB6.R_auto_sim_WC1;

SKAB6TB = load('SKAB_analysisTB6.mat','Pd_auto_meas','Pd_auto_meas2');
Pd_SKAB6_TB = SKAB6TB.Pd_auto_meas2;
Pd_CAB6_TB = SKAB6TB.Pd_auto_meas;


SKAB8 = load('SKAB_analysis8.mat','P_D_SKA2','P_D','Pd_SKAB','Pd_auto_rho','P_D_SKA_WC1','P_D_WC1','R_auto_sim_WC1','P_D_abs');
Pd_SKAB8_sim = SKAB8.P_D_SKA2;
Pd_CAB8_sim = SKAB8.P_D;
Pd_SKAB8_theo = SKAB8.Pd_SKAB;
Pd_CAB8_theo = SKAB8.Pd_auto_rho; 
Pd_SKAB8_WC_sim = SKAB8.P_D_SKA_WC1;
Pd_CAB8_WC_sim = SKAB8.P_D_WC1;
Pd_abs8 = SKAB8.P_D_abs;

SKAB8TB = load('SKAB_analysisTB8.mat','Pd_auto_meas','Pd_auto_meas2');
Pd_SKAB8_TB = SKAB8TB.Pd_auto_meas2;
Pd_CAB8_TB = SKAB8TB.Pd_auto_meas;

SNR_inds = [11,39,60];

cd(cdir)

%% Paramters 
Nbins = 50; 
Leg_FS = 19;
Leg_tick_FS = 8;
Tit_FS = 18;
Tick_FS = 25;
%LW = 3;
%MS = 10;
phase_step = (2*pi)/49;  % purely for plotting/demonstrational purposes.

% Defaults for this blog post
width = 3;     % Width in inches
height = 3;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 11;      % Fontsize
%LW = 1.5;      % LineWidth
LW = 3;
MS = 8;       % MarkerSize

xmin1 = -0.03;
xmax1 = 0.1;
ymin1 = -0.03;
ymax1 = 0.1;
point_limit1 = 500;

xmin2 = -0.05;
xmax2 = 0.1;
ymin2 = 0;
ymax2 = 100;


%% Preallocation
bins_R_auto_sim_real = cell(length(SNRdB2),1);
bins_R_auto_sim_imag = cell(length(SNRdB2),1);
bins_R_auto_sim_imagTB = cell(length(SNRdB2),1);
bins_R_auto_meas_real = cell(length(SNRdB2),1);
bins_R_auto_meas_imag = cell(length(SNRdB2),1);
bins_R_auto_meas_angle = cell(length(SNRdB2),1);

binsfit_R_auto_sim_real = cell(length(SNRdB2),1);
binsfit_R_auto_sim_imag = cell(length(SNRdB2),1);
binsfit_R_auto_meas_real = cell(length(SNRdB2),1);
binsfit_R_auto_meas_imag = cell(length(SNRdB2),1);
binsfit_R_auto_meas_imagTB = cell(length(SNRdB2),1);

pdf_R_auto_sim_real = cell(length(SNRdB2),1); 
pdf_R_auto_sim_imag = cell(length(SNRdB2),1);
pdf_R_auto_meas_real = cell(length(SNRdB2),1); 
pdf_R_auto_meas_imag = cell(length(SNRdB2),1);
pdf_R_auto_meas_angle = cell(length(SNRdB2),1);
pdf_R_auto_meas_angleTB = cell(length(SNRdB2),1);

pdffit_R_auto_sim_real = cell(length(SNRdB2),1); 
pdffit_R_auto_sim_imag = cell(length(SNRdB2),1); 
pdffit_R_auto_meas_real = cell(length(SNRdB2),1); 
pdffit_R_auto_meas_imag = cell(length(SNRdB2),1); 
pdffit_R_auto_meas_imagTB = cell(length(SNRdB2),1);

R_auto_sim_real_norm_par = cell(length(SNRdB2),1); 
R_auto_sim_imag_norm_par = cell(length(SNRdB2),1);
R_auto_meas_real_norm_par = cell(length(SNRdB2),1); 
R_auto_meas_imag_norm_par = cell(length(SNRdB2),1);
R_auto_meas_imag_norm_parTB = cell(length(SNRdB2),1);


P = cell(length(SNRdB2),1); 
B = zeros(length(SNRdB2),1);
K = zeros(length(SNRdB2),1); 
A_sim = zeros(length(SNRdB2),1); 
A_meas = zeros(length(SNRdB2),1); 

bins_WC_real = cell(length(SNR_inds),1);
binsfit_WC_real = cell(length(SNR_inds),1);
pdf_WC_real = cell(length(SNR_inds),1);
pdffit_WC_real = cell(length(SNR_inds),1);
WC_pars_real = cell(length(SNR_inds),1);

bins_WC_imag = cell(length(SNR_inds),1);
binsfit_WC_imag = cell(length(SNR_inds),1);
pdf_WC_imag = cell(length(SNR_inds),1);
pdffit_WC_imag = cell(length(SNR_inds),1);
WC_pars_imag = cell(length(SNR_inds),1);

test_stat_meas2_pars_n = cell(length(SNR_inds),1);
test_stat_meas2_pars_ev = cell(length(SNR_inds),1);



%% Operate on data
diff_comp = (1/(sqrt(2*M_in_algo))) + (j*(1/(sqrt(2*M_in_algo))));
diff_rms = abs(diff_comp);
diff_rms_pow = diff_rms^2;

 for ss = 1:length(SNRdB2) 
% Figures 2-3.    
      [bins_R_auto_sim_real{ss,1},binsfit_R_auto_sim_real{ss,1}, pdf_R_auto_sim_real{ss,1},pdffit_R_auto_sim_real{ss,1},R_auto_sim_real_norm_par{ss,1}] = distfit(real(R_auto_sim(ss,:)),Nbins,'pdf','normal');
      [bins_R_auto_sim_imag{ss,1},binsfit_R_auto_sim_imag{ss,1}, pdf_R_auto_sim_imag{ss,1},pdffit_R_auto_sim_imag{ss,1},R_auto_sim_imag_norm_par{ss,1}] = distfit(imag(R_auto_sim(ss,:)),Nbins,'pdf','normal');
      [bins_R_auto_meas_real{ss,1},binsfit_R_auto_meas_real{ss,1}, pdf_R_auto_meas_real{ss,1},pdffit_R_auto_meas_real{ss,1},R_auto_meas_real_norm_par{ss,1}] = distfit(real(R_auto_meas(ss,:)),Nbins,'pdf','normal');
      [bins_R_auto_meas_imag{ss,1},binsfit_R_auto_meas_imag{ss,1}, pdf_R_auto_meas_imag{ss,1},pdffit_R_auto_meas_imag{ss,1},R_auto_meas_imag_norm_par{ss,1}] = distfit(imag(R_auto_meas(ss,:)),Nbins,'pdf','normal');
      [bins_R_auto_meas_imagTB{ss,1},binsfit_R_auto_meas_imagTB{ss,1}, pdf_R_auto_meas_imagTB{ss,1},pdffit_R_auto_meas_imagTB{ss,1},R_auto_meas_imag_norm_parTB{ss,1}] =  distfit(imag(R_auto_meas_SKAB_TB(ss,:)),10,'pdf','normal');
      [~,~,~,~,test_stat_meas2_pars_n{ss,1}] = distfit(test_stat_meas2(ss,:),Nbins,'pdf','normal');
      [~,~,~,~,test_stat_meas2_pars_ev{ss,1}] = distfit(test_stat_meas2(ss,:),Nbins,'pdf','extreme value');
      
      
      
% Figure 4   
      rho_1(ss) = (T_c/(T_d + T_c))*(10^(SNRdB2(ss)/10))/((10^(SNRdB2(ss)/10)) + 1);
      bins_P = [-pi:phase_step:pi];     
      [P{ss,1},B(ss,1),K(ss,1)] =  ComplexGaussPhasePDF(rho_1(ss), 1/(2*M_in_algo),1/(2*M_in_algo), phase_step); 
      [bins_R_auto_meas_angle{ss,1},~, pdf_R_auto_meas_angle{ss,1},~] = distfit(R_sim_angle(ss,:),Nbins,'pdf','normal');
      A_sim(ss) = (mean(abs(R_auto_sim(ss,:))))^2 - diff_rms_pow; 
      A_meas(ss) = (mean(abs(R_auto_meas(ss,:))))^2 - diff_rms_pow; 
 end
             
[~,~,~,~,test_stat_cor_TBn_par] = distfit(-1*test_stat_cor_TBn,Nbins,'pdf','extreme value');
[~,~,~,~,test_stat_cor_n_par] = distfit(-1*test_stat_cor_n,Nbins,'pdf','extreme value');




for ss = 1:length(SNR_inds) 
    
[bins_WC_real{ss,1},binsfit_WC_real{ss,1},pdf_WC_real{ss,1}, pdffit_WC_real{ss,1},WC_pars_real{ss,1}] = distfit(real(R6_WC(SNR_inds(ss),:)),Nbins,'pdf','normal');
[bins_WC_imag{ss,1},binsfit_WC_imag{ss,1},pdf_WC_imag{ss,1}, pdffit_WC_imag{ss,1},WC_pars_imag{ss,1}] = distfit(imag(R6_WC(SNR_inds(ss),:)),Nbins,'pdf','normal');           
             
             
end             
             
%% Figures.
figure(1)
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

%preserve the size of the image when we save it.
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);



subplot(2,1,1)
plot_CAB_sim_min20dB = plot(R_auto_sim(1,1:point_limit1),'bx','MarkerSize',MS);
hold on; grid on
plot_CAB_sim_0p16dB = plot(R_auto_sim(8,1:point_limit1),'ro','MarkerSize',MS);
plot_CAB_sim_16dB = plot(R_auto_sim(13,1:point_limit1),'g+','MarkerSize',MS);
axis([xmin1, xmax1, ymin1, ymax1]);
handles = [plot_CAB_sim_min20dB, plot_CAB_sim_0p16dB, plot_CAB_sim_16dB];
legend(handles, {'\rho_{F}: SNR = - 20.00dB', '\rho_{F}: SNR = 0.17dB', '\rho_{F}: SNR = 16.16dB'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthEast'); 
title('Figure 1a: \rho_{F} from CAB algorithm (Simulation)','Fontsize',Tit_FS );
xlabel('\Re\{\rho_{F}\}','Fontsize',Tick_FS);
ylabel('\Im\{\rho_{F}\}','Fontsize',Tick_FS);
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)

subplot(2,1,2)
plot_CAB_meas_min20dB = plot(R_auto_meas(1,1:point_limit1),'bx','MarkerSize',MS);
hold on; grid on
plot_CAB_meas_0p16dB = plot(R_auto_meas(8,1:point_limit1),'ro','MarkerSize',MS);
plot_CAB_meas_16dB = plot(R_auto_meas(13,1:point_limit1),'g+','MarkerSize',MS);
axis([xmin1, xmax1, ymin1, ymax1]);
handles = [plot_CAB_meas_min20dB, plot_CAB_meas_0p16dB, plot_CAB_meas_16dB];
legend(handles, {'\rho_{F}: SNR = - 20.00dB', '\rho_{F}: SNR = 0.17dB', '\rho_{F}: SNR = 16.16dB'},'FontSize',Leg_FS,'FontWeight','bold','Location','SouthEast');
title('Figure 1b: \rho_{F} from CAB algorithm (Testbed)','Fontsize',Tit_FS )
xlabel('\Re\{\rho_{F}\}','Fontsize',Tick_FS)
ylabel('\Im\{\rho_{F}\}','Fontsize',Tick_FS)
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)
         
Leg_FS = 17;
Tick_FS = 20;
Tit_FS = 18;

figure(2) 
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

% preserve the size of the image when we save it.
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

subplot(2,2,1)
plot_CAB_sim_min20dB = plot(bins_R_auto_sim_real{1,1}, pdf_R_auto_sim_real{1,1},'-bs','LineWidth',LW-1);
hold on; grid on
plot_CAB_sim_min20dB_fit = plot(binsfit_R_auto_sim_real{1,1}, pdffit_R_auto_sim_real{1,1},'-b','LineWidth',LW-1);
plot_CAB_sim_0p16dB = plot(bins_R_auto_sim_real{8,1}, pdf_R_auto_sim_real{8,1},'-r^','LineWidth',LW-1);
plot_CAB_sim_0p16dB_fit = plot(binsfit_R_auto_sim_real{8,1}, pdffit_R_auto_sim_real{8,1},'--r','LineWidth',LW-1);         
plot_CAB_sim_16dB = plot(bins_R_auto_sim_real{13,1}, pdf_R_auto_sim_real{13,1},'-go','LineWidth',LW-1);
plot_CAB_sim_16dB_fit = plot(binsfit_R_auto_sim_real{13,1}, pdffit_R_auto_sim_real{13,1},':g','LineWidth',LW-1); 
axis([xmin2, 0.2, ymin2, ymax2]);
handles = [plot_CAB_sim_min20dB, plot_CAB_sim_min20dB_fit, plot_CAB_sim_0p16dB,  plot_CAB_sim_0p16dB_fit, plot_CAB_sim_16dB, plot_CAB_sim_16dB_fit];         
legend(handles, {'SNR = - 20.00dB', 'Guassian fit', 'SNR = 0.17dB','Guassian fit', 'SNR = 16.16dB','Guassian fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthEast');         
title('Figure 2a: PDFs of \Re\{\rho_{F}\} from CAB algorithm (Simulation)','Fontsize',Tit_FS );        
xlabel('\Re\{\rho_{F}\}','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x < \Re\{\rho_{F}\} < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)   


subplot(2,2,2)
plot_CAB_sim_min20dB_imag = plot(bins_R_auto_sim_imag{1,1}, pdf_R_auto_sim_imag{1,1},'-bs','LineWidth',LW-1);
hold on; grid on
plot_CAB_sim_min20dB_fit_imag = plot(binsfit_R_auto_sim_imag{1,1}, pdffit_R_auto_sim_imag{1,1},'-b','LineWidth',LW-1);
plot_CAB_sim_0p16dB_imag = plot(bins_R_auto_sim_imag{8,1}, pdf_R_auto_sim_imag{8,1},'-r^','LineWidth',LW-1);
plot_CAB_sim_0p16dB_fit_imag = plot(binsfit_R_auto_sim_imag{8,1}, pdffit_R_auto_sim_imag{8,1},'--r','LineWidth',LW-1);         
plot_CAB_sim_16dB_imag = plot(bins_R_auto_sim_imag{13,1}, pdf_R_auto_sim_imag{13,1},'-go','LineWidth',LW-1);
plot_CAB_sim_16dB_fit_imag = plot(binsfit_R_auto_sim_imag{13,1}, pdffit_R_auto_sim_imag{13,1},':g','LineWidth',LW-1);  
axis([xmin2, 0.2, ymin2, ymax2]);
handles = [plot_CAB_sim_min20dB_imag, plot_CAB_sim_min20dB_fit_imag, plot_CAB_sim_0p16dB_imag,  plot_CAB_sim_0p16dB_fit_imag, plot_CAB_sim_16dB_imag, plot_CAB_sim_16dB_fit_imag];         
legend(handles, {'SNR = - 20.00dB', 'Guassian fit', 'SNR = 0.17dB','Guassian fit', 'SNR = 16.16dB','Guassian fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthEast');         
title('Figure 2b: PDFs of \Im\{\rho_{F}\} from CAB algorithm (Simulation)','Fontsize',Tit_FS );        
xlabel('\Im\{\rho_{F}\}','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x < \Im\{\rho_{F}\} < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS) 




subplot(2,2,3)
plot_CAB_meas_min20dB = plot(bins_R_auto_meas_real{1,1}, pdf_R_auto_meas_real{1,1},'-bs','LineWidth',LW-1);
hold on; grid on
plot_CAB_meas_min20dB_fit = plot(binsfit_R_auto_meas_real{1,1}, pdffit_R_auto_meas_real{1,1},'-b','LineWidth',LW-1);
plot_CAB_meas_0p16dB = plot(bins_R_auto_meas_real{8,1}, pdf_R_auto_meas_real{8,1},'-r^','LineWidth',LW-1);
plot_CAB_meas_0p16dB_fit = plot(binsfit_R_auto_meas_real{8,1}, pdffit_R_auto_meas_real{8,1},'--r','LineWidth',LW-1);         
plot_CAB_meas_16dB = plot(bins_R_auto_meas_real{13,1}, pdf_R_auto_meas_real{13,1},'-go','LineWidth',LW-1);
plot_CAB_meas_16dB_fit = plot(binsfit_R_auto_meas_real{13,1}, pdffit_R_auto_meas_real{13,1},':g','LineWidth',LW-1); 
axis([xmin2, 0.2, ymin2, ymax2]);
handles = [plot_CAB_meas_min20dB, plot_CAB_meas_min20dB_fit, plot_CAB_meas_0p16dB,  plot_CAB_meas_0p16dB_fit, plot_CAB_meas_16dB, plot_CAB_meas_16dB_fit];         
legend(handles, {'SNR = - 20.00dB', 'Guassian fit', 'SNR = 0.17dB','Guassian fit', 'SNR = 16.16dB','Guassian fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthEast');         
title('Figure 2c: PDFs of \Re\{\rho_{F}\} from CAB algorithm (Testbed)','Fontsize',Tit_FS );        
xlabel('\Re\{\rho_{F}\}','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x < \Re\{\rho_{F}\} < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)  


subplot(2,2,4)
plot_CAB_meas_min20dB_imag = plot(bins_R_auto_meas_imag{1,1}, pdf_R_auto_meas_imag{1,1},'-bs','LineWidth',LW-1);
hold on; grid on
plot_CAB_meas_min20dB_fit_imag = plot(binsfit_R_auto_meas_imag{1,1}, pdffit_R_auto_meas_imag{1,1},'-b','LineWidth',LW-1);
plot_CAB_meas_0p16dB_imag = plot(bins_R_auto_meas_imag{8,1}, pdf_R_auto_meas_imag{8,1},'-r^','LineWidth',LW-1);
plot_CAB_meas_0p16dB_fit_imag = plot(binsfit_R_auto_meas_imag{8,1}, pdffit_R_auto_meas_imag{8,1},'--r','LineWidth',LW-1);         
plot_CAB_meas_16dB_imag = plot(bins_R_auto_meas_imag{13,1}, pdf_R_auto_meas_imag{13,1},'-go','LineWidth',LW-1);
plot_CAB_meas_16dB_fit_imag = plot(binsfit_R_auto_meas_imag{13,1}, pdffit_R_auto_meas_imag{13,1},':g','LineWidth',LW-1);  
axis([xmin2, 0.2, ymin2, ymax2]);
handles = [plot_CAB_meas_min20dB_imag, plot_CAB_meas_min20dB_fit_imag, plot_CAB_meas_0p16dB_imag,  plot_CAB_meas_0p16dB_fit_imag, plot_CAB_meas_16dB_imag, plot_CAB_meas_16dB_fit_imag];         
legend(handles, {'SNR = - 20.00dB', 'Guassian fit', 'SNR = 0.17dB','Guassian fit', 'SNR = 16.16dB','Guassian fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthEast');         
title('Figure 2d: PDFs of \Im\{\rho_{F}\} from CAB algorithm (Testbed)','Fontsize',Tit_FS );        
xlabel('\Im\{\rho_{F}\}','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x < \Im\{\rho_{F}\} < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)



figure(3)
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

strA = 'A (Simulation)';
strrho = '$\rho^{2}_{1}$ (Theory, (5))';
strrhof = '$E\left\{|\rho_{F}|^{2}\right\}$ (Simulation)';
%text(0.25,2.5,str,'Interpreter','latex')

%preserve the size of the image when we save it.
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

Unbias_plot = plot(SNR_vec_dB, 10*log10(K_fac_mean),'-bs','MarkerSize',MS+2,'MarkerFaceColor','k');
hold on; grid on;
rho2plot = plot(SNR_vec_dB, 10*log10(rho2),'-r^','MarkerSize',MS+2,'MarkerFaceColor','k');
R_auto_sim_abs_mean_plot = plot(SNR_vec_dB, 20*log10(R_auto_sim_abs_mean),'-go','MarkerSize',MS+2,'MarkerFaceColor','k');
handles = [Unbias_plot,rho2plot,R_auto_sim_abs_mean_plot];
leg = legend(handles, {strA,strrho,strrhof},'FontSize',Leg_FS+6,...
    'FontWeight','bold','Location','SouthEast');
set(leg,'Interpreter','Latex');
xlabel('SNR, [dB]','Fontsize',Tick_FS+6,'FontWeight','bold');
ylabel('Gain, [dB]','Fontsize',Tick_FS+6,'FontWeight','bold');
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)




figure(4) 
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

% preserve the size of the image when we save it.
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

subplot(2,2,1)
Angle_min20_plot = plot(bins_R_auto_meas_angle{1,1}, pdf_R_auto_meas_angle{1,1},'-bs','LineWidth',LW-1);
hold on; grid on;
Angle_min20_plot_fit = plot(bins_P, P{1,1},'-r','LineWidth',LW-1);
axis([-pi, pi, 0, 6]);
handles = [Angle_min20_plot, Angle_min20_plot_fit];         
legend(handles, {'\theta', 'PDF_{\theta} fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthWest');         
title('Figure 4a: PDF of \theta (CAB Simulation), SNR = -20.00 dB','Fontsize',Tit_FS );        
xlabel('\theta','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x < \theta < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)   


subplot(2,2,2)
Angle_min9p14_plot = plot(bins_R_auto_meas_angle{5,1}, pdf_R_auto_meas_angle{5,1},'-bs','LineWidth',LW-1);
hold on; grid on;
Angle_min9p14_plot_fit = plot(bins_P, P{5,1},'-r','LineWidth',LW-1);
axis([-pi, pi, 0, 6]);
handles = [Angle_min9p14_plot, Angle_min9p14_plot_fit];         
legend(handles, {'\theta', 'PDF_{\theta} fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthWest');         
title('Figure 4b: PDF of \theta (CAB Simulation), SNR = -9.14 dB','Fontsize',Tit_FS );        
xlabel('\theta','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x < \theta < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)   





subplot(2,2,3)
Angle_0p17_plot = plot(bins_R_auto_meas_angle{8,1}, pdf_R_auto_meas_angle{8,1},'-bs','LineWidth',LW-1);
hold on; grid on;
Angle_0p17_plot_fit = plot(bins_P, P{8,1},'-r','LineWidth',LW-1);
axis([-pi, pi, 0, 6]);
handles = [Angle_0p17_plot, Angle_0p17_plot_fit];         
legend(handles, {'\theta', 'PDF_{\theta} fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthWest');         
title('Figure 4c: PDF of \theta (CAB Simulation), SNR = 0.17 dB','Fontsize',Tit_FS );        
xlabel('\theta','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x < \theta < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)    


subplot(2,2,4)
Angle_16p16_plot = plot(bins_R_auto_meas_angle{13,1}, pdf_R_auto_meas_angle{13,1},'-bs','LineWidth',LW-1);
hold on; grid on;
Angle_16p16_plot_fit = plot(bins_P, P{13,1},'-r','LineWidth',LW-1);
axis([-pi, pi, 0, 6]);
handles = [Angle_16p16_plot, Angle_16p16_plot_fit];         
legend(handles, {'\theta', 'PDF_{\theta} fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthWest');         
title('Figure 4d: PDF of \theta (CAB Simulation), SNR = 16.16 dB','Fontsize',Tit_FS);        
xlabel('\theta','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x < \theta < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)  



figure(5) 
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

% preserve the size of the image when we save it.
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

subplot(2,2,1)
Sim_noise_CAB_plot = plot(bins_R_auto_sim_real_n_stan, pdf_R_auto_sim_real_n_stan,'-bs','LineWidth',LW-1);
hold on; grid on
Sim_noise_CAB_normfit_plot = plot(binsfit_R_auto_sim_real_n_stan, pdffit_R_auto_sim_real_n_stan,'-r','LineWidth',LW-1);
axis([-0.02, 0.025, 0, 140]);
handles = [Sim_noise_CAB_plot,Sim_noise_CAB_normfit_plot];
legend(handles, {'\rho_{CAB}','Gaussian fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthEast');
title('Figure 6a: PDF of \rho_{CAB} - Simulated AWGN samples.','Fontsize',Tit_FS );
xlabel('\rho','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x < \rho < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)  

subplot(2,2,2)
Meas_noise_CAB_plot = plot(bins_R_auto_sim_real_TBn_stan, pdf_R_auto_sim_real_TBn_stan,'-bs','LineWidth',LW-1);
hold on; grid on
Meas_noise_CAB_normfit_plot = plot(binsfit_R_auto_sim_real_TBn_stan, pdffit_R_auto_sim_real_TBn_stan,'-r','LineWidth',LW-1);
axis([-0.02, 0.025, 0, 140]);
handles = [Meas_noise_CAB_plot,Meas_noise_CAB_normfit_plot];
legend(handles, {'\rho_{CAB}','Gaussian fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthEast');
title('Figure 6b: PDF of \rho_{CAB} - AWGN samples from testbed.','Fontsize',Tit_FS );
xlabel('\rho','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x < \rho < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS) 


subplot(2,2,3)
Sim_noise_SKAB_plot = plot(bins_R_auto_sim_real_n,pdf_R_auto_sim_real_n,'-bs','LineWidth',LW-1);
hold on; grid on
Sim_noise_SKAB_normfit_plot = plot(binsfit_R_auto_sim_real_n, pdffit_R_auto_sim_real_n,'-r','LineWidth',LW-1);
Sim_noise_SKAB_evfit_plot = plot(binsfit_R_auto_sim_real_ev, pdffit_R_auto_sim_real_ev,':g','LineWidth',LW-1); 
axis([-0.02, 0.025, 0, 140]);
handles = [Sim_noise_SKAB_plot,Sim_noise_SKAB_normfit_plot,Sim_noise_SKAB_evfit_plot]; 
legend(handles, {'\rho_{SKAB}','Gaussian fit','Gumbel fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthEast');
title('Figure 6c: PDF of \rho_{SKAB} - Simulated AWGN samples.','Fontsize',Tit_FS );
xlabel('\rho','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x < \rho < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS) 

subplot(2,2,4)
Meas_noise_SKAB_plot = plot(bins_R_auto_sim_real_TBn,pdf_R_auto_sim_real_TBn,'-bs','LineWidth',LW-1);
hold on; grid on
Meas_noise_SKAB_normfit_plot = plot(binsfit_R_auto_sim_real_TBn, pdffit_R_auto_sim_real_TBn,'-r','LineWidth',LW-1);
Meas_noise_SKAB_evfit_plot = plot(binsfit_R_auto_sim_real_TBev, pdffit_R_auto_sim_real_TBev,':g','LineWidth',LW-1);
axis([-0.02, 0.025, 0, 140]);
handles = [Meas_noise_SKAB_plot,Meas_noise_SKAB_normfit_plot,Meas_noise_SKAB_evfit_plot];
legend(handles, {'\rho_{SKAB}','Gaussian fit','Gumbel fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthEast');
title('Figure 6d: PDF of \rho_{SKAB} - AWGN samples from testbed.','Fontsize',Tit_FS );
xlabel('\rho','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x <\theta < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS) 

rho_1 = rho_1.^2;
figure(6)
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

strA = '$E\left\{A\right\}$ (Simulation)';
strrho = '$\rho^{2}_{1}$ (Theory, eqn (5))';
strrhof = '$E\left\{A\right\}$ (Testbed)';
%text(0.25,2.5,str,'Interpreter','latex')

%preserve the size of the image when we save it.
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

A_sim_plot = plot(SNRdB2, A_sim,'-bs','MarkerSize',MS+2,'MarkerFaceColor','k');
hold on; grid on;
A_meas_plot = plot(SNRdB2, A_meas,'-r^','MarkerSize',MS+2,'MarkerFaceColor','k');
rho_one_plot = plot(SNRdB2, rho_1,'-go','MarkerSize',MS+2,'MarkerFaceColor','k');
handles = [A_sim_plot,A_meas_plot,rho_one_plot];
leg = legend(handles, {strA,strrhof,strrho},'FontSize',Leg_FS+6,...
    'FontWeight','bold','Location','SouthEast');
set(leg,'Interpreter','Latex');
xlabel('SNR, [dB]','Fontsize',Tick_FS+6,'FontWeight','bold');
ylabel('Gain','Fontsize',Tick_FS+6,'FontWeight','bold');
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)


figure(7) 
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

% preserve the size of the image when we save it.
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);


bins_cor2  = AutoFigs4p3.bins_cor2;
bins_fit_cor2 = AutoFigs4p3.bins_fit_cor2;
pdf_cor2 = AutoFigs4p3.pdf_cor2;
pdf_fit_cor2 =  AutoFigs4p3.pdf_fit_cor2;
bins_fit_cor2_G =  AutoFigs4p3.bins_fit_cor2_G;
pdf_fit_cor2_G =  AutoFigs4p3.pdf_fit_cor2_G;





subplot(2,2,1)
Meas_SKAB_min20_plot = plot(bins_cor2{1,1}, pdf_cor2{1,1},'-bs','LineWidth',LW-1);
hold on; grid on;
Meas_SKAB_min20_plot_fit_n = plot(bins_fit_cor2{1,1}, pdf_fit_cor2{1,1},'-r','LineWidth',LW-1);
Meas_SKAB_min20_plot_fit_G = plot(bins_fit_cor2_G{1,1}, pdf_fit_cor2_G{1,1},':g','LineWidth',LW-1);
axis([-0.02, 0.095, 0, 130]);
handles = [Meas_SKAB_min20_plot, Meas_SKAB_min20_plot_fit_n, Meas_SKAB_min20_plot_fit_G];         
legend(handles, {'\rho_{SKAB}','Gaussian fit','Gumbel fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthEast');       
title('Figure 7a: PDF of \rho_{SKAB} (Testbed), SNR = -20.00 dB','Fontsize',Tit_FS );        
xlabel('\rho_{SKAB}','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x <\rho_{SKAB} < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)   


subplot(2,2,2)
Meas_SKAB_0p17_plot = plot(bins_cor2{8,1}, pdf_cor2{8,1},'-bs','LineWidth',LW-1);
hold on; grid on;
Meas_SKAB_0p17_plot_fit_n = plot(bins_fit_cor2{8,1}, pdf_fit_cor2{8,1},'-r','LineWidth',LW-1);
Meas_SKAB_0p17_plot_fit_G = plot(bins_fit_cor2_G{8,1}, pdf_fit_cor2_G{8,1},':g','LineWidth',LW-1);
axis([-0.02, 0.095, 0, 130]);
handles = [Meas_SKAB_0p17_plot, Meas_SKAB_0p17_plot_fit_n, Meas_SKAB_0p17_plot_fit_G];         
legend(handles, {'\rho_{SKAB}','Gaussian fit','Gumbel fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthEast');       
title('Figure 7b: PDF of \rho_{SKAB} (Testbed), SNR = 0.17 dB','Fontsize',Tit_FS );        
xlabel('\rho_{SKAB}','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x <\rho_{SKAB} < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)    


subplot(2,2,3)
Meas_SKAB_16p16_plot = plot(bins_cor2{13,1}, pdf_cor2{13,1},'-bs','LineWidth',LW-1);
hold on; grid on;
Meas_SKAB_16p16_plot_fit_n = plot(bins_fit_cor2{13,1}, pdf_fit_cor2{13,1},'-r','LineWidth',LW-1);
Meas_SKAB_16p16_plot_fit_G = plot(bins_fit_cor2_G{13,1}, pdf_fit_cor2_G{13,1},':g','LineWidth',LW-1);
axis([-0.02, 0.095, 0, 130]);
handles = [Meas_SKAB_16p16_plot, Meas_SKAB_16p16_plot_fit_n, Meas_SKAB_16p16_plot_fit_G];         
legend(handles, {'\rho_{SKAB}','Gaussian fit','Gumbel fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthWest');       
title('Figure 7c: PDF of \rho_{SKAB} (Testbed), SNR = 16.16 dB','Fontsize',Tit_FS );        
xlabel('\rho_{SKAB}','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x <\rho_{SKAB} < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)  

subplot(2,2,4)
plot_CAB_meas_min20dB_imagTB = plot(bins_R_auto_meas_imagTB{1,1}, pdf_R_auto_meas_imagTB{1,1},'-bs','LineWidth',LW-1);
hold on; grid on
plot_CAB_meas_min20dB_fit_imagTB = plot(binsfit_R_auto_meas_imagTB{1,1}, pdffit_R_auto_meas_imagTB{1,1},'-b','LineWidth',LW-1);
plot_CAB_meas_0p16dB_imagTB = plot(bins_R_auto_meas_imagTB{8,1}, pdf_R_auto_meas_imagTB{8,1},'-r^','LineWidth',LW-1);
plot_CAB_meas_0p16dB_fit_imagTB = plot(binsfit_R_auto_meas_imagTB{8,1}, pdffit_R_auto_meas_imagTB{8,1},'--r','LineWidth',LW-1);         
plot_CAB_meas_16dB_imagTB = plot(bins_R_auto_meas_imagTB{13,1}, pdf_R_auto_meas_imagTB{13,1},'-go','LineWidth',LW-1);
plot_CAB_meas_16dB_fit_imagTB = plot(binsfit_R_auto_meas_imagTB{13,1}, pdffit_R_auto_meas_imagTB{13,1},':g','LineWidth',LW-1);  
axis([-0.02, 0.095, 0, 130]);
handles = [plot_CAB_meas_min20dB_imagTB, plot_CAB_meas_min20dB_fit_imagTB, plot_CAB_meas_0p16dB_imagTB,  plot_CAB_meas_0p16dB_fit_imagTB, plot_CAB_meas_16dB_imagTB, plot_CAB_meas_16dB_fit_imagTB];         
legend(handles, {'SNR = - 20.00dB', 'Guassian fit', 'SNR = 0.17dB','Guassian fit', 'SNR = 16.16dB','Guassian fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthEast');         
title('Figure 7d: PDFs of \Im\{|\rho_{F}|exp{j\theta}\} (Testbed)','Fontsize',Tit_FS );        
xlabel('\Im\{|\rho_{F}|exp{j\theta}\}','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x < \Im\{|\rho_{F}|exp{j\theta}\} < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)


figure(8) 
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

% preserve the size of the image when we save it.
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

Pd_CAB_theo_ROC_plot = plot(Pfa_vec,Pd_CAB_theo_ROC,'-b','LineWidth',LW-1);
hold on; grid on
Pd_CAB_sim_ROC_plot = plot(Pfa_vec,Pd_CAB_sim_ROC,'-bs','LineWidth',LW-1,'MarkerSize',MS-3);
Pd_CAB_TB_ROC_plot = plot(Pfa_vec,Pd_CAB_TB_ROC,'-b*','LineWidth',LW-1,'MarkerSize',MS-3);
Pd_SKAB_theo_ROC_plot = plot(Pfa_vec,Pd_SKAB_theo_ROC,'--r','LineWidth',LW-1);
Pd_SKAB_sim_ROC_plot =  plot(Pfa_vec,Pd_SKAB_sim_ROC,'--rs','LineWidth',LW-1,'MarkerSize',MS-3);
Pd_SKAB_TB_ROC_plot = plot(Pfa_vec,Pd_SKAB_TB_ROC,'--r*','LineWidth',LW-1,'MarkerSize',MS-3);
WC_plot =  plot(Pfa_vec,Pfa_vec,'-k','LineWidth',LW-1,'MarkerSize',MS-3);

handles = [Pd_CAB_theo_ROC_plot,Pd_CAB_sim_ROC_plot,Pd_CAB_TB_ROC_plot,Pd_SKAB_theo_ROC_plot,Pd_SKAB_sim_ROC_plot,Pd_SKAB_TB_ROC_plot,WC_plot];
legend(handles, {'CAB (Theory)', 'CAB (Sim)', 'CAB (Testbed)','SKAB (Theory)', 'SKAB (Sim)', 'SKAB (Testbed)','Worthless test'},'FontSize',Leg_FS,'FontWeight','bold','Location','SouthEast');  
title('ROC plot for SNR = -9.1376 dB','Fontsize',Tit_FS );      
xlabel('Probability of false alarm, P_{fa}','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('Probability of detection, P_{d}','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)






figure(9) 
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

% preserve the size of the image when we save it.
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

subplot(2,1,1)
plot_CAB_WC_min20dB = plot(R6_WC(11,1:point_limit1),'bx','MarkerSize',MS);
hold on; grid on
plot_CAB_WC_0p16dB = plot(R6_WC(39,1:point_limit1),'ro','MarkerSize',MS);
plot_CAB_WC_16dB = plot(R6_WC(60,1:point_limit1),'g+','MarkerSize',MS);
axis([-0.08, 0.08, -0.1, 0.175]);
handles = [plot_CAB_WC_min20dB, plot_CAB_WC_0p16dB, plot_CAB_WC_16dB];
legend(handles, {'\rho_{F(WC)}: SNR = - 20.00dB', '\rho_{F(WC)}: SNR = 0.17dB', '\rho_{F(WC)}: SNR = 16.16dB'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthEast'); 
title('Figure 10a: \rho_{F(WC)} from CAB algorithm','Fontsize',Tit_FS );
xlabel('\Re\{\rho_{F(WC)}\}','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('\Im\{\rho_{F(WC)}\}','Fontsize',Tick_FS,'FontWeight','bold');
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)

subplot(2,2,3)
plot_CAB_WC_min20dB = plot(bins_WC_real{1,1}, pdf_WC_real{1,1},'-bs','LineWidth',LW-1);
hold on; grid on
%plot_CAB_WC_min20dB_fit = plot(binsfit_WC_real{1,1},  pdffit_WC_real{1,1},'-b','LineWidth',LW-1);
plot_CAB_WC_0p16dB = plot(bins_WC_real{2,1}, pdf_WC_real{2,1},'-r^','LineWidth',LW-1);
%plot_CAB_WC_0p16dB_fit = plot(binsfit_WC_real{2,1},  pdffit_WC_real{2,1},'--r','LineWidth',LW-1);         
plot_CAB_WC_16dB = plot(bins_WC_real{3,1}, pdf_WC_real{3,1},'-go','LineWidth',LW-1);
%plot_CAB_WC_16dB_fit = plot(binsfit_WC_real{3,1},  pdffit_WC_real{3,1},':g','LineWidth',LW-1); 
%axis([xmin2, 0.2, ymin2, ymax2]);
%handles = [plot_CAB_WC_min20dB, plot_CAB_WC_min20dB_fit, plot_CAB_WC_0p16dB,  plot_CAB_WC_0p16dB_fit, plot_CAB_WC_16dB, plot_CAB_WC_16dB_fit]; 
handles = [plot_CAB_WC_min20dB, plot_CAB_WC_0p16dB,  plot_CAB_WC_16dB];
%legend(handles, {'SNR = - 20.00dB', 'Guassian fit', 'SNR = 0.17dB','Guassian fit', 'SNR = 16.16dB','Guassian fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthEast');
legend(handles, {'SNR = - 20.00dB', 'SNR = 0.17dB', 'SNR = 16.16dB'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthEast');
title('Figure 10b: PDFs of \Re\{\rho_{F(WC)}\} from CAB algorithm','Fontsize',Tit_FS );        
xlabel('\Re\{\rho_{F(WC)}\}','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x < \Re\{\rho_{F(WC)}\} < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS)   


subplot(2,2,4)
plot_CAB_WC_min20dB = plot(bins_WC_imag{1,1}, pdf_WC_imag{1,1},'-bs','LineWidth',LW-1);
hold on; grid on
%plot_CAB_WC_min20dB_fit = plot(binsfit_WC_imag{1,1},  pdffit_WC_imag{1,1},'-b','LineWidth',LW-1);
plot_CAB_WC_0p16dB = plot(bins_WC_imag{2,1}, pdf_WC_imag{2,1},'-r^','LineWidth',LW-1);
%plot_CAB_WC_0p16dB_fit = plot(binsfit_WC_imag{2,1},  pdffit_WC_imag{2,1},'--r','LineWidth',LW-1);         
plot_CAB_WC_16dB = plot(bins_WC_imag{3,1}, pdf_WC_imag{3,1},'-go','LineWidth',LW-1);
%plot_CAB_WC_16dB_fit = plot(binsfit_WC_imag{3,1},  pdffit_WC_imag{3,1},':g','LineWidth',LW-1); 
%axis([xmin2, 0.2, ymin2, ymax2]);
%handles = [plot_CAB_WC_min20dB, plot_CAB_WC_min20dB_fit, plot_CAB_WC_0p16dB,  plot_CAB_WC_0p16dB_fit, plot_CAB_WC_16dB, plot_CAB_WC_16dB_fit];
handles = [plot_CAB_WC_min20dB, plot_CAB_WC_0p16dB, plot_CAB_WC_16dB];
%legend(handles, {'SNR = - 20.00dB', 'Guassian fit', 'SNR = 0.17dB','Guassian fit', 'SNR = 16.16dB','Guassian fit'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthEast');     
legend(handles, {'SNR = - 20.00dB', 'SNR = 0.17dB', 'SNR = 16.16dB'},'FontSize',Leg_FS,'FontWeight','bold','Location','NorthEast');
title('Figure 10c: PDFs of \Im\{\rho_{F(WC)}\} from CAB algorithm','Fontsize',Tit_FS );        
xlabel('\Im\{\rho_{F(WC)}\}','Fontsize',Tick_FS,'FontWeight','bold');
ylabel('P(x < \Im\{\rho_{F(WC)}\} < X)','Fontsize',Tick_FS,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS) 



% SKAB4 = load('SKAB_analysis4.mat','P_D_SKA2','P_D','Pd_SKAB','Pd_auto_rho','P_D_SKA_WC1','P_D_WC1','R_auto_sim_WC1','SNR_vec_dB');
% Pd_SKAB4_sim = SKAB4.P_D_SKA2;
% Pd_CAB4_sim = SKAB4.P_D;
% Pd_SKAB4_theo = SKAB4.Pd_SKAB;
% Pd_CAB4_theo = SKAB4.Pd_auto_rho; 
% Pd_SKAB4_WC_sim = SKAB4.P_D_SKA_WC1;
% Pd_CAB4_WC_sim = SKAB4.P_D_WC1;
% SNR_vec_dB = SKAB4.SNR_vec_dB;
% 
% 
% SKAB4TB = load('SKAB_analysisTB4.mat','dec_auto_meas','dec_auto_meas2')
% Pd_SKAB4_TB = SKAB4TB.dec_auto_meas2;
% Pd_CAB4_TB = SKAB4TB.dec_auto_meas;




figure(10)
Pd_CAB4_theo_plot = plot(SNR_vec_dB,Pd_CAB4_theo,'-b','LineWidth',LW-1.5,'MarkerSize',MS); 
hold on; grid on
Pd_CAB4_sim_plot = plot(SNR_vec_dB,Pd_CAB4_sim,'-rs','LineWidth',LW-1.5,'MarkerSize',MS); 
Pd_CAB4_TB_plot = plot(SNRdB2,Pd_CAB4_TB,'-g*','LineWidth',LW-1.5,'MarkerSize',MS);
Pd_CAB4_WC_sim_plot = plot(SNR_vec_dB,Pd_CAB4_WC_sim,'-ko','LineWidth',LW-1.5,'MarkerSize',MS);
Pd_abs4_plot = plot(SNR_vec_dB,Pd_abs4,'-m^','LineWidth',LW-1.5,'MarkerSize',MS); 
Pd_SKAB4_theo_plot = plot(SNR_vec_dB,Pd_SKAB4_theo,'--b','LineWidth',LW-1.5,'MarkerSize',MS); 
Pd_SKAB4_sim_plot = plot(SNR_vec_dB,Pd_SKAB4_sim,'--rs','LineWidth',LW-1.5,'MarkerSize',MS); 
Pd_SKAB4_TB_plot = plot(SNRdB2,Pd_SKAB4_TB,'--g*','LineWidth',LW-1.5,'MarkerSize',MS);
Pd_SKAB4_WC_sim_plot = plot(SNR_vec_dB,Pd_SKAB4_WC_sim,'--ko','LineWidth',LW-1.5,'MarkerSize',MS); 

handles = [Pd_CAB4_theo_plot,Pd_CAB4_sim_plot,Pd_CAB4_TB_plot,Pd_CAB4_WC_sim_plot,Pd_abs4_plot,Pd_SKAB4_theo_plot,Pd_SKAB4_sim_plot,Pd_SKAB4_TB_plot,Pd_SKAB4_WC_sim_plot];  
legend(handles, {'CAB (Theory, eqn. (4))', 'CAB (Sim)', 'CAB (Testbed)','CAB (WC)','CAB (Abs)','SKAB (Theory, eqn. (17))', 'SKAB (Sim)', 'SKAB (Testbed)','SKAB (WC)'},'FontSize',Leg_FS+5,'FontWeight','bold','Location','NorthEast');
title('P_{d} vs SNR for P_{fa} = 0.05 and M = 33920 samples','Fontsize',Tit_FS+5 );        
xlabel('SNR, [dB]','Fontsize',Tick_FS+5,'FontWeight','bold');
ylabel('P_{d}','Fontsize',Tick_FS+5,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS+5)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS+5) 

figure(11)
Pd_CAB6_theo_plot = plot(SNR_vec_dB,Pd_CAB6_theo,'-b','LineWidth',LW-1.5,'MarkerSize',MS); 
hold on; grid on
Pd_CAB6_sim_plot = plot(SNR_vec_dB,Pd_CAB6_sim,'-rs','LineWidth',LW-1.5,'MarkerSize',MS); 
Pd_CAB6_TB_plot = plot(SNRdB2,Pd_CAB6_TB,'-g*','LineWidth',LW-1.5,'MarkerSize',MS);
Pd_CAB6_WC_sim_plot = plot(SNR_vec_dB,Pd_CAB6_WC_sim,'-ko','LineWidth',LW-1.5,'MarkerSize',MS);
Pd_abs6_plot = plot(SNR_vec_dB,Pd_abs6,'-m^','LineWidth',LW-1.5,'MarkerSize',MS); 
Pd_SKAB6_theo_plot = plot(SNR_vec_dB,Pd_SKAB6_theo,'--b','LineWidth',LW-1.5,'MarkerSize',MS); 
Pd_SKAB6_sim_plot = plot(SNR_vec_dB,Pd_SKAB6_sim,'--rs','LineWidth',LW-1.5,'MarkerSize',MS); 
Pd_SKAB6_TB_plot = plot(SNRdB2,Pd_SKAB6_TB,'--g*','LineWidth',LW-1.5,'MarkerSize',MS);
Pd_SKAB6_WC_sim_plot = plot(SNR_vec_dB,Pd_SKAB6_WC_sim,'--ko','LineWidth',LW-1.5,'MarkerSize',MS); 

handles = [Pd_CAB6_theo_plot,Pd_CAB6_sim_plot,Pd_CAB6_TB_plot,Pd_CAB6_WC_sim_plot,Pd_abs6_plot,Pd_SKAB6_theo_plot,Pd_SKAB6_sim_plot,Pd_SKAB6_TB_plot,Pd_SKAB6_WC_sim_plot];  
legend(handles, {'CAB (Theory, eqn. (4))', 'CAB (Sim)', 'CAB (Testbed)','CAB (WC)','CAB (Abs)','SKAB (Theory, eqn. (17))', 'SKAB (Sim)', 'SKAB (Testbed)','SKAB (WC)'},'FontSize',Leg_FS+5,'FontWeight','bold','Location','NorthEast');
title('P_{d} vs SNR for P_{fa} = 0.05 and M = 33920 samples','Fontsize',Tit_FS+5 );        
xlabel('SNR, [dB]','Fontsize',Tick_FS+5,'FontWeight','bold');
ylabel('P_{d}','Fontsize',Tick_FS+5,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS+5)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS+5) 





figure(12)
Pd_CAB8_theo_plot = plot(SNR_vec_dB,Pd_CAB8_theo,'-b','LineWidth',LW-1.5,'MarkerSize',MS); 
hold on; grid on
Pd_CAB8_sim_plot = plot(SNR_vec_dB,Pd_CAB8_sim,'-rs','LineWidth',LW-1.5,'MarkerSize',MS); 
Pd_CAB8_TB_plot = plot(SNRdB2,Pd_CAB8_TB,'-g*','LineWidth',LW-1.5,'MarkerSize',MS);
Pd_CAB8_WC_sim_plot = plot(SNR_vec_dB,Pd_CAB8_WC_sim,'-ko','LineWidth',LW-1.5,'MarkerSize',MS);
Pd_abs8_plot = plot(SNR_vec_dB,Pd_abs8,'-m^','LineWidth',LW-1.5,'MarkerSize',MS); 
Pd_SKAB8_theo_plot = plot(SNR_vec_dB,Pd_SKAB8_theo,'--b','LineWidth',LW-1.5,'MarkerSize',MS); 
Pd_SKAB8_sim_plot = plot(SNR_vec_dB,Pd_SKAB8_sim,'--rs','LineWidth',LW-1.5,'MarkerSize',MS); 
Pd_SKAB8_TB_plot = plot(SNRdB2,Pd_SKAB8_TB,'--g*','LineWidth',LW-1.5,'MarkerSize',MS);
Pd_SKAB8_WC_sim_plot = plot(SNR_vec_dB,Pd_SKAB8_WC_sim,'--ko','LineWidth',LW-1.5,'MarkerSize',MS); 

handles = [Pd_CAB8_theo_plot,Pd_CAB8_sim_plot,Pd_CAB8_TB_plot,Pd_CAB8_WC_sim_plot,Pd_abs8_plot,Pd_SKAB8_theo_plot,Pd_SKAB8_sim_plot,Pd_SKAB8_TB_plot,Pd_SKAB8_WC_sim_plot];  
legend(handles, {'CAB (Theory, eqn. (4))', 'CAB (Sim)', 'CAB (Testbed)','CAB (WC)','CAB (Abs)','SKAB (Theory, eqn. (17))', 'SKAB (Sim)', 'SKAB (Testbed)','SKAB (WC)'},'FontSize',Leg_FS+5,'FontWeight','bold','Location','NorthEast');
title('P_{d} vs SNR for P_{fa} = 0.05 and M = 33920 samples','Fontsize',Tit_FS+5 );        
xlabel('SNR, [dB]','Fontsize',Tick_FS+5,'FontWeight','bold');
ylabel('P_{d}','Fontsize',Tick_FS+5,'FontWeight','bold')        
xt = get(gca,'XTick');
set(gca,'Fontsize',Tick_FS+5)
yt = get(gca,'YTick');
set(gca,'Fontsize',Tick_FS+5) 





