function Trials_Data_detrend = detrend_data(Trials_Data, bPlotDetrend)

global SR
t = 0:1/SR:(length(Trials_Data.HipAngle)-1)/SR;

Trials_Data_detrend.vr_input = Trials_Data.vr_input;
Trials_Data_detrend.vr_input_deg = Trials_Data.vr_input_deg;
Trials_Data_detrend.trials = Trials_Data.trials;

Trials_Data_detrend.HipAngle = detrend(Trials_Data.HipAngle);
Trials_Data_detrend.RightShAngle = detrend(Trials_Data.RightShAngle);
Trials_Data_detrend.LeftShAngle = detrend(Trials_Data.LeftShAngle);
Trials_Data_detrend.Torque_R = detrend(Trials_Data.Torque_R);
Trials_Data_detrend.Torque_L = detrend(Trials_Data.Torque_L);
 
Trials_Data_detrend.L_Sol_EMG = detrend(Trials_Data.L_Sol_EMG);
Trials_Data_detrend.R_Sol_EMG = detrend(Trials_Data.R_Sol_EMG);
Trials_Data_detrend.L_MG_EMG = detrend(Trials_Data.L_MG_EMG);
Trials_Data_detrend.R_MG_EMG = detrend(Trials_Data.R_MG_EMG);
 
Trials_Data_detrend.L_LG_EMG = detrend(Trials_Data.L_LG_EMG);
Trials_Data_detrend.R_LG_EMG = detrend(Trials_Data.R_LG_EMG);
Trials_Data_detrend.L_TA_EMG = detrend(Trials_Data.L_TA_EMG);
Trials_Data_detrend.R_TA_EMG = detrend(Trials_Data.R_TA_EMG);

if (bPlotDetrend == 'y')
    
    figure(length(findobj('type','figure'))+1);    
    
    subplot(3,2,[1 2]);
    plot(t, Trials_Data.HipAngle); hold on;
    trend = Trials_Data.HipAngle - Trials_Data_detrend.HipAngle;
    plot(t, trend, ':r');hold on;
    plot(t, Trials_Data_detrend.HipAngle, 'm'); hold on;
    plot(t, zeros(size(Trials_Data_detrend.HipAngle)),':k'); hold on;
    legend('Original Data','Trend','Detrended Data','Mean of Detrended Data','Location','southeast');
    title('Detrended data for HipAngle');
    
    subplot(3,2,3);
    plot(t, Trials_Data.RightShAngle); hold on;
    trend = Trials_Data.RightShAngle - Trials_Data_detrend.RightShAngle;
    plot(t, trend, ':r'); hold on;
    plot(t, Trials_Data_detrend.RightShAngle, 'm'); hold on;
    plot(t, zeros(size(Trials_Data_detrend.RightShAngle)),':k'); hold on;   
    legend('Original Data','Trend','Detrended Data','Mean of Detrended Data','Location','southeast');
    title('Detrended data for RightShAngle');
    
    subplot(3,2,4);
    plot(t, Trials_Data.LeftShAngle); hold on;
    trend = Trials_Data.LeftShAngle - Trials_Data_detrend.LeftShAngle; 
    plot(t, trend, ':r'); hold on;      
    plot(t, Trials_Data_detrend.LeftShAngle, 'm'); hold on;
    plot(t, zeros(size(Trials_Data_detrend.LeftShAngle)),':k'); hold on;
    legend('Original Data','Trend','Detrended Data','Mean of Detrended Data','Location','southeast');
    title('Detrended data for LeftShAngle');
    
    subplot(3,2,5);     
    plot(t, Trials_Data.Torque_R); hold on;
    trend = Trials_Data.Torque_R - Trials_Data_detrend.Torque_R;  
    plot(t, trend, ':r'); hold on;    
    plot(t, Trials_Data_detrend.Torque_R, 'm'); hold on;
    plot(t, zeros(size(Trials_Data_detrend.Torque_R)),':k'); hold on;    
    legend('Original Data','Trend','Detrended Data','Mean of Detrended Data','Location','southeast');
    title('Detrended data for Torque_R');
    
    subplot(3,2,6);
    plot(t, Trials_Data.Torque_L); hold on;
    trend = Trials_Data.Torque_L - Trials_Data_detrend.Torque_L;  
    plot(t, trend, ':r'); hold on;
    plot(t, Trials_Data_detrend.Torque_L, 'm'); hold on;
    plot(t, zeros(size(Trials_Data_detrend.Torque_L)),':k'); hold on;    
    legend('Original Data','Trend','Detrended Data','Mean of Detrended Data','Location','southeast');
    title('Detrended data for Torque_L');    
    
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    
    % NO EMG Plots at this time      
end


end

