clear all;
clc; close all;

% Exp = {'TrapZ_2deg_5dps_Tr1', 'TrapZ_2deg_5dps_Tr2', ...
%        'TrapZ_2deg_10dps_Tr1', 'TrapZ_2deg_10dps_Tr2', ...
%        'TrapZ_5deg_5dps_Tr1', 'TrapZ_5deg_5dps_Tr2', ...
%        'TrapZ_5deg_10dps_Tr1', 'TrapZ_5deg_10dps_Tr2', ...
%        'TrapZ_2deg_3dps_Tr1', 'TrapZ_2deg_3dps_Tr2', ...
%        'TrapZ_2deg_6dps_Tr1', 'TrapZ_2deg_6dps_Tr2', ...
%        'TrapZ_5deg_3dps_Tr1', 'TrapZ_5deg_3dps_Tr2', ...
%        'TrapZ_5deg_6dps_Tr1', 'TrapZ_5deg_6dps_Tr2', ...
%        'TrapZ_10deg_3dps_Tr1', 'TrapZ_10deg_3dps_Tr2'};

Left_Torque_VAF = [69, 50, 60, 47, 73, 70, 59, 69, 57, 59, 17, 21, 61, 70, 75, 74, 67, 79];
Right_Torque_VAF =[69, 50, 60, 47, 73, 70, 59, 69, 57, 59, 17, 21, 61, 70, 75, 74, 67, 79];
Left_Shank_VAF =  [65, 55, 54, 44, 66, 64, 57, 68, 66, 41, 21, 27, 43, 52, 78, 66, 62, 79];
Right_Shank_VAF = [61, 58, 44, 41, 67, 67, 57, 68, 68, 48, 16, 17, 54, 63, 80, 69, 70, 82];
TorqueSum_VAF =   [69, 50, 60, 47, 73, 70, 59, 69, 57, 59, 17, 21, 61, 70, 75, 74, 67, 79];
Hip_VAF =         [70, 50, 49, 47, 76, 71, 56, 69, 63, 54, 18, 20, 60, 74, 80, 75, 68, 83];



%% Bar Plots
ExpA =   {'2deg-5dps', ...
          '2deg-10dps', ...
          '5deg-5dps', ...
          '5deg-10dps', ...
          '2deg-3dps', ...
          '2deg-6dps', ...
          '5deg-3dps', ...
          '5deg-6dps', ...
          '10deg-3dps'};

Left_Torque_VAF_Tr1 = [];
Left_Torque_VAF_Tr2 = [];
Right_Torque_VAF_Tr1 = [];
Right_Torque_VAF_Tr2 = [];
Left_Torque_VAF_Tr1 = [];
Left_Torque_VAF_Tr2 = [];
Right_Shank_VAF_Tr1 = [];
Right_Shank_VAF_Tr2 = [];
Left_Shank_VAF_Tr1 = [];
Left_Shank_VAF_Tr2 = [];
TorqueSum_VAF_Tr1 = [];
TorqueSum_VAF_Tr2 = [];
Hip_VAF_Tr1 = [];
Hip_VAF_Tr2 = [];


for i = 1:floor(length(Left_Torque_VAF)/2)
    Left_Torque_VAF_Tr1 = [Left_Torque_VAF_Tr1, Left_Torque_VAF((2*i)-1)];
    Left_Torque_VAF_Tr2 = [Left_Torque_VAF_Tr2, Left_Torque_VAF(2*i)];     
    Right_Torque_VAF_Tr1 = [Right_Torque_VAF_Tr1, Right_Torque_VAF((2*i)-1)];
    Right_Torque_VAF_Tr2 = [Right_Torque_VAF_Tr2, Right_Torque_VAF(2*i)];
    Right_Shank_VAF_Tr1 = [Right_Shank_VAF_Tr1,Right_Shank_VAF((2*i)-1)];
    Right_Shank_VAF_Tr2 = [Right_Shank_VAF_Tr2, Right_Shank_VAF(2*i)];
    Left_Shank_VAF_Tr1 = [Left_Shank_VAF_Tr1, Left_Shank_VAF((2*i)-1)];
    Left_Shank_VAF_Tr2 = [Left_Shank_VAF_Tr2, Left_Shank_VAF(2*i)];
    TorqueSum_VAF_Tr1 = [TorqueSum_VAF_Tr1, TorqueSum_VAF((2*i)-1) ];
    TorqueSum_VAF_Tr2 = [TorqueSum_VAF_Tr2, TorqueSum_VAF(2*i)];
    Hip_VAF_Tr1 = [Hip_VAF_Tr1, Hip_VAF((2*i)-1)];
    Hip_VAF_Tr2 = [Hip_VAF_Tr2, Hip_VAF(2*i)];   
end

figure(1);
bar([Left_Torque_VAF_Tr1; Left_Torque_VAF_Tr2]')
title('Left Torque VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(2);
bar([Right_Torque_VAF_Tr1; Right_Torque_VAF_Tr2]')
title('Right Torque VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22)
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(3);
bar([Left_Shank_VAF_Tr1; Left_Shank_VAF_Tr2]')
title('Left Shank VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(4);
bar([Right_Shank_VAF_Tr1; Right_Shank_VAF_Tr2]')
title('Right Shank VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22)
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(5);
bar([TorqueSum_VAF_Tr1; TorqueSum_VAF_Tr2]')
title('Sum of Torques VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(6);
bar([Hip_VAF_Tr1; Hip_VAF_Tr2]')
title('Hip VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])


%% Plot Amp increasing
   
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

Left_Torque_VAF_Tr1 = [];
Left_Torque_VAF_Tr2 = [];
Right_Torque_VAF_Tr1 = [];
Right_Torque_VAF_Tr2 = [];
Left_Torque_VAF_Tr1 = [];
Left_Torque_VAF_Tr2 = [];
Right_Shank_VAF_Tr1 = [];
Right_Shank_VAF_Tr2 = [];
Left_Shank_VAF_Tr1 = [];
Left_Shank_VAF_Tr2 = [];
TorqueSum_VAF_Tr1 = [];
TorqueSum_VAF_Tr2 = [];
Hip_VAF_Tr1 = [];
Hip_VAF_Tr2 = [];


for i = 1:floor(length(Left_Torque_VAF)/2)
    Left_Torque_VAF_Tr1 = [Left_Torque_VAF_Tr1, Left_Torque_VAF((2*i)-1)];
    Left_Torque_VAF_Tr2 = [Left_Torque_VAF_Tr2, Left_Torque_VAF(2*i)];     
    Right_Torque_VAF_Tr1 = [Right_Torque_VAF_Tr1, Right_Torque_VAF((2*i)-1)];
    Right_Torque_VAF_Tr2 = [Right_Torque_VAF_Tr2, Right_Torque_VAF(2*i)];
    Right_Shank_VAF_Tr1 = [Right_Shank_VAF_Tr1,Right_Shank_VAF((2*i)-1)];
    Right_Shank_VAF_Tr2 = [Right_Shank_VAF_Tr2, Right_Shank_VAF(2*i)];
    Left_Shank_VAF_Tr1 = [Left_Shank_VAF_Tr1, Left_Shank_VAF((2*i)-1)];
    Left_Shank_VAF_Tr2 = [Left_Shank_VAF_Tr2, Left_Shank_VAF(2*i)];
    TorqueSum_VAF_Tr1 = [TorqueSum_VAF_Tr1, TorqueSum_VAF((2*i)-1) ];
    TorqueSum_VAF_Tr2 = [TorqueSum_VAF_Tr2, TorqueSum_VAF(2*i)];
    Hip_VAF_Tr1 = [Hip_VAF_Tr1, Hip_VAF((2*i)-1)];
    Hip_VAF_Tr2 = [Hip_VAF_Tr2, Hip_VAF(2*i)];   
end

figure(7);
plot([Left_Torque_VAF_Tr1; Left_Torque_VAF_Tr2]', 'linewidth' , 3)
title('Left Torque VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(8);
plot([Right_Torque_VAF_Tr1; Right_Torque_VAF_Tr2]', 'linewidth' , 3)
title('Right Torque VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22)
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(9);
plot([Left_Shank_VAF_Tr1; Left_Shank_VAF_Tr2]', 'linewidth' , 3)
title('Left Shank VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(10);
plot([Right_Shank_VAF_Tr1; Right_Shank_VAF_Tr2]', 'linewidth' , 3)
title('Right Shank VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22)
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(11);
plot([TorqueSum_VAF_Tr1; TorqueSum_VAF_Tr2]', 'linewidth' , 3)
title('Sum of Torques VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(12);
plot([Hip_VAF_Tr1; Hip_VAF_Tr2]', 'linewidth' , 3)
title('Hip VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])


%% PRTS No Averaging

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


Left_Torque_VAF_Tr1 = [];
Left_Torque_VAF_Tr2 = [];
Right_Torque_VAF_Tr1 = [];
Right_Torque_VAF_Tr2 = [];
Left_Torque_VAF_Tr1 = [];
Left_Torque_VAF_Tr2 = [];
Right_Shank_VAF_Tr1 = [];
Right_Shank_VAF_Tr2 = [];
Left_Shank_VAF_Tr1 = [];
Left_Shank_VAF_Tr2 = [];
TorqueSum_VAF_Tr1 = [];
TorqueSum_VAF_Tr2 = [];
Hip_VAF_Tr1 = [];
Hip_VAF_Tr2 = [];

for i = 1:floor(length(Left_Torque_VAF)/2)
    Left_Torque_VAF_Tr1 = [Left_Torque_VAF_Tr1, Left_Torque_VAF((2*i)-1)];
    Left_Torque_VAF_Tr2 = [Left_Torque_VAF_Tr2, Left_Torque_VAF(2*i)];     
    Right_Torque_VAF_Tr1 = [Right_Torque_VAF_Tr1, Right_Torque_VAF((2*i)-1)];
    Right_Torque_VAF_Tr2 = [Right_Torque_VAF_Tr2, Right_Torque_VAF(2*i)];
    Right_Shank_VAF_Tr1 = [Right_Shank_VAF_Tr1,Right_Shank_VAF((2*i)-1)];
    Right_Shank_VAF_Tr2 = [Right_Shank_VAF_Tr2, Right_Shank_VAF(2*i)];
    Left_Shank_VAF_Tr1 = [Left_Shank_VAF_Tr1, Left_Shank_VAF((2*i)-1)];
    Left_Shank_VAF_Tr2 = [Left_Shank_VAF_Tr2, Left_Shank_VAF(2*i)];
    TorqueSum_VAF_Tr1 = [TorqueSum_VAF_Tr1, TorqueSum_VAF((2*i)-1) ];
    TorqueSum_VAF_Tr2 = [TorqueSum_VAF_Tr2, TorqueSum_VAF(2*i)];
    Hip_VAF_Tr1 = [Hip_VAF_Tr1, Hip_VAF((2*i)-1)];
    Hip_VAF_Tr2 = [Hip_VAF_Tr2, Hip_VAF(2*i)];   
end

% Plot Bars
figure(13);
bar([Left_Torque_VAF_Tr1; Left_Torque_VAF_Tr2]')
title('Left Torque VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(14);
bar([Right_Torque_VAF_Tr1; Right_Torque_VAF_Tr2]')
title('Right Torque VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22)
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(15);
bar([Left_Shank_VAF_Tr1; Left_Shank_VAF_Tr2]')
title('Left Shank VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(16);
bar([Right_Shank_VAF_Tr1; Right_Shank_VAF_Tr2]')
title('Right Shank VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22)
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(17);
bar([TorqueSum_VAF_Tr1; TorqueSum_VAF_Tr2]')
title('Sum of Torques VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(18);
bar([Hip_VAF_Tr1; Hip_VAF_Tr2]')
title('Hip VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

% plot Amps Increasing
figure(19);
plot([Left_Torque_VAF_Tr1; Left_Torque_VAF_Tr2]', 'linewidth' , 3)
title('Left Torque VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(20);
plot([Right_Torque_VAF_Tr1; Right_Torque_VAF_Tr2]', 'linewidth' , 3)
title('Right Torque VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22)
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(21);
plot([Left_Shank_VAF_Tr1; Left_Shank_VAF_Tr2]', 'linewidth' , 3)
title('Left Shank VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(22);
plot([Right_Shank_VAF_Tr1; Right_Shank_VAF_Tr2]', 'linewidth' , 3)
title('Right Shank VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22)
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(23);
plot([TorqueSum_VAF_Tr1; TorqueSum_VAF_Tr2]', 'linewidth' , 3)
title('Sum of Torques VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(24);
plot([Hip_VAF_Tr1; Hip_VAF_Tr2]', 'linewidth' , 3)
title('Hip VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])



%% PRTS With Averaging

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
      
Left_Torque_VAF_Tr1 = [];
Left_Torque_VAF_Tr2 = [];
Right_Torque_VAF_Tr1 = [];
Right_Torque_VAF_Tr2 = [];
Left_Torque_VAF_Tr1 = [];
Left_Torque_VAF_Tr2 = [];
Right_Shank_VAF_Tr1 = [];
Right_Shank_VAF_Tr2 = [];
Left_Shank_VAF_Tr1 = [];
Left_Shank_VAF_Tr2 = [];
TorqueSum_VAF_Tr1 = [];
TorqueSum_VAF_Tr2 = [];
Hip_VAF_Tr1 = [];
Hip_VAF_Tr2 = [];

for i = 1:floor(length(Left_Torque_VAF)/2)
    Left_Torque_VAF_Tr1 = [Left_Torque_VAF_Tr1, Left_Torque_VAF((2*i)-1)];
    Left_Torque_VAF_Tr2 = [Left_Torque_VAF_Tr2, Left_Torque_VAF(2*i)];     
    Right_Torque_VAF_Tr1 = [Right_Torque_VAF_Tr1, Right_Torque_VAF((2*i)-1)];
    Right_Torque_VAF_Tr2 = [Right_Torque_VAF_Tr2, Right_Torque_VAF(2*i)];
    Right_Shank_VAF_Tr1 = [Right_Shank_VAF_Tr1,Right_Shank_VAF((2*i)-1)];
    Right_Shank_VAF_Tr2 = [Right_Shank_VAF_Tr2, Right_Shank_VAF(2*i)];
    Left_Shank_VAF_Tr1 = [Left_Shank_VAF_Tr1, Left_Shank_VAF((2*i)-1)];
    Left_Shank_VAF_Tr2 = [Left_Shank_VAF_Tr2, Left_Shank_VAF(2*i)];
    TorqueSum_VAF_Tr1 = [TorqueSum_VAF_Tr1, TorqueSum_VAF((2*i)-1) ];
    TorqueSum_VAF_Tr2 = [TorqueSum_VAF_Tr2, TorqueSum_VAF(2*i)];
    Hip_VAF_Tr1 = [Hip_VAF_Tr1, Hip_VAF((2*i)-1)];
    Hip_VAF_Tr2 = [Hip_VAF_Tr2, Hip_VAF(2*i)];   
end

% Plot Bars
figure(25);
bar([Left_Torque_VAF_Tr1; Left_Torque_VAF_Tr2]')
title('Left Torque VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(26);
bar([Right_Torque_VAF_Tr1; Right_Torque_VAF_Tr2]')
title('Right Torque VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22)
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(27);
bar([Left_Shank_VAF_Tr1; Left_Shank_VAF_Tr2]')
title('Left Shank VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(28);
bar([Right_Shank_VAF_Tr1; Right_Shank_VAF_Tr2]')
title('Right Shank VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22)
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(29);
bar([TorqueSum_VAF_Tr1; TorqueSum_VAF_Tr2]')
title('Sum of Torques VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(30);
bar([Hip_VAF_Tr1; Hip_VAF_Tr2]')
title('Hip VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

% plot Amps Increasing
figure(31);
plot([Left_Torque_VAF_Tr1; Left_Torque_VAF_Tr2]', 'linewidth' , 3)
title('Left Torque VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(32);
plot([Right_Torque_VAF_Tr1; Right_Torque_VAF_Tr2]', 'linewidth' , 3)
title('Right Torque VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22)
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(33);
plot([Left_Shank_VAF_Tr1; Left_Shank_VAF_Tr2]', 'linewidth' , 3)
title('Left Shank VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(34);
plot([Right_Shank_VAF_Tr1; Right_Shank_VAF_Tr2]', 'linewidth' , 3)
title('Right Shank VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22)
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(35);
plot([TorqueSum_VAF_Tr1; TorqueSum_VAF_Tr2]', 'linewidth' , 3)
title('Sum of Torques VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(36);
plot([Hip_VAF_Tr1; Hip_VAF_Tr2]', 'linewidth' , 3)
title('Hip VAF', 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExpA); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])













