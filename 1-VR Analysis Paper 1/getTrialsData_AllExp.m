function Trials_Data = getTrialsData_AllExp(SubjIndex, Subject_data, flb_file_path, data, trialsMatrix, VelCase, AmpCase)

global SR LasDel emgGain d_f d_b fc

% Assign Parameters from csv file
hBody = Subject_data{3}(SubjIndex);
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

load(fullfile('..\CalibrationParams', 'LeftLaserCalibrationConstants'))
load(fullfile('..\CalibrationParams', 'RightLaserCalibrationConstants'))
load(fullfile('..\CalibrationParams', 'HipLaserCalibrationConstants'))

LeftShAngle = {};
BodyAngle = {};
RightShAngle = {};
Torque_L = {};
Torque_R = {};
L_Sol_EMG = {};
R_Sol_EMG = {};
L_MG_EMG = {};
R_MG_EMG = {};
L_LG_EMG = {};
R_LG_EMG = {};
L_TA_EMG = {};
R_TA_EMG = {};


for i = VelCase
    for j = AmpCase
        
%         data_trial = flb2mat(flb_file_path,'read_case', trialsMatrix(i,j));
        
        data_trial = data(trialsMatrix(i,j));
        
        trial_names = data_trial.comment;  % To verify the trials
        Channel_Length = data_trial.chanLen;  %Trial time
        data_trial.Data = removeNAN(data_trial.Data, 'Array');
        Channel_Length = length(data_trial.Data);  %Trial time
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
        
        % finding the distances
        dLeftSh = mLeftLaser * vLeft(LasDel:Channel_Length) + bLeftLaser;
        dRightSh = mRightLaser * vRight(LasDel:Channel_Length) + bRightLaser;
        dHip = mHipLaser * vHip(LasDel:Channel_Length) + bHipLaser;
        
        LeftShAngle{i, j}(:) = angle_cal(dLeftSh,QS.dLeftSh_QS,hLeftSh - hLM);
        BodyAngle{i, j}(:) = -angle_cal(dHip,QS.dHip_QS,hBody - hLM);
        RightShAngle{i, j}(:) = angle_cal(dRightSh,QS.dRightSh_QS,hRightSh - hLM);
        
        % Calculation of ankle torque using load cell data
        Force_raw = data_trial.Data(1:Channel_Length,16:23);
        Force = 4.536*9.81*Force_raw;
        Torque_L{i, j}(:)  = -( d_f * (Force(1:Channel_Length - LasDel + 1,1)+Force(1:Channel_Length - LasDel + 1,2)) - d_b * (Force(1:Channel_Length - LasDel + 1,3)+Force(1:Channel_Length - LasDel + 1,4)));
        Torque_R{i, j}(:)  = -( d_f * (Force(1:Channel_Length - LasDel + 1,5)+Force(1:Channel_Length - LasDel + 1,6)) - d_b * (Force(1:Channel_Length - LasDel + 1,7)+Force(1:Channel_Length - LasDel + 1,8)));
        
        TL_trans = data_trial.Data(1:Channel_Length - LasDel + 1,2);
        TR_trans = data_trial.Data(1:Channel_Length - LasDel + 1,4);
        
        Torque_L{i, j}(:)  = Torque_L{i, j}(:)  + mean(TL_trans - Torque_L{i, j}(:));
        Torque_R{i, j}(:)  = Torque_R{i, j}(:)  + mean(TR_trans - Torque_R{i, j}(:));
        
        % EMGs
        L_Sol_EMG{i, j}(:)  = abs(data_trial.Data(1:Channel_Length-LasDel+1,8))/emgGain;
        R_Sol_EMG{i, j}(:) = abs(data_trial.Data(1:Channel_Length-LasDel+1,9))/emgGain;
        L_MG_EMG{i, j}(:)  = abs(data_trial.Data(1:Channel_Length-LasDel+1,7))/emgGain;
        R_MG_EMG{i, j}(:)  = abs(data_trial.Data(1:Channel_Length-LasDel+1,10))/emgGain;
        L_LG_EMG{i, j}(:)  = abs(data_trial.Data(1:Channel_Length-LasDel+1,24))/emgGain;
        R_LG_EMG{i, j}(:)  = abs(data_trial.Data(1:Channel_Length-LasDel+1,25))/emgGain;
        L_TA_EMG{i, j}(:)  = abs(data_trial.Data(1:Channel_Length-LasDel+1,6))/emgGain;
        R_TA_EMG{i, j}(:)  = abs(data_trial.Data(1:Channel_Length-LasDel+1,11))/emgGain;
        
        vr_input{i, j}(:) = data_trial.Data(1:Channel_Length - LasDel + 1, 15);        
 
    end
end

% Create a structure of structures 
Trials_Data.vr_input = vr_input;
Trials_Data.RightShAngle = RightShAngle;
Trials_Data.LeftShAngle = LeftShAngle;
Trials_Data.BodyAngle = BodyAngle;
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
Trials_Data.trialsMatrix = trialsMatrix;

end

