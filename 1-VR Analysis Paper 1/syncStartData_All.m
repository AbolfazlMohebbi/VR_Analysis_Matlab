function Trials_Data_All_Sync = syncStartData_All(Trials_Data_All)
% Synchronise the start time for VR input and outputs

Trials_Data_All_Sync = Trials_Data_All;

%% Cut unnecessary initial and final zero data

tt_sync = {};
for S = 1:Trials_Data_All.SubjNo
    for i = Trials_Data_All.VelCase
        for j = Trials_Data_All.AmpCase
            
            trials = Trials_Data_All.trialsAll{1,S}{i,j};
            
            for T = 1:length(trials)
                
                if isfile('tt_sync_AllTrials.mat')
                    load('tt_sync_AllTrials.mat');
                    tif = tt_sync{1,S}{i,j}{1,T};
                else
                    figure()
                    t_vr = 1:length(Trials_Data_All.vr_input{1,S}{i,j}{1,T});
                    ax = plotyy(t_vr, Trials_Data_All.vr_input{1,S}{i,j}{1,T} - mean(Trials_Data_All.vr_input{1,S}{i,j}{1,T}), t_vr, Trials_Data_All.BodyAngle{1,S}{i,j}{1,T}-mean(Trials_Data_All.BodyAngle{1,S}{i,j}{1,T}));hold on
                    title({'Synchronizing Start and End times: VR Input vs. Body Angle', strcat('Subject No.', num2str(S), ' , ' ,'Amp =', num2str(j), ' , ', 'Vel =', num2str(i))})
                    xlabel('Time (s)')
                    ylabel(ax(1), 'VR input (Volts)');
                    ylabel(ax(2), 'Hip Angle (Rad)');
                    
                    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
                    [tif, yif] = getpts(gca);
                    close;
                    tt_sync{1,S}{i,j}{1,T} = tif;
                end
                
                ti = floor(tif(1)); tf = floor(tif(2));
                
                vr_input_buff = Trials_Data_All.vr_input{1,S}{i,j}{1,T}(ti:tf);
                LeftShAngle_buff = Trials_Data_All.LeftShAngle{1,S}{i,j}{1,T}(ti:tf);
                BodyAngle_buff = Trials_Data_All.BodyAngle{1,S}{i,j}{1,T}(ti:tf);
                RightShAngle_buff = Trials_Data_All.RightShAngle{1,S}{i,j}{1,T}(ti:tf);
                Torque_L_buff = Trials_Data_All.Torque_L{1,S}{i,j}{1,T}(ti:tf);
                Torque_R_buff = Trials_Data_All.Torque_R{1,S}{i,j}{1,T}(ti:tf);
                
                % EMGs
                L_Sol_EMG_buff = Trials_Data_All.L_Sol_EMG{1,S}{i,j}{1,T}(ti:tf);
                R_Sol_EMG_buff = Trials_Data_All.R_Sol_EMG{1,S}{i,j}{1,T}(ti:tf);
                L_MG_EMG_buff =  Trials_Data_All.L_MG_EMG{1,S}{i,j}{1,T}(ti:tf);
                R_MG_EMG_buff =  Trials_Data_All.R_MG_EMG{1,S}{i,j}{1,T}(ti:tf);
                L_LG_EMG_buff =  Trials_Data_All.L_LG_EMG{1,S}{i,j}{1,T}(ti:tf);
                R_LG_EMG_buff =  Trials_Data_All.R_LG_EMG{1,S}{i,j}{1,T}(ti:tf);
                L_TA_EMG_buff =  Trials_Data_All.L_TA_EMG{1,S}{i,j}{1,T}(ti:tf);
                R_TA_EMG_buff =  Trials_Data_All.R_TA_EMG{1,S}{i,j}{1,T}(ti:tf);
                
                % To Output
                Trials_Data_All_Sync.vr_input{1,S}{i,j}{1,T} = vr_input_buff;
                Trials_Data_All_Sync.RightShAngle{1,S}{i,j}{1,T} = RightShAngle_buff;
                Trials_Data_All_Sync.LeftShAngle{1,S}{i,j}{1,T} = LeftShAngle_buff;
                Trials_Data_All_Sync.BodyAngle{1,S}{i,j}{1,T} = BodyAngle_buff;
                Trials_Data_All_Sync.Torque_R{1,S}{i,j}{1,T} = Torque_R_buff;
                Trials_Data_All_Sync.Torque_L{1,S}{i,j}{1,T} = Torque_L_buff;
                Trials_Data_All_Sync.L_Sol_EMG{1,S}{i,j}{1,T} = L_Sol_EMG_buff;
                Trials_Data_All_Sync.R_Sol_EMG{1,S}{i,j}{1,T} = R_Sol_EMG_buff;
                Trials_Data_All_Sync.L_MG_EMG{1,S}{i,j}{1,T} = L_MG_EMG_buff;
                Trials_Data_All_Sync.R_MG_EMG{1,S}{i,j}{1,T} = R_MG_EMG_buff;
                Trials_Data_All_Sync.L_LG_EMG{1,S}{i,j}{1,T} = L_LG_EMG_buff;
                Trials_Data_All_Sync.R_LG_EMG{1,S}{i,j}{1,T} = R_LG_EMG_buff;
                Trials_Data_All_Sync.L_TA_EMG{1,S}{i,j}{1,T} = L_TA_EMG_buff;
                Trials_Data_All_Sync.R_TA_EMG{1,S}{i,j}{1,T} = R_TA_EMG_buff;
                Trials_Data_All_Sync.trialsAll = Trials_Data_All.trialsAll;
                
            end
        end
    end
end

if not(isfile('tt_sync_AllTrials.mat'))
    save('tt_sync_AllTrials.mat','tt_sync')
end

end

