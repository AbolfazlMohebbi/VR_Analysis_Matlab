%%
close all
clear all;
clc;

%% Load Data: 

% disp('Please Press Enter to Select the Input Signal Data!')
% pause;
% [vr_file,vr_path] = uigetfile({'*.txt';'*.xlsx';'*.slx';'*.mat';'*.*'},'VR Input File');
% vr_input = importdata(strcat(vr_path, vr_file));
% 
% disp('Please Press Enter to Select the Head Tracking Data!' );
% pause;
% [HMD_file,HMD_path] = uigetfile({'*.txt';'*.xlsx';'*.slx';'*.mat';'*.*'},'Head Tracking Data file');
% head_ori = dlmread(strcat(HMD_path, HMD_file));
% head_OriX = head_ori(:,1);
% head_OriY = head_ori(:,2);
% head_OriZ = head_ori(:,3);
% 
% disp('Please Press Enter to Select the Time Data!' );
% pause;
% [time_file,time_path] = uigetfile({'*.txt';'*.xlsx';'*.slx';'*.mat';'*.*'},'Time data file');
% time = importdata(strcat(time_path, time_file));

%% Load Data: 

disp('Please Press Enter to Select the Input Signal Data!')
pause;
[vr_file,vr_path] = uigetfile({'*.txt';'*.xlsx';'*.slx';'*.mat';'*.*'},'VR Input File');
vr_input = importdata(strcat(vr_path, vr_file));

HMD_file = strcat('HeadMotion', vr_file(3:end));
head_ori = dlmread(strcat(vr_path, HMD_file));
head_OriX = head_ori(:,1);
head_OriY = head_ori(:,2);
head_OriZ = head_ori(:,3);

time_file = strcat('Time', vr_file(3:end));
time = importdata(strcat(vr_path, time_file));

%%

% path = 'D:\GDrive\0-PostDoc McGill\5-My Papers\2-EMBC2019\Matlab\data\20-06-2019\TrapZ\';
% vr_file = 'VR_TrapZ_Room_T1.txt';
% time_file = 'Time_TrapZ_Room_T1.txt';
% HMD_file = 'HeadMotion_TrapZ_Room_T1.txt';
% 
% vr_input = importdata(strcat(path, vr_file));
% time = importdata(strcat(path, time_file));
% head_ori = dlmread(strcat(path, HMD_file));
% head_OriX = head_ori(:,1);
% head_OriY = head_ori(:,2);
% head_OriZ = head_ori(:,3);


%% Global variables
global SR dr fc nlags
SR = 100; % data Sampling rate
dr = 1; % decimation filters the signal with a cutoff of 0.8/dr*(SR/2)
fc = 0.8/dr*(SR/2);

%% Experiment Specs: Averaging, Stacking, Amplitude, ....
stackTrials = 2;
Averaging = input('Which kind of averaging?\n 0) No Averaging (each trial separately)\n 1) Average on periods for each trial\n');
Diff_flag = input('\n Would you like to analyze the velocity is input?\n 0) NO\n 1) YES\n');

if (Averaging == 0) % No averaging. show both trials at the same time       
  
    figure(1)
    subplot(3,2,[1 3 5])
    plot(vr_input,'linewidth',1);title('VR Perturbation')    
    subplot(3,2,2)
    plot(head_OriX,'linewidth',1);title('Head Ori X')   
    subplot(3,2,4)
    plot(head_OriY,'linewidth',1);title('Head Ori Y')
    subplot(3,2,6)
    plot(head_OriZ,'linewidth',1);title('Head Ori Z')    
    vr_realizations = vr_input;
    
    % VR
    
    if (Diff_flag == 0)  % No derivatives
        
        VRnldat = nldat;
        set(VRnldat,'dataSet', vr_realizations, 'domainIncr',1/SR);       
        % Head Ori
        OriXnldat = nldat;
        set(OriXnldat,'dataSet', head_OriX, 'domainIncr',1/SR);
        OriYnldat = nldat;
        set(OriYnldat,'dataSet', head_OriY, 'domainIncr',1/SR);
        OriZnldat = nldat;
        set(OriZnldat,'dataSet', head_OriZ, 'domainIncr',1/SR);
        
    else
        
        VRnldat = nldat;
        set(VRnldat,'dataSet', vr_realizations, 'domainIncr',1/SR);        
        VRnldat = ddt(VRnldat); % derivatives        
        % Head Ori
        OriXnldat = nldat;
        set(OriXnldat,'dataSet', head_OriX, 'domainIncr',1/SR);
        OriXnldat = ddt(OriXnldat); % derivatives        
        OriYnldat = nldat;
        set(OriYnldat,'dataSet', head_OriY, 'domainIncr',1/SR);
        OriYnldat = ddt(OriYnldat); % derivatives        
        OriZnldat = nldat;
        set(OriZnldat,'dataSet', head_OriZ, 'domainIncr',1/SR);
        OriZnldat = ddt(OriZnldat); % derivatives
        
    end
    
   
    
    
else  % Averaging == 1 (average on periods of one trial) or 2 (average on all periods of all Trials_Data.trials)    
    
    periodTime = input('What is the period time? 24.2 or 48.4?') * SR;
    periodCount = 2;  
    
    vr_realizations = (VR_IO_Averaging(vr_input', 1, periodTime, periodCount, 'y'));
    OriX_realizations = (VR_IO_Averaging(head_OriX', 1, periodTime, periodCount, 'n'));
    OriY_realizations = (VR_IO_Averaging(head_OriY', 1, periodTime, periodCount, 'n'));
    OriZ_realizations = (VR_IO_Averaging(head_OriZ', 1, periodTime, periodCount, 'n'));
    
    % VR
    VRnldat = nldat;
    set(VRnldat,'dataSet', mean(vr_realizations)' - mean(mean(vr_realizations)), 'domainIncr',1/SR);   
    VRnldat = ddt(VRnldat); % derivatives    
    
    % Head Ori
    OriXnldat = nldat;
    set(OriXnldat,'dataSet', mean(OriX_realizations)' - mean(mean(OriX_realizations)), 'domainIncr',1/SR);   
    OriXnldat = ddt(OriXnldat); % derivatives
    OriYnldat = nldat;
    set(OriYnldat,'dataSet', mean(OriY_realizations)' - mean(mean(OriY_realizations)), 'domainIncr',1/SR);
    OriYnldat = ddt(OriYnldat); % derivatives
    OriZnldat = nldat;    
    set(OriZnldat,'dataSet', mean(OriZ_realizations)' - mean(mean(OriZ_realizations)), 'domainIncr',1/SR);  
    OriZnldat = ddt(OriZnldat); % derivatives
end

%% Plotting the NLDAT objects

t = 0:1/SR:(length(VRnldat)-1)/SR;

set(0,'DefaultAxesFontSize',16,'DefaultLineLineWidth',1.2,'DefaultAxesXGrid','on','DefaultAxesYGrid','off','DefaultLineMarkerSize',7)
set(0,'DefaultLineColor','b');

figure(2);
pl5(1) = subplot(311);
ax = plotyy(t, VRnldat.dataSet, t, OriXnldat.dataSet);hold on
title('Head Orientation X')
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (Deg)');
ylabel(ax(2), 'Head Orientation X (degree)');

pl5(2) = subplot(312);
ax = plotyy(t, VRnldat.dataSet, t, OriYnldat.dataSet);hold on
title('Head Orientation Y')
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (Deg)');
ylabel(ax(2), 'Head Orientation Y (degree)');

pl5(3) = subplot(313);
ax = plotyy(t, VRnldat.dataSet, t, OriZnldat.dataSet);hold on
title('Head Orientation Z')
xlabel('Time (s)')
ylabel(ax(1), 'VR input angle (Deg)');
ylabel(ax(2), 'Head Orientation Z (degree)')

linkaxes(pl5,'x')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])


%% Decimate: Resample data at a lower rate after lowpass filtering.

VRnldat_decimated = decimate(VRnldat, dr);  % position input
OriXnldat_decimated = decimate(OriXnldat, dr);  
OriYnldat_decimated = decimate(OriYnldat, dr);  
OriZnldat_decimated = decimate(OriZnldat, dr);  

%% Remove mean
VRnldat_decimated = VRnldat_decimated - mean(VRnldat_decimated);
OriXnldat_decimated = OriXnldat_decimated - mean(OriXnldat_decimated);
OriYnldat_decimated = OriYnldat_decimated - mean(OriYnldat_decimated);
OriZnldat_decimated = OriZnldat_decimated - mean(OriZnldat_decimated);

%% concatenate input and output
vr2oriX_decimated = cat(2,VRnldat_decimated, OriXnldat_decimated); 
vr2oriY_decimated = cat(2,VRnldat_decimated, OriYnldat_decimated); 
vr2oriZ_decimated = cat(2,VRnldat_decimated, OriZnldat_decimated); 

%%
nlags = (SR/dr);
nsides = 2;

irf_vr2oriX = irf(vr2oriX_decimated,'nSides',nsides,'nLags',nlags);
set(irf_vr2oriX,'irfPseudoInvMode','manual');
irf_vr2oriX = nlident(irf_vr2oriX, vr2oriX_decimated,'nSides', nsides,'nLags', nlags); close;
set(irf_vr2oriX, 'nSides', 1, 'nLags', nlags, 'domainStart', 0);
I = irf_vr2oriX.dataSet; I = I(floor(length(irf_vr2oriX)/2) + 1 : end); irf_vr2oriX.dataSet = I;

irf_vr2oriY = irf(vr2oriY_decimated,'nSides',nsides,'nLags',nlags);
set(irf_vr2oriY,'irfPseudoInvMode','manual');
irf_vr2oriY = nlident(irf_vr2oriY, vr2oriY_decimated,'nSides', nsides,'nLags', nlags); close;
set(irf_vr2oriY, 'nSides', 1, 'nLags', nlags, 'domainStart', 0);
I = irf_vr2oriY.dataSet; I = I(floor(length(irf_vr2oriY)/2) + 1 : end); irf_vr2oriY.dataSet = I;

irf_vr2oriZ = irf(vr2oriZ_decimated,'nSides',nsides,'nLags',nlags);
set(irf_vr2oriZ,'irfPseudoInvMode','manual');
irf_vr2oriZ = nlident(irf_vr2oriZ, vr2oriZ_decimated,'nSides', nsides,'nLags', nlags); close;
set(irf_vr2oriZ, 'nSides', 1, 'nLags', nlags, 'domainStart', 0);
I = irf_vr2oriZ.dataSet; I = I(floor(length(irf_vr2oriZ)/2) + 1 : end); irf_vr2oriZ.dataSet = I;

figure(3)
subplot(311)
plot(irf_vr2oriX);
title('IRF: VR -> OriX');hold on
subplot(312)
plot(irf_vr2oriY);
title('IRF: VR -> OriY');hold on
subplot(313)
plot(irf_vr2oriZ);
title('IRF: VR -> OriZ');hold on

set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

%% VAF is "Variance Accounted For" between observed output and predicted(simulated) output

% VAF<100% : 
%          A) There is noise
%          B) System is Nonlinear
%          C) There is not enough Lags in IRF

vr2oriX_sim = nlsim(irf_vr2oriX, VRnldat_decimated);
vaf_OriX = vaf(OriXnldat_decimated, vr2oriX_sim);

vr2oriY_sim = nlsim(irf_vr2oriY, VRnldat_decimated);
vaf_OriY = vaf(OriYnldat_decimated, vr2oriY_sim);

vr2oriZ_sim = nlsim(irf_vr2oriZ, VRnldat_decimated);
vaf_OriZ = vaf(OriZnldat_decimated, vr2oriZ_sim);

figure(4)
subplot(311)
plot(OriXnldat_decimated); hold on
plot(vr2oriX_sim);
title(['Ori X, VAF = %' num2str(double(vaf_OriX),2)]);
legend('Measured','Simulated')

subplot(312)
plot(OriYnldat_decimated); hold on
plot(vr2oriY_sim);
title(['Ori Y, VAF = %' num2str(double(vaf_OriY),2)]);
legend('Measured','Simulated')

subplot(313)
plot(OriZnldat_decimated); hold on
plot(vr2oriZ_sim);
title(['Ori Z, VAF = %' num2str(double(vaf_OriZ),2)]);
legend('Measured','Simulated')

set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

%% Power Spectrum Decimated
nFFT = 10 * SR;
%nFFT = periodTime

figure(5)
inputVRpower_decimated = spect(VRnldat_decimated,'nFFT', nFFT/dr);
pl3(1) = subplot(221);
semilogx(0:SR/nFFT:SR/(2*dr),inputVRpower_decimated.dataSet);hold on
xlim([0 SR/(2*dr)])
title('Input VR power Decimated')
xlabel('Frequency (Hz)')
ylabel('Power')

pl3(2) = subplot(222);
OriXPower_decimated = spect(OriXnldat_decimated,'nFFT', nFFT/dr);
semilogx(0:SR/nFFT:SR/(2*dr),OriXPower_decimated.dataSet); hold on
xlim([0 SR/(2*dr)])
legend('right', 'left', 'Sum');
title('OriX powers Decimated')
xlabel('Frequency (Hz)')
ylabel('Power')

pl3(3) = subplot(223);
OriYPower_decimated = spect(OriYnldat_decimated,'nFFT', nFFT/dr);
semilogx(0:SR/nFFT:SR/(2*dr),OriYPower_decimated.dataSet); hold on
xlim([0 SR/(2*dr)])
legend('right', 'left', 'Sum');
title('OriY powers Decimated')
xlabel('Frequency (Hz)')
ylabel('Power')

pl3(4) = subplot(224);
OriZPower_decimated = spect(OriZnldat_decimated,'nFFT', nFFT/dr);
semilogx(0:SR/nFFT:SR/(2*dr),OriZPower_decimated.dataSet); hold on
xlim([0 SR/(2*dr)])
legend('right', 'left', 'Sum');
title('OriZ powers Decimated')
xlabel('Frequency (Hz)')
ylabel('Power')

set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
%% Frequency Response 

nOverlap = nFFT/(2*dr);

figure(6)
plot(fresp(vr2oriX_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> OriX ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
allAxesInFigure = findall(gcf,'type','axes');
set(allAxesInFigure(1), 'XScale', 'log')
set(allAxesInFigure(2), 'XScale', 'log')
set(allAxesInFigure(3), 'XScale', 'log')

figure(7)
plot(fresp(vr2oriY_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> OriX ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
allAxesInFigure = findall(gcf,'type','axes');
set(allAxesInFigure(1), 'XScale', 'log')
set(allAxesInFigure(2), 'XScale', 'log')
set(allAxesInFigure(3), 'XScale', 'log')

figure(8)
plot(fresp(vr2oriZ_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> OriX ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
allAxesInFigure = findall(gcf,'type','axes');
set(allAxesInFigure(1), 'XScale', 'log')
set(allAxesInFigure(2), 'XScale', 'log')
set(allAxesInFigure(3), 'XScale', 'log')

set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])








