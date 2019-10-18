function Trials_Data_Sync = syncStartData_App_AllExp(Trials_Data)
% Synchronise the start time for VR input and outputs

Trials_Data_Sync = Trials_Data;

% Cut unnecessary initial and final zero data

for i = Trials_Data.VelCase
    for j = Trials_Data.AmpCase
        
        figure()
        t_vr = 1:length(Trials_Data.vr_input{i,j});
        ax = plotyy(t_vr, Trials_Data.vr_input{i,j} - mean(Trials_Data.vr_input{i,j}), t_vr, Trials_Data.BodyAngle{i,j}-mean(Trials_Data.BodyAngle{i,j}));hold on
        title('Synchronizing Start and End times: VR Input vs. Body Angle')
        xlabel('Time (s)')
        ylabel(ax(1), 'VR input (Volts)');
        ylabel(ax(2), 'Hip Angle (Rad)');
        
        set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
        [tif, yif] = getpts(gca);
        close;
        ti = tif(1); tf = tif(2);
        
        vr_input_buff = Trials_Data.vr_input{i,j}(ti:tf);
        LeftShAngle_buff = Trials_Data.LeftShAngle{i,j}(ti:tf);
        BodyAngle_buff = Trials_Data.BodyAngle{i,j}(ti:tf);
        RightShAngle_buff = Trials_Data.RightShAngle{i,j}(ti:tf);
        Torque_L_buff = Trials_Data.Torque_L{i,j}(ti:tf);
        Torque_R_buff = Trials_Data.Torque_R{i,j}(ti:tf);
        
        % EMGs
        L_Sol_EMG_buff = Trials_Data.L_Sol_EMG{i,j}(ti:tf);
        R_Sol_EMG_buff = Trials_Data.R_Sol_EMG{i,j}(ti:tf);
        L_MG_EMG_buff =  Trials_Data.L_MG_EMG{i,j}(ti:tf);
        R_MG_EMG_buff =  Trials_Data.R_MG_EMG{i,j}(ti:tf);
        L_LG_EMG_buff =  Trials_Data.L_LG_EMG{i,j}(ti:tf);
        R_LG_EMG_buff =  Trials_Data.R_LG_EMG{i,j}(ti:tf);
        L_TA_EMG_buff =  Trials_Data.L_TA_EMG{i,j}(ti:tf);
        R_TA_EMG_buff =  Trials_Data.R_TA_EMG{i,j}(ti:tf);
        
        % To Output
        Trials_Data_Sync.vr_input{i,j} = vr_input_buff;
        Trials_Data_Sync.RightShAngle{i,j} = RightShAngle_buff;
        Trials_Data_Sync.LeftShAngle{i,j} = LeftShAngle_buff;
        Trials_Data_Sync.BodyAngle{i,j} = BodyAngle_buff;
        Trials_Data_Sync.Torque_R{i,j} = Torque_R_buff;
        Trials_Data_Sync.Torque_L{i,j} = Torque_L_buff;
        Trials_Data_Sync.L_Sol_EMG{i,j} = L_Sol_EMG_buff;
        Trials_Data_Sync.R_Sol_EMG{i,j} = R_Sol_EMG_buff;
        Trials_Data_Sync.L_MG_EMG{i,j} = L_MG_EMG_buff;
        Trials_Data_Sync.R_MG_EMG{i,j} = R_MG_EMG_buff;
        Trials_Data_Sync.L_LG_EMG{i,j} = L_LG_EMG_buff;
        Trials_Data_Sync.R_LG_EMG{i,j} = R_LG_EMG_buff;
        Trials_Data_Sync.L_TA_EMG{i,j} = L_TA_EMG_buff;
        Trials_Data_Sync.R_TA_EMG{i,j} = R_TA_EMG_buff;
        Trials_Data_Sync.trialsMatrix = Trials_Data.trialsMatrix;
        
    end
end



end

