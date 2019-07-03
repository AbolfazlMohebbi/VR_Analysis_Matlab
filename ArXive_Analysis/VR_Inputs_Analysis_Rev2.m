clear all;
clc;
dataPath = pwd + "\data\";
set(0,'DefaultAxesFontSize',14,'DefaultLineLineWidth',1.5,'DefaultLineMarkerSize',8)
set(0,'DefaultLineColor','b')
datestring = datestr(now,'ddmmmyyyy_HH-MM');

%% Load Data and subject info: 
Subject_Name = 'Pouya_4';
fid = fopen('SubjectsParams_1.csv');
Subject_data = textscan(fid, '%f %s %f %f %f %f %f %f %f %f %s', 'Delimiter', ',', 'HeaderLines', 1);
fclose(fid);

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

%% Global variables
global SR LasDel emgGain dr d_f d_b
SR = 1000; % data Sampling rate
LasDel = 4;  % Laser sensors delay
emgGain = 1000; 
dr = 50; % decimation filters the signal with a cutoff of 0.8/dr*(SR/2)
d_f = 238.89/1000; % distance between the front load cells and ankle axis of rotation
d_b = 51.05/1000; % distance between the back load cells and ankle axis of rotation
fc = 0.8/dr*(SR/2);

%% Define Filtering
% [filter_num,filter_den] = cheby1(10,0.05,fc/(SR/2)); % Chebyshev was used because it is used in decimation

%% Quiet Stance 

QSdata = flb2mat(flb_file_path,'read_case',QS_trial_number);
QS = QuietStance(QSdata , fc , tQS , 'N');

%% All data and Trials

data = flb2mat(flb_file_path, 'read_all')
trials = {data.comment}
Averaging = 0;

Experiment = input('Which experiment would you like to examine?\n 1) TrapZ \n 2) PRTS \n 3) Sum of Sinusoids \n');
if (Experiment == 1)
    ExperimentStr = 'TrapZ';
    NN = input('Which experiment do you want to examine for TrapZ?\n 1) TrapZ 2deg, 5dps\n 2) TrapZ 2deg, 10dps\n 3) TrapZ 5deg, 5dps\n 4) TrapZ 5deg, 10dps\n');
    if NN == 1
        trials = 8:9;
        Amp = 2.0;
        AmpStr = '2deg';
        SpecStr = '5dps';
    elseif NN == 2
        trials = 12:13;
        Amp = 2.0;
        AmpStr = '2deg';
        SpecStr = '10dps';
    elseif NN == 3
        trials = 10:11;
        Amp = 5.0;
        AmpStr = '5deg';
        SpecStr = '5dps';
    elseif NN == 4
        trials = 6:7;
        Amp = 5.0;
        AmpStr = '5deg';
        SpecStr = '10dps';
    end    
end

if (Experiment == 2)   % PRTS 
    NN = input('Which experiment do you want to examine for PRTS?\n 1) PRTS 2deg, dt=0.16s\n 2) PRTS 5deg, dt=0.16s\n 3) PRTS 2deg, dt=0.22s\n 4) PRTS 5deg, dt=0.22s\n');
    ExperimentStr = 'PRTS';
    if NN == 1
        trials = 16:17;  % 2deg, dt=0.166s
        Amp = 2.0; 
        AmpStr = '2deg';
        min_PRTS = -0.3529356;
        SpecStr = 'dt166ms';
    elseif NN == 2
        trials = 14:15;  % 5deg, dt=0.166s
        Amp = 5.0; 
        AmpStr = '5deg';
        min_PRTS = -1.176452;
        SpecStr = 'dt166ms';
    elseif NN == 3
        trials = 18:19;  % 10deg, dt=0.222s
        Amp = 2.0;
        AmpStr = '2deg';
        min_PRTS = -2.352905;
        SpecStr = 'dt222ms';
    elseif NN == 4
        trials = 20:21;  % 5 deg, dt=0.222s
        Amp = 5.0; 
        AmpStr = '5deg';
        min_PRTS = -1.176452;
        SpecStr = 'dt222ms';
    end
end

if (Experiment == 3)
    NN = input('Which experiment do you want to examine for Sum of Sinusoids?\n 1) SOS 2deg, maxFR=1.5Hz\n 2) SOS 5deg, maxFR=1.5Hz\n');
    ExperimentStr = 'SoS';
    if NN == 1
        trials = 25:26;
        Amp = 2.0;
        AmpStr = '2deg';
        SpecStr = 'BW1n5Hz';
    elseif NN == 2
        trials = [22 24];
        Amp = 5.0;
        AmpStr = '5deg';
        SpecStr = 'BW1n5Hz';
    end
end

trial_case = 0;
stackTrials = input('Do you wish to stack trials together as one signal?\n 1) Yes\n 2) No\n');
if (stackTrials == 2)    
    if (Experiment == 2)
        Averaging = input('Which kind of averaging?\n 0)No Averaging (each trial separately)\n 1)Average on periods for each trial\n 2)Average on periods and trials\n');
        if ((Averaging == 0) || (Averaging == 1))
            trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
            trials = trials(trial_case);            
        end
    
    elseif (Experiment == 3)
        Averaging = input('Which kind of averaging?\n 0)No Averaging (each trial separately)\n 1)Average on periods for each trial\n');        
        trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
        trials = trials(trial_case);
    else
        trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
        trials = trials(trial_case);        
    end
end

if (stackTrials == 2) stackcondstr = 'NoStack'; end
if (stackTrials == 1) stackcondstr = 'WStack'; end
if (Averaging == 0) avgstr = 'NoAvrg'; end
if (Averaging == 1) avgstr = 'AvrgPeriod'; end
if (Averaging == 2) avgstr = 'AvrgAll'; end

condstr = strcat(avgstr,'_',stackcondstr, '_Tr', int2str(trial_case));
FigsPath = strcat('FigLogs/',datestring,'/',ExperimentStr,'_',AmpStr,SpecStr,'_',condstr);
mkdir(FigsPath);

%% read data based on chosen experiments

for i = 1:length(trials)
    data_trial = flb2mat(flb_file_path,'read_case',trials(i));
    trial_names = data_trial.comment  % To verify the trials
    Channel_Length = data_trial.chanLen;  %Trial time
    if (Experiment == 1) Channel_Length = 210 * SR; end  % If TrapZ 
    if (Experiment == 2) % If PRTS  
        if ((NN == 3) || (NN == 4))       
            Channel_Length = 230 * SR;
        else
        Channel_Length = 250 * SR; 
        end
    end  
    if (Experiment == 3) Channel_Length = 225 * SR; end  % If SoS
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
data_trial.chanName % To verify channel names

%% Synchronise the start time for VR input and outputs 
init_sample_size = 4 * SR;
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


%% change volts to deg

if (Experiment == 1) % TrapZ
    % Change volts to degrees
    
    vr_input_deg = Amp * ((vr_input_new/2.5) - 1.0);
    ti = 2 * SR;
    tf = 204 * SR;
    
elseif (Experiment == 2)    % for PRTS inputs (2 Period)
    
    % Change volts to degrees   
    vr_input_deg = (vr_input_new-1.173)*(Amp/5.0);    
    if ((NN == 3) || (NN == 4)) % Dt = 222ms
        ti = 240; tf = 215400; %242180;
    
    else % Dt = 166 ms        
        ti = 190; tf = 242220;        
    end    
    
elseif (Experiment == 3)  % Sum of Sin
    % Change volts to degrees
    vr_input_deg = (vr_input_new/5.0)* Amp;   % NO other option for now!!!
    ti = 40;
    tf = 220015;    
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

%% Average data in each periods for periodic VR inputs

if (Averaging == 0) % No averaging. All 2 trials together   
    
    vr_realizations = vr_input_deg;
    left_tq = Torque_L_new;
    right_tq = Torque_R_new;
    left_shank = LeftShAngle_new;
    right_shank = RightShAngle_new;
    hip_angle = HipAngle_new;
    
    LSol = L_Sol_EMG_new;
    RSol = R_Sol_EMG_new;
    LMG = L_MG_EMG_new;
    RMG = R_MG_EMG_new;
    RLG = R_LG_EMG_new;
    LLG = L_LG_EMG_new;
    RTA = R_TA_EMG_new;
    LTA = L_TA_EMG_new;
    
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
    
    
else  % Averaging == 1 (average on periods of one trial) or 2 (average on all periods of all trials)
    
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
    
    vr_realizations = VR_IO_Averaging(vr_input_deg, trials, periodTime, periodCount, 'y');
    left_tq = VR_IO_Averaging(Torque_L_new, trials, periodTime, periodCount, 'n');
    right_tq = VR_IO_Averaging(Torque_R_new, trials, periodTime, periodCount, 'n');
    left_shank = VR_IO_Averaging(LeftShAngle_new, trials, periodTime, periodCount, 'n');
    right_shank = VR_IO_Averaging(RightShAngle_new, trials, periodTime, periodCount, 'n');
    hip_angle = VR_IO_Averaging(HipAngle_new, trials, periodTime, periodCount, 'n');
    
    LSol = VR_IO_Averaging(L_Sol_EMG_new, trials, periodTime, periodCount, 'n');
    RSol = VR_IO_Averaging(R_Sol_EMG_new, trials, periodTime, periodCount, 'n');
    LMG = VR_IO_Averaging(L_MG_EMG_new, trials, periodTime, periodCount, 'n');
    RMG = VR_IO_Averaging(R_MG_EMG_new, trials, periodTime, periodCount, 'n');
    RLG = VR_IO_Averaging(R_LG_EMG_new, trials, periodTime, periodCount, 'n');
    LLG = VR_IO_Averaging(L_LG_EMG_new, trials, periodTime, periodCount, 'n');
    RTA = VR_IO_Averaging(R_TA_EMG_new, trials, periodTime, periodCount, 'n');
    LTA = VR_IO_Averaging(L_TA_EMG_new, trials, periodTime, periodCount, 'n');    
    
end

   
%% Stack all trials together

if (stackTrials == 1)  % Stacking   
    vr_realizations = VR_IO_Stacking(vr_realizations);
    
    left_tq = VR_IO_Stacking(left_tq);
    right_tq = VR_IO_Stacking(right_tq);
    left_shank = VR_IO_Stacking(left_shank);
    right_shank = VR_IO_Stacking(right_shank);
    hip_angle = VR_IO_Stacking(hip_angle);
    
    LSol = VR_IO_Stacking(LSol);
    RSol = VR_IO_Stacking(RSol);
    LMG = VR_IO_Stacking(LMG);
    RMG = VR_IO_Stacking(RMG);
    RLG = VR_IO_Stacking(RLG);
    LLG = VR_IO_Stacking(LLG);
    RTA = VR_IO_Stacking(RTA);
    LTA = VR_IO_Stacking(LTA);
    
    % Using NLID Toolbox
    
    % Left limb
    TorqueL = nldat;  %Create an NLDAT object for left torque data
    set(TorqueL,'dataSet', left_tq' ,'domainIncr', 1/SR);
    shankL = nldat;
    set(shankL,'dataSet', left_shank','domainIncr',1/SR);
    
    %Right limb
    TorqueR = nldat;
    set(TorqueR,'dataSet', right_tq' ,'domainIncr',1/SR);
    shankR = nldat;
    set(shankR,'dataSet', right_shank','domainIncr',1/SR);
    
    %Hip
    HipA = nldat;
    set(HipA,'dataSet', hip_angle' ,'domainIncr',1/SR);
    
    % Summations
    TorqueSum = nldat;
    torque_s = left_tq + right_tq;
    set(TorqueSum,'dataSet', torque_s', 'domainIncr', 1/SR);
    
    
    VRnldat = nldat;
    set(VRnldat,'dataSet', vr_realizations', 'domainIncr',1/SR);
    
    t = 0:1/SR:(length(TorqueL)-1)/SR;
    
elseif ((stackTrials == 2) && (Averaging == 0))  %No stacking
    
    % Using NDID Toolbox
    
    % Left limb
    TorqueL = nldat;  %Create an NLDAT object for left torque data
    set(TorqueL,'dataSet', left_tq' ,'domainIncr', 1/SR);
    shankL = nldat;
    set(shankL,'dataSet', left_shank','domainIncr',1/SR);
    
    %Right limb
    TorqueR = nldat;
    set(TorqueR,'dataSet', right_tq' ,'domainIncr',1/SR);
    shankR = nldat;
    set(shankR,'dataSet', right_shank','domainIncr',1/SR);
    
    %Hip
    HipA = nldat;
    set(HipA,'dataSet', hip_angle' ,'domainIncr',1/SR);
    
    % Summations
    TorqueSum = nldat;
    torque_s = left_tq + right_tq;
    set(TorqueSum,'dataSet', torque_s', 'domainIncr', 1/SR);
    
    
    VRnldat = nldat;
    set(VRnldat,'dataSet', vr_realizations', 'domainIncr',1/SR);
    
    t = 0:1/SR:(length(TorqueL)-1)/SR;
    
    
elseif ((stackTrials == 2) && ((Averaging == 1) || (Averaging == 2)) )
           
    % Left limb
    TorqueL = nldat;  %Create an NLDAT object for left torque data
    set(TorqueL,'dataSet',mean(left_tq)' - mean(mean(left_tq)),'domainIncr', 1/SR);
    shankL = nldat;
    set(shankL,'dataSet',mean(left_shank)' - mean(mean(left_shank)),'domainIncr',1/SR);
    
    %Right limb
    TorqueR = nldat;
    set(TorqueR,'dataSet',mean(right_tq)' - mean(mean(right_tq)) ,'domainIncr',1/SR);
    shankR = nldat;
    set(shankR,'dataSet',mean(right_shank)' - mean(mean(right_shank)),'domainIncr',1/SR);
    
    %Hip
    HipA = nldat;
    set(HipA,'dataSet', mean(hip_angle)' - mean(mean(hip_angle)) ,'domainIncr',1/SR);
    
    % Summations
    TorqueSum = nldat;
    torque_s = left_tq + right_tq;
    set(TorqueSum,'dataSet',mean(torque_s)' - mean(mean(torque_s)),'domainIncr', 1/SR);
    
    
    VRnldat = nldat;
    set(VRnldat,'dataSet', mean(vr_realizations)' - mean(mean(vr_realizations)) ,'domainIncr',1/SR);
    % set(VRnldat,'dataSet', vr_realizations' ,'domainIncr',1/SR);
    
    t = 0:1/SR:(length(TorqueL)-1)/SR;

end

%% Plotting the NLDAT objects

figure(5);
pl1(1) = subplot(221);
ax = plotyy(t,VRnldat.dataSet, t,TorqueL.dataSet);hold on
title('Left Ankle')
xlabel('Time (s)')
ylabel(ax(1), 'VR pert. angle (rad)');
ylabel(ax(2), 'Left Ankle torque');

% shank angle
pl1(2) = subplot(223);
ax = plotyy(t,VRnldat.dataSet, t,shankL.dataSet);hold on
title('Left Shank Angle')
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (rad)');
ylabel(ax(2), 'Left Shank Angle (rad)')

pl1(3) = subplot(222);
ax = plotyy(t,VRnldat.dataSet, t,TorqueR.dataSet);hold on
title('Right Ankle')
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (rad)');
ylabel(ax(2), 'Right Ankle torque');

pl1(4) = subplot(224);
ax = plotyy(t,VRnldat.dataSet, t,shankR.dataSet);hold on
title('Right Shank Angle')
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (rad)');
ylabel(ax(2), 'Right Shank Angle (rad)')

linkaxes(pl1,'x')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(6);
pl2(1) = subplot(211);
ax = plotyy(t,VRnldat.dataSet, t,TorqueSum.dataSet);hold on
title('Sum of Ankle Torques')
xlabel('Time (s)')
ylabel(ax(1), 'VR pert. angle (rad)');
ylabel(ax(2), 'Sum of Ankle Torques');

% shank angle
pl2(2) = subplot(212);
ax = plotyy(t,VRnldat.dataSet, t,HipA.dataSet);hold on
title('Hip Angle')
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (rad)');
ylabel(ax(2), 'Hip Angle (rad)')

linkaxes(pl2,'x')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

%% Power Spectrum
nFFT = 20 * SR;
%nFFT = periodTime

figure(7)
inputVRpower = spect(VRnldat-mean(VRnldat),'nFFT',nFFT);
pl3(1) = subplot(311);
semilogx(0:SR/nFFT:SR/2,inputVRpower.dataSet);hold on
xlim([0 SR/2])
title('Input VR power')
xlabel('Frequency (Hz)')
ylabel('Power')


pl3(2) = subplot(312);
rightTorquePower = spect(TorqueR,'nFFT',nFFT);
leftTorquePower = spect(TorqueL,'nFFT',nFFT);
sumTorquePower = spect(TorqueSum,'nFFT',nFFT);
semilogx(0:SR/nFFT:SR/2,rightTorquePower.dataSet);hold on
semilogx(0:SR/nFFT:SR/2,leftTorquePower.dataSet);hold on
semilogx(0:SR/nFFT:SR/2,sumTorquePower.dataSet);hold on
xlim([0 SR/2])
legend('right', 'left', 'Sum');
title('All Torque powers')
xlabel('Frequency (Hz)')
ylabel('Power')


pl3(5) = subplot(313);
hipPower = spect(HipA,'nFFT',nFFT);
semilogx(0:SR/nFFT:SR/2,hipPower.dataSet);hold on
xlim([0 SR/2])
title('Hip Angle Power')
xlabel('Frequency (Hz)')
ylabel('Power')

set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])


%%  Decimate: Resample data at a lower rate after lowpass filtering.

VRnldat_decimated = decimate(VRnldat,dr);
TorqueR_decimated = decimate(TorqueR,dr);
TorqueL_decimated = decimate(TorqueL,dr);
ShankR_decimated = decimate(shankR,dr);
ShankL_decimated = decimate(shankL,dr);
TorqueSum_decimated = decimate(TorqueSum,dr);
HipA_decimated = decimate(HipA,dr);

VRnldat_decimated = VRnldat_decimated - mean(VRnldat_decimated);
TorqueR_decimated = TorqueR_decimated - mean(TorqueR_decimated);
TorqueL_decimated = TorqueL_decimated - mean(TorqueL_decimated);
ShankR_decimated = ShankR_decimated - mean(ShankR_decimated);
ShankL_decimated = ShankL_decimated - mean(ShankL_decimated);
TorqueSum_decimated = TorqueSum_decimated - mean(TorqueSum_decimated);
HipA_decimated = HipA_decimated - mean(HipA_decimated);

vr2tqL_decimated = cat(2,VRnldat_decimated, TorqueL_decimated); % ==>  [VRnldat, TorqueL]
%   CAT(2,A,B) is the same as [A,B].
%   CAT(1,A,B) is the same as [A;B].
vr2tqR_decimated = cat(2,VRnldat_decimated, TorqueR_decimated);
vr2shankL_decimated = cat(2,VRnldat_decimated, ShankL_decimated);
vr2shankR_decimated = cat(2,VRnldat_decimated, ShankR_decimated);
vr2hip_decimated = cat(2,VRnldat_decimated, HipA_decimated);
vr2tqSum_decimated = cat(2,VRnldat_decimated, TorqueSum_decimated);

%% Impulse Response Functions 
% To predict (simulate) the response of a linear system
% if length of Input is N then nlags <= N/4

nlags = 10 * (SR/dr);
nsides = 1;

irf_vr2tqL = irf(vr2tqL_decimated,'nSides',nsides,'nLags',nlags);
irf_vr2tqR = irf(vr2tqR_decimated,'nSides',nsides,'nLags',nlags);
irf_vr2shankL = irf(vr2shankL_decimated,'nSides',nsides,'nLags',nlags);
irf_vr2shankR = irf(vr2shankR_decimated,'nSides',nsides,'nLags',nlags);
irf_vr2hip = irf(vr2hip_decimated,'nSides',nsides,'nLags',nlags);
irf_vr2tqSum = irf(vr2tqSum_decimated,'nSides',nsides,'nLags',nlags);

figure(8)
subplot(221)
plot(irf_vr2tqL);
title('IRF: VR -> Torque Left');hold on

subplot(222)
plot(irf_vr2tqR);
title('IRF: VR -> Torque Right');hold on

subplot(223)
plot(irf_vr2shankL);
title('IRF: VR -> Left Shank Angle');hold on

subplot(224)
plot(irf_vr2shankR);
title('IRF: VR -> Right Shank Angle');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(9)
subplot(211)
plot(irf_vr2hip);
title('IRF: VR -> Hip Angle');hold on

subplot(212)
plot(irf_vr2tqSum);
title('IRF: VR -> Torque Sum');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

%% VAF is "Variance Accounted For" between observed output and predicted(simulated) output

% VAF<100% : 
%          A) There is noise
%          B) System is Nonlinear
%          C) There is not enough Lags in IRF

vr2tqL_sim = nlsim(irf_vr2tqL,VRnldat_decimated);
vaf_tqL = vaf(TorqueL_decimated, vr2tqL_sim);

vr2tqR_sim = nlsim(irf_vr2tqR,VRnldat_decimated);
vaf_tqR = vaf(TorqueR_decimated, vr2tqR_sim);

vr2shankL_sim = nlsim(irf_vr2shankL,VRnldat_decimated);
vaf_shankL = vaf(ShankL_decimated, vr2shankL_sim);

vr2shankR_sim = nlsim(irf_vr2shankR,VRnldat_decimated);
vaf_shankR = vaf(ShankR_decimated, vr2shankR_sim);

vr2hip_sim = nlsim(irf_vr2hip,VRnldat_decimated);
vaf_hip = vaf(HipA_decimated, vr2hip_sim);

vr2tqSum_sim = nlsim(irf_vr2tqSum,VRnldat_decimated);
vaf_tqSum = vaf(TorqueSum_decimated, vr2tqSum_sim);

figure(10)
subplot(221)
plot(TorqueL_decimated); hold on
plot(vr2tqL_sim);
title(['Left torque, VAF = %' num2str(double(vaf_tqL),2)]);
legend('Measured','Simulated')

subplot(222)
plot(TorqueR_decimated); hold on
plot(vr2tqR_sim);
title(['Right torque, VAF = %' num2str(double(vaf_tqR),2)]);
legend('Measured','Simulated')

subplot(223)
plot(ShankL_decimated); hold on
plot(vr2shankL_sim);
title(['Left shank angle, VAF = %' num2str(double(vaf_shankL),2)]);
legend('Measured','Simulated')

subplot(224)
plot(ShankR_decimated);hold on
plot(vr2shankR_sim);
title(['Right shank angle, VAF = %' num2str(double(vaf_shankR),2)]);
legend('Measured','Simulated')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(11)
subplot(211)
plot(TorqueSum_decimated);hold on
plot(vr2tqSum_sim);
title(['Sum torque, VAF = %' num2str(double(vaf_tqSum),2)]);
legend('Measured','Simulated')

subplot(212)
plot(HipA_decimated);hold on
plot(vr2hip_sim);
title(['Hip Angle, VAF = %' num2str(double(vaf_hip),2)]);
legend('Measured','Simulated')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

%% Frequency Response 
nOverlap = nFFT/(2*dr);

figure(12)
plot(fresp(vr2tqL_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> left tq ');hold on
% semilogx(0:SR/nFFT:SR/2,FR_vr2tqL.dataSet);hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(13)
plot(fresp(vr2tqR_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> right tq ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(14)
plot(fresp(vr2shankL_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> left shank angle ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(15)
plot(fresp(vr2shankR_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> right shank angle ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(16)
plot(fresp(vr2hip_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> Hip angle ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(17)
plot(fresp(vr2tqSum_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> Sum Torque');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    
%% Save Figures

% SaveAllFigures(FigsPath, '.png');


%% Power Spectrum Decimated

figure(18)
inputVRpower_decimated = spect(VRnldat_decimated,'nFFT', nFFT/dr);
pl3(1) = subplot(311);
semilogx(0:SR/nFFT:SR/(2*dr),inputVRpower_decimated.dataSet);hold on
xlim([0 SR/(2*dr)])
title('Input VR power')
xlabel('Frequency (Hz)')
ylabel('Power')


pl3(2) = subplot(312);
rightTorquePower_decimated = spect(TorqueR_decimated,'nFFT',nFFT/dr);
leftTorquePower_decimated = spect(TorqueL_decimated,'nFFT',nFFT/dr);
sumTorquePower_decimated = spect(TorqueSum_decimated,'nFFT',nFFT/dr);
semilogx(0:SR/nFFT:SR/(2*dr),rightTorquePower_decimated.dataSet);hold on
semilogx(0:SR/nFFT:SR/(2*dr),leftTorquePower_decimated.dataSet);hold on
semilogx(0:SR/nFFT:SR/(2*dr),sumTorquePower_decimated.dataSet);hold on
xlim([0 SR/(2*dr)])
legend('right', 'left', 'Sum');
title('All Torque powers')
xlabel('Frequency (Hz)')
ylabel('Power')


pl3(5) = subplot(313);
hipPower_decimated = spect(HipA_decimated,'nFFT',nFFT/dr);
semilogx(0:SR/nFFT:SR/(2*dr),hipPower_decimated.dataSet);hold on
xlim([0 SR/(2*dr)])
title('Hip Angle Power')
xlabel('Frequency (Hz)')
ylabel('Power')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    
    
    
    
    















