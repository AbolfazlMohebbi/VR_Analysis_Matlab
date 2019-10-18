%% Decimate: Resample data at a lower rate after lowpass filtering.

irf_gui = input('Would you like to use GUI to draw the IRF of Body Angle and Torque Sum? \n 1) YES\n 2) NO \n');
bPlotSim = input('Would you like to show IRF Simulations? \n 1) YES\n 2) NO \n');

nsides = 2;
% nlags = 15 * (SR/dr);
nlags = 10 * (SR/dr);

VAF_TQ = {};
VAF_Body = {};
TrialTicks = {};
XX_ticks = categorical(TrialTicks);
XX_ticks = reordercats(XX_ticks, TrialTicks);

FigNo_IRF = length(findobj('type','figure'))+1;
k = 0;

for i = Trials_Data.VelCase
    for j = Trials_Data.AmpCase 
        
        trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg'); 
        TrialTicks{end+1} = trialname;          
        %TrialTicks_arr = [TrialTicks_arr, strcat(num2str(i),'-dps, ', num2str(j), 'deg')];
%         XX_ticks(end+1) = strcat(num2str(i),'-dps, ', num2str(j), 'deg');
        XX_ticks(i,j) = trialname;
        
        VRnldat_decimated = decimate(Trials_NLD.VRnldat{i,j},dr);  % position input
        % VRnldat_decimated = decimate(ddt(Trials_NLD.VRnldat{i,j}),dr);  % Velocity input
        
        TorqueR_decimated = decimate(Trials_NLD.TorqueR{i,j},dr);
        TorqueL_decimated = decimate(Trials_NLD.TorqueL{i,j},dr);
        ShankR_decimated = decimate(Trials_NLD.shankR{i,j},dr);
        ShankL_decimated = decimate(Trials_NLD.shankL{i,j},dr);
        TorqueSum_decimated = decimate(Trials_NLD.TorqueSum{i,j},dr);
        BodyA_decimated = decimate(Trials_NLD.BodyA{i,j},dr);
        % BodyA_decimated = decimate(ddt(Trials_NLD{i,j}.BodyA),dr);  % Body Velocity Output
        
        % remove mean
        VRnldat_decimated = VRnldat_decimated - mean(VRnldat_decimated);
        TorqueR_decimated = TorqueR_decimated - mean(TorqueR_decimated);
        TorqueL_decimated = TorqueL_decimated - mean(TorqueL_decimated);
        ShankR_decimated = ShankR_decimated - mean(ShankR_decimated);
        ShankL_decimated = ShankL_decimated - mean(ShankL_decimated);
        TorqueSum_decimated = TorqueSum_decimated - mean(TorqueSum_decimated);
        BodyA_decimated = BodyA_decimated - mean(BodyA_decimated);
        

        vr2tqL_decimated = cat(2,VRnldat_decimated, TorqueL_decimated); % ==>  [VRnldat, TorqueL]
        vr2tqR_decimated = cat(2,VRnldat_decimated, TorqueR_decimated);
        vr2shankL_decimated = cat(2,VRnldat_decimated, ShankL_decimated);
        vr2shankR_decimated = cat(2,VRnldat_decimated, ShankR_decimated);
        vr2body_decimated = cat(2,VRnldat_decimated, BodyA_decimated);
        vr2tqSum_decimated = cat(2,VRnldat_decimated, TorqueSum_decimated);     
        
        irf_vr2tqL = irf(vr2tqL_decimated,'nSides',nsides,'nLags',nlags);
        irf_vr2tqR = irf(vr2tqR_decimated,'nSides',nsides,'nLags',nlags);
        irf_vr2shankL = irf(vr2shankL_decimated,'nSides',nsides,'nLags',nlags);
        irf_vr2shankR = irf(vr2shankR_decimated,'nSides',nsides,'nLags',nlags);           
        
        if (irf_gui==1)
            irf_vr2body = irf(vr2body_decimated,'nSides',nsides,'nLags',nlags);
            set(irf_vr2body,'irfPseudoInvMode','manual', 'irfFigNum', length(findobj('type','figure'))+1 );
            irf_vr2body = nlident(irf_vr2body, vr2body_decimated,'nSides', nsides,'nLags', nlags); close;
            set(irf_vr2body, 'nSides', 1, 'nLags', nlags, 'domainStart', 0);
            I = irf_vr2body.dataSet; I = I(floor(length(irf_vr2body)/2) + 1 : end); irf_vr2body.dataSet = I;
            
            irf_vr2tqSum = irf(vr2tqSum_decimated,'nSides',nsides,'nLags',nlags);
            set(irf_vr2tqSum,'irfPseudoInvMode','manual', 'irfFigNum', length(findobj('type','figure'))+1 );
            irf_vr2tqSum = nlident(irf_vr2tqSum, vr2tqSum_decimated,'nSides', nsides,'nLags', nlags); close;
            set(irf_vr2tqSum, 'nSides', 1, 'nLags', nlags, 'domainStart', 0);
            I = irf_vr2tqSum.dataSet; I = I(floor(length(irf_vr2tqSum)/2) + 1 : end); irf_vr2tqSum.dataSet = I;
        else
            irf_vr2body = irf(vr2body_decimated,'nSides',nsides,'nLags',nlags);
            irf_vr2tqSum = irf(vr2tqSum_decimated,'nSides',nsides,'nLags',nlags);
        end        
        
        figure(FigNo_IRF) 
        plot(irf_vr2body); hold on 
        set(gca, 'LineWidth', 2)
        
        figure(FigNo_IRF+1)
        plot(irf_vr2tqSum);hold on
        set(gca, 'LineWidth', 2)
        
        vr2tqL_sim = nlsim(irf_vr2tqL,VRnldat_decimated);
        vaf_tqL = vaf(TorqueL_decimated, vr2tqL_sim);
        
        vr2tqR_sim = nlsim(irf_vr2tqR,VRnldat_decimated);
        vaf_tqR = vaf(TorqueR_decimated, vr2tqR_sim);
        
        vr2shankL_sim = nlsim(irf_vr2shankL,VRnldat_decimated);
        vaf_shankL = vaf(ShankL_decimated, vr2shankL_sim);
        
        vr2shankR_sim = nlsim(irf_vr2shankR,VRnldat_decimated);
        vaf_shankR = vaf(ShankR_decimated, vr2shankR_sim);
        
        vr2body_sim = nlsim(irf_vr2body,VRnldat_decimated);
        vaf_body = vaf(BodyA_decimated, vr2body_sim);
        
        vr2tqSum_sim = nlsim(irf_vr2tqSum,VRnldat_decimated);
        vaf_tqSum = vaf(TorqueSum_decimated, vr2tqSum_sim);
        
        VAF_TQ{i,j} = vaf_tqSum.dataSet;
        VAF_Body{i,j} = vaf_body.dataSet;
        
        figure(FigNo_IRF+2);
        bar(XX_ticks(i,j), VAF_TQ{i,j}); hold on;
        %bar(XX_ticks(i,j), VAF_TQ{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
        text(XX_ticks(i,j), VAF_TQ{i,j}, num2str(VAF_TQ{i,j}),'vert','bottom','horiz','center', 'FontSize',14); 
        
        figure(FigNo_IRF+3);
        bar(XX_ticks(i,j), VAF_Body{i,j}); hold on;
        %bar(XX_ticks(i,j), VAF_Body{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
        text(XX_ticks(i,j), VAF_Body{i,j}, num2str(VAF_Body{i,j}),'vert','bottom','horiz','center', 'FontSize',14); 
        
        if (bPlotSim == 1)            
            figure(FigNo_IRF+4+k)
            plot(TorqueSum_decimated);hold on
            plot(vr2tqSum_sim);
            title(strcat('IRF Simulated Model vs. Measured Torque Sum for Input:',{' '}, trialname, {' '}, 'VAF = %', num2str(double(VAF_TQ{i,j}),2)));
            legend('Measured','Simulated')
            set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]); hold off
            
            figure(FigNo_IRF+5+k)
            plot(BodyA_decimated);hold on
            plot(vr2body_sim);
            title(strcat('IRF Simulated Model vs. Measured Body Angle for Input:', {' '}, trialname, {' '}, 'VAF = %', num2str(double(VAF_Body{i,j}),2)));
            legend('Measured','Simulated')
            set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]); hold off
        end        
        k = k + 1;        
    end
end

figure(FigNo_IRF)
legend(TrialTicks); 
title('IRF: VR to Body Angle');
set(gca, 'LineWidth', 2)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]); hold off

figure(FigNo_IRF+1)
legend(TrialTicks); 
title('IRF: VR to Torque Sum');
set(gca, 'LineWidth', 2)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);hold off

figure(FigNo_IRF+2)
title('Variance Accounted For (VAF) - VR to Torque Sum');
box off
ylim([0 100])
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);hold off

figure(FigNo_IRF+3)
title('Variance Accounted For (VAF) - VR to Body Angle');
box off
ylim([0 100])
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);hold off


%% Separate plots for (VAF vs Amp) and (VAF vs Vel) - Body Angle

FigNo_VAF = length(findobj('type','figure'))+1;
I = 1;
for i = Trials_Data.VelCase
    figure(FigNo_VAF+I);
    TrialTicks = {};
    XX_ticks = categorical(TrialTicks);
    XX_ticks = reordercats(XX_ticks, TrialTicks);
    for j = Trials_Data.AmpCase
        trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
        XX_ticks(i,j) = trialname;
        bar(XX_ticks(i,j), VAF_Body{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
        text(XX_ticks(i,j), VAF_Body{i,j}, num2str(VAF_Body{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
    end
    title(strcat('VAF vs. Amp for Vel=', num2str(i), 'dps - VR to Body Angle'));
    set(gca, 'LineWidth', 2)
    set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
    ylim([0 100]);
    hold off
    I = I + 1;
end

FigNo_VAF = length(findobj('type','figure'))+1;
I = 1;
for j = Trials_Data.AmpCase
    figure(FigNo_VAF+I);
    TrialTicks = {};
    XX_ticks = categorical(TrialTicks);
    XX_ticks = reordercats(XX_ticks, TrialTicks);
    for i = Trials_Data.VelCase
        trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
        XX_ticks(i,j) = trialname;
        bar(XX_ticks(i,j), VAF_Body{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
        text(XX_ticks(i,j), VAF_Body{i,j}, num2str(VAF_Body{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
    end
    title(strcat('VAF vs. Vel for Amp=', num2str(j), 'deg - VR to Body Angle'));
    set(gca, 'LineWidth', 2)
    set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
    ylim([0 100]);
    hold off
    I = I + 1;
end


%% Separate plots for (VAF vs Amp) and (VAF vs Vel) - Torque Sum

% FigNo_VAF = length(findobj('type','figure'))+1;
% I = 1;
% for i = Trials_Data.VelCase
%     figure(FigNo_VAF+I);
%     TrialTicks = {};
%     XX_ticks = categorical(TrialTicks);
%     XX_ticks = reordercats(XX_ticks, TrialTicks);
%     for j = Trials_Data.AmpCase
%         trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
%         XX_ticks(i,j) = trialname;
%         bar(XX_ticks(i,j), VAF_TQ{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
%         text(XX_ticks(i,j), VAF_TQ{i,j}, num2str(VAF_TQ{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
%     end
%     title(strcat('VAF vs. Amp for Vel=', num2str(i), 'dps - VR to Body Angle'));
%     set(gca, 'LineWidth', 2)
%     set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
%     ylim([0 100]);
%     hold off
%     I = I + 1;
% end
% 
% FigNo_VAF = length(findobj('type','figure'))+1;
% I = 1;
% for j = Trials_Data.AmpCase
%     figure(FigNo_VAF+I);
%     TrialTicks = {};
%     XX_ticks = categorical(TrialTicks);
%     XX_ticks = reordercats(XX_ticks, TrialTicks);
%     for i = Trials_Data.VelCase
%         trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
%         XX_ticks(i,j) = trialname;
%         bar(XX_ticks(i,j), VAF_TQ{i,j}, 'FaceColor', [0 0.5 0.5]); hold on;
%         text(XX_ticks(i,j), VAF_TQ{i,j}, num2str(VAF_TQ{i,j}),'vert','bottom','horiz','center', 'FontSize',14);
%     end
%     title(strcat('VAF vs. Vel for Amp=', num2str(j), 'deg - VR to Body Angle'));
%     set(gca, 'LineWidth', 2)
%     set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
%     ylim([0 100]);
%     hold off
%     I = I + 1;
% end











