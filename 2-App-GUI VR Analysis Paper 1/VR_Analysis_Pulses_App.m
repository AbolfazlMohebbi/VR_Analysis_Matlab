function VR_Analysis_Pulses_App(SubjIndex, Subject_data, Amplitude, Velocity, trial_case, b_detrend, bDDT_VR, bDDT_Output, bGui_IRF, ...
                                    SR_gui, dr_gui, nFFT_gui, nLags_gui, nSides_gui)

close all;
clc;

currentPath = pwd;
cd ..
mainFolder = pwd;
dataPath = pwd + "\data\";
folderName = erase(currentPath, mainFolder);

%% Parameters from csv file
number = Subject_data{1}(SubjIndex);
name = Subject_data{2}{SubjIndex};
flb_file = Subject_data{11}{SubjIndex};
flb_file_path = dataPath + flb_file;
trialsfile = pwd + "\SubjectsParams\TrialsInfo_Set1.csv";
cd(strcat(pwd,folderName)); %'1-VR Analysis Paper 1'

% best_trial = Subject_data{14}(SubjIndex);
% fprintf('\nThe best tested trial is #%d \n', best_trial)

%% Brows for flb data (if needed)
% cd data
% [file,path] = uigetfile({'*.flb';'*.xlsx';'*.slx';'*.mat';'*.*'},'File Selector');
% cd ..

%% Global variables
global SR LasDel emgGain dr d_f d_b fc nlags irf_gui nFFT nSides
nSides = nSides_gui;
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
trials = {data.comment}

%% Experiment Specs: Averaging, Stacking, Amplitude, ....
[Experiment, NN, trials, Amp, FigsPath, Averaging, stackTrials] = getExperimentSpecs_App(trialsfile, SubjIndex, Amplitude, Velocity, trial_case);

%% read trials data based on chosen experiments
Trials_Data = getTrialsData_App(SubjIndex, Subject_data, flb_file_path, Experiment, NN, trials);

%% Synchronise the start time for VR input and outputs 
% Trials_Data = syncStartData_TrapV(SubjIndex, Trials_Data, Experiment, NN);
Trials_Data = syncStartData_App(SubjIndex, Trials_Data, Experiment, NN);

%% change volts to deg
Trials_Data.vr_input_deg = inputVolts2Deg_App(SubjIndex, Experiment, Amp, Trials_Data.vr_input, NN);

if (b_detrend == 1)    
    Trials_Data = detrend_data(Trials_Data, 'y');    
end

Trials_Data = outputRad2Deg_App(Trials_Data);

%% Savitzky�Golay filter 
filtorder = 9;
framelen = 10 * (SR/dr) + 1;
Trials_Data = SGfilter_App(Trials_Data, filtorder, framelen);

%% Create Data Realizations based on Averaging and Stacking Properties

[Trials_Data_Realizations, Trials_NLD] = dataRealizations_App(SubjIndex, Experiment, Trials_Data, Averaging, stackTrials, NN, bDDT_VR, bDDT_Output);
t = 0:1/SR:(length(Trials_NLD.TorqueL)-1)/SR;

%% Plot NLD Objects - Fig (5-7)
run Plot_NLD_Objects_App.m

%% Impulse Response Functions - Fig (8-11)
run Plot_Impulse_Response_App.m

%% Plot Power Spectrum and Power Spectrum Decimated - Fig (12-13)
run Plot_Power_Spectrum_App.m

%% Frequency Response Functions - Fig (14-19)
run Plot_Frequency_Response_App.m

%% Save Figures
% SaveAllFigures(FigsPath, '.png');


end  %END FUNCTION


