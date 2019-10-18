function Trials_Data_All_detrend = detrend_data_All(Trials_Data_All)

global SR
Trials_Data_All_detrend = Trials_Data_All;

for S = 1:Trials_Data_All.SubjNo
    for i = Trials_Data_All.VelCase
        for j = Trials_Data_All.AmpCase
            trials = Trials_Data_All.trialsAll{1,S}{i,j};
            for T = 1:length(trials)
                
                Trials_Data_All.vr_input{1,S}{i,j}{1,T};
                t = 0:1/SR:(length(Trials_Data_All.BodyAngle{1,S}{i,j}{1,T})-1)/SR;
                Trials_Data_All_detrend.vr_input{1,S}{i,j}{1,T} = Trials_Data_All.vr_input{1,S}{i,j}{1,T};
                Trials_Data_All_detrend.vr_input_deg{1,S}{i,j}{1,T} = Trials_Data_All.vr_input_deg{1,S}{i,j}{1,T};
                
                Trials_Data_All_detrend.BodyAngle{1,S}{i,j}{1,T} = DetrendPoly(Trials_Data_All.BodyAngle{1,S}{i,j}{1,T});
                Trials_Data_All_detrend.RightShAngle{1,S}{i,j}{1,T} = DetrendPoly(Trials_Data_All.RightShAngle{1,S}{i,j}{1,T});
                Trials_Data_All_detrend.LeftShAngle{1,S}{i,j}{1,T} = DetrendPoly(Trials_Data_All.LeftShAngle{1,S}{i,j}{1,T});
                Trials_Data_All_detrend.Torque_R{1,S}{i,j}{1,T} = DetrendPoly(Trials_Data_All.Torque_R{1,S}{i,j}{1,T});
                Trials_Data_All_detrend.Torque_L{1,S}{i,j}{1,T} = DetrendPoly(Trials_Data_All.Torque_L{1,S}{i,j}{1,T});
                
                Trials_Data_All_detrend.L_Sol_EMG{1,S}{i,j}{1,T} = DetrendPoly(Trials_Data_All.L_Sol_EMG{1,S}{i,j}{1,T});
                Trials_Data_All_detrend.R_Sol_EMG{1,S}{i,j}{1,T} = DetrendPoly(Trials_Data_All.R_Sol_EMG{1,S}{i,j}{1,T});
                Trials_Data_All_detrend.L_MG_EMG{1,S}{i,j}{1,T} = DetrendPoly(Trials_Data_All.L_MG_EMG{1,S}{i,j}{1,T});
                Trials_Data_All_detrend.R_MG_EMG{1,S}{i,j}{1,T} = DetrendPoly(Trials_Data_All.R_MG_EMG{1,S}{i,j}{1,T});
                
                Trials_Data_All_detrend.L_LG_EMG{1,S}{i,j}{1,T} = DetrendPoly(Trials_Data_All.L_LG_EMG{1,S}{i,j}{1,T});
                Trials_Data_All_detrend.R_LG_EMG{1,S}{i,j}{1,T} = DetrendPoly(Trials_Data_All.R_LG_EMG{1,S}{i,j}{1,T});
                Trials_Data_All_detrend.L_TA_EMG{1,S}{i,j}{1,T} = DetrendPoly(Trials_Data_All.L_TA_EMG{1,S}{i,j}{1,T});
                Trials_Data_All_detrend.R_TA_EMG{1,S}{i,j}{1,T} = DetrendPoly(Trials_Data_All.R_TA_EMG{1,S}{i,j}{1,T});
                
            end
        end
    end
end


end

