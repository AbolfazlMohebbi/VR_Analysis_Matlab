function Trials_Data_Sync = syncStartData(SubjIndex, Trials_Data, Experiment, NN)
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
if (SubjIndex == 1) 
% To be completed
end

if (SubjIndex == 2) 
% To be completed
end

if (SubjIndex == 3)    
    if (Experiment == 1) % TrapZ
        ti = 2 * SR;
        tf = 107 * SR;
        
    elseif (Experiment == 2)    % for PRTS inputs (2 Period)
        ti = 0.05 * SR;
        tf = 107.57 * SR;
        
    elseif (Experiment == 3)  % Sum of Sin
        ti = 1;
        tf = 58.01 * SR;
        
    elseif (Experiment == 4) % PRBS
        ti = 2 * SR;
        tf = 107 * SR;
    end    
end

if (SubjIndex == 4)
    if (Experiment == 1) % TrapZ
        ti = 2 * SR;
        tf = 204 * SR;
        
    elseif (Experiment == 2)    % for PRTS inputs (2 Period)
        if ((NN == 3) || (NN == 4)) % Dt = 222ms
            ti = 240; tf = 215400; %242180;            
        else % Dt = 166 ms
            ti = 190; tf = 242220;
        end
        
    elseif (Experiment == 3)  % Sum of Sin
        ti = 40;
        tf = 220015;
    end    
end

if (SubjIndex == 5)
    if (Experiment == 1) % TrapZ
        
        ti = input('Please Specify the initial time in seconds. ti = ');
        tf = input('Please Specify the final time in seconds. tf = ');
        ti = ti * SR;
        tf = tf * SR;
        
%         ti = 2 * SR;
%         tf = 207 * SR;
    end    
end

if (SubjIndex == 6)
    if (Experiment == 1) % TrapZ
        ti = input('Please Specify the initial time in seconds. ti = ');
        tf = input('Please Specify the final time in seconds. tf = ');
        ti = ti * SR;
        tf = tf * SR;        
        %ti = 2 * SR;
        %tf = 207 * SR;
        
    elseif (Experiment == 2)    % for PRTS inputs (2 Period)
        if ((NN == 3) || (NN == 4)) % Dt = 222ms
            ti = 240; tf = 215400; %242180;            
        else % Dt = 166 ms
            ti = 190; tf = 242220;
        end
    end    
end

if (SubjIndex == 7)
    if (Experiment == 1) % TrapZ
        ti = input('Please Specify the initial time in seconds. ti = ');
        tf = input('Please Specify the final time in seconds. tf = ');
        ti = ti * SR;
        tf = tf * SR;        
        %ti = 1 * SR;
        %tf = 121 * SR;
        
    elseif (Experiment == 2)    % for PRTS inputs (2 Period)
        if ((NN == 3) || (NN == 4)) % Dt = 222ms
            ti = 240; tf = 161571;   % 3T         
        else % Dt = 166 ms
            ti = 190; tf = 161520;  % 4T
        end
    end    
end

if (SubjIndex == 8)
    if (Experiment == 1) % TrapZ        
        ti = input('Please Specify the initial time in seconds. ti = ');
        tf = input('Please Specify the final time in seconds. tf = ');
        ti = ti * SR;
        tf = tf * SR;
        
%         ti = 1 * SR;
%         tf = 122 * SR;
    end    
end

if (SubjIndex == 9)
    if (Experiment == 1) % TrapZ        
        ti = input('Please Specify the initial time in seconds. ti = ');
        tf = input('Please Specify the final time in seconds. tf = ');
        ti = ti * SR;
        tf = tf * SR;
        
%         ti = 1 * SR;
%         tf = 122 * SR;
    end    
end

if (SubjIndex == 10)
    if (Experiment == 1) % TrapZ
        ti = input('Please Specify the initial time in seconds. ti = ');
        tf = input('Please Specify the final time in seconds. tf = ');
        ti = ti * SR;
        tf = tf * SR;        
        %ti = 1 * SR;
        %tf = 121 * SR;
        
    elseif (Experiment == 2)    % for PRTS inputs (2 Period)
        ti = 240; tf = 221071;   % 3T         
    end    
end

if (SubjIndex == 11)    
    if (Experiment == 1)  % If HSin
        if (NN==1)
            ti = 0.5 * SR;
            tf = 48.5 * SR;
        else
            ti = 0.5 * SR;
            tf = 58.5 * SR;
        end
    end 
    
    if (Experiment == 2) % If PRTS dt=0.1  2T
        ti = 200; tf = 50100;   % 2T        
    end 
    
    if (Experiment == 3) % If PRTS dt=0.2  2T
        ti = 200; tf = 102000;   % 2T 
    end 
    
    if (Experiment == 4) % TrapZ
%         ti = input('Please Specify the initial time in seconds. ti = ');
%         tf = input('Please Specify the final time in seconds. tf = ');
        ti = 0.5 * SR;
        tf = 75.5 * SR;
    end
    
    if (Experiment == 5)       
        ti = 0.5 * SR;
        tf = 110 * SR;
    end      
end


if (SubjIndex == 12)
    %     if (Experiment == 1) % TrapZ
    %         ti = input('Please Specify the initial time in seconds. ti = ');
    %         tf = input('Please Specify the final time in seconds. tf = ');
    %         ti = ti * SR;
    %         tf = tf * SR;
    %         %ti = 1 * SR;
    %         %tf = 121 * SR;
    %
    %     elseif (Experiment == 2)    % for PRTS dt=0.2 (4 Period)
    %         ti = 240; tf = 200 * SR;
    %     elseif (Experiment == 3)    % for PRTS dt=0.1 (6 Period)
    %         ti = 240; tf = 150 * SR;
    %     end
    ti = 100;
    tf = length(vr_input_new)- 5 * SR;    
end

if (SubjIndex == 13) || (SubjIndex == 14)
    ti = 100;
    tf = length(vr_input_new)- 5 * SR;    
end

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

