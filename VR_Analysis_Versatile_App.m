function VR_Analysis_Versatile_App(SubjIndex, Subject_data, Amplitude, Velocity, trial_case, b_detrend, bDDT_VR, bDDT_Output, bGui_IRF)

close all;
clc;
dataPath = pwd + "\data\";

%% Parameters from csv file
number = Subject_data{1}(SubjIndex);
name = Subject_data{2}{SubjIndex};
flb_file = Subject_data{11}{SubjIndex};
flb_file_path = dataPath + flb_file;
trialsfile = pwd + "\SubjectsParams\TrialsInfo.csv";

%% Brows for flb data (if needed)
% cd data
% [file,path] = uigetfile({'*.flb';'*.xlsx';'*.slx';'*.mat';'*.*'},'File Selector');
% cd ..

%% Global variables
global SR LasDel emgGain dr d_f d_b fc nlags irf_gui
irf_gui = bGui_IRF;
SR = 1000; % data Sampling rate
LasDel = 4;  % Laser sensors delay
emgGain = 1000; 
dr = 50; % decimation filters the signal with a cutoff of 0.8/dr*(SR/2)
d_f = 238.89/1000; % distance between the front load cells and ankle axis of rotation
d_b = 51.05/1000; % distance between the back load cells and ankle axis of rotation
fc = 0.8/dr*(SR/2);

%% Define Filtering
% [filter_num,filter_den] = cheby1(10,0.05,fc/(SR/2)); % Chebyshev was used because it is used in decimation

%% Show All data tags and Trials
data = flb2mat(flb_file_path, 'read_all')
trials = {data.comment}

%% Experiment Specs: Averaging, Stacking, Amplitude, ....
[Experiment, NN, trials, Amp, FigsPath, Averaging, stackTrials] = getExperimentSpecs_App(trialsfile, SubjIndex, Amplitude, Velocity, trial_case);

%% read trials data based on chosen experiments
Trials_Data = getTrialsData_TrapV(SubjIndex, Subject_data, flb_file_path, Experiment, NN, trials);

%% Synchronise the start time for VR input and outputs 
% Trials_Data = syncStartData_TrapV(SubjIndex, Trials_Data, Experiment, NN);
Trials_Data = syncStartData_gui(SubjIndex, Trials_Data, Experiment, NN);

%% change volts to deg
Trials_Data.vr_input_deg = inputVolts2Deg_TrapV(SubjIndex, Experiment, Amp, Trials_Data.vr_input, NN);

if (b_detrend == 1)    
    Trials_Data = detrend_data(Trials_Data, 'y');    
end

%% Create Data Realizations based on Averaging and Stacking Properties - Fig(1)

[Trials_Data_Realizations, Trials_NLD] = dataRealizations_App(SubjIndex, Experiment, Trials_Data, Averaging, stackTrials, NN, bDDT_VR, bDDT_Output);
t = 0:1/SR:(length(Trials_NLD.TorqueL)-1)/SR;

%% Plot NLD Objects - Fig (5-7)
run Plot_NLD_Objects.m

%% Impulse Response Functions - Fig (8-11)
run Plot_Impulse_Response_App.m

%% Plot Power Spectrum and Power Spectrum Decimated - Fig (12-13)
run Plot_Power_Spectrum.m

%% Frequency Response Functions - Fig (14-19)
run Plot_Frequency_Response.m

%% Save Figures
% SaveAllFigures(FigsPath, '.png');




end  %END FUNCTION


