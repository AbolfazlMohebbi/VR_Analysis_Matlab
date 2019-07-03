function Plot_VAF_graphs(ExperimentTicks, ExperimentTitle, Left_Torque_VAF, Right_Torque_VAF, Left_Shank_VAF, Right_Shank_VAF, TorqueSum_VAF, Hip_VAF)

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
figure();
bar([Left_Torque_VAF_Tr1; Left_Torque_VAF_Tr2]')
title(strcat(ExperimentTitle, ': ', ' Left Torque VAF'), 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExperimentTicks); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure();
bar([Right_Torque_VAF_Tr1; Right_Torque_VAF_Tr2]')
title(strcat(ExperimentTitle, ': ', ' Right Torque VAF'), 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22)
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExperimentTicks); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure();
bar([Left_Shank_VAF_Tr1; Left_Shank_VAF_Tr2]')
title(strcat(ExperimentTitle, ': ', ' Left Shank VAF'), 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExperimentTicks); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure();
bar([Right_Shank_VAF_Tr1; Right_Shank_VAF_Tr2]')
title(strcat(ExperimentTitle, ': ', ' Right Shank VAF'), 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22)
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExperimentTicks); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure();
bar([TorqueSum_VAF_Tr1; TorqueSum_VAF_Tr2]')
title(strcat(ExperimentTitle, ': ', ' Sum of Torques VAF'), 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExperimentTicks); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure();
bar([Hip_VAF_Tr1; Hip_VAF_Tr2]')
title(strcat(ExperimentTitle, ': ', ' Hip VAF'), 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExperimentTicks); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

% plot Amps Increasing
figure();
plot([Left_Torque_VAF_Tr1; Left_Torque_VAF_Tr2]', 'linewidth' , 3)
title(strcat(ExperimentTitle, ': ', ' Left Torque VAF'), 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExperimentTicks); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure();
plot([Right_Torque_VAF_Tr1; Right_Torque_VAF_Tr2]', 'linewidth' , 3)
title(strcat(ExperimentTitle, ': ', ' Right Torque VAF'), 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22)
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExperimentTicks); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure();
plot([Left_Shank_VAF_Tr1; Left_Shank_VAF_Tr2]', 'linewidth' , 3)
title(strcat(ExperimentTitle, ': ', ' Left Shank VAF'), 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExperimentTicks); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure();
plot([Right_Shank_VAF_Tr1; Right_Shank_VAF_Tr2]', 'linewidth' , 3)
title(strcat(ExperimentTitle, ': ', ' Right Shank VAF'), 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22)
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExperimentTicks); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure();
plot([TorqueSum_VAF_Tr1; TorqueSum_VAF_Tr2]', 'linewidth' , 3)
title(strcat(ExperimentTitle, ': ', ' Sum of Torques VAF'), 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExperimentTicks); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure();
plot([Hip_VAF_Tr1; Hip_VAF_Tr2]', 'linewidth' , 3)
title(strcat(ExperimentTitle, ': ', ' Hip VAF'), 'FontSize', 22);hold on
legend('Trial 1','Trial 2', 'Location', 'southeast', 'FontSize', 22);
ylabel('VAF %', 'FontSize', 22);
set(gca, 'XTickLabel', ExperimentTicks); xtickangle(gca,45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

end

