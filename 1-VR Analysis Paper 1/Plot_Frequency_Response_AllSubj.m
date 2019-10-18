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
Coh_TQ_mean = {};
Coh_Body_mean = {};
Gain_TQ_mean = {};
Gain_Body_mean = {};
Coh_TQ_allSubj = [];
Gain_TQ_allSubj = [];
Coh_Body_allSubj = [];
Gain_Body_allSubj = [];


for i = Trials_Data_All.VelCase
    for j = Trials_Data_All.AmpCase
        trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
        TrialTicks{end+1} = trialname;
        XX_ticks(i,j) = trialname;
        for S = 1:Trials_Data_All.SubjNo
            
            VRnldat_decimated = decimate(Trials_All_NLD.VRnldat{1,S}{i,j},dr);  % position input
            TorqueSum_decimated = decimate(Trials_All_NLD.TorqueSum{1,S}{i,j},dr);
            BodyA_decimated = decimate(Trials_All_NLD.BodyA{1,S}{i,j},dr);
            
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
            Gain_Body{1,S}{i,j} = mean(gain_body);
            
            coh_body_nld = coherence(fr_body);
            coh_body = coh_body_nld.dataSet;
            coh_body = coh_body(1:15);
            Coh_Body{1,S}{i,j} = mean(coh_body);
            
            gain_tqSum_nld = gain(fr_tqSum);
            gain_tqSum = gain_tqSum_nld.dataSet;
            gain_tqSum = gain_tqSum(1:15);
            Gain_TQ{1,S}{i,j} = mean(gain_tqSum);
            
            coh_tqSum_nld = coherence(fr_tqSum);
            coh_tqSum = coh_tqSum_nld.dataSet;
            coh_tqSum = coh_tqSum(1:15);
            Coh_TQ{1,S}{i,j} = mean(coh_tqSum);
            
            Coh_TQ_allSubj = [Coh_TQ_allSubj, mean(coh_tqSum)];
            Gain_TQ_allSubj = [Gain_TQ_allSubj, mean(gain_tqSum)];
            Coh_Body_allSubj = [Coh_Body_allSubj, mean(coh_body)];
            Gain_Body_allSubj = [Gain_Body_allSubj, mean(gain_body)];            
        end        
        
        Coh_TQ_mean{i,j} = mean(Coh_TQ_allSubj);
        Gain_TQ_mean{i,j} = mean(Gain_TQ_allSubj);
        Coh_Body_mean{i,j} = mean(Coh_Body_allSubj);
        Gain_Body_mean{i,j} = mean(Gain_Body_allSubj);        
        
        Coh_TQ_allSubj = [];
        Gain_TQ_allSubj = [];
        Coh_Body_allSubj = [];
        Gain_Body_allSubj = [];
        
        figure(FigNo_FR);
        bar(XX_ticks(i,j), Coh_TQ_mean{i,j}); hold on;
        text(XX_ticks(i,j), Coh_TQ_mean{i,j}, num2str(Coh_TQ_mean{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
        
        figure(FigNo_FR+1);
        bar(XX_ticks(i,j), Gain_TQ_mean{i,j}); hold on;
        text(XX_ticks(i,j), Gain_TQ_mean{i,j}, num2str(Gain_TQ_mean{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
        
        figure(FigNo_FR+2);
        bar(XX_ticks(i,j), Coh_Body_mean{i,j}); hold on;
        text(XX_ticks(i,j), Coh_Body_mean{i,j}, num2str(Coh_Body_mean{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
        
        figure(FigNo_FR+3);
        bar(XX_ticks(i,j), Gain_Body_mean{i,j}); hold on;
        text(XX_ticks(i,j), Gain_Body_mean{i,j}, num2str(Gain_Body_mean{i,j}),'vert','bottom','horiz','center', 'FontSize',14);              
        
    end
end

figure(FigNo_FR)
title({'Frequency Response Coherence: VR to Torque Sum', 'Mean data for all Subjects'});
box off
ylim([0 1])
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);hold off

figure(FigNo_FR+1)
title({'Frequency Response Gain: VR to Torque Sum', 'Mean data for all Subjects'});
box off
ylim([0 100])
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);hold off

figure(FigNo_FR+2)
title({'Frequency Response Coherence: VR to Body Angle', 'Mean data for all Subjects'});
box off
ylim([0 1])
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);hold off

figure(FigNo_FR+3)
title({'Frequency Response Gain: VR to Body Angle', 'Mean data for all Subjects'});
box off
ylim([0 100])
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);hold off


%% Separate plots for (Coh vs Amp) and (Coh vs Vel) - Body Angle

FigNo_Coh = length(findobj('type','figure'))+1;
I = 1;
for i = Trials_Data_All.VelCase
    figure(FigNo_Coh+I);
    TrialTicks = {};
    XX_ticks = categorical(TrialTicks);
    XX_ticks = reordercats(XX_ticks, TrialTicks);
    for j = Trials_Data_All.AmpCase
        trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
        XX_ticks(i,j) = trialname;
        bar(XX_ticks(i,j), Coh_Body_mean{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
        text(XX_ticks(i,j), Coh_Body_mean{i,j}, num2str(Coh_Body_mean{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
    end
    title(strcat('Mean Coherence for all subjects vs. Amp for Vel=', num2str(i), 'dps - VR to Body Angle'));
    set(gca, 'LineWidth', 2)
    set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
    ylim([0 1]);
    ylabel('Coherence \gamma_{xy}');
    hold off
    I = I + 1;
end

FigNo_Coh = length(findobj('type','figure'))+1;
I = 1;
for j = Trials_Data_All.AmpCase
    figure(FigNo_Coh+I);
    TrialTicks = {};
    XX_ticks = categorical(TrialTicks);
    XX_ticks = reordercats(XX_ticks, TrialTicks);
    for i = Trials_Data_All.VelCase
        trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
        XX_ticks(i,j) = trialname;
        bar(XX_ticks(i,j), Coh_Body_mean{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
        text(XX_ticks(i,j), Coh_Body_mean{i,j}, num2str(Coh_Body_mean{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
    end
    title(strcat('Mean Coherence for all subjects vs. Vel for Amp=', num2str(j), 'deg - VR to Body Angle'));
    set(gca, 'LineWidth', 2)
    set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
    ylim([0 1]);
    ylabel('Coherence \gamma_{xy}');
    hold off
    I = I + 1;
end

