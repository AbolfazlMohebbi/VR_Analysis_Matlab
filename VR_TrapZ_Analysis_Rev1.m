close all;
clear all; clc;
dataPath = pwd + "\data\";
set(0,'DefaultAxesFontSize',14,'DefaultLineLineWidth',1.5,'DefaultLineMarkerSize',8)
set(0,'DefaultLineColor','b')

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
dr = 1; % decimation filters the signal with a cutoff of 0.8/dr*(SR/2)
d_f = 238.89/1000; % distance between the front load cells and ankle axis of rotation
d_b = 51.05/1000; % distance between the back load cells and ankle axis of rotation
fc = 0.8/dr*(SR/2);

%% Quiet Stance

QSdata = flb2mat(flb_file_path,'read_case',QS_trial_number);
QS = QuietStance(QSdata , fc , tQS , 'N');

%% All data and Trials

data = flb2mat(flb_file_path, 'read_all');

NN = input('Which experiment do you want to examine for TrapZ?\n 1) TrapZ 2deg, 5dps\n 2) TrapZ 2deg, 10dps\n 3) TrapZ 5deg, 5dps\n 4) TrapZ 5deg, 10dps\n');
if NN == 1
    trials = 8:9;
    Amp = 2.0;
elseif NN == 2
    trials = 12:13;
    Amp = 2.0;
elseif NN == 3
    trials = 10:11;
    Amp = 5.0;
elseif NN == 4
    trials = 6:7;
    Amp = 5.0;
end

PP = input('Which TrapZ segments would you like to analyze?\n 1) Positive Pulses\n 2) Negative Pulses\n');

%% read data based on chosen experiments

for i = 1:length(trials)
    data_trial = flb2mat(flb_file_path,'read_case',trials(i));
    trial_names = data_trial.comment  % To verify the trials
    Channel_Length = data_trial.chanLen;  %Trial time
    Channel_Length = 210 * SR;  % If TrapZ
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

%% clean Trial 6 data
if (NN==4) && (trials(1)==6)    
    vr_input_new = vr_input(:,1500:end);
    LeftShAngle_new = LeftShAngle(:,1500:end);
    RightShAngle_new = RightShAngle(:,1500:end);
    HipAngle_new = HipAngle(:,1500:end);
    Torque_L_new = Torque_L(:,1500:end);
    Torque_R_new = Torque_R(:,1500:end); 
    
    vr_input = vr_input_new;
    LeftShAngle = LeftShAngle_new;
    RightShAngle = RightShAngle_new;
    HipAngle = HipAngle_new;
    Torque_L = Torque_L_new;
    Torque_R = Torque_R_new; 
    
end


%% Volts to deg
vr_input = vr_input + 0.00864;
vr_input_deg = Amp * ((vr_input/2.5) - 1.0);
tf = 205 * SR;


%% Identifying the start if the Perturbations

init_sample_size = 6 * SR;
inputVR_err = 0.0004;
t_startPerturbation = zeros(1, length(trials));
for k = 1:length(trials)    
    fprintf('trial = %f \n', trials(k))
    for j = 1:init_sample_size
        if (abs(vr_input(k,j+5)-vr_input(k,j)) > inputVR_err)
            t_startPerturbation(k) = j;
            break
        end
    end
end

%% Cut each TrapZ Pulse

vel_treshold = 0.04;
dt_trapZ_pulse = 1.0 * SR; % 1 seconds

if ( min(t_startPerturbation) < dt_trapZ_pulse)
    dt_trapZ_pulse = min(t_startPerturbation);
end

TrapZ_allPosPulses = [];
TrapZ_allNegPulses = [];

TrapZ_PosPulse_RightSh = [];
TrapZ_PosPulse_LeftSh = [];
TrapZ_PosPulse_TorqueL = [];
TrapZ_PosPulse_TorqueR = [];
TrapZ_PosPulse_hip = [];

TrapZ_NegPulse_RightSh = [];
TrapZ_NegPulse_LeftSh = [];
TrapZ_NegPulse_TorqueL = [];
TrapZ_NegPulse_TorqueR = [];
TrapZ_NegPulse_hip = [];

t_test = 10 * SR;
bPulseFinish = true;
d_vr = (diff(vr_input_deg'))';

for k = 1:length(trials)
    
    vr_input_shrink = vr_input_deg(k,:);
    d_vr_shrink = d_vr(k,:);
    LeftShAngle_shrink = LeftShAngle(k,:);
    RightShAngle_shrink = RightShAngle(k,:);
    HipAngle_shrink = HipAngle(k,:);
    Torque_L_shrink = Torque_L(k,:);
    Torque_R_shrink = Torque_R(k,:);
    bPulseFinish = true;
    
    for i = 1: floor(tf/t_test)+1
        for t = 1:t_test
            if ((bPulseFinish==true) && (d_vr_shrink(t)> vel_treshold) && (vr_input_shrink(t) > 0) )
                TrapZ_allPosPulses = [TrapZ_allPosPulses; vr_input_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                
                TrapZ_PosPulse_RightSh = [TrapZ_PosPulse_RightSh; RightShAngle_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                TrapZ_PosPulse_LeftSh = [TrapZ_PosPulse_LeftSh; LeftShAngle_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                TrapZ_PosPulse_TorqueL = [TrapZ_PosPulse_TorqueL; Torque_L_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                TrapZ_PosPulse_TorqueR = [TrapZ_PosPulse_TorqueR; Torque_R_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                TrapZ_PosPulse_hip = [TrapZ_PosPulse_hip; HipAngle_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                
                vr_input_shrink = vr_input_shrink(t+dt_trapZ_pulse:end);
                d_vr_shrink = d_vr_shrink(t+dt_trapZ_pulse:end);
                LeftShAngle_shrink = LeftShAngle_shrink(t+dt_trapZ_pulse:end);
                RightShAngle_shrink = RightShAngle_shrink(t+dt_trapZ_pulse:end);
                HipAngle_shrink = HipAngle_shrink(t+dt_trapZ_pulse:end);
                Torque_R_shrink = Torque_R_shrink(t+dt_trapZ_pulse:end);
                Torque_L_shrink = Torque_L_shrink(t+dt_trapZ_pulse:end);
                bPulseFinish = false;
            end
            
            if ((bPulseFinish==true) && (d_vr_shrink(t) < -vel_treshold) && (vr_input_shrink(t) < 0))
                TrapZ_allNegPulses = [TrapZ_allNegPulses; vr_input_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                
                TrapZ_NegPulse_RightSh = [TrapZ_NegPulse_RightSh; RightShAngle_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                TrapZ_NegPulse_LeftSh = [TrapZ_NegPulse_LeftSh; LeftShAngle_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                TrapZ_NegPulse_TorqueL = [TrapZ_NegPulse_TorqueL; Torque_L_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                TrapZ_NegPulse_TorqueR = [TrapZ_NegPulse_TorqueR; Torque_R_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                TrapZ_NegPulse_hip = [TrapZ_NegPulse_hip; HipAngle_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                
                vr_input_shrink = vr_input_shrink(t+dt_trapZ_pulse:end);
                d_vr_shrink = d_vr_shrink(t+dt_trapZ_pulse:end);
                LeftShAngle_shrink = LeftShAngle_shrink(t+dt_trapZ_pulse:end);
                RightShAngle_shrink = RightShAngle_shrink(t+dt_trapZ_pulse:end);
                HipAngle_shrink = HipAngle_shrink(t+dt_trapZ_pulse:end);
                Torque_R_shrink = Torque_R_shrink(t+dt_trapZ_pulse:end);
                Torque_L_shrink = Torque_L_shrink(t+dt_trapZ_pulse:end);
                bPulseFinish = false;
            end
        end
        bPulseFinish = true;
    end
end

%% Plot the ensemble average of the input pulses
figure(1);
subplot(2,1,1)
plot(TrapZ_allPosPulses','linewidth',1); title(' Positive TrapZ Segments and Mean');
hold on
plot((mean(TrapZ_allPosPulses))','b-', 'linewidth', 3)

subplot(2,1,2)
plot(TrapZ_allNegPulses','linewidth',1); title(' Negative TrapZ Segments and Mean');
hold on
plot((mean(TrapZ_allNegPulses))','b-', 'linewidth', 3)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])


%% Ensemble average of the desired outputs for Positive Pulses

if (PP==1) % Positive Pulses
    
    VRnldat = nldat;
    set(VRnldat,'dataSet', (mean(TrapZ_allPosPulses) - mean(mean(TrapZ_allPosPulses)))' ,'domainIncr',1/SR);
    
    % Left limb
    TorqueL = nldat;  %Create an NLDAT object for left torque data
    set(TorqueL,'dataSet', (mean(TrapZ_PosPulse_TorqueL) - mean(mean(TrapZ_PosPulse_TorqueL)))' ,'domainIncr', 1/SR);
    shankL = nldat;
    set(shankL,'dataSet', (mean(TrapZ_PosPulse_LeftSh) - mean(mean(TrapZ_PosPulse_LeftSh)))' ,'domainIncr',1/SR);
    
    %Right limb
    TorqueR = nldat;
    set(TorqueR,'dataSet', (mean(TrapZ_PosPulse_TorqueR) - mean(mean(TrapZ_PosPulse_TorqueR)))' ,'domainIncr',1/SR);
    shankR = nldat;
    set(shankR,'dataSet', (mean(TrapZ_PosPulse_RightSh) - mean(mean(TrapZ_PosPulse_RightSh)))' ,'domainIncr',1/SR);
    
    %Hip
    HipA = nldat;
    set(HipA,'dataSet', (mean(TrapZ_PosPulse_hip) - mean(mean(TrapZ_PosPulse_hip)))' ,'domainIncr',1/SR);
    
    % Summations
    TorqueSum = nldat;
    TrapZ_PosPulse_TorqueSum = TrapZ_PosPulse_TorqueL + TrapZ_PosPulse_TorqueR;
    set(TorqueSum,'dataSet', (mean(TrapZ_PosPulse_TorqueSum) - mean(mean(TrapZ_PosPulse_TorqueSum)))','domainIncr', 1/SR);
    
    t = 0:1/SR:(length(TorqueL)-1)/SR;
    
elseif (PP==2) % Negative Pulses
    
    VRnldat = nldat;
    set(VRnldat,'dataSet', (mean(TrapZ_allNegPulses)- mean(mean(TrapZ_allNegPulses)))' ,'domainIncr',1/SR);
    
    % Left limb
    TorqueL = nldat;  %Create an NLDAT object for left torque data
    set(TorqueL,'dataSet', (mean(TrapZ_NegPulse_TorqueL) - mean(mean(TrapZ_NegPulse_TorqueL)))','domainIncr', 1/SR);
    
    shankL = nldat;
    set(shankL,'dataSet', (mean(TrapZ_NegPulse_LeftSh) - mean(mean(TrapZ_NegPulse_LeftSh)))','domainIncr',1/SR);
    
    %Right limb
    TorqueR = nldat;
    set(TorqueR,'dataSet', (mean(TrapZ_NegPulse_TorqueR) - mean(mean(TrapZ_NegPulse_TorqueR)))' ,'domainIncr',1/SR);
    shankR = nldat;
    set(shankR,'dataSet', (mean(TrapZ_NegPulse_RightSh) - mean(mean(TrapZ_NegPulse_RightSh)))','domainIncr',1/SR);
    
    %Hip
    HipA = nldat;
    set(HipA,'dataSet', (mean(TrapZ_NegPulse_hip) - mean(mean(TrapZ_NegPulse_hip)))' ,'domainIncr',1/SR);
    
    % Summations
    TorqueSum = nldat;
    TrapZ_NegPulse_TorqueSum = TrapZ_NegPulse_TorqueL + TrapZ_NegPulse_TorqueR;
    set(TorqueSum,'dataSet', (mean(TrapZ_NegPulse_TorqueSum) - mean(mean(TrapZ_NegPulse_TorqueSum)))','domainIncr', 1/SR);
    
    t = 0:1/SR:(length(TorqueL)-1)/SR;
    
end
   

%% Plotting the NLDAT objects for Positive Pulses - just mean

figure(2);
pl1(1) = subplot(221);
ax = plotyy(t,VRnldat.dataSet, t, TorqueL.dataSet); hold on
title('Left Ankle Torque')
xlabel('Time (s)')
ylabel(ax(1), 'VR pert. angle (deg)');
ylabel(ax(2), 'Mean Left Ankle torque');

% shank angle
pl1(2) = subplot(223);
ax = plotyy(t,VRnldat.dataSet, t, shankL.dataSet);hold on
title('Left Shank Angle')
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (deg)');
ylabel(ax(2), 'Mean Left Shank Angle (rad)')

pl1(3) = subplot(222);
ax = plotyy(t,VRnldat.dataSet, t, TorqueR.dataSet);hold on
title('Right Ankle Torque')
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (deg)');
ylabel(ax(2), 'Mean Right Ankle torque');

pl1(4) = subplot(224);
ax = plotyy(t,VRnldat.dataSet, t, shankR.dataSet);hold on
title('Right Shank Angle')
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (deg)');
ylabel(ax(2), 'Mean Right Shank Angle (rad)')

linkaxes(pl1,'x')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(3);
pl2(1) = subplot(211);
ax = plotyy(t,VRnldat.dataSet, t, TorqueSum.dataSet);hold on
title('Sum of Ankle Torques')
xlabel('Time (s)')
ylabel(ax(1), 'VR pert. angle (deg)');
ylabel(ax(2), 'Mean of Sum of Ankle Torques');


pl2(2) = subplot(212);
ax = plotyy(t,VRnldat.dataSet, t, HipA.dataSet);hold on
title('Hip Angle')
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (deg)');
ylabel(ax(2), 'Mean Hip Angle (rad)')

linkaxes(pl2,'x')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])


%% Plotting the NLDAT objects for Positive Pulses - All Segments

if (PP == 1)
    
    % To plot all segments around zero(mean of each removed)
    % plot( TrapZ_PosPulse_hip' - mean(TrapZ_PosPulse_hip') )
    
    % to plot the mean of all segments around zero (its mean is also removed)
    % plot(mean(TrapZ_PosPulse_hip) - mean(mean(TrapZ_PosPulse_hip))
    
    figure(14);
    pl1(1) = subplot(221);
    ax = plotyy(t,VRnldat.dataSet, t, TrapZ_PosPulse_TorqueL'- mean(TrapZ_PosPulse_TorqueL')); hold on
    TrapZ_PosPulse_TorqueL_mean = (mean(TrapZ_PosPulse_TorqueL)-mean(mean(TrapZ_PosPulse_TorqueL)))';
    ax(3) = plot(t, TrapZ_PosPulse_TorqueL_mean, 'k-.' , 'linewidth' , 4);
    title('Left Ankle Torque')
    xlabel('Time (s)')
    ylabel(ax(1), 'VR pert. angle (deg)');
    ylabel(ax(2), 'Left Ankle torque');
    legend(ax(3),'Mean Left Torque');
    
    % pl1(1) = subplot(221);
    % TrapZ_PosPulse_TorqueL_mean = (mean(TrapZ_PosPulse_TorqueL)-mean(mean(TrapZ_PosPulse_TorqueL)))';
    % yyaxis left
    % plot(t,VRnldat.dataSet);
    % yyaxis right
    % plot(t, TrapZ_PosPulse_TorqueL'- mean(TrapZ_PosPulse_TorqueL'), 'linewidth' , 2); hold on
    % plot(t, TrapZ_PosPulse_TorqueL_mean,  'k-.' , 'linewidth' , 2); hold off
    % title('Left Ankle Torque')
    % xlabel('Time (s)')
    
    % shank angle
    pl1(2) = subplot(223);
    ax = plotyy(t,VRnldat.dataSet, t, TrapZ_PosPulse_LeftSh'-mean(TrapZ_PosPulse_LeftSh'));hold on
    TrapZ_PosPulse_LeftSh_mean = mean((TrapZ_PosPulse_LeftSh'-mean(TrapZ_PosPulse_LeftSh'))');
    ax(3) = plot(t, TrapZ_PosPulse_LeftSh_mean, 'k-.' , 'linewidth' , 4);
    title('Left Shank Angle')
    xlabel('Time (s)')
    ylabel(ax(1), 'VR input angle (deg)');
    ylabel(ax(2), 'Left Shank Angle (rad)')
    legend(ax(3),'Mean Left Shank');
    
    pl1(3) = subplot(222);
    ax = plotyy(t,VRnldat.dataSet, t, TrapZ_PosPulse_TorqueR'-mean(TrapZ_PosPulse_TorqueR'));hold on
    TrapZ_PosPulse_TorqueR_mean = mean((TrapZ_PosPulse_TorqueR'-mean(TrapZ_PosPulse_TorqueR'))');
    ax(3) = plot(t, TrapZ_PosPulse_TorqueR_mean, 'k-.' , 'linewidth' , 4);
    title('Right Ankle Torque')
    xlabel('Time (s)')
    ylabel(ax(1), 'VR input angle (deg)');
    ylabel(ax(2), 'Right Ankle torque');
    legend(ax(3),'Mean Right Torque');
    
    pl1(4) = subplot(224);
    ax = plotyy(t,VRnldat.dataSet, t, TrapZ_PosPulse_RightSh'-mean(TrapZ_PosPulse_RightSh'));hold on
    TrapZ_PosPulse_RightSh_mean = mean((TrapZ_PosPulse_RightSh'-mean(TrapZ_PosPulse_RightSh'))');
    ax(3) = plot(t, TrapZ_PosPulse_RightSh_mean, 'k-.' , 'linewidth' , 4);
    title('Right Shank Angle')
    xlabel('Time (s)')
    ylabel(ax(1), 'VR input angle (deg)');
    ylabel(ax(2), 'Right Shank Angle (rad)')
    legend(ax(3),'Mean Right Shank');
    
    linkaxes(pl1,'x')
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    
    figure(15);
    pl2(1) = subplot(211);
    ax = plotyy(t,VRnldat.dataSet, t, TrapZ_PosPulse_TorqueSum'-mean(TrapZ_PosPulse_TorqueSum'));hold on
    TrapZ_PosPulse_TorqueSum_mean = mean((TrapZ_PosPulse_TorqueSum'-mean(TrapZ_PosPulse_TorqueSum'))');
    ax(3) = plot(t, TrapZ_PosPulse_TorqueSum_mean, 'k-.' , 'linewidth' , 4);
    title('Sum of Ankle Torques')
    xlabel('Time (s)')
    ylabel(ax(1), 'VR pert. angle (deg)');
    ylabel(ax(2), 'Sum of Ankle Torques');
    legend(ax(3),'Mean Torque Sum');
    
    % shank angle
    pl2(2) = subplot(212);
    ax = plotyy(t,VRnldat.dataSet, t, TrapZ_PosPulse_hip'-mean(TrapZ_PosPulse_hip'));hold on
    TrapZ_PosPulse_Hip_mean = mean((TrapZ_PosPulse_hip'-mean(TrapZ_PosPulse_hip'))');
    ax(3) = plot(t, TrapZ_PosPulse_Hip_mean, 'k-.' , 'linewidth' , 4);
    title('Hip Angle')
    xlabel('Time (s)')
    ylabel(ax(1), 'VR input angle (deg)');
    ylabel(ax(2), 'Hip Angle (rad)')
    legend(ax(3),'Mean Hip Angle');
    
    linkaxes(pl2,'x')
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])    
    
end

%%
nFFT = 0.2 * SR;
%nFFT = periodTime

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

nlags = 500/dr;
nsides = 1;

irf_vr2tqL = irf(vr2tqL_decimated,'nSides',nsides,'nLags',nlags);
irf_vr2tqR = irf(vr2tqR_decimated,'nSides',nsides,'nLags',nlags);
irf_vr2shankL = irf(vr2shankL_decimated,'nSides',nsides,'nLags',nlags);
irf_vr2shankR = irf(vr2shankR_decimated,'nSides',nsides,'nLags',nlags);
irf_vr2hip = irf(vr2hip_decimated,'nSides',nsides,'nLags',nlags);
irf_vr2tqSum = irf(vr2tqSum_decimated,'nSides',nsides,'nLags',nlags);

figure(4)
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

figure(5)
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

% vr2tqL_sim = nlsim(irf_vr2tqL,VRnldat_decimated);
% vaf_tqL = vaf(TorqueL_decimated, vr2tqL_sim);
% 
% vr2tqR_sim = nlsim(irf_vr2tqR,VRnldat_decimated);
% vaf_tqR = vaf(TorqueR_decimated, vr2tqR_sim);
% 
% vr2shankL_sim = nlsim(irf_vr2shankL,VRnldat_decimated);
% vaf_shankL = vaf(ShankL_decimated, vr2shankL_sim);
% 
% vr2shankR_sim = nlsim(irf_vr2shankR,VRnldat_decimated);
% vaf_shankR = vaf(ShankR_decimated, vr2shankR_sim);
% 
% vr2hip_sim = nlsim(irf_vr2hip,VRnldat_decimated);
% vaf_hip = vaf(HipA_decimated, vr2hip_sim);
% 
% vr2tqSum_sim = nlsim(irf_vr2tqSum,VRnldat_decimated);
% vaf_tqSum = vaf(TorqueSum_decimated, vr2tqSum_sim);
% 
% figure(6)
% subplot(221)
% plot(TorqueL_decimated); hold on
% plot(vr2tqL_sim);
% title(['Left torque, VAF = %' num2str(double(vaf_tqL),2)]);
% legend('Measured','Simulated')
% 
% subplot(222)
% plot(TorqueR_decimated); hold on
% plot(vr2tqR_sim);
% title(['Right torque, VAF = %' num2str(double(vaf_tqR),2)]);
% legend('Measured','Simulated')
% 
% subplot(223)
% plot(ShankL_decimated); hold on
% plot(vr2shankL_sim);
% title(['Left shank angle, VAF = %' num2str(double(vaf_shankL),2)]);
% legend('Measured','Simulated')
% 
% subplot(224)
% plot(ShankR_decimated);hold on
% plot(vr2shankR_sim);
% title(['Right shank angle, VAF = %' num2str(double(vaf_shankR),2)]);
% legend('Measured','Simulated')
% set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
% 
% figure(7)
% subplot(211)
% plot(TorqueSum_decimated);hold on
% plot(vr2tqSum_sim);
% title(['Sum torque, VAF = %' num2str(double(vaf_tqSum),2)]);
% legend('Measured','Simulated')
% 
% subplot(212)
% plot(HipA_decimated);hold on
% plot(vr2hip_sim);
% title(['Hip Angle, VAF = %' num2str(double(vaf_hip),2)]);
% legend('Measured','Simulated')
% set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

%% Frequency Response 
nOverlap = nFFT/(2*dr);

figure(8)
plot(fresp(vr2tqL_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> left tq ');hold on
% semilogx(0:SR/nFFT:SR/2,FR_vr2tqL.dataSet);hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(9)
plot(fresp(vr2tqR_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> right tq ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(10)
plot(fresp(vr2shankL_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> left shank angle ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(11)
plot(fresp(vr2shankR_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> right shank angle ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(12)
plot(fresp(vr2hip_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> Hip angle ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(13)
plot(fresp(vr2tqSum_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> Sum Torque');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

















