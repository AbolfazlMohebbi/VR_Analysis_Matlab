
%% Plotting the NLDAT objects
set(0,'DefaultAxesFontSize',16,'DefaultLineLineWidth',1.2,'DefaultAxesXGrid','on','DefaultAxesYGrid','off','DefaultLineMarkerSize',7)
set(0,'DefaultLineColor','b');


%% Plot VR input vs. Outputs in each subplot
figure(length(findobj('type','figure'))+1);
pl5(1) = subplot(221);
ax = plotyy(t,Trials_NLD.VRnldat.dataSet, t, Trials_NLD.TorqueL.dataSet-mean(Trials_NLD.TorqueL.dataSet));hold on
title('VR Input vs. Left Ankle Torque')
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (Deg)');
ylabel(ax(2), 'Left Ankle torque (Nm)');

pl5(2) = subplot(223);
ax = plotyy(t,Trials_NLD.VRnldat.dataSet, t, Trials_NLD.TorqueR.dataSet-mean(Trials_NLD.TorqueR.dataSet));hold on
title('VR Input vs. Right Ankle Torque')
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (Deg)');
ylabel(ax(2), 'Right Ankle torque');

pl5(3) = subplot(222);
ax = plotyy(t,Trials_NLD.VRnldat.dataSet, t, Trials_NLD.shankL.dataSet-mean(Trials_NLD.shankL.dataSet));hold on
title('VR Input vs. Left Shank Angle')
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (Deg)');
ylabel(ax(2), 'Left Shank Angle (rad)')

pl5(4) = subplot(224);
ax = plotyy(t,Trials_NLD.VRnldat.dataSet, t, Trials_NLD.shankR.dataSet-mean(Trials_NLD.shankR.dataSet));hold on
title('VR Input vs. Right Shank Angle')
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (Deg)');
ylabel(ax(2), 'Right Shank Angle (rad)')

linkaxes(pl5,'x')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(length(findobj('type','figure'))+1);
ax = plotyy(t,Trials_NLD.VRnldat.dataSet, t, Trials_NLD.BodyA.dataSet-mean(Trials_NLD.BodyA.dataSet));hold on
title('VR Input vs. Body Angle')
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (Deg)');
ylabel(ax(2), 'Body Angle (rad)');
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(length(findobj('type','figure'))+1);
ax = plotyy(t,Trials_NLD.VRnldat.dataSet, t, Trials_NLD.TorqueSum.dataSet-mean(Trials_NLD.TorqueSum.dataSet));hold on
title('VR Input vs. Sum of Ankle Torques')
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (Deg)');
ylabel(ax(2), 'Sum of Ankle Torques');
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

%% EMGs
figure(length(findobj('type','figure'))+1);

pl7(1) = subplot(421);
ax = plotyy(t,Trials_NLD.VRnldat.dataSet, t, Trials_NLD.EMG_LSol.dataSet-mean(Trials_NLD.EMG_LSol.dataSet));hold on
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (Deg)');
ylabel(ax(2), 'EMG_{LSol}');

pl7(2) = subplot(423);
ax = plotyy(t,Trials_NLD.VRnldat.dataSet, t, Trials_NLD.EMG_LMG.dataSet-mean(Trials_NLD.EMG_LMG.dataSet));hold on
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (Deg)');
ylabel(ax(2), 'EMG_{LMG}');

pl7(3) = subplot(425);
ax = plotyy(t,Trials_NLD.VRnldat.dataSet, t, Trials_NLD.EMG_LLG.dataSet-mean(Trials_NLD.EMG_LLG.dataSet));hold on
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (Deg)');
ylabel(ax(2), 'EMG_{LLG}');

pl7(4) = subplot(427);
ax = plotyy(t,Trials_NLD.VRnldat.dataSet, t, Trials_NLD.EMG_LTA.dataSet-mean(Trials_NLD.EMG_LTA.dataSet));hold on
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (Deg)');
ylabel(ax(2), 'EMG_{LTA}');

pl7(5) = subplot(422);
ax = plotyy(t,Trials_NLD.VRnldat.dataSet, t, Trials_NLD.EMG_RSol.dataSet-mean(Trials_NLD.EMG_RSol.dataSet));hold on
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (Deg)');
ylabel(ax(2), 'EMG_{RSol}');

pl7(6) = subplot(424);
ax = plotyy(t,Trials_NLD.VRnldat.dataSet, t, Trials_NLD.EMG_RMG.dataSet-mean(Trials_NLD.EMG_RMG.dataSet));hold on
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (Deg)');
ylabel(ax(2), 'EMG_{RMG}');

pl7(7) = subplot(426);
ax = plotyy(t,Trials_NLD.VRnldat.dataSet, t, Trials_NLD.EMG_RLG.dataSet-mean(Trials_NLD.EMG_RLG.dataSet));hold on
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (Deg)');
ylabel(ax(2), 'EMG_{RLG}');

pl7(8) = subplot(428);
ax = plotyy(t,Trials_NLD.VRnldat.dataSet, t, Trials_NLD.EMG_RTA.dataSet-mean(Trials_NLD.EMG_RTA.dataSet));hold on
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (Deg)');
ylabel(ax(2), 'EMG_{RTA}');

linkaxes(pl7,'x')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
%suptitle('VR Input vs. EMGs')
sgtitle('VR Input vs. EMGs','FontSize', 20);

