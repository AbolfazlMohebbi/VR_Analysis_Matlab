function Trials_Data_Sync = syncStartData_TrapV(SubjIndex, Trials_Data, Experiment, NN)
% Synchronise the start time for VR input and outputs

global SR;

init_sample_size = 4 * SR;
inputVR_err = 0.0004;
startPerturbation_index = zeros(1, length(Trials_Data.trials));

vr_input_new = zeros(size(Trials_Data.vr_input));

LeftShAngle_new = zeros(size(Trials_Data.LeftShAngle));
HipAngle_new = zeros(size(Trials_Data.HipAngle));
RightShAngle_new = zeros(size(Trials_Data.RightShAngle));
    
Torque_L_new = zeros(size(Trials_Data.Torque_L));
Torque_R_new = zeros(size(Trials_Data.Torque_R));

% EMGs
L_Sol_EMG_new = zeros(size(Trials_Data.L_Sol_EMG));
R_Sol_EMG_new = zeros(size(Trials_Data.R_Sol_EMG));
L_MG_EMG_new = zeros(size(Trials_Data.L_MG_EMG));
R_MG_EMG_new = zeros(size(Trials_Data.R_MG_EMG));
L_LG_EMG_new = zeros(size(Trials_Data.L_LG_EMG));
R_LG_EMG_new = zeros(size(Trials_Data.R_LG_EMG));
L_TA_EMG_new = zeros(size(Trials_Data.L_TA_EMG));
R_TA_EMG_new = zeros(size(Trials_Data.R_TA_EMG));

for i = 1:length(Trials_Data.trials)
    for j = 1:init_sample_size
        if (abs(Trials_Data.vr_input(i,j+1)-Trials_Data.vr_input(i,j))>inputVR_err)
            startPerturbation_index(i) = j;
            break
        end
    end
    vr_input_new(i,1:length(Trials_Data.vr_input(i,startPerturbation_index(i)+1:end))) = Trials_Data.vr_input(i,startPerturbation_index(i)+1:end);
    
    LeftShAngle_new(i,1:length(Trials_Data.vr_input(i,startPerturbation_index(i)+1:end))) = Trials_Data.LeftShAngle(i,startPerturbation_index(i)+1:end);
    HipAngle_new(i,1:length(Trials_Data.vr_input(i,startPerturbation_index(i)+1:end))) = Trials_Data.HipAngle(i,startPerturbation_index(i)+1:end);
    RightShAngle_new(i,1:length(Trials_Data.vr_input(i,startPerturbation_index(i)+1:end))) = Trials_Data.RightShAngle(i,startPerturbation_index(i)+1:end);
    
    Torque_L_new(i,1:length(Trials_Data.vr_input(i,startPerturbation_index(i)+1:end))) = Trials_Data.Torque_L(i,startPerturbation_index(i)+1:end);
    Torque_R_new(i,1:length(Trials_Data.vr_input(i,startPerturbation_index(i)+1:end))) = Trials_Data.Torque_R(i,startPerturbation_index(i)+1:end);
    
    % EMGs
    L_Sol_EMG_new(i,1:length(Trials_Data.vr_input(i,startPerturbation_index(i)+1:end))) = Trials_Data.L_Sol_EMG(i,startPerturbation_index(i)+1:end);
    R_Sol_EMG_new(i,1:length(Trials_Data.vr_input(i,startPerturbation_index(i)+1:end))) = Trials_Data.R_Sol_EMG(i,startPerturbation_index(i)+1:end);
    L_MG_EMG_new(i,1:length(Trials_Data.vr_input(i,startPerturbation_index(i)+1:end))) = Trials_Data.L_MG_EMG(i,startPerturbation_index(i)+1:end);
    R_MG_EMG_new(i,1:length(Trials_Data.vr_input(i,startPerturbation_index(i)+1:end))) = Trials_Data.R_MG_EMG(i,startPerturbation_index(i)+1:end);
    L_LG_EMG_new(i,1:length(Trials_Data.vr_input(i,startPerturbation_index(i)+1:end))) = Trials_Data.L_LG_EMG(i,startPerturbation_index(i)+1:end);
    R_LG_EMG_new(i,1:length(Trials_Data.vr_input(i,startPerturbation_index(i)+1:end))) = Trials_Data.R_LG_EMG(i,startPerturbation_index(i)+1:end);
    L_TA_EMG_new(i,1:length(Trials_Data.vr_input(i,startPerturbation_index(i)+1:end))) = Trials_Data.L_TA_EMG(i,startPerturbation_index(i)+1:end);
    R_TA_EMG_new(i,1:length(Trials_Data.vr_input(i,startPerturbation_index(i)+1:end))) = Trials_Data.R_TA_EMG(i,startPerturbation_index(i)+1:end);
end

%% Cut unnecessary initial and final zero data
ti = 100;
tf = length(vr_input_new)- 5 * SR;


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

