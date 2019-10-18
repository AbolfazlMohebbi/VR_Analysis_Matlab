%% Decimate: Resample data at a lower rate after lowpass filtering.

nsides = 2;
% nlags = 15 * (SR/dr);
nlags = 10 * (SR/dr);

VAF_TQ = {};
VAF_Body = {};
VAF_TQ_mean = {};
VAF_Body_mean = {};
VAF_TQ_allSubj = [];
VAF_Body_allSubj = [];

TrialTicks = {};
XX_ticks = categorical(TrialTicks);
XX_ticks = reordercats(XX_ticks, TrialTicks);

FigNo_IRF = length(findobj('type','figure'))+1;
k = 0;

for i = Trials_Data_All.VelCase
    for j = Trials_Data_All.AmpCase
        trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
        TrialTicks{end+1} = trialname;
        XX_ticks(i,j) = trialname;
        for S = 1:Trials_Data_All.SubjNo
            
            VRnldat_decimated = decimate(Trials_All_NLD.VRnldat{1,S}{i,j},dr);  % position input
            % VRnldat_decimated = decimate(ddt(Trials_NLD.VRnldat{i,j}),dr);  % Velocity input
            TorqueSum_decimated = decimate(Trials_All_NLD.TorqueSum{1,S}{i,j},dr);
            BodyA_decimated = decimate(Trials_All_NLD.BodyA{1,S}{i,j},dr);
            % BodyA_decimated = decimate(ddt(Trials_NLD{i,j}.BodyA),dr);  % Body Velocity Output
            
            % remove mean
            VRnldat_decimated = VRnldat_decimated - mean(VRnldat_decimated);
            TorqueSum_decimated = TorqueSum_decimated - mean(TorqueSum_decimated);
            BodyA_decimated = BodyA_decimated - mean(BodyA_decimated);
            
            vr2body_decimated = cat(2,VRnldat_decimated, BodyA_decimated);
            vr2tqSum_decimated = cat(2,VRnldat_decimated, TorqueSum_decimated);
            
            irf_vr2body = irf(vr2body_decimated,'nSides',nsides,'nLags',nlags);
            irf_vr2tqSum = irf(vr2tqSum_decimated,'nSides',nsides,'nLags',nlags);
            
            vr2body_sim = nlsim(irf_vr2body,VRnldat_decimated);
            vaf_body = vaf(BodyA_decimated, vr2body_sim);
            
            vr2tqSum_sim = nlsim(irf_vr2tqSum,VRnldat_decimated);
            vaf_tqSum = vaf(TorqueSum_decimated, vr2tqSum_sim);
            
            VAF_TQ{1,S}{i,j} = vaf_tqSum.dataSet;
            VAF_Body{1,S}{i,j} = vaf_body.dataSet;
            
            VAF_TQ_allSubj = [VAF_TQ_allSubj, vaf_tqSum.dataSet];
            VAF_Body_allSubj = [VAF_Body_allSubj, vaf_body.dataSet];
        end
        
        VAF_TQ_mean{i,j} = mean(VAF_TQ_allSubj);
        VAF_Body_mean{i,j} = mean(VAF_Body_allSubj);
        VAF_TQ_allSubj = [];
        VAF_Body_allSubj = [];
        
        figure(FigNo_IRF);
        bar(XX_ticks(i,j), VAF_TQ_mean{i,j}); hold on;
        %bar(XX_ticks(i,j), VAF_TQ{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
        text(XX_ticks(i,j), VAF_TQ_mean{i,j}, num2str(VAF_TQ_mean{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
        
        figure(FigNo_IRF+1);
        bar(XX_ticks(i,j), VAF_Body_mean{i,j}); hold on;
        %bar(XX_ticks(i,j), VAF_Body{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
        text(XX_ticks(i,j), VAF_Body_mean{i,j}, num2str(VAF_Body_mean{i,j}),'vert','bottom','horiz','center', 'FontSize',14);        
    end    
end

figure(FigNo_IRF)
title({'Variance Accounted For (VAF) - VR to Torque Sum', 'Mean data for all Subjects'});
box off
ylim([0 100])
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);hold off

figure(FigNo_IRF+1)
title({'Variance Accounted For (VAF) - VR to Body Angle', 'Mean data for all Subjects'});
box off
ylim([0 100])
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);hold off

%% Separate plots for (VAF vs Amp) and (VAF vs Vel) - Body Angle

FigNo_VAF = length(findobj('type','figure'))+1;
I = 1;
for i = Trials_Data_All.VelCase
    figure(FigNo_VAF+I);
    TrialTicks = {};
    XX_ticks = categorical(TrialTicks);
    XX_ticks = reordercats(XX_ticks, TrialTicks);
    for j = Trials_Data_All.AmpCase
        trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
        XX_ticks(i,j) = trialname;
        bar(XX_ticks(i,j), VAF_Body_mean{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
        text(XX_ticks(i,j), VAF_Body_mean{i,j}, num2str(VAF_Body_mean{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
    end
    title(strcat('mean VAF vs. Amp for Vel=', num2str(i), 'dps - VR to Body Angle'));
    set(gca, 'LineWidth', 2)
    set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
    ylim([0 100]);
    hold off
    I = I + 1;
end

FigNo_VAF = length(findobj('type','figure'))+1;
I = 1;
for j = Trials_Data_All.AmpCase
    figure(FigNo_VAF+I);
    TrialTicks = {};
    XX_ticks = categorical(TrialTicks);
    XX_ticks = reordercats(XX_ticks, TrialTicks);
    for i = Trials_Data_All.VelCase
        trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
        XX_ticks(i,j) = trialname;
        bar(XX_ticks(i,j), VAF_Body_mean{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
        text(XX_ticks(i,j), VAF_Body_mean{i,j}, num2str(VAF_Body_mean{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
    end
    title(strcat('mean VAF vs. Vel for Amp=', num2str(j), 'deg - VR to Body Angle'));
    set(gca, 'LineWidth', 2)
    set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
    ylim([0 100]);
    hold off
    I = I + 1;
end


