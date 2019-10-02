function [Trials_Data_Realizations, Trials_NLD] = dataRealizations_App(SubjIndex, Experiment, Trials_Data, Averaging, stackTrials, NN, bDDT_VR, bDDT_Output)

global SR

if (Averaging == 0) % No averaging. show both trials at the same time   
    
    Trials_Data_Realizations.vr_realizations = Trials_Data.vr_input_deg;
    Trials_Data_Realizations.left_tq = Trials_Data.Torque_L;
    Trials_Data_Realizations.right_tq = Trials_Data.Torque_R;
    Trials_Data_Realizations.left_shank = Trials_Data.LeftShAngle;
    Trials_Data_Realizations.right_shank = Trials_Data.RightShAngle;
    Trials_Data_Realizations.body_angle = Trials_Data.BodyAngle;
    
    Trials_Data_Realizations.LSol = Trials_Data.L_Sol_EMG;
    Trials_Data_Realizations.RSol = Trials_Data.R_Sol_EMG;
    Trials_Data_Realizations.LMG = Trials_Data.L_MG_EMG;
    Trials_Data_Realizations.RMG = Trials_Data.R_MG_EMG;
    Trials_Data_Realizations.RLG = Trials_Data.R_LG_EMG;
    Trials_Data_Realizations.LLG = Trials_Data.L_LG_EMG;
    Trials_Data_Realizations.RTA = Trials_Data.R_TA_EMG;
    Trials_Data_Realizations.LTA = Trials_Data.L_TA_EMG;
    
    figure(length(findobj('type','figure'))+1)
    subplot(2,2,[1 3])
    plot(Trials_Data_Realizations.vr_realizations','linewidth',1);title('Perturbation')
    
    subplot(2,2,2)
    plot(Trials_Data_Realizations.left_tq','linewidth',1);title('Left torque')
    hold on
    plot(mean(Trials_Data_Realizations.left_tq),'b')
    
    subplot(2,2,4)
    plot(Trials_Data_Realizations.right_tq','linewidth',1);title('Right torque')
    hold on
    plot(mean(Trials_Data_Realizations.right_tq),'b')
    
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    
    
else  % Averaging == 1 (average on periods of one trial) or 2 (average on all periods of all Trials_Data.trials)
    
    if (SubjIndex == 1)
        % To be completed
    end
    
    if (SubjIndex == 2)
        % To be completed
    end
    
    if (SubjIndex == 3)
        if (Experiment == 2) % PRTS
            if (NN == 4)
                periodTime = 107.52 * SR; % with dt = 0.444sec
                periodCount = 1; % number of periods to be considered  CHECK THIS OUT PLZ!
            else
                periodTime = 53.76 * SR; % with dt = 0.222sec
                periodCount = 2; % number of periods to be considered
            end
        elseif (Experiment == 3) % SOS
            
            periodCount = 5; % 5 period out of 6 to have good data
            periodTime = 10 * SR; % with fund_freq = 0.1 Hz;
        end    
    end
    
    if (SubjIndex == 4)
        if (Experiment == 2) % PRTS
            if ((NN == 1) || (NN == 2))
                periodTime = 40.334 * SR; % with dt = 0.166sec
                periodCount = 6; % number of periods to be considered
            elseif ((NN == 3) || (NN == 4))
                periodTime = 53.778 * SR; % with dt = 0.222sec
                periodCount = 4; % number of periods to be considered
            end
        elseif (Experiment == 3) % SOS
            
            periodCount = 10; % 5 period out of 6 to have good data
            periodTime = 20 * SR; % with fund_freq = 0.05 Hz;
        end
    end  
    
    if (SubjIndex == 5)
        % NOTHING
        
    end
            
    if (SubjIndex == 6)
        if (Experiment == 2) % PRTS
            if ((NN == 1) || (NN == 2))
                periodTime = 40.334 * SR; % with dt = 0.166sec
                periodCount = 4; % number of periods to be considered
            elseif ((NN == 3) || (NN == 4))
                periodTime = 53.778 * SR; % with dt = 0.222sec
                periodCount = 3; % number of periods to be considered
            end
        end
    end
    
    if (SubjIndex == 7)
        if (Experiment == 2) % PRTS
            if ((NN == 1))
                periodTime = 40.331 * SR; % with dt = 0.166sec
                periodCount = 4; % number of periods to be considered
            elseif ((NN == 2) || (NN == 3))
                periodTime = 53.776 * SR; % with dt = 0.222sec
                periodCount = 3; % number of periods to be considered
            end
        end
    end
    
    if (SubjIndex == 8)
        % NOTHING        
    end
    
    if (SubjIndex == 9)
        % NOTHING        
    end
    
    if (SubjIndex == 10)
        if (Experiment == 2) % PRTS
            periodTime = 53.776 * SR; % with dt = 0.222sec
            periodCount = 4; % number of periods to be considered            
        end
    end
    
    if (SubjIndex == 11)
        if (Experiment == 2) % PRTS dt=0.1
            periodTime = 24.2 * SR;
            periodCount = 2; % number of periods to be considered
        end
        if (Experiment == 3) % PRTS dt=0.2
            periodTime = 48.4 * SR; 
            periodCount = 2; % number of periods to be considered
        end
    end
    
    if (SubjIndex == 12)
        if (Experiment == 3) % PRTS dt=0.1
            periodTime = 24.2 * SR;
            periodCount = 4; % number of periods to be considered
        end
        if (Experiment == 2) % PRTS dt=0.2
            periodTime = 48.4 * SR;
            periodCount = 4; % number of periods to be considered
        end
    end
    
    if (SubjIndex == 13)
        if (Experiment == 2) % PRTS dt=0.1
            periodTime = 24.2 * SR;
            periodCount = 6; % number of periods to be considered
        end
        if (Experiment == 1) % PRTS dt=0.2
            periodTime = 48.4 * SR;
            periodCount = 4; % number of periods to be considered
        end
    end
    
    if (SubjIndex == 14)
        % NOTHING        
    end
    
    
    Trials_Data_Realizations.vr_realizations = VR_IO_Averaging(Trials_Data.vr_input_deg, Trials_Data.trials, periodTime, periodCount, 'y');
    Trials_Data_Realizations.left_tq = VR_IO_Averaging(Trials_Data.Torque_L, Trials_Data.trials, periodTime, periodCount, 'n');
    Trials_Data_Realizations.right_tq = VR_IO_Averaging(Trials_Data.Torque_R, Trials_Data.trials, periodTime, periodCount, 'n');
    Trials_Data_Realizations.left_shank = VR_IO_Averaging(Trials_Data.LeftShAngle, Trials_Data.trials, periodTime, periodCount, 'n');
    Trials_Data_Realizations.right_shank = VR_IO_Averaging(Trials_Data.RightShAngle, Trials_Data.trials, periodTime, periodCount, 'n');
    Trials_Data_Realizations.body_angle = VR_IO_Averaging(Trials_Data.BodyAngle, Trials_Data.trials, periodTime, periodCount, 'n');
    
    Trials_Data_Realizations.LSol = VR_IO_Averaging(Trials_Data.L_Sol_EMG, Trials_Data.trials, periodTime, periodCount, 'n');
    Trials_Data_Realizations.RSol = VR_IO_Averaging(Trials_Data.R_Sol_EMG, Trials_Data.trials, periodTime, periodCount, 'n');
    Trials_Data_Realizations.LMG = VR_IO_Averaging(Trials_Data.L_MG_EMG, Trials_Data.trials, periodTime, periodCount, 'n');
    Trials_Data_Realizations.RMG = VR_IO_Averaging(Trials_Data.R_MG_EMG, Trials_Data.trials, periodTime, periodCount, 'n');
    Trials_Data_Realizations.RLG = VR_IO_Averaging(Trials_Data.R_LG_EMG, Trials_Data.trials, periodTime, periodCount, 'n');
    Trials_Data_Realizations.LLG = VR_IO_Averaging(Trials_Data.L_LG_EMG, Trials_Data.trials, periodTime, periodCount, 'n');
    Trials_Data_Realizations.RTA = VR_IO_Averaging(Trials_Data.R_TA_EMG, Trials_Data.trials, periodTime, periodCount, 'n');
    Trials_Data_Realizations.LTA = VR_IO_Averaging(Trials_Data.L_TA_EMG, Trials_Data.trials, periodTime, periodCount, 'n');    
    
end

    
%% Stack all Trials_Data.trials together

if (stackTrials == 1)  % Stacking   
    Trials_Data_Realizations.vr_realizations = VR_IO_Stacking(Trials_Data_Realizations.vr_realizations);
    
    Trials_Data_Realizations.left_tq = VR_IO_Stacking(Trials_Data_Realizations.left_tq);
    Trials_Data_Realizations.right_tq = VR_IO_Stacking(Trials_Data_Realizations.right_tq);
    Trials_Data_Realizations.left_shank = VR_IO_Stacking(Trials_Data_Realizations.left_shank);
    Trials_Data_Realizations.right_shank = VR_IO_Stacking(Trials_Data_Realizations.right_shank);
    Trials_Data_Realizations.body_angle = VR_IO_Stacking(Trials_Data_Realizations.body_angle);
    
    Trials_Data_Realizations.LSol = VR_IO_Stacking(Trials_Data_Realizations.LSol);
    Trials_Data_Realizations.RSol = VR_IO_Stacking(Trials_Data_Realizations.RSol);
    Trials_Data_Realizations.LMG = VR_IO_Stacking(Trials_Data_Realizations.LMG);
    Trials_Data_Realizations.RMG = VR_IO_Stacking(Trials_Data_Realizations.RMG);
    Trials_Data_Realizations.RLG = VR_IO_Stacking(Trials_Data_Realizations.RLG);
    Trials_Data_Realizations.LLG = VR_IO_Stacking(Trials_Data_Realizations.LLG);
    Trials_Data_Realizations.RTA = VR_IO_Stacking(Trials_Data_Realizations.RTA);
    Trials_Data_Realizations.LTA = VR_IO_Stacking(Trials_Data_Realizations.LTA);
    
    % Using NLID Toolbox
    
    % Left limb
    TorqueL = nldat;  %Create an NLDAT object for left torque data
    set(TorqueL,'dataSet', Trials_Data_Realizations.left_tq' ,'domainIncr', 1/SR);
    shankL = nldat;
    set(shankL,'dataSet', Trials_Data_Realizations.left_shank','domainIncr',1/SR);
    if (bDDT_Output == 1) shankL = ddt(shankL); end
    
    %Right limb
    TorqueR = nldat;
    set(TorqueR,'dataSet', Trials_Data_Realizations.right_tq' ,'domainIncr',1/SR);
    shankR = nldat;
    set(shankR,'dataSet', Trials_Data_Realizations.right_shank','domainIncr',1/SR);
    if (bDDT_Output == 1) shankR = ddt(shankR); end
    
    %Body
    BodyA = nldat;
    set(BodyA,'dataSet', Trials_Data_Realizations.body_angle' ,'domainIncr',1/SR);
    if (bDDT_Output == 1) BodyA = ddt(BodyA); end
    
    % Summations
    TorqueSum = nldat;
    torque_s = Trials_Data_Realizations.left_tq + Trials_Data_Realizations.right_tq;
    set(TorqueSum,'dataSet', torque_s', 'domainIncr', 1/SR);
        
    % VR input
    VRnldat = nldat;
    set(VRnldat,'dataSet', Trials_Data_Realizations.vr_realizations', 'domainIncr',1/SR);
    if (bDDT_VR == 1) VRnldat = ddt(VRnldat); end
    
    % EMGs Right
    RSol = nldat; 
    set(RSol,'dataSet', Trials_Data_Realizations.RSol' ,'domainIncr', 1/SR);
    
    RMG = nldat;
    set(RMG,'dataSet', Trials_Data_Realizations.RMG' ,'domainIncr', 1/SR);
    
    RLG = nldat;
    set(RLG,'dataSet', Trials_Data_Realizations.RLG' ,'domainIncr', 1/SR);
    
    RTA = nldat;   
    set(RTA,'dataSet', Trials_Data_Realizations.RTA' ,'domainIncr', 1/SR);    
    
    % EMGs Left
    LSol = nldat; 
    set(LSol,'dataSet', Trials_Data_Realizations.LSol' ,'domainIncr', 1/SR);
    
    LMG = nldat;
    set(LMG,'dataSet', Trials_Data_Realizations.LMG' ,'domainIncr', 1/SR);
    
    LLG = nldat;
    set(LLG,'dataSet', Trials_Data_Realizations.LLG' ,'domainIncr', 1/SR);
    
    LTA = nldat;   
    set(LTA,'dataSet', Trials_Data_Realizations.LTA' ,'domainIncr', 1/SR);    

    
elseif ((stackTrials == 2) && (Averaging == 0))  % No stacking No Averaging
    
    % Using NDID Toolbox    
    % Left limb
    TorqueL = nldat;  %Create an NLDAT object for left torque data
    set(TorqueL,'dataSet', Trials_Data_Realizations.left_tq' ,'domainIncr', 1/SR);
    shankL = nldat;
    set(shankL,'dataSet', Trials_Data_Realizations.left_shank','domainIncr',1/SR);
    if (bDDT_Output == 1) shankL = ddt(shankL); end
    
    %Right limb
    TorqueR = nldat;
    set(TorqueR,'dataSet', Trials_Data_Realizations.right_tq' ,'domainIncr',1/SR);
    shankR = nldat;
    set(shankR,'dataSet', Trials_Data_Realizations.right_shank','domainIncr',1/SR);
    if (bDDT_Output == 1) shankR = ddt(shankR); end
    
    %Body
    BodyA = nldat;
    set(BodyA,'dataSet', Trials_Data_Realizations.body_angle' ,'domainIncr',1/SR);
    if (bDDT_Output == 1) BodyA = ddt(BodyA); end
    
    % Summations
    TorqueSum = nldat;
    torque_s = Trials_Data_Realizations.left_tq + Trials_Data_Realizations.right_tq;
    set(TorqueSum,'dataSet', torque_s', 'domainIncr', 1/SR);
    
    % VR
    VRnldat = nldat;
    set(VRnldat,'dataSet', Trials_Data_Realizations.vr_realizations' , 'domainIncr',1/SR);
    if (bDDT_VR == 1) VRnldat = ddt(VRnldat); end

    
    % EMGs Right
    RSol = nldat; 
    set(RSol,'dataSet', Trials_Data_Realizations.RSol' ,'domainIncr', 1/SR);
    
    RMG = nldat;
    set(RMG,'dataSet', Trials_Data_Realizations.RMG' ,'domainIncr', 1/SR);
    
    RLG = nldat;
    set(RLG,'dataSet', Trials_Data_Realizations.RLG' ,'domainIncr', 1/SR);
    
    RTA = nldat;   
    set(RTA,'dataSet', Trials_Data_Realizations.RTA' ,'domainIncr', 1/SR);    
    
    % EMGs Left
    LSol = nldat; 
    set(LSol,'dataSet', Trials_Data_Realizations.LSol' ,'domainIncr', 1/SR);
    
    LMG = nldat;
    set(LMG,'dataSet', Trials_Data_Realizations.LMG' ,'domainIncr', 1/SR);
    
    LLG = nldat;
    set(LLG,'dataSet', Trials_Data_Realizations.LLG' ,'domainIncr', 1/SR);
    
    LTA = nldat;   
    set(LTA,'dataSet', Trials_Data_Realizations.LTA' ,'domainIncr', 1/SR);   
    
    
elseif ((stackTrials == 2) && ((Averaging == 1) || (Averaging == 2)) ) % No stacking with Averaging
           
    % Left limb
    TorqueL = nldat;  %Create an NLDAT object for left torque data
    set(TorqueL,'dataSet',mean(Trials_Data_Realizations.left_tq)' - mean(mean(Trials_Data_Realizations.left_tq)),'domainIncr', 1/SR);
    shankL = nldat;
    set(shankL,'dataSet',mean(Trials_Data_Realizations.left_shank)' - mean(mean(Trials_Data_Realizations.left_shank)),'domainIncr',1/SR);
    if (bDDT_Output == 1) shankL = ddt(shankL); end
    
    %Right limb
    TorqueR = nldat;
    set(TorqueR,'dataSet',mean(Trials_Data_Realizations.right_tq)' - mean(mean(Trials_Data_Realizations.right_tq)) ,'domainIncr',1/SR);
    shankR = nldat;
    set(shankR,'dataSet',mean(Trials_Data_Realizations.right_shank)' - mean(mean(Trials_Data_Realizations.right_shank)),'domainIncr',1/SR);
    if (bDDT_Output == 1) shankR = ddt(shankR); end
    
    %Body
    BodyA = nldat;
    set(BodyA,'dataSet', mean(Trials_Data_Realizations.body_angle)' - mean(mean(Trials_Data_Realizations.body_angle)) ,'domainIncr',1/SR);
    if (bDDT_Output == 1) BodyA = ddt(BodyA); end
    
    % Summations
    TorqueSum = nldat;
    torque_s = Trials_Data_Realizations.left_tq + Trials_Data_Realizations.right_tq;
    set(TorqueSum,'dataSet',mean(torque_s)' - mean(mean(torque_s)),'domainIncr', 1/SR);    
    
    % EMGs Right
    RSol = nldat; 
    set(RSol,'dataSet', mean(Trials_Data_Realizations.RSol)'- mean(mean(Trials_Data_Realizations.RSol)) ,'domainIncr', 1/SR);
    
    RMG = nldat;
    set(RMG,'dataSet', mean(Trials_Data_Realizations.RMG)'- mean(mean(Trials_Data_Realizations.RMG)) ,'domainIncr', 1/SR);
    
    RLG = nldat;
    set(RLG,'dataSet', mean(Trials_Data_Realizations.RLG)'- mean(mean(Trials_Data_Realizations.RLG)) ,'domainIncr', 1/SR);
    
    RTA = nldat;   
    set(RTA,'dataSet', mean(Trials_Data_Realizations.RTA)'- mean(mean(Trials_Data_Realizations.RTA)) ,'domainIncr', 1/SR);    
    
    % EMGs Left
    LSol = nldat; 
    set(LSol,'dataSet', mean(Trials_Data_Realizations.LSol)'- mean(mean(Trials_Data_Realizations.LSol)) ,'domainIncr', 1/SR);
    
    LMG = nldat;
    set(LMG,'dataSet', mean(Trials_Data_Realizations.LMG)'- mean(mean(Trials_Data_Realizations.LMG)) ,'domainIncr', 1/SR);
    
    LLG = nldat;
    set(LLG,'dataSet', mean(Trials_Data_Realizations.LLG)'- mean(mean(Trials_Data_Realizations.LLG)) ,'domainIncr', 1/SR);
    
    LTA = nldat;   
    set(LTA,'dataSet', mean(Trials_Data_Realizations.LTA)'- mean(mean(Trials_Data_Realizations.LTA)) ,'domainIncr', 1/SR);    
        
    VRnldat = nldat;
    set(VRnldat,'dataSet', mean(Trials_Data_Realizations.vr_realizations)' - mean(mean(Trials_Data_Realizations.vr_realizations)) ,'domainIncr',1/SR);    
    %set(VRnldat,'dataSet', (Trials_Data_Realizations.vr_realizations)' ,'domainIncr', 1/SR);
    if (bDDT_VR == 1) VRnldat = ddt(VRnldat); end

end

Trials_NLD.VRnldat = VRnldat;

Trials_NLD.TorqueL = TorqueL;
Trials_NLD.TorqueR = TorqueR;
Trials_NLD.BodyA = BodyA;
Trials_NLD.shankL = shankL;
Trials_NLD.shankR = shankR;
Trials_NLD.TorqueSum = TorqueSum;

% EMG NLD Objects
Trials_NLD.EMG_RSol = RSol;
Trials_NLD.EMG_RMG = RMG;
Trials_NLD.EMG_RLG = RLG;
Trials_NLD.EMG_RTA = RTA;
Trials_NLD.EMG_LSol = LSol;
Trials_NLD.EMG_LMG = LMG;
Trials_NLD.EMG_LLG = LLG;
Trials_NLD.EMG_LTA = LTA;


end

