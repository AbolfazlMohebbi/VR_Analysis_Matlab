
%%
close all
clear all;
clc;

currentPath = pwd;
cd ..
mainFolder = pwd;
dataPath = pwd + "\data\";
folderName = erase(currentPath, mainFolder);

%% Load Data and subject info: 

fid = fopen('SubjectsParams/SubjectsParams_Set1.csv');
Subject_data = textscan(fid, '%d %s %f %f %f %f %f %f %d %d %s %s %d', 'Delimiter', ',', 'HeaderLines', 1);
fclose(fid);
Subject_Names = Subject_data{2};
Exp_date = Subject_data{12};

str_full = '';
for i=1:length(Subject_Names)    
    str_buff = strcat(int2str(i),'- ', string(Subject_Names(i)), ' -- ', string(Exp_date(i)), '\n');
    str_full = strcat(str_full, {' '}, str_buff);    
end

SubjIndex = input(strcat('Which subject would you like to examine?\n',str_full) );

%% Parameters from csv file
number = Subject_data{1}(SubjIndex);
name = Subject_data{2}{SubjIndex};
flb_file = Subject_data{11}{SubjIndex};
flb_file_path = dataPath + flb_file;
trialsfile = pwd + "\SubjectsParams\TrialsInfo_Set1_bestTrials.csv";
cd(strcat(pwd,folderName)); %'1-VR Analysis Paper 1'

%% Browse for flb data (if needed)
% cd data
% [file,path] = uigetfile({'*.flb';'*.xlsx';'*.slx';'*.mat';'*.*'},'File Selector');
% cd ..

%% Global variables
global SR LasDel emgGain dr d_f d_b fc nlags
SR = 1000; % data Sampling rate
LasDel = 4;  % Laser sensors delay
emgGain = 1000; 
dr = 100; % decimation filters the signal with a cutoff of 0.8/dr*(SR/2)
d_f = 238.89/1000; % distance between the front load cells and ankle axis of rotation
d_b = 51.05/1000; % distance between the back load cells and ankle axis of rotation
fc = 0.8/dr*(SR/2);

%% Define Filtering
% [filter_num,filter_den] = cheby1(10,0.05,fc/(SR/2)); % Chebyshev was used because it is used in decimation

%% Show All data tags and Trials
data = flb2mat(flb_file_path, 'read_all')
trials_names = {data.comment}

%% Experiment Specs: Averaging, Stacking, Amplitude, ....
[Experiment, NN, trials, Amp, FigsPath, Averaging, stackTrials] = getExperimentSpecs_TrapV(trialsfile, SubjIndex);

%% read trials data based on chosen experiments
Trials_Data = getTrialsData_TrapV(SubjIndex, Subject_data, flb_file_path, Experiment, NN, trials);

%% Synchronise the start time for VR input and outputs 
% Trials_Data = syncStartData_TrapV(SubjIndex, Trials_Data, Experiment, NN);
Trials_Data = syncStartData_gui(SubjIndex, Trials_Data, Experiment, NN);

%% change volts to deg
Trials_Data.vr_input_deg = inputVolts2Deg_TrapV(SubjIndex, Experiment, Amp, Trials_Data.vr_input, NN);

b_detrend = input('Would you like to de-trend the data? \n 1) YES\n 2) NO\n');
if (b_detrend == 1)    
    Trials_Data = detrend_data(Trials_Data, 'y');    
end

Trials_Data = outputRad2Deg_TrapV(Trials_Data);

%% Create Data Realizations based on Averaging and Stacking Properties - Fig(1)

[Trials_Data_Realizations, Trials_NLD] = dataRealizations(SubjIndex, Experiment, Trials_Data, Averaging, stackTrials, NN);
t = 0:1/SR:(length(Trials_NLD.TorqueL)-1)/SR;

%% Plot NLD Objects - Fig (5-7)
run Plot_NLD_Objects.m

%% Impulse Response Functions - Fig (8-11)
run Plot_Impulse_Response.m

%% Plot Power Spectrum and Power Spectrum Decimated - Fig (12-13)
run Plot_Power_Spectrum.m

%% Frequency Response Functions - Fig (14-19)
run Plot_Frequency_Response.m

%% Save Figures
% SaveAllFigures(FigsPath, '.png');
