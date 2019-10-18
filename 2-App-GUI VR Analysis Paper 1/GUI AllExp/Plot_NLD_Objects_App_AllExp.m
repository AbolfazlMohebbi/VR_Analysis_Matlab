global SR

for i = Trials_Data.VelCase
    for j = Trials_Data.AmpCase        
        
        % Plotting the NLDAT objects
        set(0,'DefaultAxesFontSize',16,'DefaultLineLineWidth',1.2,'DefaultAxesXGrid','on','DefaultAxesYGrid','off','DefaultLineMarkerSize',7)
        set(0,'DefaultLineColor','b'); 
        
        t = 0:1/SR:(length(Trials_NLD.TorqueL{i,j})-1)/SR;
        trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg'); 
        
        % Plot VR input vs. Outputs in each subplot
        figure(length(findobj('type','figure'))+1);
        pl5(1) = subplot(221);
        ax = plotyy(t,Trials_NLD.VRnldat{i,j}.dataSet, t, Trials_NLD.TorqueL{i,j}.dataSet-mean(Trials_NLD.TorqueL{i,j}.dataSet));hold on
        title(strcat('VR Input vs. Left Ankle Torque for',{' '}, trialname))
        xlabel('Time (s)')
        ylabel(ax(1), 'VR input angle (Deg)');
        ylabel(ax(2), 'Left Ankle torque (Nm)');
        
        pl5(2) = subplot(223);
        ax = plotyy(t,Trials_NLD.VRnldat{i,j}.dataSet, t, Trials_NLD.TorqueR{i,j}.dataSet-mean(Trials_NLD.TorqueR{i,j}.dataSet));hold on
        title(strcat('VR Input vs. Right Ankle Torque',{' '}, trialname))
        xlabel('Time (s)')
        ylabel(ax(1), 'VR input angle (Deg)');
        ylabel(ax(2), 'Right Ankle torque');
        
        pl5(3) = subplot(222);
        ax = plotyy(t,Trials_NLD.VRnldat{i,j}.dataSet, t, Trials_NLD.shankL{i,j}.dataSet-mean(Trials_NLD.shankL{i,j}.dataSet));hold on
        title(strcat('VR Input vs. Left Shank Angle',{' '}, trialname))
        xlabel('Time (s)')
        ylabel(ax(1), 'VR input angle (Deg)');
        ylabel(ax(2), 'Left Shank Angle (rad)')
        
        pl5(4) = subplot(224);
        ax = plotyy(t,Trials_NLD.VRnldat{i,j}.dataSet, t, Trials_NLD.shankR{i,j}.dataSet-mean(Trials_NLD.shankR{i,j}.dataSet));hold on
        title(strcat('VR Input vs. Right Shank Angle',{' '}, trialname))
        xlabel('Time (s)')
        ylabel(ax(1), 'VR input angle (Deg)');
        ylabel(ax(2), 'Right Shank Angle (rad)')
        
        linkaxes(pl5,'x')
        set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
        
        figure(length(findobj('type','figure'))+1);
        ax = plotyy(t,Trials_NLD.VRnldat{i,j}.dataSet, t, Trials_NLD.BodyA{i,j}.dataSet-mean(Trials_NLD.BodyA{i,j}.dataSet));hold on
        title(strcat('VR Input vs. Body Angle',{' '}, trialname))
        xlabel('Time (s)')
        ylabel(ax(1), 'VR input angle (Deg)');
        ylabel(ax(2), 'Body Angle (rad)');
        set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
        
        figure(length(findobj('type','figure'))+1);
        ax = plotyy(t,Trials_NLD.VRnldat{i,j}.dataSet, t, Trials_NLD.TorqueSum{i,j}.dataSet-mean(Trials_NLD.TorqueSum{i,j}.dataSet));hold on
        title(strcat('VR Input vs. Sum of Ankle Torques',{' '}, trialname))
        xlabel('Time (s)')
        ylabel(ax(1), 'VR input angle (Deg)');
        ylabel(ax(2), 'Sum of Ankle Torques');
        set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
        
        % EMGs
        figure(length(findobj('type','figure'))+1);
        
        pl7(1) = subplot(421);
        ax = plotyy(t,Trials_NLD.VRnldat{i,j}.dataSet, t, Trials_NLD.EMG_LSol{i,j}.dataSet-mean(Trials_NLD.EMG_LSol{i,j}.dataSet));hold on
        xlabel('Time (s)')
        ylabel(ax(1), 'VR input angle (Deg)');
        ylabel(ax(2), 'EMG_{LSol}');
        
        pl7(2) = subplot(423);
        ax = plotyy(t,Trials_NLD.VRnldat{i,j}.dataSet, t, Trials_NLD.EMG_LMG{i,j}.dataSet-mean(Trials_NLD.EMG_LMG{i,j}.dataSet));hold on
        xlabel('Time (s)')
        ylabel(ax(1), 'VR input angle (Deg)');
        ylabel(ax(2), 'EMG_{LMG}');
        
        pl7(3) = subplot(425);
        ax = plotyy(t,Trials_NLD.VRnldat{i,j}.dataSet, t, Trials_NLD.EMG_LLG{i,j}.dataSet-mean(Trials_NLD.EMG_LLG{i,j}.dataSet));hold on
        xlabel('Time (s)')
        ylabel(ax(1), 'VR input angle (Deg)');
        ylabel(ax(2), 'EMG_{LLG}');
        
        pl7(4) = subplot(427);
        ax = plotyy(t,Trials_NLD.VRnldat{i,j}.dataSet, t, Trials_NLD.EMG_LTA{i,j}.dataSet-mean(Trials_NLD.EMG_LTA{i,j}.dataSet));hold on
        xlabel('Time (s)')
        ylabel(ax(1), 'VR input angle (Deg)');
        ylabel(ax(2), 'EMG_{LTA}');
        
        pl7(5) = subplot(422);
        ax = plotyy(t,Trials_NLD.VRnldat{i,j}.dataSet, t, Trials_NLD.EMG_RSol{i,j}.dataSet-mean(Trials_NLD.EMG_RSol{i,j}.dataSet));hold on
        xlabel('Time (s)')
        ylabel(ax(1), 'VR input angle (Deg)');
        ylabel(ax(2), 'EMG_{RSol}');
        
        pl7(6) = subplot(424);
        ax = plotyy(t,Trials_NLD.VRnldat{i,j}.dataSet, t, Trials_NLD.EMG_RMG{i,j}.dataSet-mean(Trials_NLD.EMG_RMG{i,j}.dataSet));hold on
        xlabel('Time (s)')
        ylabel(ax(1), 'VR input angle (Deg)');
        ylabel(ax(2), 'EMG_{RMG}');
        
        pl7(7) = subplot(426);
        ax = plotyy(t,Trials_NLD.VRnldat{i,j}.dataSet, t, Trials_NLD.EMG_RLG{i,j}.dataSet-mean(Trials_NLD.EMG_RLG{i,j}.dataSet));hold on
        xlabel('Time (s)')
        ylabel(ax(1), 'VR input angle (Deg)');
        ylabel(ax(2), 'EMG_{RLG}');
        
        pl7(8) = subplot(428);
        ax = plotyy(t,Trials_NLD.VRnldat{i,j}.dataSet, t, Trials_NLD.EMG_RTA{i,j}.dataSet-mean(Trials_NLD.EMG_RTA{i,j}.dataSet));hold on
        xlabel('Time (s)')
        ylabel(ax(1), 'VR input angle (Deg)');
        ylabel(ax(2), 'EMG_{RTA}');
        
        linkaxes(pl7,'x')
        set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
        %suptitle('VR Input vs. EMGs')
        sgtitle(strcat('VR Input vs. EMGs',{' '}, trialname),'FontSize', 20);
        
    end
end

