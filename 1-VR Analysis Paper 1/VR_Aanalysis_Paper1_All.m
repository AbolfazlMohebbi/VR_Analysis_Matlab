% C:\Users\VR-PC-REKLAB\Documents\MATLAB\Add-Ons\Collections\MATLAB Schemer
% schemer_import

% run D:\StashVR\reklab_public-master\reklab_public\reklabPaths.m

clc;

%% Global variables
global SR LasDel emgGain dr d_f d_b fc nlags
SR = 1000; % data Sampling rate
LasDel = 4;  % Laser sensors delay
emgGain = 1000;
dr = 100; % decimation filters the signal with a cutoff of 0.8/dr*(SR/2)
d_f = 238.89/1000; % distance between the front load cells and ankle axis of rotation
d_b = 51.05/1000; % distance between the back load cells and ankle axis of rotation
fc = 0.8/dr*(SR/2);

%% Load or Create Data

if (not(exist('Trials_Data_All','var')) && isfile('Trials_Data_All.mat'))
    load('Trials_Data_All.mat');
    
elseif (not(isfile('Trials_Data_All.mat')))    
    currentPath = pwd;
    cd ..
    dataPath = pwd + "\data\";
    folderName = erase(currentPath, pwd);
    clear currentPath
    
    % Load Data and subject info:
    
    fid = fopen('SubjectsParams/SubjectsParams_Set1.csv');
    Subject_data = textscan(fid, '%d %s %f %f %f %f %f %f %d %d %s %s %d', 'Delimiter', ',', 'HeaderLines', 1);
    fclose(fid);
    Subject_No = length(Subject_data{2});    
    
    % Load All Data
    trialsfile = pwd + "\SubjectsParams\TrialsInfo_Set1.csv";
    allData = {};
    flb_file_path_All = {};
    for S = 1:Subject_No
        
        % Parameters from csv file
        flb_file = Subject_data{11}{S};
        flb_file_path = dataPath + flb_file;
        flb_file_path_All{S} = flb_file_path;
        cd(strcat(pwd,folderName));
        
        % Show All data tags and Trials
        data = flb2mat(flb_file_path, 'read_all');
        allData{S} = data;
        cd ..
        
    end
    cd(strcat(pwd,folderName));
    
    % Experiment Specs
    VelCase = [2 5 10];
    AmpCase = [1 2 5 10];
    
    trialsAll = getExperimentSpecs_All(trialsfile, VelCase, AmpCase, Subject_No);
    
    %clear trialsfile data flb_file flb_file_path fid S folderName dataPath;
    
    % Read trials for all experiments
    
    Trials_Data_All = getTrialsData_All(Subject_No, Subject_data, flb_file_path_All, allData, trialsAll, VelCase, AmpCase);
    Trials_Data_All.VelCase = VelCase;
    Trials_Data_All.AmpCase = AmpCase;
    Trials_Data_All.SubjNo = Subject_No;
    



%% Synchronise the start time for VR input and outputs 
Trials_Data_All = syncStartData_All(Trials_Data_All);

%% change volts to deg
Trials_Data_All = inputVolts2Deg_All(Trials_Data_All);

%% Detrend data
Trials_Data_All = detrend_data_All(Trials_Data_All);

%% Change RAD to DEG
Trials_Data_All = outputRad2Deg_All(Trials_Data_All);

end

%% Create Data Realizations and NLD Objects

if (not(exist('Trials_All_NLD','var')) && isfile('Trials_All_NLD.mat'))
    load('Trials_All_NLD.mat');    
elseif (not(isfile('Trials_All_NLD.mat'))) 
    [Trials_Data_All_Realizations, Trials_All_NLD] = dataRealizations_All(Trials_Data_All);    
end

%%
%run Plot_Impulse_Response_All.m


















