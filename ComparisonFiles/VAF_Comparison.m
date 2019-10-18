close all; clc

%% TrapZ

ExperimentTitle = 'TrapZ';

ExpA =   {'2deg-3dps', ...
          '2deg-5dps', ...
          '2deg-6dps', ...
          '2deg-10dps', ...
          '5deg-3dps', ...
          '5deg-5dps', ...
          '5deg-6dps', ...
          '5deg-10dps', ...                   
          '10deg-3dps'};     

Left_Torque_VAF = [57, 59, 69, 50, 17, 21, 60, 47, 61, 70, 73, 70, 75, 74, 59, 69, 67, 79];
Right_Torque_VAF =[57, 59, 69, 50, 17, 21, 60, 47, 61, 70, 73, 70, 75, 74, 59, 69, 67, 79];
Left_Shank_VAF =  [66, 41, 65, 55, 21, 27, 54, 44, 43, 52, 66, 64, 78, 66, 57, 68, 62, 79];
Right_Shank_VAF = [68, 48, 61, 58, 16, 17, 44, 41, 54, 63, 67, 67, 80, 69, 57, 68, 70, 82];
TorqueSum_VAF =   [57, 59, 69, 50, 17, 21, 60, 47, 61, 70, 73, 70, 75, 74, 59, 69, 67, 79];
Hip_VAF =         [63, 54, 70, 50, 18, 20, 49, 47, 60, 74, 76, 71, 80, 75, 56, 69, 68, 83];

mean_TqVAF_TrapZ_2deg = mean(TorqueSum_VAF(1:8));
mean_TqVAF_TrapZ_5deg = mean(TorqueSum_VAF(9:16));
mean_HipVAF_TrapZ_2deg = mean(Hip_VAF(1:8));
mean_HipVAF_TrapZ_5deg = mean(Hip_VAF(9:16));

Plot_VAF_graphs(ExpA, ExperimentTitle, Left_Torque_VAF, Right_Torque_VAF, Left_Shank_VAF, Right_Shank_VAF, TorqueSum_VAF, Hip_VAF)

%% PRTS No Averaging

ExperimentTitle = 'PRTS No Averaging';

ExpA =   {'2deg:dt=0.22s Exp4', ...
          '2deg:dt=0.22s Exp3', ...
          '2deg:dt=0.16s Exp4', ...
          '5deg:dt=0.22s Exp4', ...
          '5deg:dt=0.22s Exp3', ...
          '5deg:dt=0.16s Exp4', ...              
          '10deg:dt=0.22s Exp3'};     

Left_Torque_VAF = [13, 13, 1.8, 4.7, 8.3, 5.8, 15, 21, 47, 48, 28, 25, 43, 24];
Right_Torque_VAF =[13, 13, 1.8, 4.7, 8.3, 5.8, 15, 21, 47, 48, 28, 25, 43, 24];
Left_Shank_VAF =  [9.5, 26, 8, 7.9, 9, 1.0, 8.5, 11, 21, 37, 24, 14, 27, 23];
Right_Shank_VAF = [9.6, 25, 15, 3.7, 7.7, 4.4, 7.5, 11, 33, 41, 24, 10, 36, 12];
TorqueSum_VAF =   [13, 13, 1.8, 4.7, 8.3, 5.8, 15, 21, 47, 48, 28, 25, 43, 24];
Hip_VAF =         [11, 7.4, 2.3, 0.78, 9.5, 1.8, 8.9, 15, 50, 45, 24, 18, 40, 18];

mean_TqVAF_PRTS_2deg = mean(TorqueSum_VAF(1:6));
mean_TqVAF_PRTS_5deg = mean(TorqueSum_VAF(7:12));
mean_HipVAF_PRTS_2deg = mean(Hip_VAF(1:6));
mean_HipVAF_PRTS_5deg = mean(Hip_VAF(7:12));

Plot_VAF_graphs(ExpA, ExperimentTitle, Left_Torque_VAF, Right_Torque_VAF, Left_Shank_VAF, Right_Shank_VAF, TorqueSum_VAF, Hip_VAF)

%% PRTS With Averaging

ExperimentTitle = 'PRTS with Averaging';

ExpA =   {'2deg:dt=0.22s Exp4', ...
          '2deg:dt=0.22s Exp3', ...
          '2deg:dt=0.16s Exp4', ...
          '5deg:dt=0.22s Exp4', ...
          '5deg:dt=0.22s Exp3', ...
          '5deg:dt=0.16s Exp4', ...              
          '10deg:dt=0.22s Exp3'};   

Left_Torque_VAF = [61, 51, 5, 24, 63, 38, 51, 69, 60, 56, 75, 64, 66, 58];
Right_Torque_VAF =[61, 51, 5, 24, 63, 38, 51, 69, 60, 56, 75, 64, 66, 58];
Left_Shank_VAF =  [47, 48, 19, 38, 67, 17, 48, 61, 22, 29, 74, 45, 51, 67];
Right_Shank_VAF = [47, 42, 30, 32, 55, 17, 19, 64, 47, 16, 74, 48, 60, 49];
TorqueSum_VAF =   [61, 51, 5, 24, 63, 38, 51, 69, 60, 56, 75, 64, 66, 58];
Hip_VAF =         [52, 63, 17, 20, 66, 5.7, 62, 70, 66, 53, 76, 62, 66, 51];

mean_TqVAF_PRTSav_2deg = mean(TorqueSum_VAF(1:6));
mean_TqVAF_PRTSav_5deg = mean(TorqueSum_VAF(7:12));
mean_HipVAF_PRTSav_2deg = mean(Hip_VAF(1:6));
mean_HipVAF_PRTSav_5deg = mean(Hip_VAF(7:12));

Plot_VAF_graphs(ExpA, ExperimentTitle, Left_Torque_VAF, Right_Torque_VAF, Left_Shank_VAF, Right_Shank_VAF, TorqueSum_VAF, Hip_VAF)


%% Sum of Sin with Averaging

ExperimentTitle = 'SoS with Averaging';

ExpA =   {'2deg:maxFR=1.5Hz Exp4', ...
          '5deg:maxFR=1.5Hz Exp4'};

Left_Torque_VAF = [65, 22, 64, 56];
Right_Torque_VAF =[65, 22, 64, 56];
Left_Shank_VAF =  [61, 3, 78, 45];
Right_Shank_VAF = [68, 12, 72, 62];
TorqueSum_VAF =   [65, 22, 64, 56];
Hip_VAF =         [64, 8, 66, 70];

mean_TqVAF_SoS_2deg = mean(TorqueSum_VAF(1:2));
mean_TqVAF_SoS_5deg = mean(TorqueSum_VAF(3:4));
mean_HipVAF_SoS_2deg = mean(Hip_VAF(1:2));
mean_HipVAF_SoS_5deg = mean(Hip_VAF(3:4));

Plot_VAF_graphs(ExpA, ExperimentTitle, Left_Torque_VAF, Right_Torque_VAF, Left_Shank_VAF, Right_Shank_VAF, TorqueSum_VAF, Hip_VAF)

%% Compare Experiments

ExpTitles = {'2 deg', '5 deg'};

% Plot Bars
tq_2deg = [mean_TqVAF_TrapZ_2deg, mean_TqVAF_PRTS_2deg, mean_TqVAF_PRTSav_2deg ,mean_TqVAF_SoS_2deg];
tq_5deg = [mean_TqVAF_TrapZ_5deg, mean_TqVAF_PRTS_5deg, mean_TqVAF_PRTSav_5deg ,mean_TqVAF_SoS_5deg];
hip_2deg = [mean_HipVAF_TrapZ_2deg, mean_HipVAF_PRTS_2deg, mean_HipVAF_PRTSav_2deg ,mean_HipVAF_SoS_2deg];
hip_5deg = [mean_HipVAF_TrapZ_5deg, mean_HipVAF_PRTS_5deg, mean_HipVAF_PRTSav_5deg ,mean_HipVAF_SoS_5deg];

figure();
bar([tq_2deg; tq_5deg])
title('Sum of Torques VAF', 'FontSize', 22);hold on
legend('TrapZ','PRTS No Averaging', 'PRTS With Averaging', 'SoS With Averaging', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpTitles); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])


figure();
bar([hip_2deg; hip_5deg])
title('Hip Angle VAF', 'FontSize', 22);hold on
legend('TrapZ','PRTS No Averaging', 'PRTS With Averaging', 'SoS With Averaging', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpTitles); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

%% Save Figures
datestring = datestr(now,'ddmmmyyyy_HH-MM');
FigsPath = strcat('FigLogs/Comparisons/',datestring,'/VAF/');
mkdir(FigsPath);
% SaveAllFigures(FigsPath, '.png');
% close all











