%% Decimate: Resample data at a lower rate after lowpass filtering.

nsides = 2;
% nlags = 15 * (SR/dr);
nlags = 10 * (SR/dr);

VAF_TQ = {};
VAF_Body = {};

VAF_TQ_Mat = [];
VAF_Body_Mat = [];
VAF_TQ_allSubj = [];
VAF_Body_allSubj = [];

TrialTicks = {};
FigNo_IRF = length(findobj('type','figure'))+1;

for i = Trials_Data_All.VelCase
    for j = Trials_Data_All.AmpCase
        
        trialname = strcat(num2str(i),'dps, ', num2str(j), 'deg');
        TrialTicks{end+1} = trialname;
        
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
        VAF_TQ_Mat = [VAF_TQ_Mat; VAF_TQ_allSubj];
        VAF_Body_Mat = [VAF_Body_Mat; VAF_Body_allSubj];
        VAF_TQ_allSubj = [];
        VAF_Body_allSubj = [];
        
    end    
end

figure(FigNo_IRF);
boxplot(VAF_Body_Mat','Labels', TrialTicks);
xtickangle(-45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);
title({'Variance Accounted For (VAF) - VR to Body Angle', 'Data for all Subjects'}); hold off

figure(FigNo_IRF+1);
boxplot(VAF_TQ_Mat','Labels', TrialTicks);
xtickangle(-45)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);
title({'Variance Accounted For (VAF) - VR to Torque Sum', 'Data for all Subjects'}); hold off


%% Separate plots for (VAF vs Amp)

VAF_TQ_allSubj = [];
VAF_Body_allSubj = [];
VAF_TQ_Mat = [];
VAF_Body_Mat = [];
FigNo_VAF = length(findobj('type','figure'))+1;
I = 1;
for i = Trials_Data_All.VelCase
    
    TrialTicks = {};
    
    for j = Trials_Data_All.AmpCase
        trialname = strcat(num2str(j), '-deg');
        TrialTicks{end+1} = trialname;
        
        for S = 1:Trials_Data_All.SubjNo           
            VAF_TQ_allSubj = [VAF_TQ_allSubj, VAF_TQ{1,S}{i,j}];
            VAF_Body_allSubj = [VAF_Body_allSubj, VAF_Body{1,S}{i,j}];       
        end
        
        VAF_TQ_Mat = [VAF_TQ_Mat; VAF_TQ_allSubj];
        VAF_Body_Mat = [VAF_Body_Mat; VAF_Body_allSubj];
        
        figure(FigNo_VAF+I);
        boxplot(VAF_Body_Mat','Labels', TrialTicks);
        xtickangle(-45)
        set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
        title({'VAF vs. Amp - VR to Body Angle for all Subjects', strcat('Velocity = ', num2str(i), '-dps')});
        
        figure(FigNo_IRF+I+1);
        boxplot(VAF_TQ_Mat','Labels', TrialTicks);
        xtickangle(-45)
        set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
        title({'VAF vs. Amp - VR to Torque Sum for all Subjects', strcat('Velocity = ', num2str(i), '-dps')});
        
        VAF_TQ_allSubj = [];
        VAF_Body_allSubj = [];        
    end
    VAF_TQ_Mat = [];
    VAF_Body_Mat = [];
    
    I = I + 2;
end


%% Separate plots for (VAF vs Vel) - Body Angle
VAF_TQ_allSubj = [];
VAF_Body_allSubj = [];
VAF_TQ_Mat = [];
VAF_Body_Mat = [];
FigNo_VAF = length(findobj('type','figure'))+1;
I = 1;
for j = Trials_Data_All.AmpCase
    
    TrialTicks = {};
    
    for i = Trials_Data_All.VelCase
        trialname = strcat(num2str(i), '-dps');
        TrialTicks{end+1} = trialname;
        
        for S = 1:Trials_Data_All.SubjNo           
            VAF_TQ_allSubj = [VAF_TQ_allSubj, VAF_TQ{1,S}{i,j}];
            VAF_Body_allSubj = [VAF_Body_allSubj, VAF_Body{1,S}{i,j}];       
        end
        
        VAF_TQ_Mat = [VAF_TQ_Mat; VAF_TQ_allSubj];
        VAF_Body_Mat = [VAF_Body_Mat; VAF_Body_allSubj];
        
        figure(FigNo_VAF+I);
        boxplot(VAF_Body_Mat','Labels', TrialTicks);
        xtickangle(-45)
        set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
        title({'VAF vs. Vel - VR to Body Angle for all Subjects', strcat('Amplitude = ', num2str(j), '-deg')});
        
        figure(FigNo_IRF+I+1);
        boxplot(VAF_TQ_Mat','Labels', TrialTicks);
        xtickangle(-45)
        set(gcf,'Units','Normalized','OuterPosition',[0.1 0.1 0.4 0.8]);
        title({'VAF vs. Vel - VR to Torque Sum for all Subjects', strcat('Amplitude = ', num2str(i), '-deg')});
        
        VAF_TQ_allSubj = [];
        VAF_Body_allSubj = [];        
    end
    VAF_TQ_Mat = [];
    VAF_Body_Mat = [];
    
%     figure(FigNo_VAF+I); hold off
%     figure(FigNo_VAF+I+1);hold off
    
    I = I + 2;
end



