function [Trials_Data_Realizations, Trials_All_NLD] = dataRealizations_AllExp(Trials_Data)

global SR

% bDDT_VR     = input('Would you like to analyze the input Velocity or Position? \n 1) Velocity\n 2) Position\n');
% bDDT_Output = input('Would you like to analyze the output Velocity or Position? \n 1) Velocity\n 2) Position\n');
bDDT_VR     = 2;
bDDT_Output = 2;


% figure(length(findobj('type','figure'))+1)
% subplot(2,2,[1 3])
% plot(Trials_Data_Realizations.vr_realizations','linewidth',1);title('Perturbation')
%
% subplot(2,2,2)
% plot(Trials_Data_Realizations.left_tq','linewidth',1);title('Left torque')
% hold on
% plot(mean(Trials_Data_Realizations.left_tq),'b')
%
% subplot(2,2,4)
% plot(Trials_Data_Realizations.right_tq','linewidth',1);title('Right torque')
% hold on
% plot(mean(Trials_Data_Realizations.right_tq),'b')
%
% set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])


for i = Trials_Data.VelCase
    for j = Trials_Data.AmpCase
        
        Trials_Data_Realizations.vr_realizations{i,j} = Trials_Data.vr_input_deg{i,j};
        Trials_Data_Realizations.left_tq{i,j} = Trials_Data.Torque_L{i,j};
        Trials_Data_Realizations.right_tq{i,j} = Trials_Data.Torque_R{i,j};
        Trials_Data_Realizations.left_shank{i,j} = Trials_Data.LeftShAngle{i,j};
        Trials_Data_Realizations.right_shank{i,j} = Trials_Data.RightShAngle{i,j};
        Trials_Data_Realizations.body_angle{i,j} = Trials_Data.BodyAngle{i,j};
        
        Trials_Data_Realizations.LSol{i,j} = Trials_Data.L_Sol_EMG{i,j};
        Trials_Data_Realizations.RSol{i,j} = Trials_Data.R_Sol_EMG{i,j};
        Trials_Data_Realizations.LMG{i,j} = Trials_Data.L_MG_EMG{i,j};
        Trials_Data_Realizations.RMG{i,j} = Trials_Data.R_MG_EMG{i,j};
        Trials_Data_Realizations.RLG{i,j} = Trials_Data.R_LG_EMG{i,j};
        Trials_Data_Realizations.LLG{i,j} = Trials_Data.L_LG_EMG{i,j};
        Trials_Data_Realizations.RTA{i,j} = Trials_Data.R_TA_EMG{i,j};
        Trials_Data_Realizations.LTA{i,j} = Trials_Data.L_TA_EMG{i,j};
        
        % Using NDID Toolbox
        % Left limb
        TorqueL = nldat;  %Create an NLDAT object for left torque data
        set(TorqueL,'dataSet', Trials_Data_Realizations.left_tq{i,j}' ,'domainIncr', 1/SR);
        shankL = nldat;
        set(shankL,'dataSet', Trials_Data_Realizations.left_shank{i,j}','domainIncr',1/SR);
        if (bDDT_Output == 1) shankL = ddt(shankL); end
        
        %Right limb
        TorqueR = nldat;
        set(TorqueR,'dataSet', Trials_Data_Realizations.right_tq{i,j}' ,'domainIncr',1/SR);
        shankR = nldat;
        set(shankR,'dataSet', Trials_Data_Realizations.right_shank{i,j}','domainIncr',1/SR);
        if (bDDT_Output == 1) shankR = ddt(shankR); end
        
        %Body Angle
        BodyA = nldat;
        set(BodyA,'dataSet', Trials_Data_Realizations.body_angle{i,j}' ,'domainIncr',1/SR);
        if (bDDT_Output == 1) BodyA = ddt(BodyA); end
        
        % Summations
        TorqueSum = nldat;
        torque_s = Trials_Data_Realizations.left_tq{i,j} + Trials_Data_Realizations.right_tq{i,j};
        set(TorqueSum,'dataSet', torque_s', 'domainIncr', 1/SR);
        
        % VR
        VRnldat = nldat;
        set(VRnldat,'dataSet', Trials_Data_Realizations.vr_realizations{i,j}' , 'domainIncr',1/SR);
        if (bDDT_VR == 1) VRnldat = ddt(VRnldat); end
        
        % EMGs Right
        RSol = nldat;
        set(RSol,'dataSet', Trials_Data_Realizations.RSol{i,j}' ,'domainIncr', 1/SR);
        RMG = nldat;
        set(RMG,'dataSet', Trials_Data_Realizations.RMG{i,j}' ,'domainIncr', 1/SR);
        RLG = nldat;
        set(RLG,'dataSet', Trials_Data_Realizations.RLG{i,j}' ,'domainIncr', 1/SR);
        RTA = nldat;
        set(RTA,'dataSet', Trials_Data_Realizations.RTA{i,j}' ,'domainIncr', 1/SR);
        
        % EMGs Left
        LSol = nldat;
        set(LSol,'dataSet', Trials_Data_Realizations.LSol{i,j}' ,'domainIncr', 1/SR);
        LMG = nldat;
        set(LMG,'dataSet', Trials_Data_Realizations.LMG{i,j}' ,'domainIncr', 1/SR);
        LLG = nldat;
        set(LLG,'dataSet', Trials_Data_Realizations.LLG{i,j}' ,'domainIncr', 1/SR);
        LTA = nldat;
        set(LTA,'dataSet', Trials_Data_Realizations.LTA{i,j}' ,'domainIncr', 1/SR);
        
        Trials_All_NLD.VRnldat{i,j} = VRnldat;
        Trials_All_NLD.TorqueL{i,j} = TorqueL;
        Trials_All_NLD.TorqueR{i,j} = TorqueR;
        Trials_All_NLD.BodyA{i,j} = BodyA;
        Trials_All_NLD.shankL{i,j} = shankL;
        Trials_All_NLD.shankR{i,j} = shankR;
        Trials_All_NLD.TorqueSum{i,j} = TorqueSum;
        
        % EMG NLD Objects
        Trials_All_NLD.EMG_RSol{i,j} = RSol;
        Trials_All_NLD.EMG_RMG{i,j} = RMG;
        Trials_All_NLD.EMG_RLG{i,j} = RLG;
        Trials_All_NLD.EMG_RTA{i,j} = RTA;
        Trials_All_NLD.EMG_LSol{i,j} = LSol;
        Trials_All_NLD.EMG_LMG{i,j} = LMG;
        Trials_All_NLD.EMG_LLG{i,j} = LLG;
        Trials_All_NLD.EMG_LTA{i,j} = LTA;
    end
end





end

