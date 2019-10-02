
nFFT = 25 * SR;
%nFFT = periodTime

%% Power Spectrum 
% figure(length(findobj('type','figure'))+1)
% inputVRpower = spect(Trials_NLD.VRnldat-mean(Trials_NLD.VRnldat),'nFFT',nFFT);
% pl3(1) = subplot(311);
% semilogx(0:SR/nFFT:SR/2,inputVRpower.dataSet);hold on
% xlim([0 SR/2])
% title('Input VR power')
% xlabel('Frequency (Hz)')
% ylabel('Power')
% 
% pl3(2) = subplot(312);
% rightTorquePower = spect(Trials_NLD.TorqueR,'nFFT',nFFT);
% leftTorquePower = spect(Trials_NLD.TorqueL,'nFFT',nFFT);
% sumTorquePower = spect(Trials_NLD.TorqueSum,'nFFT',nFFT);
% semilogx(0:SR/nFFT:SR/2,rightTorquePower.dataSet);hold on
% semilogx(0:SR/nFFT:SR/2,leftTorquePower.dataSet);hold on
% semilogx(0:SR/nFFT:SR/2,sumTorquePower.dataSet);hold on
% xlim([0 SR/2])
% legend('right', 'left', 'Sum');
% title('All Torque powers')
% xlabel('Frequency (Hz)')
% ylabel('Power')
% 
% pl3(5) = subplot(313);
% bodyPower = spect(Trials_NLD.BodyA,'nFFT',nFFT);
% semilogx(0:SR/nFFT:SR/2,bodyPower.dataSet);hold on
% xlim([0 SR/2])
% title('Body Angle Power')
% xlabel('Frequency (Hz)')
% ylabel('Power')
% 
% set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

%% Power Spectrum Decimated

figure(length(findobj('type','figure'))+1)
inputVRpower_decimated = spect(VRnldat_decimated,'nFFT', nFFT/dr);
pl3(1) = subplot(211);
semilogx(0:SR/nFFT:SR/(2*dr),inputVRpower_decimated.dataSet);hold on
xlim([0 SR/(2*dr)])
title('Input VR power Decimated')
xlabel('Frequency (Hz)')
ylabel('Power')

pl3(2) = subplot(212);
rightTorquePower_decimated = spect(TorqueR_decimated,'nFFT',nFFT/dr);
leftTorquePower_decimated = spect(TorqueL_decimated,'nFFT',nFFT/dr);
sumTorquePower_decimated = spect(TorqueSum_decimated,'nFFT',nFFT/dr);
semilogx(0:SR/nFFT:SR/(2*dr),rightTorquePower_decimated.dataSet);hold on
semilogx(0:SR/nFFT:SR/(2*dr),leftTorquePower_decimated.dataSet);hold on
semilogx(0:SR/nFFT:SR/(2*dr),sumTorquePower_decimated.dataSet);hold on
xlim([0 SR/(2*dr)])
legend('right', 'left', 'Sum');
title('All Torque powers Decimated')
xlabel('Frequency (Hz)')
ylabel('Power')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(length(findobj('type','figure'))+1)
inputVRpower_decimated = spect(VRnldat_decimated,'nFFT', nFFT/dr);
pl4(1) = subplot(211);
semilogx(0:SR/nFFT:SR/(2*dr),inputVRpower_decimated.dataSet);hold on
xlim([0 SR/(2*dr)])
title('Input VR power Decimated')
xlabel('Frequency (Hz)')
ylabel('Power')

pl4(2) = subplot(212);
bodyPower_decimated = spect(BodyA_decimated,'nFFT',nFFT/dr);
semilogx(0:SR/nFFT:SR/(2*dr),bodyPower_decimated.dataSet);hold on
xlim([0 SR/(2*dr)])
title('Body Angle Power Decimated')
xlabel('Frequency (Hz)')
ylabel('Power')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
