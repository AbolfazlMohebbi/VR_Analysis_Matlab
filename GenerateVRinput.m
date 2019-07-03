
%% TrapZ
clc; clear all; close all

%% Modulate Input

SR = 1000;
Total_Time_Sec = 200;
nFFT = 20 * SR;

minW_Sec = [0, 1, 2.5, 5.0, 8.0]; % Seconds
% minW_Sec = 0; % Seconds
minDelta_sec = [1, 2.5, 5.0, 8.0]; %Seconds
% minDelta_sec = 2.5;

TrapZ_P2PAmp = 5;
TrapZ_Vel = [2, 5, 10, 15];
% TrapZ_Vel = 8;

[PositionArray, daqInputArray] = TrapZ_Generator(TrapZ_P2PAmp, TrapZ_Vel(1), minW_Sec(1), minDelta_sec(1), Total_Time_Sec, SR, 'y');

figure();
hold on
count = 0;
for i = 1:length(minW_Sec)
    for j = 1:length(minDelta_sec)
        for k = 1:length(TrapZ_Vel)
            count = count + 1;
            [PositionArray, ~] = TrapZ_Generator(TrapZ_P2PAmp, TrapZ_Vel(k), minW_Sec(i), minDelta_sec(j), Total_Time_Sec, SR, 'n');
            inputVRpower = spect(PositionArray'-mean(PositionArray'),'nFFT',nFFT);
            semilogx(0:SR/nFFT:SR/2,inputVRpower.dataSet);hold on
            xlim([0 SR/2])
            legendstr{count} = strcat('Amp=', string(TrapZ_P2PAmp), ', Velocity=', string(TrapZ_Vel(k)), ', minDelta=', string(minDelta_sec(j)), ', minW=', string(minW_Sec(i)) );
        end
    end
end

title('TrapZ Input Power', 'fontsize', 18)
xlabel('Frequency (Hz)', 'fontsize', 18)
ylabel('Power', 'fontsize', 18)
set(gca, 'XScale', 'log', 'YScale', 'log')
% set(gca, 'XScale', 'log')
legend(legendstr)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
hold off
legend show

%titlestr = strcat('TrapZ Input Power with Amplitude=', string(TrapZ_P2PAmp(i)), ' and Velocity=', string(TrapZ_Vel(j)));
%title(titlestr, 'fontsize', 18)







%% Constant Velocity and Amp
% Variable W and delta

SR = 1000;
Total_Time_Sec = 200;
nFFT = 40 * SR;

TrapZ_P2PAmp = 5;
TrapZ_Vel = 5;

minW_Sec = [0, 1, 2.5, 5.0]; % Seconds
% minDelta_sec = [1, 2.5, 5.0]; %Seconds
minDelta_sec = 2.5; %Seconds

figure();
hold on
count = 0;
for i = 1:length(minW_Sec)
    for j = 1:length(minDelta_sec)
            count = count + 1;
            [PositionArray, ~] = TrapZ_Generator(TrapZ_P2PAmp, TrapZ_Vel, minW_Sec(i), minDelta_sec(j), Total_Time_Sec, SR, 'n');
            inputVRpower = spect(PositionArray'-mean(PositionArray'),'nFFT',nFFT);
            semilogx(0:SR/nFFT:SR/2,inputVRpower.dataSet);hold on
            xlim([0 SR/2])
            legendstr{count} = strcat('Amp=', string(TrapZ_P2PAmp), ', Velocity=', string(TrapZ_Vel), ', minDelta=', string(minDelta_sec(j)), ', minW=', string(minW_Sec(i)) );
    end
end

title('TrapZ Input Power', 'fontsize', 18)
xlabel('Frequency (Hz)', 'fontsize', 18)
ylabel('Power', 'fontsize', 18)
% set(gca, 'XScale', 'log', 'YScale', 'log')
set(gca, 'XScale', 'log')
legend(legendstr)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
hold off
legend show



%% Constant Amp and delta (delay)
% Variable W and velocity

SR = 1000;
Total_Time_Sec = 200;
nFFT = 20 * SR;

TrapZ_P2PAmp = 5;
TrapZ_Vel = [2, 5, 10];
minW_Sec = [0, 1, 2.5, 5.0]; % Seconds
minDelta_sec = 2.5; %Seconds

figure();
hold on
count = 0;
for i = 1:length(minW_Sec)
    for k = 1:length(TrapZ_Vel)
            count = count + 1;
            [PositionArray, ~] = TrapZ_Generator(TrapZ_P2PAmp, TrapZ_Vel(k), minW_Sec(i), minDelta_sec, Total_Time_Sec, SR, 'n');
            inputVRpower = spect(PositionArray'-mean(PositionArray'),'nFFT',nFFT);
            semilogx(0:SR/nFFT:SR/2,inputVRpower.dataSet);hold on
            xlim([0 SR/2])
            legendstr{count} = strcat('Amp=', string(TrapZ_P2PAmp), ', Velocity=', string(TrapZ_Vel(k)), ', minDelta=', string(minDelta_sec), ', minW=', string(minW_Sec(i)) );
    end
end

title('TrapZ Input Power', 'fontsize', 18)
xlabel('Frequency (Hz)', 'fontsize', 18)
ylabel('Power', 'fontsize', 18)
set(gca, 'XScale', 'log', 'YScale', 'log')
% set(gca, 'XScale', 'log')
legend(legendstr)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
hold off
legend show



%% Constant Amp and W
% Variable delta (delay) and velocity

SR = 1000;
Total_Time_Sec = 200;
nFFT = 20 * SR;

TrapZ_P2PAmp = 5;
TrapZ_Vel = [2, 5, 10];
minW_Sec = 2.5; % Seconds
minDelta_sec = [1, 2.5, 5]; %Seconds

figure();
hold on
count = 0;
for j = 1:length(minDelta_sec)
    for k = 1:length(TrapZ_Vel)
            count = count + 1;
            [PositionArray, ~] = TrapZ_Generator(TrapZ_P2PAmp, TrapZ_Vel(k), minW_Sec, minDelta_sec(j), Total_Time_Sec, SR, 'n');
            inputVRpower = spect(PositionArray'-mean(PositionArray'),'nFFT',nFFT);
            semilogx(0:SR/nFFT:SR/2,inputVRpower.dataSet);hold on
            xlim([0 SR/2])
            legendstr{count} = strcat('Amp=', string(TrapZ_P2PAmp), ', Velocity=', string(TrapZ_Vel(k)), ', minDelta=', string(minDelta_sec(j)), ', minW=', string(minW_Sec) );
    end
end

title('TrapZ Input Power', 'fontsize', 18)
xlabel('Frequency (Hz)', 'fontsize', 18)
ylabel('Power', 'fontsize', 18)
set(gca, 'XScale', 'log', 'YScale', 'log')
% set(gca, 'XScale', 'log')
legend(legendstr)
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
hold off
legend show




















