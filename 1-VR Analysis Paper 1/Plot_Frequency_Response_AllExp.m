%% Frequency Response

nFFT = 25 * SR;
% nOverlap = nFFT/(2*dr);
nOverlap = 0.6 * nFFT/dr;
TrialTicks = {};
XX_ticks = categorical(TrialTicks);
XX_ticks = reordercats(XX_ticks, TrialTicks);

FigNo_FR = length(findobj('type','figure'))+1;
k = 0;
I = 1;

Coh_TQ = {};
Coh_Body = {};

Gain_TQ = {};
Gain_Body = {};

for i = Trials_Data.VelCase
    figure(FigNo_FR+I);
    figure(FigNo_FR+I+1);
    figure(FigNo_FR+I+2);
    %     figure(FigNo_FR+I+3);
    %     figure(FigNo_FR+I+4);
    %     figure(FigNo_FR+I+5);
    
    TrialTicks = {};
    XX_ticks = categorical(TrialTicks);
    XX_ticks = reordercats(XX_ticks, TrialTicks);
    
    for j = Trials_Data.AmpCase
        trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
        XX_ticks(i,j) = trialname;
        TrialTicks{end+1} = trialname;
        
        VRnldat_decimated = decimate(Trials_NLD.VRnldat{i,j},dr);  % position input
        TorqueSum_decimated = decimate(Trials_NLD.TorqueSum{i,j},dr);
        BodyA_decimated = decimate(Trials_NLD.BodyA{i,j},dr);
        
        % remove mean
        VRnldat_decimated = VRnldat_decimated - mean(VRnldat_decimated);
        TorqueSum_decimated = TorqueSum_decimated - mean(TorqueSum_decimated);
        BodyA_decimated = BodyA_decimated - mean(BodyA_decimated);
        
        vr2body_decimated = cat(2,VRnldat_decimated, BodyA_decimated);
        vr2tqSum_decimated = cat(2,VRnldat_decimated, TorqueSum_decimated);
        fr_body = fresp(vr2body_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap);
        fr_tqSum = fresp(vr2tqSum_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap);
        
        gain_body_nld = gain(fr_body);
        gain_body = gain_body_nld.dataSet;
        gain_body = gain_body(1:15);
        Gain_Body{i,j} = mean(gain_body);
        
        coh_body_nld = coherence(fr_body);
        coh_body = coh_body_nld.dataSet;
        coh_body = coh_body(1:15);
        Coh_Body{i,j} = mean(coh_body);
        
        gain_tqSum_nld = gain(fr_tqSum);
        gain_tqSum = gain_tqSum_nld.dataSet;
        gain_tqSum = gain_tqSum(1:15);
        Gain_TQ{i,j} = mean(gain_tqSum);
        
        coh_tqSum_nld = coherence(fr_tqSum);
        coh_tqSum = coh_tqSum_nld.dataSet;
        coh_tqSum = coh_tqSum(1:15);
        Coh_TQ{i,j} = mean(coh_tqSum);
      
        % Body Angle
        figure(FigNo_FR+I);
        plot(gain(fr_body), 'ymode', 'db', 'LineWidth', 2); hold on
        set(gca, 'XScale', 'log')
        
        figure(FigNo_FR+I+1);
        plot(phase(fr_body)*(180/pi), 'ymode', 'linear', 'LineWidth', 2); hold on
        set(gca, 'XScale', 'log')
        
        figure(FigNo_FR+I+2);
        plot(coherence(fr_body), 'ymode', 'linear', 'LineWidth', 2); hold on
        set(gca, 'XScale', 'log')
        
        %         % Sum Torque
        %         figure(FigNo_FR+I+3);
        %         plot(gain(fr_tqSum), 'ymode', 'db', 'LineWidth', 2); hold on
        %         set(gca, 'XScale', 'log')
        %
        %         figure(FigNo_FR+I+4);
        %         plot(phase(fr_tqSum)*(180/pi), 'ymode', 'linear', 'LineWidth', 2); hold on
        %         set(gca, 'XScale', 'log')
        %
        %         figure(FigNo_FR+I+5);
        %         plot(coherence(fr_tqSum), 'ymode', 'linear', 'LineWidth', 2); hold on
        %         set(gca, 'XScale', 'log')
        
    end
    
    % Body Angle
    figure(FigNo_FR+I);
    title(strcat('Frequency Response Gain vs. Amp for Vel=', num2str(i), 'dps - VR to Body Angle'));
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    legend(TrialTicks)
    hold off;
    
    figure(FigNo_FR+I+1);
    ylabel('Phase (degrees)')
    title(strcat('Frequency Response Phase vs. Amp for Vel=', num2str(i), 'dps - VR to Body Angle'));
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    legend(TrialTicks)
    hold off;
    
    figure(FigNo_FR+I+2);
    ylabel('Coherence \gamma_{xy}')
    title(strcat('Frequency Response Coherence vs. Amp for Vel=', num2str(i), 'dps - VR to Body Angle'));
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    legend(TrialTicks)
    hold off;
    
    %     % Sum Torque
    %     figure(FigNo_FR+I+3);
    %     title(strcat('Frequency Response Gain vs. Amp for Vel=', num2str(i), 'dps - VR to Torque Sum'));
    %     set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    %     hold off;
    %
    %     figure(FigNo_FR+I+4);
    %     ylabel('Phase (degrees)')
    %     title(strcat('Frequency Response Phase vs. Amp for Vel=', num2str(i), 'dps - VR to Torque Sum'));
    %     set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    %     hold off;
    %
    %     figure(FigNo_FR+I+5);
    %     ylabel('Coherence \gamma_{xy}')
    %     title(strcat('Frequency Response Coherence vs. Amp for Vel=', num2str(i), 'dps - VR to Torque Sum'));
    %     set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    %     hold off;
    
    %     I = I + 6;
    I = I + 3;
    
end


FigNo_FR = length(findobj('type','figure'))+1;
k = 0;
I = 1;

for j = Trials_Data.AmpCase
    figure(FigNo_FR+I);
    figure(FigNo_FR+I+1);
    figure(FigNo_FR+I+2);
    %     figure(FigNo_FR+I+3);
    %     figure(FigNo_FR+I+4);
    %     figure(FigNo_FR+I+5);
    
    TrialTicks = {};
    XX_ticks = categorical(TrialTicks);
    XX_ticks = reordercats(XX_ticks, TrialTicks);
    
    for i = Trials_Data.VelCase
        trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
        XX_ticks(i,j) = trialname;
        TrialTicks{end+1} = trialname;
        
        VRnldat_decimated = decimate(Trials_NLD.VRnldat{i,j},dr);  % position input
        TorqueSum_decimated = decimate(Trials_NLD.TorqueSum{i,j},dr);
        BodyA_decimated = decimate(Trials_NLD.BodyA{i,j},dr);
        
        % remove mean
        VRnldat_decimated = VRnldat_decimated - mean(VRnldat_decimated);
        TorqueSum_decimated = TorqueSum_decimated - mean(TorqueSum_decimated);
        BodyA_decimated = BodyA_decimated - mean(BodyA_decimated);
        
        vr2body_decimated = cat(2,VRnldat_decimated, BodyA_decimated);
        vr2tqSum_decimated = cat(2,VRnldat_decimated, TorqueSum_decimated);
        fr_body = fresp(vr2body_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap);
        fr_tqSum = fresp(vr2tqSum_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap);
        
        % Body Angle
        figure(FigNo_FR+I);
        plot(gain(fr_body), 'ymode', 'db', 'LineWidth', 2); hold on
        set(gca, 'XScale', 'log')
        
        figure(FigNo_FR+I+1);
        plot(phase(fr_body)*(180/pi), 'ymode', 'linear', 'LineWidth', 2); hold on
        set(gca, 'XScale', 'log')
        
        figure(FigNo_FR+I+2);
        plot(coherence(fr_body), 'ymode', 'linear', 'LineWidth', 2); hold on
        set(gca, 'XScale', 'log')
        
        %         % Sum Torque
        %         figure(FigNo_FR+I+3);
        %         plot(gain(fr_tqSum), 'ymode', 'db', 'LineWidth', 2); hold on
        %         set(gca, 'XScale', 'log')
        %
        %         figure(FigNo_FR+I+4);
        %         plot(phase(fr_tqSum)*(180/pi), 'ymode', 'linear', 'LineWidth', 2); hold on
        %         set(gca, 'XScale', 'log')
        %
        %         figure(FigNo_FR+I+5);
        %         plot(coherence(fr_tqSum), 'ymode', 'linear', 'LineWidth', 2); hold on
        %         set(gca, 'XScale', 'log')
        
    end
    
    % Body Angle
    figure(FigNo_FR+I);
    title(strcat('Frequency Response Gain vs. Vel for Amp=', num2str(j), 'dps - VR to Body Angle'));
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    legend(TrialTicks)
    hold off;
    
    figure(FigNo_FR+I+1);
    ylabel('Phase (degrees)')
    title(strcat('Frequency Response Phase vs. Vel for Amp=', num2str(j), 'dps - VR to Body Angle'));
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    legend(TrialTicks)
    hold off;
    
    figure(FigNo_FR+I+2);
    ylabel('Coherence \gamma_{xy}')
    title(strcat('Frequency Response Coherence vs. Vel for Amp=', num2str(j), 'dps - VR to Body Angle'));
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    legend(TrialTicks)
    hold off;
    
    %     % Sum Torque
    %     figure(FigNo_FR+I+3);
    %     title(strcat('Frequency Response Gain vs. Vel for Amp=', num2str(j), 'dps - VR to Torque Sum'));
    %     set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    %     hold off;
    %
    %     figure(FigNo_FR+I+4);
    %     ylabel('Phase (degrees)')
    %     title(strcat('Frequency Response Phase vs. Vel for Amp=', num2str(j), 'dps - VR to Torque Sum'));
    %     set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    %     hold off;
    %
    %     figure(FigNo_FR+I+5);
    %     ylabel('Coherence \gamma_{xy}')
    %     title(strcat('Frequency Response Coherence vs. Vel for Amp=', num2str(j), 'dps - VR to Torque Sum'));
    %     set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    %     hold off;
    
    %     I = I + 6;
    I = I + 3;
end


%% Separate plots for (Coh vs Amp) and (Coh vs Vel) - Body Angle

FigNo_Coh = length(findobj('type','figure'))+1;
I = 1;
for i = Trials_Data.VelCase
    figure(FigNo_Coh+I);
    TrialTicks = {};
    XX_ticks = categorical(TrialTicks);
    XX_ticks = reordercats(XX_ticks, TrialTicks);
    for j = Trials_Data.AmpCase
        trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
        XX_ticks(i,j) = trialname;
        bar(XX_ticks(i,j), Coh_Body{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
        text(XX_ticks(i,j), Coh_Body{i,j}, num2str(Coh_Body{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
    end
    title(strcat('Mean Coherence vs. Amp for Vel=', num2str(i), 'dps - VR to Body Angle'));
    set(gca, 'LineWidth', 2)
    set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
    ylim([0 1]);
    ylabel('Coherence \gamma_{xy}');
    hold off
    I = I + 1;
end

FigNo_Coh = length(findobj('type','figure'))+1;
I = 1;
for j = Trials_Data.AmpCase
    figure(FigNo_Coh+I);
    TrialTicks = {};
    XX_ticks = categorical(TrialTicks);
    XX_ticks = reordercats(XX_ticks, TrialTicks);
    for i = Trials_Data.VelCase
        trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
        XX_ticks(i,j) = trialname;
        bar(XX_ticks(i,j), Coh_Body{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
        text(XX_ticks(i,j), Coh_Body{i,j}, num2str(Coh_Body{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
    end
    title(strcat('Mean Coherence vs. Vel for Amp=', num2str(j), 'deg - VR to Body Angle'));
    set(gca, 'LineWidth', 2)
    set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
    ylim([0 1]);
    ylabel('Coherence \gamma_{xy}');
    hold off
    I = I + 1;
end


%% Separate plots for (Coh vs Amp) and (Coh vs Vel) - Torque Sum
% 
% FigNo_Coh = length(findobj('type','figure'))+1;
% I = 1;
% for i = Trials_Data.VelCase
%     figure(FigNo_Coh+I);
%     TrialTicks = {};
%     XX_ticks = categorical(TrialTicks);
%     XX_ticks = reordercats(XX_ticks, TrialTicks);
%     for j = Trials_Data.AmpCase
%         trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
%         XX_ticks(i,j) = trialname;
%         bar(XX_ticks(i,j), Coh_TQ{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
%         text(XX_ticks(i,j), Coh_TQ{i,j}, num2str(Coh_TQ{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
%     end
%     title(strcat('Mean Coherence vs. Amp for Vel=', num2str(i), 'dps - VR to Body Angle'));
%     set(gca, 'LineWidth', 2)
%     set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
%     ylim([0 1]);
%     hold off
%     I = I + 1;
% end
% 
% FigNo_Coh = length(findobj('type','figure'))+1;
% I = 1;
% for j = Trials_Data.AmpCase
%     figure(FigNo_Coh+I);
%     TrialTicks = {};
%     XX_ticks = categorical(TrialTicks);
%     XX_ticks = reordercats(XX_ticks, TrialTicks);
%     for i = Trials_Data.VelCase
%         trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
%         XX_ticks(i,j) = trialname;
%         bar(XX_ticks(i,j), Coh_TQ{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
%         text(XX_ticks(i,j), Coh_TQ{i,j}, num2str(Coh_TQ{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
%     end
%     title(strcat('Mean Coherence vs. Vel for Amp=', num2str(j), 'deg - VR to Body Angle'));
%     set(gca, 'LineWidth', 2)
%     set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
%     ylim([0 1]);
%     hold off
%     I = I + 1;
% end
% 
% 
% 

%% Separate plots for (Gain vs Amp) and (Gain vs Vel) - Body Angle

FigNo_Coh = length(findobj('type','figure'))+1;
I = 1;
for i = Trials_Data.VelCase
    figure(FigNo_Coh+I);
    TrialTicks = {};
    XX_ticks = categorical(TrialTicks);
    XX_ticks = reordercats(XX_ticks, TrialTicks);
    for j = Trials_Data.AmpCase
        trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
        XX_ticks(i,j) = trialname;
        bar(XX_ticks(i,j), Gain_Body{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
        text(XX_ticks(i,j), Gain_Body{i,j}, num2str(Gain_Body{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
    end
    title(strcat('Mean Gain vs. Amp for Vel=', num2str(i), 'dps - VR to Body Angle'));
    set(gca, 'LineWidth', 2)
    set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
    ylim([0 100]);
    ylabel('Gain dB');
    hold off
    I = I + 1;
end

FigNo_Coh = length(findobj('type','figure'))+1;
I = 1;
for j = Trials_Data.AmpCase
    figure(FigNo_Coh+I);
    TrialTicks = {};
    XX_ticks = categorical(TrialTicks);
    XX_ticks = reordercats(XX_ticks, TrialTicks);
    for i = Trials_Data.VelCase
        trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
        XX_ticks(i,j) = trialname;
        bar(XX_ticks(i,j), Gain_Body{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
        text(XX_ticks(i,j), Gain_Body{i,j}, num2str(Gain_Body{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
    end
    title(strcat('Mean Gain vs. Vel for Amp=', num2str(j), 'deg - VR to Body Angle'));
    set(gca, 'LineWidth', 2)
    set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
    ylim([0 100]);
    ylabel('Gain dB');
    hold off
    I = I + 1;
end


%% Separate plots for (Gain vs Amp) and (Gain vs Vel) - Torque Sum
% 
% FigNo_Coh = length(findobj('type','figure'))+1;
% I = 1;
% for i = Trials_Data.VelCase
%     figure(FigNo_Coh+I);
%     TrialTicks = {};
%     XX_ticks = categorical(TrialTicks);
%     XX_ticks = reordercats(XX_ticks, TrialTicks);
%     for j = Trials_Data.AmpCase
%         trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
%         XX_ticks(i,j) = trialname;
%         bar(XX_ticks(i,j), Gain_TQ{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
%         text(XX_ticks(i,j), Gain_TQ{i,j}, num2str(Gain_TQ{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
%     end
%     title(strcat('Mean Gain vs. Amp for Vel=', num2str(i), 'dps - VR to Body Angle'));
%     set(gca, 'LineWidth', 2)
%     set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
%     ylim([0 100]);
%     hold off
%     I = I + 1;
% end
% 
% FigNo_Coh = length(findobj('type','figure'))+1;
% I = 1;
% for j = Trials_Data.AmpCase
%     figure(FigNo_Coh+I);
%     TrialTicks = {};
%     XX_ticks = categorical(TrialTicks);
%     XX_ticks = reordercats(XX_ticks, TrialTicks);
%     for i = Trials_Data.VelCase
%         trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
%         XX_ticks(i,j) = trialname;
%         bar(XX_ticks(i,j), Gain_TQ{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
%         text(XX_ticks(i,j), Gain_TQ{i,j}, num2str(Gain_TQ{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
%     end
%     title(strcat('Mean Gain vs. Vel for Amp=', num2str(j), 'deg - VR to Body Angle'));
%     set(gca, 'LineWidth', 2)
%     set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
%     ylim([0 100]);
%     hold off
%     I = I + 1;
% end
% 
% 
% 







%
%
% for i = Trials_Data.VelCase
%     for j = Trials_Data.AmpCase
%
%         trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
%         TrialTicks{end+1} = trialname;
%         %TrialTicks_arr = [TrialTicks_arr, strcat(num2str(i),'-dps, ', num2str(j), 'deg')];
% %         XX_ticks(end+1) = strcat(num2str(i),'-dps, ', num2str(j), 'deg');
%         XX_ticks(i,j) = trialname;
%
%         VRnldat_decimated = decimate(Trials_NLD.VRnldat{i,j},dr);  % position input
%         % VRnldat_decimated = decimate(ddt(Trials_NLD.VRnldat{i,j}),dr);  % Velocity input
%
%         TorqueR_decimated = decimate(Trials_NLD.TorqueR{i,j},dr);
%         TorqueL_decimated = decimate(Trials_NLD.TorqueL{i,j},dr);
%         ShankR_decimated = decimate(Trials_NLD.shankR{i,j},dr);
%         ShankL_decimated = decimate(Trials_NLD.shankL{i,j},dr);
%         TorqueSum_decimated = decimate(Trials_NLD.TorqueSum{i,j},dr);
%         BodyA_decimated = decimate(Trials_NLD.BodyA{i,j},dr);
%         % BodyA_decimated = decimate(ddt(Trials_NLD{i,j}.BodyA),dr);  % Body Velocity Output
%
%         % remove mean
%         VRnldat_decimated = VRnldat_decimated - mean(VRnldat_decimated);
%         TorqueR_decimated = TorqueR_decimated - mean(TorqueR_decimated);
%         TorqueL_decimated = TorqueL_decimated - mean(TorqueL_decimated);
%         ShankR_decimated = ShankR_decimated - mean(ShankR_decimated);
%         ShankL_decimated = ShankL_decimated - mean(ShankL_decimated);
%         TorqueSum_decimated = TorqueSum_decimated - mean(TorqueSum_decimated);
%         BodyA_decimated = BodyA_decimated - mean(BodyA_decimated);
%
%         vr2tqL_decimated = cat(2,VRnldat_decimated, TorqueL_decimated); % ==>  [VRnldat, TorqueL]
%         vr2tqR_decimated = cat(2,VRnldat_decimated, TorqueR_decimated);
%         vr2shankL_decimated = cat(2,VRnldat_decimated, ShankL_decimated);
%         vr2shankR_decimated = cat(2,VRnldat_decimated, ShankR_decimated);
%         vr2body_decimated = cat(2,VRnldat_decimated, BodyA_decimated);
%         vr2tqSum_decimated = cat(2,VRnldat_decimated, TorqueSum_decimated);
%
%         fr_body = fresp(vr2body_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap);
%         fr_tqSum = fresp(vr2tqSum_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap);
%
%         % Body Angle
%         figure(FigNo_FR)
%         plot(gain(fr_body), 'ymode', 'db', 'LineWidth', 2); hold on
%         set(gca, 'XScale', 'log')
%
%         figure(FigNo_FR+1)
%         plot(phase(fr_body)*(180/pi), 'ymode', 'linear', 'LineWidth', 2); hold on
%         set(gca, 'XScale', 'log')
%
%         figure(FigNo_FR+2)
%         plot(coherence(fr_body), 'ymode', 'linear', 'LineWidth', 2); hold on
%         set(gca, 'XScale', 'log')
%
%         % Sum Torque
%         figure(FigNo_FR+3)
%         plot(gain(fr_tqSum), 'ymode', 'db', 'LineWidth', 2); hold on
%         set(gca, 'XScale', 'log')
%
%         figure(FigNo_FR+4)
%         plot(phase(fr_tqSum)*(180/pi), 'ymode', 'linear', 'LineWidth', 2); hold on
%         set(gca, 'XScale', 'log')
%
%         figure(FigNo_FR+5)
%         plot(coherence(fr_tqSum), 'ymode', 'linear', 'LineWidth', 2); hold on
%         set(gca, 'XScale', 'log')
%     end
% end
%
%
% % Body Angle
% figure(FigNo_FR); legend(TrialTicks);
% title('Frequency Response Gain: VR to Body Angle')
% set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
% hold off;
%
% figure(FigNo_FR+1); legend(TrialTicks);
% ylabel('Phase (degrees)')
% title('Frequency Response Phase: VR to Body Angle')
% set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
% hold off;
%
% figure(FigNo_FR+2); legend(TrialTicks);
% ylabel('Coherence \gamma_{xy}')
% title('Frequency Response Coherence: VR to Body Angle')
% set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
% hold off;
%
% % Sum Torque
% figure(FigNo_FR+3); legend(TrialTicks);
% title('Frequency Response Gain: VR to Torque Sum')
% set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
% hold off;
%
% figure(FigNo_FR+4); legend(TrialTicks);
% ylabel('Phase (degrees)')
% title('Frequency Response Phase: VR to Torque Sum')
% set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
% hold off;
%
% figure(FigNo_FR+5); legend(TrialTicks);
% ylabel('Coherence \gamma_{xy}')
% title('Frequency Response Coherence: VR to Torque Sum')
% set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
% hold off;
%


%% Simulations and VAF
%
% FR_vr2body_sim = nlsim(fr_body, VRnldat_decimated);
% FR_vaf_body = vaf(BodyA_decimated, FR_vr2body_sim);
%
% figure(length(findobj('type','figure'))+1)
% plot(BodyA_decimated);hold on
% plot(FR_vr2body_sim);
% title(['FR Simulated Model vs. Measured Body Angle, VAF = %' num2str(double(FR_vaf_body),2)]);
% legend('Measured','Simulated FR')
% set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
%
%
% FR_vr2tqSum_sim = nlsim(fr_tqSum, VRnldat_decimated);
% FR_vaf_tqSum = vaf(TorqueSum_decimated, FR_vr2tqSum_sim);
% figure(length(findobj('type','figure'))+1)
% plot(TorqueSum_decimated);hold on
% plot(FR_vr2tqSum_sim);
% title(['FR Simulated Model vs. Measured Torque Sum, VAF = %' num2str(double(FR_vaf_tqSum),2)]);
% legend('Measured','Simulated FR')
% set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])









