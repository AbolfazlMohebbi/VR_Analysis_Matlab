clear all;
close all;
clc;
dataPath = pwd + "\data\";
set(0,'DefaultAxesFontSize',14,'DefaultLineLineWidth',1.5,'DefaultLineMarkerSize',8)
set(0,'DefaultLineColor','b')

%% subject info: 

Subject_Name = 'Pouya_3';

fid = fopen('SubjectsParams_1.csv');
Subject_data = textscan(fid, '%f %s %f %f %f %f %f %f %f %f %s', 'Delimiter', ',', 'HeaderLines', 1);
fclose(fid);
% datenum(data{6})  % array of the column 6
SubjIndex = find(contains(Subject_data{2},Subject_Name));
number = Subject_data{1}(SubjIndex);
name = Subject_data{2}{SubjIndex};
hHip = Subject_data{3}(SubjIndex);
hRightSh = Subject_data{4}(SubjIndex);
hLeftSh = Subject_data{5}(SubjIndex);
hLM = Subject_data{6}(SubjIndex);
mass = Subject_data{7}(SubjIndex);
height = Subject_data{8}(SubjIndex);
tQS = Subject_data{9}(SubjIndex);
QS_trial_number = Subject_data{10}(SubjIndex);
flb_file = Subject_data{11}{SubjIndex};

flb_file_path = dataPath + flb_file;

%%
global SR LasDel emgGain dr d_f d_b
SR = 1000; % data Sampling rate
LasDel = 4;  % Laser sensors delay
emgGain = 1000; 
dr = 10; % decimation filters the signal with a cutoff of 0.8/dr*(SR/2)
d_f = 238.89/1000; % distance between the front load cells and ankle axis of rotation
d_b = 51.05/1000; % distance between the back load cells and ankle axis of rotation
fc = 0.8/dr*(SR/2);
[filter_num,filter_den] = cheby1(10,0.05,fc/(SR/2)); % Chebyshev was used because it is used in decimation


%% Quiet Stance 

QSdata = flb2mat(flb_file_path,'read_case',QS_trial_number);
QS = QuietStance(QSdata , fc , tQS , 'N');


%% All data and Trials

data = flb2mat(flb_file_path, 'read_all')
trials = {data.comment}
Averaging = 0;

Experiment = input('Which experiment would you like to examine?\n 1) TrapZ \n 2) PRTS \n 3) Sum of Sinusoids \n 4) PRBS \n ');

if (Experiment == 1)
    NN = input('Which trial do you want to examine for TrapZ?\n 1) TrapZ 2deg, 6dps\n 2) TrapZ 2deg, 3dps\n 3) TrapZ 5deg, 3dps\n 4) TrapZ 5deg, 6dps\n 5) TrapZ 10deg, 3dps\n');
    if NN == 1
        trials = 3:4;
        TrapZ_Amp = 2.0;
    elseif NN == 2
        trials = 5:6;
        TrapZ_Amp = 2.0;
    elseif NN == 3
        trials = 7:8;
        TrapZ_Amp = 5.0;
    elseif NN == 4
        trials = 9:10;
        TrapZ_Amp = 5.0;
    elseif NN == 5
        trials = 11:12;
        TrapZ_Amp = 10.0;        
    end
end

if (Experiment == 2)   % PRTS 
    NN = input('Which trial do you want to examine for PRTS?\n 1) PRTS 2deg, dt=0.22s\n 2) PRTS 5deg, dt=0.22s\n 3) PRTS 10deg, dt=0.22s\n 4) PRTS 5deg, dt=0.44s\n');
    Averaging = input('Would you like to perform averaging?\n 1)Yes\n 2)No\n');
    if NN == 1
        trials = 13:14;  % 2deg, dt=0.22s
        PRTS_Amp = 2.0; 
        min_PRTS = -0.4705809;
    elseif NN == 2
        trials = 17:18;  % 5deg, dt=0.22s
        PRTS_Amp = 5.0; 
        min_PRTS = -1.176452;
    elseif NN == 3
        trials = 15:16;  % 10deg, dt=0.22s
        PRTS_Amp = 10.0;
        min_PRTS = -2.352905;
    elseif NN == 4
        trials = 21:22;  % 5 deg, dt=0.44s
        PRTS_Amp = 5.0; 
        min_PRTS = -1.176452;
    end
end

if (Experiment == 3)
    NN = input('Which trial do you want to examine for Sum of Sinusoids?\n 1) SOS 2deg, maxFR=3Hz\n 2) SOS 5deg, maxFR=3Hz\n 3) SOS 2deg, maxFR=1.5Hz\n 4) SOS 5deg, maxFR=1.5Hz\n');
    Averaging = input('Would you like to perform averaging?\n 1)Yes\n 2)No\n');
    if NN == 1
        trials = 23:24;
        SoS_Amp = 2.0;
    elseif NN == 2
        trials = [25 27];
        SoS_Amp = 5.0;
    elseif NN == 3
        trials = [28 39];
        SoS_Amp = 2.0;
    elseif NN == 4
        trials = 29:30; 
        SoS_Amp = 5.0;
    end
end

if (Experiment == 4)
    NN = input('Which trial do you want to examine for Sum of PRBS?\n 1) PRBS 2deg, SR=0.22s\n 2) PRBS 5deg, SR=0.22s\n 3) PRBS 2deg, SR=0.44s\n 4) PRBS 5deg, SR=0.44s\n');
    if NN == 1
        trials = 31:32;
        PRBS_Amp = 2.0;
    elseif NN == 2
        trials = 33:34;
        PRBS_Amp = 5.0;
    elseif NN == 3
        trials = 35:36;
        PRBS_Amp = 2.0;
    elseif NN == 4
        trials = 37:38; 
        PRBS_Amp = 5.0;
    end
end


%% read data based on chosen experiments

for i = 1:length(trials)
    data_trial = flb2mat(flb_file_path,'read_case',trials(i));
    trial_names = data_trial.comment  % To verify the trials
    Channel_Length = data_trial.chanLen;  %Trial time
    if (Experiment == 3) Channel_Length = 62 * SR; end
    t = (0:(1/SR):(Channel_Length - LasDel)/SR)';
    
    % rename channels
    data_trial.chanName{12} = 'Hip Laser';  % instead of Tibia
    data_trial.chanName{13} = 'Right Shank Laser';  % instead of Femur
    data_trial.chanName{14} = 'Left Shank Laser';  % instead of Sacrum
    data_trial.chanName{15} = 'VR Input';  % instead of Heel
    
    % laser calculations
    vLeft=data_trial.Data(1:Channel_Length,14);
    vRight=data_trial.Data(1:Channel_Length,13);
    vHip=data_trial.Data(1:Channel_Length,12);
    
    load LeftLaserCalibrationConstants
    load RightLaserCalibrationConstants
    load HipLaserCalibrationConstants
    
    % finding the distances
    dLeftSh = mLeftLaser * vLeft(LasDel:Channel_Length) + bLeftLaser;
    dRightSh = mRightLaser * vRight(LasDel:Channel_Length) + bRightLaser;
    dHip = mHipLaser * vHip(LasDel:Channel_Length) + bHipLaser;
    
    % zero order shift filtering using the above Chebyshev filter
    dLeftShFilt = filtfilt(filter_num,filter_den,dLeftSh);
    dRightShFilt = filtfilt(filter_num,filter_den,dRightSh);
    dHipFilt = filtfilt(filter_num,filter_den,dHip);
    
    % a minuse must be added for the hip angle
    LeftShAngle(i,:) = angle_cal(dLeftShFilt,QS.dLeftSh_QS,hLeftSh - hLM);
    HipAngle(i,:) = -angle_cal(dHipFilt,QS.dHip_QS,hHip - hLM);
    RightShAngle(i,:) = angle_cal(dRightShFilt,QS.dRightSh_QS,hRightSh - hLM);
    
    % Calculation of ankle torque using load cell data
    Force_raw = data_trial.Data(1:Channel_Length,16:23);
    Force = 4.536*9.81*filtfilt(filter_num,filter_den,Force_raw);
    Torque_L(i,:)  = -( d_f * (Force(1:Channel_Length - LasDel + 1,1)+Force(1:Channel_Length - LasDel + 1,2)) - d_b * (Force(1:Channel_Length - LasDel + 1,3)+Force(1:Channel_Length - LasDel + 1,4)));
    Torque_R(i,:)  = -( d_f * (Force(1:Channel_Length - LasDel + 1,5)+Force(1:Channel_Length - LasDel + 1,6)) - d_b * (Force(1:Channel_Length - LasDel + 1,7)+Force(1:Channel_Length - LasDel + 1,8)));
    
    TL_trans = filtfilt(filter_num,filter_den,data_trial.Data(1:Channel_Length - LasDel + 1,2));
    TR_trans = filtfilt(filter_num,filter_den,data_trial.Data(1:Channel_Length - LasDel + 1,4));
    
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
    
    % VR input    
    if (Experiment == 4)        
        vr_input(i,:) = filtfilt(filter_num, filter_den, data_trial.Data(1:Channel_Length - LasDel + 1, 15));
        
    else
        vr_input(i,:) = data_trial.Data(1:Channel_Length - LasDel + 1, 15);
    end
    
end
data_trial.chanName % To verify channel names

%% Synchronise the start time for VR input and outputs 
if (Experiment == 2)    % for PRTS inputs (2 Period)
    init_sample_size = 4000;
    inputVR_err = 0.0004;
    startPerturbation_index = zeros(1, length(trials));
    
    vr_input_new = zeros(size(vr_input));
    
    LeftShAngle_new = zeros(size(LeftShAngle));
    HipAngle_new = zeros(size(HipAngle));
    RightShAngle_new = zeros(size(RightShAngle));
    
    Torque_L_new = zeros(size(Torque_L));
    Torque_R_new = zeros(size(Torque_R));
    
    % EMGs
    L_Sol_EMG_new = zeros(size(L_Sol_EMG));
    R_Sol_EMG_new = zeros(size(R_Sol_EMG));
    L_MG_EMG_new = zeros(size(L_MG_EMG));
    R_MG_EMG_new = zeros(size(R_MG_EMG));
    L_LG_EMG_new = zeros(size(L_LG_EMG));
    R_LG_EMG_new = zeros(size(R_LG_EMG));
    L_TA_EMG_new = zeros(size(L_TA_EMG));
    R_TA_EMG_new = zeros(size(R_TA_EMG));
    
    for i = 1:length(trials)
        for j = 1:init_sample_size
            if (abs(vr_input(i,j+1)-vr_input(i,j))>inputVR_err)
                startPerturbation_index(i) = j;
                break
            end
        end
        vr_input_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = vr_input(i,startPerturbation_index(i)+1:end);
        
        LeftShAngle_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = LeftShAngle(i,startPerturbation_index(i)+1:end);
        HipAngle_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = HipAngle(i,startPerturbation_index(i)+1:end);
        RightShAngle_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = RightShAngle(i,startPerturbation_index(i)+1:end);
        
        Torque_L_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = Torque_L(i,startPerturbation_index(i)+1:end);
        Torque_R_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = Torque_R(i,startPerturbation_index(i)+1:end);
        
        % EMGs
        L_Sol_EMG_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = L_Sol_EMG(i,startPerturbation_index(i)+1:end);
        R_Sol_EMG_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = R_Sol_EMG(i,startPerturbation_index(i)+1:end);
        L_MG_EMG_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = L_MG_EMG(i,startPerturbation_index(i)+1:end);
        R_MG_EMG_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = R_MG_EMG(i,startPerturbation_index(i)+1:end);
        L_LG_EMG_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = L_LG_EMG(i,startPerturbation_index(i)+1:end);
        R_LG_EMG_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = R_LG_EMG(i,startPerturbation_index(i)+1:end);
        L_TA_EMG_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = L_TA_EMG(i,startPerturbation_index(i)+1:end);
        R_TA_EMG_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = R_TA_EMG(i,startPerturbation_index(i)+1:end);
    end
    
    % Change volts to degrees
    vr_input_deg = ((PRTS_Amp/5.0) * vr_input_new) + min_PRTS;
    ti_PRTS = 50;
    tf_PRTS = 107570;
    vr_input_deg = vr_input_deg(:, ti_PRTS:tf_PRTS);  % cut unnecessary initial and final zero data to have exactly 2 periods
    
    LeftShAngle_new = LeftShAngle_new(:, ti_PRTS:tf_PRTS);
    HipAngle_new = HipAngle_new(:, ti_PRTS:tf_PRTS);
    RightShAngle_new = RightShAngle_new(:, ti_PRTS:tf_PRTS);
    Torque_L_new = Torque_L_new(:, ti_PRTS:tf_PRTS);
    Torque_R_new = Torque_R_new(:, ti_PRTS:tf_PRTS);
    
    % EMGs
    L_Sol_EMG_new = L_Sol_EMG_new(:, ti_PRTS:tf_PRTS);
    R_Sol_EMG_new = R_Sol_EMG_new(:, ti_PRTS:tf_PRTS);
    L_MG_EMG_new = L_MG_EMG_new(:, ti_PRTS:tf_PRTS);
    R_MG_EMG_new = R_MG_EMG_new(:, ti_PRTS:tf_PRTS);
    L_LG_EMG_new = L_LG_EMG_new(:, ti_PRTS:tf_PRTS);
    R_LG_EMG_new = R_LG_EMG_new(:, ti_PRTS:tf_PRTS);
    L_TA_EMG_new = L_TA_EMG_new(:, ti_PRTS:tf_PRTS);
    R_TA_EMG_new = R_TA_EMG_new(:, ti_PRTS:tf_PRTS);    
    
    figure(1)
    plot(vr_input_deg','DisplayName','vr_input_deg');
    
else  % if PRBS, SOS, TrapZ
    
    % Synchronise the start time for VR input abd outputs for Non-periodic inputs (PRBS, SoS, TrapZ)
    init_sample_size = 4000;
    inputVR_err = 0.0004;
    startPerturbation_index = zeros(1, length(trials));
    
    vr_input_new = zeros(size(vr_input));
    
    LeftShAngle_new = zeros(size(LeftShAngle));
    HipAngle_new = zeros(size(HipAngle));
    RightShAngle_new = zeros(size(RightShAngle));
    
    Torque_L_new = zeros(size(Torque_L));
    Torque_R_new = zeros(size(Torque_R));
    
    % EMGs
    L_Sol_EMG_new = zeros(size(L_Sol_EMG));
    R_Sol_EMG_new = zeros(size(R_Sol_EMG));
    L_MG_EMG_new = zeros(size(L_MG_EMG));
    R_MG_EMG_new = zeros(size(R_MG_EMG));
    L_LG_EMG_new = zeros(size(L_LG_EMG));
    R_LG_EMG_new = zeros(size(R_LG_EMG));
    L_TA_EMG_new = zeros(size(L_TA_EMG));
    R_TA_EMG_new = zeros(size(R_TA_EMG));
    
    for i = 1:length(trials)
        for j = 1:init_sample_size
            if (abs(vr_input(i,j+1)-vr_input(i,j))>inputVR_err)
                startPerturbation_index(i) = j;
                break
            end
        end
        vr_input_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = vr_input(i,startPerturbation_index(i)+1:end);
        
        LeftShAngle_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = LeftShAngle(i,startPerturbation_index(i)+1:end);
        HipAngle_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = HipAngle(i,startPerturbation_index(i)+1:end);
        RightShAngle_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = RightShAngle(i,startPerturbation_index(i)+1:end);
        
        Torque_L_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = Torque_L(i,startPerturbation_index(i)+1:end);
        Torque_R_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = Torque_R(i,startPerturbation_index(i)+1:end);
        
        % EMGs
        L_Sol_EMG_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = L_Sol_EMG(i,startPerturbation_index(i)+1:end);
        R_Sol_EMG_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = R_Sol_EMG(i,startPerturbation_index(i)+1:end);
        L_MG_EMG_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = L_MG_EMG(i,startPerturbation_index(i)+1:end);
        R_MG_EMG_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = R_MG_EMG(i,startPerturbation_index(i)+1:end);
        L_LG_EMG_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = L_LG_EMG(i,startPerturbation_index(i)+1:end);
        R_LG_EMG_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = R_LG_EMG(i,startPerturbation_index(i)+1:end);
        L_TA_EMG_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = L_TA_EMG(i,startPerturbation_index(i)+1:end);
        R_TA_EMG_new(i,1:length(vr_input(i,startPerturbation_index(i)+1:end))) = R_TA_EMG(i,startPerturbation_index(i)+1:end);
    end
    
    
    if (Experiment == 1) % TrapZ
        vr_input_deg = TrapZ_Amp * ((vr_input_new/2.5) - 1.0);
        ti = 2000;
        tf = 107000;
        
    elseif (Experiment == 3)  % Sum of Sin
        vr_input_deg = (vr_input_new/5.0)* SoS_Amp;
        % NO    other option for now!!!
        ti = 1;
        tf = 58010;
        
    elseif (Experiment == 4) % PRBS
        vr_input_deg = ((vr_input_new/2.5)-1.0) * PRBS_Amp;
        ti = 2000;
        tf = 107000;
    end
    
    vr_input_deg = vr_input_deg(:, ti:tf);  % cut unnecessary initial and final zero data to have exactly 2 periods
    
    LeftShAngle_new = LeftShAngle_new(:, ti:tf);
    HipAngle_new = HipAngle_new(:, ti:tf);
    RightShAngle_new = RightShAngle_new(:, ti:tf);
    Torque_L_new = Torque_L_new(:, ti:tf);
    Torque_R_new = Torque_R_new(:, ti:tf);
    
    % EMGs
    L_Sol_EMG_new = L_Sol_EMG_new(:, ti:tf);
    R_Sol_EMG_new = R_Sol_EMG_new(:, ti:tf);
    L_MG_EMG_new = L_MG_EMG_new(:, ti:tf);
    R_MG_EMG_new = R_MG_EMG_new(:, ti:tf);
    L_LG_EMG_new = L_LG_EMG_new(:, ti:tf);
    R_LG_EMG_new = R_LG_EMG_new(:, ti:tf);
    L_TA_EMG_new = L_TA_EMG_new(:, ti:tf);
    R_TA_EMG_new = R_TA_EMG_new(:, ti:tf);    
    
    figure(1);
    plot(vr_input_deg','DisplayName','vr_input_deg');
    %plot(vr_input_new','DisplayName','vr_input_new');
    
end

% vr_input = vr_input_new;

%% Average data in each periods for periodic VR inputs (PRTS)

% Not useful for SumOfSin or PRBS or TrapZ as the phase is random
% TODO: Use ginput to get starting point

if (Averaging==1)
    
    if (Experiment == 2) % PRTS    
        if (NN == 4)
            periodTime = 107.52 * SR; % with dt = 0.444sec
        else
            periodTime = 53.76 * SR; % with dt = 0.222sec
        end
        
        periodCount = 2; % number of periods to be considered         
        [~, vr_realizations] = VR_IO_Averaging(vr_input_deg, trials, periodTime, periodCount, 'y');
        [left_tq_mean, left_tq] = VR_IO_Averaging(Torque_L_new, trials, periodTime, periodCount, 'y');
        [right_tq_mean, right_tq] = VR_IO_Averaging(Torque_R_new, trials, periodTime, periodCount, 'y');
        [left_shank_mean, left_shank] = VR_IO_Averaging(LeftShAngle_new, trials, periodTime, periodCount, 'y');
        [right_shank_mean, right_shank] = VR_IO_Averaging(RightShAngle_new, trials, periodTime, periodCount, 'y');
        [hip_angle_mean, hip_angle] = VR_IO_Averaging(HipAngle_new, trials, periodTime, periodCount, 'y');
        
        [LSol_mean, LSol] = VR_IO_Averaging(L_Sol_EMG_new, trials, periodTime, periodCount, 'y');
        [RSol_mean, RSol] = VR_IO_Averaging(R_Sol_EMG_new, trials, periodTime, periodCount, 'n');        
        [LMG_mean, LMG] = VR_IO_Averaging(L_MG_EMG_new, trials, periodTime, periodCount, 'n');
        [RMG_mean, RMG] = VR_IO_Averaging(R_MG_EMG_new, trials, periodTime, periodCount, 'n');        
        [RLG_mean, RLG] = VR_IO_Averaging(R_LG_EMG_new, trials, periodTime, periodCount, 'n');
        [LLG_mean, LLG] = VR_IO_Averaging(L_LG_EMG_new, trials, periodTime, periodCount, 'n');        
        [RTA_mean, RTA] = VR_IO_Averaging(R_TA_EMG_new, trials, periodTime, periodCount, 'n');
        [LTA_mean, LTA] = VR_IO_Averaging(L_TA_EMG_new, trials, periodTime, periodCount, 'n');       

    end    
    
    if (Experiment == 3) % SOS
        
        periodCount = 5; % 5 period out of 6 to have good data
        periodTime = 10 * SR; % with fund_freq = 0.1 Hz;        
        [~, vr_realizations] = VR_IO_Averaging(vr_input_deg, 0, periodTime, periodCount, 'y');
        [left_tq_mean, left_tq] = VR_IO_Averaging(Torque_L_new, 0, periodTime, periodCount, 'y');
        [right_tq_mean, right_tq] = VR_IO_Averaging(Torque_R_new, 0, periodTime, periodCount, 'y');
        [left_shank_mean, left_shank] = VR_IO_Averaging(LeftShAngle_new, 0, periodTime, periodCount, 'y');
        [right_shank_mean, right_shank] = VR_IO_Averaging(RightShAngle_new, 0, periodTime, periodCount, 'y');
        [hip_angle_mean, hip_angle] = VR_IO_Averaging(HipAngle_new, 0, periodTime, periodCount, 'y');
        
        [LSol_mean, LSol] = VR_IO_Averaging(L_Sol_EMG_new, 0, periodTime, periodCount, 'y');
        [RSol_mean, RSol] = VR_IO_Averaging(R_Sol_EMG_new, 0, periodTime, periodCount, 'n');        
        [LMG_mean, LMG] = VR_IO_Averaging(L_MG_EMG_new, 0, periodTime, periodCount, 'n');
        [RMG_mean, RMG] = VR_IO_Averaging(R_MG_EMG_new, 0, periodTime, periodCount, 'n');        
        [RLG_mean, RLG] = VR_IO_Averaging(R_LG_EMG_new, 0, periodTime, periodCount, 'n');
        [LLG_mean, LLG] = VR_IO_Averaging(L_LG_EMG_new, 0, periodTime, periodCount, 'n');        
        [RTA_mean, RTA] = VR_IO_Averaging(R_TA_EMG_new, 0, periodTime, periodCount, 'n');
        [LTA_mean, LTA] = VR_IO_Averaging(L_TA_EMG_new, 0, periodTime, periodCount, 'n');
        
    end
     
else  % No Averaging
    
    vr_realizations = vr_input_deg;
    left_tq = Torque_L_new;
    right_tq = Torque_R_new;
    left_shank = LeftShAngle_new;
    right_shank = RightShAngle_new;
    
    figure()
    subplot(2,2,[1 3])
    plot(vr_realizations','linewidth',1);title('Perturbation')
    
    subplot(2,2,2)
    plot(left_tq','linewidth',1);title('Left torque')
    hold on
    plot(mean(left_tq),'b')
    
    subplot(2,2,4)
    plot(right_tq','linewidth',1);title('Right torque')
    hold on
    plot(mean(right_tq),'b')    

end


%% defining the variables
%Left limb
outputL = nldat;
set(outputL,'dataSet',mean(left_tq)' - mean(mean(left_tq)),'domainIncr',1/SR);
teta_shL = nldat;
set(teta_shL,'dataSet',mean(left_shank)' - mean(mean(left_shank)),'domainIncr',1/SR);

%Right limb
outputR = nldat;
set(outputR,'dataSet',mean(right_tq)' - mean(mean(right_tq)) ,'domainIncr',1/SR);
teta_shR = nldat;
set(teta_shR,'dataSet',mean(right_shank)' - mean(mean(right_shank)),'domainIncr',1/SR);

vr_input_nldat = nldat;
set(vr_input_nldat,'dataSet',mean(vr_realizations)','domainIncr',1/SR);
%set(vr_input_nldat,'dataSet',mean(vr_realizations)' - mean(mean(vr_realizations)) ,'domainIncr',1/SR);
t = 0:1/SR:(length(outputL)-1)/SR;

%%
%%%%%%%%%%%%%%%%%%%%
%%% plot the data%%%
%%%%%%%%%%%%%%%%%%%%
nFFT = 10000;
figure(3)
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Left ankle %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
x(1) = subplot(221);
ax = plotyy(t,vr_input_nldat.dataSet,t,outputL.dataSet);hold on
title('Left Ankle')
ylabel(ax(1),'VR pert. angle (rad)');
ylabel(ax(2),'Ankle torque');

% shank angle
x(2) = subplot(223);
plot(t,teta_shL.dataSet);hold on
xlabel('Time (s)')
ylabel('Angle (rad)')

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Right Ankle %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
x(3) = subplot(222);
ax = plotyy(t,vr_input_nldat.dataSet,t,outputR.dataSet);hold on
title('Right Ankle');hold on
ylabel(ax(1),'VR pert. angle (rad)');
ylabel(ax(2),'Ankle torque');

% shank angle
x(4) = subplot(224);
plot(t,teta_shR.dataSet);hold on
xlabel('Time (s)')
ylabel('Angle (rad)')
linkaxes(x,'x')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4)
% left torque power
leftTorquePower = spect(outputL,'nFFT',nFFT);
x(1) = subplot(221);
semilogx(0:SR/nFFT:SR/2,leftTorquePower.dataSet);hold on
xlim([0 SR/2])
xlabel('Frequency (Hz)')
ylabel('Power')

% left torque distribution
leftTorqueDist = pdf(outputL,'nBins',100);hold on
x(2) = subplot(223);
plot(leftTorqueDist.domainValues,leftTorqueDist.dataSet);hold on
ylabel('Density')
xlabel('Torque (Nm)')

%right torque power
rightTorquePower = spect(outputR,'nFFT',nFFT);
x(3) = subplot(222);
semilogx(0:SR/nFFT:SR/2,rightTorquePower.dataSet);hold on
xlim([0 SR/2])
xlabel('Frequency (Hz)')
ylabel('Power')

% right torque distribution
rightTorqueDist = pdf(outputR,'nBins',100);
x(4) = subplot(224);
plot(rightTorqueDist.domainValues,rightTorqueDist.dataSet);hold on
ylabel('Density')
xlabel('Torque (Nm)')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Linear ID %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
zleft_vr2tq = cat(2,vr_input_nldat,outputL);zleft_vr2tq_decimated = decimate(zleft_vr2tq,dr);
zright_vr2tq = cat(2,vr_input_nldat,outputR);zright_vr2tq_decimated = decimate(zright_vr2tq,dr); 
zleft_vr2tetaSh = cat(2,vr_input_nldat,teta_shL);zleft_vr2tetaSh_decimated = decimate(zleft_vr2tetaSh,dr);
zright_vr2tetaSh = cat(2,vr_input_nldat,teta_shR);zright_vr2tetaSh_decimated = decimate(zright_vr2tetaSh,dr);

nlags = 400;
nsides = 1;
irf_left_vr2tq = irf(zleft_vr2tq_decimated,'nSides',nsides,'nLags',nlags);
% set(irf_left_vr2tq,'dataSet',filtfilt(fil_num,fil_den,irf_left_vr2tq.dataSet));

irf_right_vr2tq = irf(zright_vr2tq_decimated,'nSides',nsides,'nLags',nlags);
% set(irf_right_vr2tq,'dataSet',filtfilt(fil_num,fil_den,irf_right_vr2tq.dataSet));

irf_left_vr2tetaSh = irf(zleft_vr2tetaSh_decimated,'nSides',nsides,'nLags',nlags);
% set(irf_left_vr2tetaSh,'dataSet',filtfilt(fil_num,fil_den,irf_left_vr2tetaSh.dataSet));

irf_right_vr2tetaSh = irf(zright_vr2tetaSh_decimated,'nSides',nsides,'nLags',nlags);
% set(irf_right_vr2tetaSh,'dataSet',filtfilt(fil_num,fil_den,irf_right_vr2tetaSh.dataSet));

output_left_vr2tq_sim = nlsim(irf_left_vr2tq,decimate(vr_input_nldat,dr));
vaf_tql = vaf(decimate(outputL,dr),output_left_vr2tq_sim);


output_right_vr2tq_sim = nlsim(irf_right_vr2tq,decimate(vr_input_nldat,dr));vaf_tqr = vaf(decimate(outputR,dr),output_right_vr2tq_sim);
output_left_vr2tetaSh_sim = nlsim(irf_left_vr2tetaSh,decimate(vr_input_nldat,dr));vaf_tetal = vaf(decimate(teta_shL,dr),output_left_vr2tetaSh_sim);
output_right_vr2tetaSh_sim = nlsim(irf_right_vr2tetaSh,decimate(vr_input_nldat,dr));vaf_tetar = vaf(decimate(teta_shR,dr),output_right_vr2tetaSh_sim);

figure(5)
subplot(221)
plot(irf_left_vr2tq);title('IRF: left VR -> tq ');hold on
subplot(222)
plot(irf_right_vr2tq);title('IRF: right VR -> tq ');hold on
subplot(223)
plot(irf_left_vr2tetaSh);title('IRF: left VR -> shank angle ');hold on
subplot(224)
plot(irf_right_vr2tetaSh);title('IRF: right VR -> shank angle ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])


figure(6)
plot(fresp(zleft_vr2tq_decimated,'nFFT',nFFT/dr));title('FR: left VR -> tq ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
figure(7)
plot(fresp(zright_vr2tq_decimated,'nFFT',nFFT/dr));title('FR: right VR -> tq ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
figure(8)
plot(fresp(zleft_vr2tetaSh_decimated,'nFFT',nFFT/dr));title('FR: left VR -> shank angle ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
figure(9)
plot(fresp(zright_vr2tetaSh_decimated,'nFFT',nFFT/dr));title('FR: right VR -> shank angle ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(10)
subplot(221)
plot(decimate(outputL,dr));hold on
plot(output_left_vr2tq_sim);title(['Left torque, VAF = %' num2str(double(vaf_tql),2)]);
legend('Measured','Simulated')

subplot(222)
plot(decimate(outputR,dr));hold on
plot(output_right_vr2tq_sim);title(['Right torque, VAF = %' num2str(double(vaf_tqr),2)]);
legend('Measured','Simulated')

subplot(223)
plot( decimate(teta_shL,dr));hold on
plot(output_left_vr2tetaSh_sim);title(['Left shank angle, VAF = %' num2str(double(vaf_tetal),2)]);
legend('Measured','Simulated')

subplot(224)
plot(decimate(teta_shR,dr));hold on
plot(output_right_vr2tetaSh_sim);title(['Right shank angle, VAF = %' num2str(double(vaf_tetar),2)]);
legend('Measured','Simulated')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

%%
figure()
% left torque power
input_VR_power = spect(vr_input_nldat-mean(vr_input_nldat),'nFFT',nFFT);
plot(input_VR_power);
% semilogx(0:SR/nFFT:SR/2,leftTorquePower.dataSet);hold on
xlabel('Frequency (Hz)')
ylabel('Power')


FR_left_vr2tq = fresp(zleft_vr2tq_decimated,'nFFT',500);
figure()
plot(FR_left_vr2tq)






