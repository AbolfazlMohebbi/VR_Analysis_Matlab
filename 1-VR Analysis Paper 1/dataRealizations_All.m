function [Trials_Data_All_Realizations, Trials_NLD] = dataRealizations_All(Trials_Data_All)

global SR
% bDDT_VR     = input('Would you like to analyze the input Velocity or Position? \n 1) Velocity\n 2) Position\n');
% bDDT_Output = input('Would you like to analyze the output Velocity or Position? \n 1) Velocity\n 2) Position\n');
bDDT_VR     = 2;
bDDT_Output = 2;

for S = 1:Trials_Data_All.SubjNo
    for i = Trials_Data_All.VelCase
        for j = Trials_Data_All.AmpCase
            
            trials = Trials_Data_All.trialsAll{1,S}{i,j};
            for T = 1:length(trials)
                
                Trials_Data_All_Realizations.vr_realizations{1,S}{i,j}{1,T} = Trials_Data_All.vr_input_deg{1,S}{i,j}{1,T};
                Trials_Data_All_Realizations.left_tq{1,S}{i,j}{1,T} = Trials_Data_All.Torque_L{1,S}{i,j}{1,T};
                Trials_Data_All_Realizations.right_tq{1,S}{i,j}{1,T} = Trials_Data_All.Torque_R{1,S}{i,j}{1,T};
                Trials_Data_All_Realizations.left_shank{1,S}{i,j}{1,T} = Trials_Data_All.LeftShAngle{1,S}{i,j}{1,T};
                Trials_Data_All_Realizations.right_shank{1,S}{i,j}{1,T} = Trials_Data_All.RightShAngle{1,S}{i,j}{1,T};
                Trials_Data_All_Realizations.body_angle{1,S}{i,j}{1,T} = Trials_Data_All.BodyAngle{1,S}{i,j}{1,T};
                
                Trials_Data_All_Realizations.LSol{1,S}{i,j}{1,T} = Trials_Data_All.L_Sol_EMG{1,S}{i,j}{1,T};
                Trials_Data_All_Realizations.RSol{1,S}{i,j}{1,T} = Trials_Data_All.R_Sol_EMG{1,S}{i,j}{1,T};
                Trials_Data_All_Realizations.LMG{1,S}{i,j}{1,T} = Trials_Data_All.L_MG_EMG{1,S}{i,j}{1,T};
                Trials_Data_All_Realizations.RMG{1,S}{i,j}{1,T} = Trials_Data_All.R_MG_EMG{1,S}{i,j}{1,T};
                Trials_Data_All_Realizations.RLG{1,S}{i,j}{1,T} = Trials_Data_All.R_LG_EMG{1,S}{i,j}{1,T};
                Trials_Data_All_Realizations.LLG{1,S}{i,j}{1,T} = Trials_Data_All.L_LG_EMG{1,S}{i,j}{1,T};
                Trials_Data_All_Realizations.RTA{1,S}{i,j}{1,T} = Trials_Data_All.R_TA_EMG{1,S}{i,j}{1,T};
                Trials_Data_All_Realizations.LTA{1,S}{i,j}{1,T} = Trials_Data_All.L_TA_EMG{1,S}{i,j}{1,T};
                
                % Using NDID Toolbox
                
                % Left limb
                TorqueL = nldat;  %Create an NLDAT object for left torque data
                set(TorqueL,'dataSet', Trials_Data_All_Realizations.left_tq{1,S}{i,j}{1,T}' ,'domainIncr', 1/SR);
                
                shankL = nldat;
                set(shankL,'dataSet', Trials_Data_All_Realizations.left_shank{1,S}{i,j}{1,T}','domainIncr',1/SR);
                if (bDDT_Output == 1) shankL = ddt(shankL); end
                
                %Right limb
                TorqueR = nldat;
                set(TorqueR,'dataSet', Trials_Data_All_Realizations.right_tq{1,S}{i,j}{1,T}' ,'domainIncr',1/SR);
                
                shankR = nldat;
                set(shankR,'dataSet', Trials_Data_All_Realizations.right_shank{1,S}{i,j}{1,T}','domainIncr',1/SR);
                if (bDDT_Output == 1) shankR = ddt(shankR); end
                
                %Body Angle
                BodyA = nldat;
                set(BodyA,'dataSet', Trials_Data_All_Realizations.body_angle{1,S}{i,j}{1,T}' ,'domainIncr',1/SR);
                if (bDDT_Output == 1) BodyA = ddt(BodyA); end
                
                % Summations
                TorqueSum = nldat;
                torque_s = Trials_Data_All_Realizations.left_tq{1,S}{i,j}{1,T} + Trials_Data_All_Realizations.right_tq{1,S}{i,j}{1,T};
                set(TorqueSum,'dataSet', torque_s', 'domainIncr', 1/SR);
                
                % VR
                VRnldat = nldat;
                set(VRnldat,'dataSet', Trials_Data_All_Realizations.vr_realizations{1,S}{i,j}{1,T} , 'domainIncr',1/SR);
                if (bDDT_VR == 1) VRnldat = ddt(VRnldat); end
                
                % EMGs Right
                RSol = nldat;
                set(RSol,'dataSet', Trials_Data_All_Realizations.RSol{1,S}{i,j}{1,T}' ,'domainIncr', 1/SR);
                RMG = nldat;
                set(RMG,'dataSet', Trials_Data_All_Realizations.RMG{1,S}{i,j}{1,T}' ,'domainIncr', 1/SR);
                RLG = nldat;
                set(RLG,'dataSet', Trials_Data_All_Realizations.RLG{1,S}{i,j}{1,T}' ,'domainIncr', 1/SR);
                RTA = nldat;
                set(RTA,'dataSet', Trials_Data_All_Realizations.RTA{1,S}{i,j}{1,T}' ,'domainIncr', 1/SR);
                
                % EMGs Left
                LSol = nldat;
                set(LSol,'dataSet', Trials_Data_All_Realizations.LSol{1,S}{i,j}{1,T}' ,'domainIncr', 1/SR);
                LMG = nldat;
                set(LMG,'dataSet', Trials_Data_All_Realizations.LMG{1,S}{i,j}{1,T}' ,'domainIncr', 1/SR);
                LLG = nldat;
                set(LLG,'dataSet', Trials_Data_All_Realizations.LLG{1,S}{i,j}{1,T}' ,'domainIncr', 1/SR);
                LTA = nldat;
                set(LTA,'dataSet', Trials_Data_All_Realizations.LTA{1,S}{i,j}{1,T}' ,'domainIncr', 1/SR);
                
                Trials_NLD.VRnldat{1,S}{i,j}{1,T} = VRnldat;
                Trials_NLD.TorqueL{1,S}{i,j}{1,T} = TorqueL;
                Trials_NLD.TorqueR{1,S}{i,j}{1,T} = TorqueR;
                Trials_NLD.BodyA{1,S}{i,j}{1,T} = BodyA;
                Trials_NLD.shankL{1,S}{i,j}{1,T} = shankL;
                Trials_NLD.shankR{1,S}{i,j}{1,T} = shankR;
                Trials_NLD.TorqueSum{1,S}{i,j}{1,T} = TorqueSum;
                
                % EMG NLD Objects
                Trials_NLD.EMG_RSol{1,S}{i,j}{1,T} = RSol;
                Trials_NLD.EMG_RMG{1,S}{i,j}{1,T} = RMG;
                Trials_NLD.EMG_RLG{1,S}{i,j}{1,T} = RLG;
                Trials_NLD.EMG_RTA{1,S}{i,j}{1,T} = RTA;
                Trials_NLD.EMG_LSol{1,S}{i,j}{1,T} = LSol;
                Trials_NLD.EMG_LMG{1,S}{i,j}{1,T} = LMG;
                Trials_NLD.EMG_LLG{1,S}{i,j}{1,T} = LLG;
                Trials_NLD.EMG_LTA{1,S}{i,j}{1,T} = LTA;                
            end                    
            
        end
    end
end


end

