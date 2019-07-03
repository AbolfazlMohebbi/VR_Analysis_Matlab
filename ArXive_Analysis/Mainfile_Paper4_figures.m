

set(0,'DefaultAxesFontSize',16,'DefaultLineLineWidth',1.2,'DefaultAxesXGrid','on','DefaultAxesYGrid','off','DefaultLineMarkerSize',7)
set(0,'DefaultLineColor','b');

%% figure 1: Sample data of subject 4 madhusun

hf = figure(2);
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

ax1(1) = subplot(4,2,1);  % VR
plot(t,VRnldat.dataSet,'b')
set(ax1(1),'xtick',[])
% ylim([-.04 .04])

ax1(3) = subplot(4,2,3); %Shank
plot(t,shankL.dataSet,'b')
set(ax1(3),'xtick',[])
% ylim([-.04 .04])

ax1(5) = subplot(4,2,5); % Hip
plot(t,HipA.dataSet,'b')
set(ax1(5),'xtick',[])
% ylim([-.04 .04])

ax1(7) = subplot(4,2,7); % Torque
plot(t,TorqueL.dataSet,'b');hold on
set(ax1(7),'XGrid','off')
xlabel('Time (s)')

ax1(2) = subplot(4,2,2); % EMG
plot(t,EMG_LSol.dataSet,'b');hold on
set(ax1(2),'xtick',[])

ax1(4) = subplot(4,2,4);
plot(t, EMG_LMG.dataSet,'b');hold on
set(ax1(4),'xtick',[])

ax1(6) = subplot(4,2,6);
plot(t, EMG_LLG.dataSet,'b');hold on
set(ax1(6),'xtick',[])

ax1(8) = subplot(4,2,8);
plot(t, EMG_LTA.dataSet,'b');hold on
set(ax1(8),'XGrid','off')
xlabel('Time (s)')


ax1(1).YLabel.String = {'VR input angle','(rad)'};
ax1(3).YLabel.String = {'Ankle angle','(rad)'};
ax1(5).YLabel.String = {'Hip angle','(rad)'};
ax1(7).YLabel.String = {'Ankle torque (Nm)','(Nm)'};
ax1(2).YLabel.String = {'SOL EMG','(v)'};
ax1(4).YLabel.String = {'MG EMG','(v)'};
ax1(6).YLabel.String = {'LG EMG','(v)'};
ax1(8).YLabel.String = {'TA EMG','(v)'};
linkaxes(ax1,'x')
xlim([0 max(t)])

verAlign = input('1) top or 2) bottom?');
horAlign = input('1} left or 2) right?');
vertical = {'top','bottom'};
horizontal ={'left','right'};

for i=1:8
    pos{i} = get(ax1(i),'Position');
end
dim = cellfun(@(x) x.*[1 1 1 1], pos, 'uni',0);
labels = {'(A)','(B)','(C)','(D)','(E)','(F)','(G)','(H)','(I)','(J)','(K)','(L)','(M)','(N)','(O)','(P)','(Q)','(R)'};
for i=1:12
    annotation(hf, 'textbox', dim{i}, 'String',labels{i}, 'FitBoxToText','on','verticalalignment', vertical{verAlign},'horizontalalignment', horizontal{horAlign},'FontSize',12,'LineStyle','none');
end
