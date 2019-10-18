function Trials_Data_All_Sync = syncStartData_AllSubj(Trials_Data_All)
% Synchronise the start time for VR input and outputs

Trials_Data_All_Sync = Trials_Data_All;

%% Cut unnecessary initial and final zero data

tt_sync = {};
for S = 1:Trials_Data_All.SubjNo
    for i = Trials_Data_All.VelCase
        for j = Trials_Data_All.AmpCase
            
            if isfile('tt_sync.mat')
                load('tt_sync.mat');
                tif = tt_sync{1,S}{i,j};
            else
                figure()
                t_vr = 1:length(Trials_Data_All.vr_input{1,S}{i,j});
                ax = plotyy(t_vr, Trials_Data_All.vr_input{1,S}{i,j} - mean(Trials_Data_All.vr_input{1,S}{i,j}), t_vr, Trials_Data_All.BodyAngle{1,S}{i,j}-mean(Trials_Data_All.BodyAngle{1,S}{i,j}));hold on
                title({'Synchronizing Start and End times: VR Input vs. Body Angle', strcat('Subject No.', num2str(S), ' , ' ,'Amp =', num2str(j), ' , ', 'Vel =', num2str(i))})
                xlabel('Time (s)')
                ylabel(ax(1), 'VR input (Volts)');
                ylabel(ax(2), 'Hip Angle (Rad)');
                
                set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
                [tif, yif] = getpts(gca);
                close;
                tt_sync{1,S}{i,j} = tif;
            end
            
            ti = floor(tif(1)); tf = floor(tif(2));
            
            vr_input_buff = Trials_Data_All.vr_input{1,S}{i,j}(ti:tf);
            LeftShAngle_buff = Trials_Data_All.LeftShAngle{1,S}{i,j}(ti:tf);
            BodyAngle_buff = Trials_Data_All.BodyAngle{1,S}{i,j}(ti:tf);
            RightShAngle_buff = Trials_Data_All.RightShAngle{1,S}{i,j}(ti:tf);
            Torque_L_buff = Trials_Data_All.Torque_L{1,S}{i,j}(ti:tf);
            Torque_R_buff = Trials_Data_All.Torque_R{1,S}{i,j}(ti:tf);
            
            % EMGs
            L_Sol_EMG_buff = Trials_Data_All.L_Sol_EMG{1,S}{i,j}(ti:tf);
            R_Sol_EMG_buff = Trials_Data_All.R_Sol_EMG{1,S}{i,j}(ti:tf);
            L_MG_EMG_buff =  Trials_Data_All.L_MG_EMG{1,S}{i,j}(ti:tf);
            R_MG_EMG_buff =  Trials_Data_All.R_MG_EMG{1,S}{i,j}(ti:tf);
            L_LG_EMG_buff =  Trials_Data_All.L_LG_EMG{1,S}{i,j}(ti:tf);
            R_LG_EMG_buff =  Trials_Data_All.R_LG_EMG{1,S}{i,j}(ti:tf);
            L_TA_EMG_buff =  Trials_Data_All.L_TA_EMG{1,S}{i,j}(ti:tf);
            R_TA_EMG_buff =  Trials_Data_All.R_TA_EMG{1,S}{i,j}(ti:tf);
            
            % To Output
            Trials_Data_All_Sync.vr_input{1,S}{i,j} = vr_input_buff;
            Trials_Data_All_Sync.RightShAngle{1,S}{i,j} = RightShAngle_buff;
            Trials_Data_All_Sync.LeftShAngle{1,S}{i,j} = LeftShAngle_buff;
            Trials_Data_All_Sync.BodyAngle{1,S}{i,j} = BodyAngle_buff;
            Trials_Data_All_Sync.Torque_R{1,S}{i,j} = Torque_R_buff;
            Trials_Data_All_Sync.Torque_L{1,S}{i,j} = Torque_L_buff;
            Trials_Data_All_Sync.L_Sol_EMG{1,S}{i,j} = L_Sol_EMG_buff;
            Trials_Data_All_Sync.R_Sol_EMG{1,S}{i,j} = R_Sol_EMG_buff;
            Trials_Data_All_Sync.L_MG_EMG{1,S}{i,j} = L_MG_EMG_buff;
            Trials_Data_All_Sync.R_MG_EMG{1,S}{i,j} = R_MG_EMG_buff;
            Trials_Data_All_Sync.L_LG_EMG{1,S}{i,j} = L_LG_EMG_buff;
            Trials_Data_All_Sync.R_LG_EMG{1,S}{i,j} = R_LG_EMG_buff;
            Trials_Data_All_Sync.L_TA_EMG{1,S}{i,j} = L_TA_EMG_buff;
            Trials_Data_All_Sync.R_TA_EMG{1,S}{i,j} = R_TA_EMG_buff;
            Trials_Data_All_Sync.trialsAll = Trials_Data_All.trialsAll;
            
        end
    end
end

if not(isfile('tt_sync.mat'))
    save('tt_sync.mat','tt_sync')
end

end

