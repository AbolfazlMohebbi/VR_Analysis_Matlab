close all; clc

% Comparing the Scenes
Scenes_Tick = {'Nordic Home', 'Rotating Cylinder', 'Moving Room', 'Tunnel' , 'Peterka Replicate'};
PRTS_mean_VAF = [40, 54, 40, 47, 12];
PRTS_mean_Coh = [0.63, 0.58, 0.54, 0.32, 0.11]; 
TrapZ_mean_VAF = [40, 24, 44, 15, 18];
TrapZ_mean_Coh = [0.26, 0.08, 0.28, 0.04, 0.07];
TrapV_mean_VAF = [61, 32, 62, 23, 0];
TrapV_mean_Coh = [0.56, 0.19, 0.62, 0.1, 0];

figure();
bar([PRTS_mean_VAF; TrapZ_mean_VAF; TrapV_mean_VAF]')
title(strcat('Comparison of VR Scenes: VAF%'), 'FontSize', 22);hold on
legend('PRTS', 'TrapZ', 'TrapV', 'Location', 'northeast', 'FontSize', 28);
ylabel('VAF %', 'FontSize', 26);
set(gca, 'XTickLabel', Scenes_Tick); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure();
bar([PRTS_mean_Coh; TrapZ_mean_Coh; TrapV_mean_Coh]')
title(strcat('Comparison of VR Scenes: Coherence'), 'FontSize', 22);hold on
legend('PRTS', 'TrapZ', 'TrapV', 'Location', 'northeast', 'FontSize', 28);
ylabel('Coherence \gamma', 'FontSize', 26);
set(gca, 'XTickLabel', Scenes_Tick); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])


% Nordic Home Scene, PRTS Effect of dt

PRTS_Tick = {'dt=0.1sec', 'dt=0.2sec'};
PRTS_mean_VAF = [6, 52, 57;  % dt = 0.1
                 46, 66, 68]; % dt = 0.2 
PRTS_mean_Coh = [0.25, 0.67, 0.7;
                 0.3, 0.35, 0.71]; 
figure();
bar(PRTS_mean_VAF);
title(strcat('PRTS: Effect of SR (dt) on VAF'), 'FontSize', 22);hold on
legend('2 deg', '5 deg', '10 deg', 'Location', 'northeast', 'FontSize', 28);
ylabel('VAF %', 'FontSize', 26);
set(gca, 'XTickLabel', PRTS_Tick, 'FontSize', 28); 
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure();
bar(PRTS_mean_Coh);
title(strcat('PRTS: Effect of SR (dt) on Coherence'), 'FontSize', 22);hold on
legend('2 deg', '5 deg', '10 deg', 'Location', 'northeast', 'FontSize', 28);
ylabel('Coherence \gamma', 'FontSize', 26);
set(gca, 'XTickLabel', PRTS_Tick, 'FontSize', 28); 
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

% Nordic Home Scene, TrapZ effect of dps
TrapZ_Tick = {'5 dps', '10 dps'};
TrapZ_mean_VAF = [60, 40;  % 5dps
                  45, 35]; % 10dps 
TrapZ_mean_Coh = [0.57, 0.37;
                 0.38, 0.34]; 
             
figure();
bar(TrapZ_mean_VAF);
title(strcat('TrapZ: Effect of Velocity on VAF'), 'FontSize', 22);hold on
legend('Amp = 2 deg', 'Amp = 5 deg', 'Location', 'northeast', 'FontSize', 28);
ylabel('VAF %', 'FontSize', 26);
set(gca, 'XTickLabel', TrapZ_Tick, 'FontSize', 28);
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure();
bar(TrapZ_mean_Coh);
title(strcat('TrapZ: Effect of Velocity on Coherence'), 'FontSize', 22);hold on
legend('Amp = 2 deg', 'Amp = 5 deg', 'Location', 'northeast', 'FontSize', 28);
ylabel('Coherence \gamma', 'FontSize', 26);
set(gca, 'XTickLabel', TrapZ_Tick, 'FontSize', 28);
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

% Nordic Home Scene, TrapV effect of dps
TrapV_Tick = {'5 dps', '10 dps'};
TrapV_mean_VAF = [51, 46, 61;  % 5dps
                  35, 48, 59]; % 10dps 
TrapV_mean_Coh = [0.4, 0.5, 0.55;
                  0.3, 0.45, 0.51];              
figure();
bar(TrapV_mean_VAF);
title(strcat('TrapV: Effect of Velocity on VAF'), 'FontSize', 22);hold on
legend('Amp = 2 deg', 'Amp = 5 deg', 'Amp = 10 deg', 'Location', 'northeast', 'FontSize', 28);
ylabel('VAF %', 'FontSize', 26);
set(gca, 'XTickLabel', TrapV_Tick, 'FontSize', 28);
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
             
figure();
bar(TrapV_mean_Coh);
title(strcat('TrapZ: Effect of Velocity on Coherence'), 'FontSize', 22);hold on
legend('Amp = 2 deg', 'Amp = 5 deg', 'Amp = 10 deg', 'Location', 'northeast', 'FontSize', 28);
ylabel('Coherence \gamma', 'FontSize', 26);
set(gca, 'XTickLabel', TrapV_Tick, 'FontSize', 28);
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])


%% Save Figures
datestring = datestr(now,'ddmmmyyyy_HH-MM');
FigsPath = strcat('FigLogs/Comparisons/',datestring,'/');
mkdir(FigsPath);
SaveAllFigures(FigsPath, '.png');























