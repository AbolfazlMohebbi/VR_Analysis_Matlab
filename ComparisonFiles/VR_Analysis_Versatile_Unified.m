
%%
close all
clear all;
clc;
dataPath = pwd + "\data\";

%% Load Data and subject info: 

fid = fopen('SubjectsParams/SubjectsParams_2.csv');
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
trialsfile = pwd + "\SubjectsParams\TrialsInfo.csv";

%% Brows for flb data (if needed)
% cd data
% [file,path] = uigetfile({'*.flb';'*.xlsx';'*.slx';'*.mat';'*.*'},'File Selector');
% cd ..

%% Global variables
global SR LasDel emgGain dr d_f d_b fc nlags
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

Amps = [1 2 5 10]; 
Vels = [2 5 10];

for i = 1:length(Amps)
    for j = 1: length(Vels)
        for trial_case = 1:3
            AmpCase = Amps(i);
            VelCase = Vels(j);
            [Experiment, NN, trials, Amp, FigsPath, Averaging, stackTrials] = getExperimentSpecs_Unified(trialsfile, SubjIndex, AmpCase, VelCase, trial_case);
            Trials_Data = getTrialsData_TrapV(SubjIndex, Subject_data, flb_file_path, Experiment, NN, trials);
            Trials_Data = syncStartData_gui(SubjIndex, Trials_Data, Experiment, NN);
            Trials_Data.vr_input_deg = inputVolts2Deg_TrapV(SubjIndex, Experiment, Amp, Trials_Data.vr_input, NN);
            [Trials_Data_Realizations, Trials_NLD] = dataRealizations_Unified(SubjIndex, Experiment, Trials_Data, Averaging, stackTrials, NN);
            t = 0:1/SR:(length(Trials_NLD.TorqueL)-1)/SR;
            run Plot_NLD_Objects.m
            run Plot_Impulse_Response.m
            run Plot_Power_Spectrum.m
            run Plot_Frequency_Response.m
        end
    end
end


%% Save Figures
% SaveAllFigures(FigsPath, '.png');
