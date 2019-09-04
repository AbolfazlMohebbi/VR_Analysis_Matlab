function Trials_Data_Sync = syncStartData_gui(SubjIndex, Trials_Data, Experiment, NN)
% Synchronise the start time for VR input and outputs

global SR;

init_sample_size = 4 * SR;
inputVR_err = 0.0004;
startPerturbation_index = zeros(1, length(Trials_Data.trials));

vr_input_new = Trials_Data.vr_input;
LeftShAngle_new = Trials_Data.LeftShAngle;
HipAngle_new = Trials_Data.HipAngle;
RightShAngle_new = Trials_Data.RightShAngle;    
Torque_L_new = Trials_Data.Torque_L;
Torque_R_new = Trials_Data.Torque_R;

% EMGs
L_Sol_EMG_new = Trials_Data.L_Sol_EMG;
R_Sol_EMG_new = Trials_Data.R_Sol_EMG;
L_MG_EMG_new =  Trials_Data.L_MG_EMG;
R_MG_EMG_new =  Trials_Data.R_MG_EMG;
L_LG_EMG_new =  Trials_Data.L_LG_EMG;
R_LG_EMG_new =  Trials_Data.R_LG_EMG;
L_TA_EMG_new =  Trials_Data.L_TA_EMG;
R_TA_EMG_new =  Trials_Data.R_TA_EMG;

%% Cut unnecessary initial and final zero data
figure()
plot(Trials_Data.vr_input);
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
[tif, yif] = getpts(gca);
close;
ti = tif(1); tf = tif(2);


%%

vr_input_new = vr_input_new(:, ti:tf);  

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

%% To Output
Trials_Data_Sync.vr_input = vr_input_new;
Trials_Data_Sync.RightShAngle = RightShAngle_new;
Trials_Data_Sync.LeftShAngle = LeftShAngle_new;
Trials_Data_Sync.HipAngle = HipAngle_new;
Trials_Data_Sync.Torque_R = Torque_R_new;
Trials_Data_Sync.Torque_L = Torque_L_new;
Trials_Data_Sync.L_Sol_EMG = L_Sol_EMG_new;
Trials_Data_Sync.R_Sol_EMG = R_Sol_EMG_new;
Trials_Data_Sync.L_MG_EMG = L_MG_EMG_new;
Trials_Data_Sync.R_MG_EMG = R_MG_EMG_new;
Trials_Data_Sync.L_LG_EMG = L_LG_EMG_new;
Trials_Data_Sync.R_LG_EMG = R_LG_EMG_new;
Trials_Data_Sync.L_TA_EMG = L_TA_EMG_new;
Trials_Data_Sync.R_TA_EMG = R_TA_EMG_new;
Trials_Data_Sync.trials = Trials_Data.trials;

end

