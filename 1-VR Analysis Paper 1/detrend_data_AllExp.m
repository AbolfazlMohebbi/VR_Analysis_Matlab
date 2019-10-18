function Trials_Data_detrend = detrend_data_AllExp(Trials_Data, bPlotDetrend)

global SR
Trials_Data_detrend = Trials_Data;

for i = Trials_Data.VelCase
    for j = Trials_Data.AmpCase        
        
        t = 0:1/SR:(length(Trials_Data.BodyAngle{i,j})-1)/SR;
        
        Trials_Data_detrend.vr_input{i,j} = Trials_Data.vr_input{i,j};
        Trials_Data_detrend.vr_input_deg{i,j} = Trials_Data.vr_input_deg{i,j};
        Trials_Data_detrend.trialsMatrix = Trials_Data.trialsMatrix;
        
        Trials_Data_detrend.BodyAngle{i,j} = detrend(Trials_Data.BodyAngle{i,j});
        Trials_Data_detrend.RightShAngle{i,j} = detrend(Trials_Data.RightShAngle{i,j});
        Trials_Data_detrend.LeftShAngle{i,j} = detrend(Trials_Data.LeftShAngle{i,j});
        Trials_Data_detrend.Torque_R{i,j} = detrend(Trials_Data.Torque_R{i,j});
        Trials_Data_detrend.Torque_L{i,j} = detrend(Trials_Data.Torque_L{i,j});
        
        Trials_Data_detrend.L_Sol_EMG{i,j} = detrend(Trials_Data.L_Sol_EMG{i,j});
        Trials_Data_detrend.R_Sol_EMG{i,j} = detrend(Trials_Data.R_Sol_EMG{i,j});
        Trials_Data_detrend.L_MG_EMG{i,j} = detrend(Trials_Data.L_MG_EMG{i,j});
        Trials_Data_detrend.R_MG_EMG{i,j} = detrend(Trials_Data.R_MG_EMG{i,j});
        
        Trials_Data_detrend.L_LG_EMG{i,j} = detrend(Trials_Data.L_LG_EMG{i,j});
        Trials_Data_detrend.R_LG_EMG{i,j} = detrend(Trials_Data.R_LG_EMG{i,j});
        Trials_Data_detrend.L_TA_EMG{i,j} = detrend(Trials_Data.L_TA_EMG{i,j});
        Trials_Data_detrend.R_TA_EMG{i,j} = detrend(Trials_Data.R_TA_EMG{i,j});
        
        if (bPlotDetrend == 'y')
            
            figure(length(findobj('type','figure'))+1);
            
            subplot(3,2,[1 2]);
            plot(t, Trials_Data.BodyAngle{i,j}); hold on;
            trend = Trials_Data.BodyAngle{i,j} - Trials_Data_detrend.BodyAngle{i,j};
            plot(t, trend, ':r');hold on;
            plot(t, Trials_Data_detrend.BodyAngle{i,j}, 'm'); hold on;
            plot(t, zeros(size(Trials_Data_detrend.BodyAngle{i,j})),':k'); hold on;
            legend('Original Data','Trend','Detrended Data','Mean of Detrended Data','Location','southeast');
            title('Detrended data for BodyAngle');
            
            subplot(3,2,3);
            plot(t, Trials_Data.RightShAngle{i,j}); hold on;
            trend = Trials_Data.RightShAngle{i,j} - Trials_Data_detrend.RightShAngle{i,j};
            plot(t, trend, ':r'); hold on;
            plot(t, Trials_Data_detrend.RightShAngle{i,j}, 'm'); hold on;
            plot(t, zeros(size(Trials_Data_detrend.RightShAngle{i,j})),':k'); hold on;
            legend('Original Data','Trend','Detrended Data','Mean of Detrended Data','Location','southeast');
            title('Detrended data for RightShAngle');
            
            subplot(3,2,4);
            plot(t, Trials_Data.LeftShAngle{i,j}); hold on;
            trend = Trials_Data.LeftShAngle{i,j} - Trials_Data_detrend.LeftShAngle{i,j};
            plot(t, trend, ':r'); hold on;
            plot(t, Trials_Data_detrend.LeftShAngle{i,j}, 'm'); hold on;
            plot(t, zeros(size(Trials_Data_detrend.LeftShAngle{i,j})),':k'); hold on;
            legend('Original Data','Trend','Detrended Data','Mean of Detrended Data','Location','southeast');
            title('Detrended data for LeftShAngle');
            
            subplot(3,2,5);
            plot(t, Trials_Data.Torque_R{i,j}); hold on;
            trend = Trials_Data.Torque_R{i,j} - Trials_Data_detrend.Torque_R{i,j};
            plot(t, trend, ':r'); hold on;
            plot(t, Trials_Data_detrend.Torque_R{i,j}, 'm'); hold on;
            plot(t, zeros(size(Trials_Data_detrend.Torque_R{i,j})),':k'); hold on;
            legend('Original Data','Trend','Detrended Data','Mean of Detrended Data','Location','southeast');
            title('Detrended data for Torque_R');
            
            subplot(3,2,6);
            plot(t, Trials_Data.Torque_L{i,j}); hold on;
            trend = Trials_Data.Torque_L{i,j} - Trials_Data_detrend.Torque_L{i,j};
            plot(t, trend, ':r'); hold on;
            plot(t, Trials_Data_detrend.Torque_L{i,j}, 'm'); hold on;
            plot(t, zeros(size(Trials_Data_detrend.Torque_L{i,j})),':k'); hold on;
            legend('Original Data','Trend','Detrended Data','Mean of Detrended Data','Location','southeast');
            title('Detrended data for Torque_L');
            
            set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
            
            % NO EMG Plots at this time
        end
        
        
        
    end
end



end

