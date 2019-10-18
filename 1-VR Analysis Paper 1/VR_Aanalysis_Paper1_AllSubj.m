%% Analysis of data of each experiments for all Subject
% Example: VAF and Coherence for each amp and vel for all subject

% C:\Users\VR-PC-REKLAB\Documents\MATLAB\Add-Ons\Collections\MATLAB Schemer
% schemer_import
% run D:\StashVR\reklab_public-master\reklab_public\reklabPaths.m

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
Subject_No = length(Subject_Names);

%% Global variables
global SR LasDel emgGain dr d_f d_b fc nlags
SR = 1000; % data Sampling rate
LasDel = 4;  % Laser sensors delay
emgGain = 1000; 
dr = 100; % decimation filters the signal with a cutoff of 0.8/dr*(SR/2)
d_f = 238.89/1000; % distance between the front load cells and ankle axis of rotation
d_b = 51.05/1000; % distance between the back load cells and ankle axis of rotation
fc = 0.8/dr*(SR/2);


%% Load All Data
trialsfile = pwd + "\SubjectsParams\TrialsInfo_Set1_bestTrials.csv";
allData = {};
flb_file_path_All = {};
for s = 1:Subject_No
    
    % Parameters from csv file
    number = Subject_data{1}(s);
    name = Subject_data{2}{s};
    flb_file = Subject_data{11}{s};
    flb_file_path = dataPath + flb_file;
    flb_file_path_All{s} = flb_file_path;
    cd(strcat(pwd,folderName));    
    
    % Show All data tags and Trials
    data = flb2mat(flb_file_path, 'read_all');    
    allData{s} = data;     
    cd ..

end
cd(strcat(pwd,folderName));

%% Experiment Specs
VelCase = [2 5 10];
AmpCase = [1 2 5 10];

trialsAll = getExperimentSpecs_AllSubj(trialsfile, VelCase, AmpCase, Subject_No);

%% Read trials for all experiments
Trials_Data_All = getTrialsData_AllSubj(Subject_No, Subject_data, flb_file_path_All, allData, trialsAll, VelCase, AmpCase);
Trials_Data_All.VelCase = VelCase;
Trials_Data_All.AmpCase = AmpCase;
Trials_Data_All.SubjNo = Subject_No;


%% Synchronise the start time for VR input and outputs 
Trials_Data_All = syncStartData_AllSubj(Trials_Data_All);

%% change volts to deg
Trials_Data_All = inputVolts2Deg_AllSubj(Trials_Data_All);

 %% Detrend data  - TODO
% 
% b_detrend = input('Would you like to de-trend the data? \n 1) YES\n 2) NO\n');
% if (b_detrend == 1)    
%     Trials_Data = detrend_data_AllExp(Trials_Data, 'n');    
% end
% 
% %% Change RAD to DEG
% Trials_Data = outputRad2Deg_AllExp(Trials_Data);


%% Create Data Realizations based on Averaging and Stacking Properties - Fig(1)
[Trials_Data_All_Realizations, Trials_All_NLD] = dataRealizations_AllSubj(Trials_Data_All);

%% Plot NLD Objects
% run Plot_NLD_Objects_AllSubj.m  TO BE IMPLEMENTED

%% Impulse Response Functions
run Plot_Impulse_Response_AllSubj.m
run Plot_Impulse_Response_AllSubj_BOXPLOT.m

%% Frequency Response Functions
run Plot_Frequency_Response_AllSubj.m



















