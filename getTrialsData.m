function Trials_Data = getTrialsData(SubjIndex, Subject_data, flb_file_path, Experiment, NN, trials)

global SR LasDel emgGain d_f d_b fc

% Assign Parameters from csv file
hHip = Subject_data{3}(SubjIndex);
hRightSh = Subject_data{4}(SubjIndex);
hLeftSh = Subject_data{5}(SubjIndex);
hLM = Subject_data{6}(SubjIndex);
mass = Subject_data{7}(SubjIndex);
height = Subject_data{8}(SubjIndex);
tQS = Subject_data{9}(SubjIndex);
QS_trial_number = Subject_data{10}(SubjIndex);

% Quiet Stance
QSdata = flb2mat(flb_file_path,'read_case',QS_trial_number);
QS = QuietStance(QSdata , fc , tQS , 'N');

for i = 1:length(trials)
    data_trial = flb2mat(flb_file_path,'read_case',trials(i));
    trial_names = data_trial.comment  % To verify the trials
    Channel_Length = data_trial.chanLen;  %Trial time
    
    data_trial.Data = removeNAN(data_trial.Data, 'Array');
    Channel_Length = length(data_trial.Data);  %Trial time 
    
    % ************ Define Experiment Specific Channel Length *********
    if (SubjIndex == 1)
        % To be completed
    end
    
    if (SubjIndex == 2)
        % To be completed
    end
    
    if (SubjIndex == 3)
        if (Experiment == 3) Channel_Length = 62 * SR; end  % If SoS the length is 60 seconds
    end
    
    if (SubjIndex == 4)
        if (Experiment == 1) Channel_Length = 210 * SR; end  % If TrapZ
        if (Experiment == 2) % If PRTS
            if ((NN == 3) || (NN == 4))
                Channel_Length = 230 * SR;
            else
                Channel_Length = 250 * SR;
            end
        end
        if (Experiment == 3) Channel_Length = 225 * SR; end  % If SoS
    end
    
    if (SubjIndex == 5)
        if (Experiment == 1) Channel_Length = 209 * SR; end
    end
    
    if (SubjIndex == 6)
        if (Experiment == 1) Channel_Length = 209 * SR; end  % If TrapZ
        if (Experiment == 2) % If PRTS
                Channel_Length = 203 * SR;
        end
    end
    
    if (SubjIndex == 7)
        if (Experiment == 1) Channel_Length = 125 * SR; end  % If TrapZ
        if (Experiment == 2) % If PRTS
                Channel_Length = 183 * SR;
        end
    end
    
    if (SubjIndex == 8)
        if (Experiment == 1) Channel_Length = 122 * SR; end  % If TrapZ
    end
    
    if (SubjIndex == 9)
        if (Experiment == 1) Channel_Length = 119.5 * SR; end  % If TrapZ
    end
    
    if (SubjIndex == 10)
        if (Experiment == 1) Channel_Length = 123 * SR; end  % If TrapZ
        if (Experiment == 2) % If PRTS
                Channel_Length = 225 * SR;
        end
    end
    
    if (SubjIndex == 11)
        if (Experiment == 1)  % If HSin
            if (NN==1)
                Channel_Length = 49.5 * SR; 
            else
                Channel_Length = 60 * SR;
            end
        end
        if (Experiment == 2) Channel_Length = 52 * SR; end  % If PRTS dt=0.1  2T
        if (Experiment == 3) Channel_Length = 103 * SR; end  % If PRTS dt=0.2  2T
        if (Experiment == 4) Channel_Length = 80 * SR; end  % If TrapZ
        if (Experiment == 5) Channel_Length = 113 * SR; end  % If TrapV       
    end
    
%     if (SubjIndex == 12)
%         if (Experiment == 1) Channel_Length = 130 * SR; end  % If TrapZ
%         if (Experiment == 2) Channel_Length = 202 * SR; end  % If PRTS dt=0.2
%         if (Experiment == 3) Channel_Length = 152 * SR; end  % If PRTS dt=0.1
%     end

    % ****************************************************************    
    t = (0:(1/SR):(Channel_Length - LasDel)/SR)';    
    
    % rename channels
    data_trial.chanName{12} = 'Hip Laser';  % instead of Tibia
    data_trial.chanName{13} = 'Right Shank Laser';  % instead of Femur
    data_trial.chanName{14} = 'Left Shank Laser';  % instead of Sacrum
    data_trial.chanName{15} = 'VR Input';  % instead of Heel
    data_trial.chanName
    
    % laser calculations
    vLeft=data_trial.Data(1:Channel_Length,14);
    vRight=data_trial.Data(1:Channel_Length,13);
    vHip=data_trial.Data(1:Channel_Length,12);
    
    load(fullfile('CalibrationParams', 'LeftLaserCalibrationConstants'))
    load(fullfile('CalibrationParams', 'RightLaserCalibrationConstants'))
    load(fullfile('CalibrationParams', 'HipLaserCalibrationConstants'))
    
    % finding the distances
    dLeftSh = mLeftLaser * vLeft(LasDel:Channel_Length) + bLeftLaser;
    dRightSh = mRightLaser * vRight(LasDel:Channel_Length) + bRightLaser;
    dHip = mHipLaser * vHip(LasDel:Channel_Length) + bHipLaser;
    
    LeftShAngle(i,:) = angle_cal(dLeftSh,QS.dLeftSh_QS,hLeftSh - hLM);
    HipAngle(i,:) = -angle_cal(dHip,QS.dHip_QS,hHip - hLM);
    RightShAngle(i,:) = angle_cal(dRightSh,QS.dRightSh_QS,hRightSh - hLM);
    
    % Calculation of ankle torque using load cell data
    Force_raw = data_trial.Data(1:Channel_Length,16:23);
    Force = 4.536*9.81*Force_raw;
    Torque_L(i,:)  = -( d_f * (Force(1:Channel_Length - LasDel + 1,1)+Force(1:Channel_Length - LasDel + 1,2)) - d_b * (Force(1:Channel_Length - LasDel + 1,3)+Force(1:Channel_Length - LasDel + 1,4)));
    Torque_R(i,:)  = -( d_f * (Force(1:Channel_Length - LasDel + 1,5)+Force(1:Channel_Length - LasDel + 1,6)) - d_b * (Force(1:Channel_Length - LasDel + 1,7)+Force(1:Channel_Length - LasDel + 1,8)));
    
    TL_trans = data_trial.Data(1:Channel_Length - LasDel + 1,2);
    TR_trans = data_trial.Data(1:Channel_Length - LasDel + 1,4);
    
    Torque_L(i,:)  = Torque_L(i,:)  + mean(TL_trans - Torque_L(i,:)');
    Torque_R(i,:)  = Torque_R(i,:)  + mean(TR_trans - Torque_R(i,:)');
    
    % EMGs
    L_Sol_EMG(i,:)  = abs(data_trial.Data(1:Channel_Length-LasDel+1,8))/emgGain;
    R_Sol_EMG(i,:) = abs(data_trial.Data(1:Channel_Length-LasDel+1,9))/emgGain;
    L_MG_EMG(i,:)  = abs(data_trial.Data(1:Channel_Length-LasDel+1,7))/emgGain;
    R_MG_EMG(i,:)  = abs(data_trial.Data(1:Channel_Length-LasDel+1,10))/emgGain;
    L_LG_EMG(i,:)  = abs(data_trial.Data(1:Channel_Length-LasDel+1,24))/emgGain;
    R_LG_EMG(i,:)  = abs(data_trial.Data(1:Channel_Length-LasDel+1,25))/emgGain;
    L_TA_EMG(i,:)  = abs(data_trial.Data(1:Channel_Length-LasDel+1,6))/emgGain;
    R_TA_EMG(i,:)  = abs(data_trial.Data(1:Channel_Length-LasDel+1,11))/emgGain;
    
    vr_input(i,:) = data_trial.Data(1:Channel_Length - LasDel + 1, 15);
    
end

Trials_Data.vr_input = vr_input;
Trials_Data.RightShAngle = RightShAngle;
Trials_Data.LeftShAngle = LeftShAngle;
Trials_Data.HipAngle = HipAngle;
Trials_Data.Torque_R = Torque_R;
Trials_Data.Torque_L = Torque_R;
Trials_Data.L_Sol_EMG = L_Sol_EMG;
Trials_Data.R_Sol_EMG = R_Sol_EMG;
Trials_Data.L_MG_EMG = L_MG_EMG;
Trials_Data.R_MG_EMG = R_MG_EMG;
Trials_Data.L_LG_EMG = L_LG_EMG;
Trials_Data.R_LG_EMG = R_LG_EMG;
Trials_Data.L_TA_EMG = L_TA_EMG;
Trials_Data.R_TA_EMG = R_TA_EMG;
Trials_Data.trials = trials;

end

