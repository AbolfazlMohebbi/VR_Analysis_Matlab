function VR_Analysis_Versatile_App_AllExp(SubjIndex, Subject_data, b_detrend, bDDT_VR, bDDT_Output, bGui_IRF, SR_gui, dr_gui, nFFT_gui, nLags_gui)

close all;
clc;

% currentPath = pwd;
% cd ..\..
% mainFolder = pwd;
% dataPath = pwd + "\data\";
% folderName = erase(currentPath, mainFolder);
dataPath = 'D:\StashVR\VR_Analysis_Matlab\data\';

%% Parameters from csv file
number = Subject_data{1}(SubjIndex);
name = Subject_data{2}{SubjIndex};
flb_file = Subject_data{11}{SubjIndex};
flb_file_path = strcat(dataPath, flb_file);
trialsfile = "D:\StashVR\VR_Analysis_Matlab\SubjectsParams\TrialsInfo_Set1_bestTrials.csv";

%cd(strcat(pwd,folderName));

% best_trial = Subject_data{14}(SubjIndex);
% fprintf('\nThe best tested trial is #%d \n', best_trial)

%% Brows for flb data (if needed)
% cd data
% [file,path] = uigetfile({'*.flb';'*.xlsx';'*.slx';'*.mat';'*.*'},'File Selector');
% cd ..

%% Global variables
global SR LasDel emgGain dr d_f d_b fc nlags irf_gui nFFT
irf_gui = bGui_IRF;
SR = SR_gui; % data Sampling rate
LasDel = 4;  % Laser sensors delay
emgGain = 1000; 
dr = dr_gui; % decimation filters the signal with a cutoff of 0.8/dr*(SR/2)
d_f = 238.89/1000; % distance between the front load cells and ankle axis of rotation
d_b = 51.05/1000; % distance between the back load cells and ankle axis of rotation
fc = 0.8/dr*(SR/2);
nlags = nLags_gui;
nFFT = nFFT_gui;

%% Define Filtering
% [filter_num,filter_den] = cheby1(10,0.05,fc/(SR/2)); % Chebyshev was used because it is used in decimation

%% Show All data tags and Trials
data = flb2mat(flb_file_path, 'read_all')
trials_names = {data.comment};

%% Experiment Specs: Averaging, Stacking, Amplitude, ....
VelCase = [2 5 10];
AmpCase = [1 2 5 10];
trialsMatrix = getExperimentSpecs_App_AllExp(trialsfile, VelCase, AmpCase, SubjIndex);

%% read trials data based on chosen experiments
Trials_Data = getTrialsData_App_AllExp(SubjIndex, Subject_data, flb_file_path, data, trialsMatrix, VelCase, AmpCase);
Trials_Data.VelCase = VelCase;
Trials_Data.AmpCase = AmpCase;

%% Synchronise the start time for VR input and outputs 
Trials_Data = syncStartData_App_AllExp(Trials_Data);

%% change volts to deg
Trials_Data = inputVolts2Deg_App_AllExp(Trials_Data);

%% Detrend data
if (b_detrend == 1)    
    Trials_Data = detrend_data_App_AllExp(Trials_Data, 'n');    
end

%% Change RAD to DEG
Trials_Data = outputRad2Deg_App_AllExp(Trials_Data);

%% Create Data Realizations based on Averaging and Stacking Properties - Fig(1)
[Trials_Data_Realizations, Trials_NLD] = dataRealizations_App_AllExp(Trials_Data, bDDT_VR, bDDT_Output);

%% Plot NLD Objects - Fig (5-7)
% run Plot_NLD_Objects_App_AllExp.m

%% Impulse Response Functions - Fig (8-11)
run Plot_Impulse_Response_App_AllExp.m

%% Frequency Response Functions - Fig (14-19)
run Plot_Frequency_Response_App_AllExp.m

%% Save Figures
% SaveAllFigures(FigsPath, '.png');


end  %END FUNCTION


