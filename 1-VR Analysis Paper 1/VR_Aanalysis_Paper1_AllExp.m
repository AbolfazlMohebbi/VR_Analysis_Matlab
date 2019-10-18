%% Analysis of data of all experiments for each Subject (using best trials)
% Example: VAF and Coherence for all amps and vels for a subject

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
cd(strcat(pwd,folderName)); 

%% Global variables
global SR LasDel emgGain dr d_f d_b fc nlags
SR = 1000; % data Sampling rate
LasDel = 4;  % Laser sensors delay
emgGain = 1000; 
dr = 100; % decimation filters the signal with a cutoff of 0.8/dr*(SR/2)
d_f = 238.89/1000; % distance between the front load cells and ankle axis of rotation
d_b = 51.05/1000; % distance between the back load cells and ankle axis of rotation
fc = 0.8/dr*(SR/2);

%% Show All data tags and Trials
data = flb2mat(flb_file_path, 'read_all')
trials_names = {data.comment}

%% Experiment Specs

VelCase = [2 5 10];
AmpCase = [1 2 5 10];
trialsMatrix = getExperimentSpecs_AllExp(trialsfile, VelCase, AmpCase, SubjIndex);

%% Read trials for all experiments
Trials_Data = getTrialsData_AllExp(SubjIndex, Subject_data, flb_file_path, data, trialsMatrix, VelCase, AmpCase);
Trials_Data.VelCase = VelCase;
Trials_Data.AmpCase = AmpCase;


%% Synchronise the start time for VR input and outputs 
Trials_Data = syncStartData_AllExp(Trials_Data);

%% change volts to deg
Trials_Data = inputVolts2Deg_AllExp(Trials_Data);

%% Detrend data

b_detrend = input('Would you like to de-trend the data? \n 1) YES\n 2) NO\n');
if (b_detrend == 1)    
    Trials_Data = detrend_data_AllExp(Trials_Data, 'n');    
end

%% Change RAD to DEG
Trials_Data = outputRad2Deg_AllExp(Trials_Data);

%% Create Data Realizations based on Averaging and Stacking Properties - Fig(1)
[Trials_Data_Realizations, Trials_NLD] = dataRealizations_AllExp(Trials_Data);

%% Plot NLD Objects
% run Plot_NLD_Objects_AllExp.m

%% Impulse Response Functions
run Plot_Impulse_Response_AllExp.m

%% Frequency Response Functions
run Plot_Frequency_Response_AllExp.m





















