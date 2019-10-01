%% Decimate: Resample data at a lower rate after lowpass filtering.

VRnldat_decimated = decimate(Trials_NLD.VRnldat,dr);  % position input
% VRnldat_decimated = decimate(ddt(Trials_NLD.VRnldat),dr);  % Velocity input

TorqueR_decimated = decimate(Trials_NLD.TorqueR,dr);
TorqueL_decimated = decimate(Trials_NLD.TorqueL,dr);
ShankR_decimated = decimate(Trials_NLD.shankR,dr);
ShankL_decimated = decimate(Trials_NLD.shankL,dr);
TorqueSum_decimated = decimate(Trials_NLD.TorqueSum,dr);
HipA_decimated = decimate(Trials_NLD.HipA,dr);
% HipA_decimated = decimate(ddt(Trials_NLD.HipA),dr);  % Hip Velocity Output

% remove mean
VRnldat_decimated = VRnldat_decimated - mean(VRnldat_decimated);
TorqueR_decimated = TorqueR_decimated - mean(TorqueR_decimated);
TorqueL_decimated = TorqueL_decimated - mean(TorqueL_decimated);
ShankR_decimated = ShankR_decimated - mean(ShankR_decimated);
ShankL_decimated = ShankL_decimated - mean(ShankL_decimated);
TorqueSum_decimated = TorqueSum_decimated - mean(TorqueSum_decimated);
HipA_decimated = HipA_decimated - mean(HipA_decimated);

% concatenate input and output
vr2tqL_decimated = cat(2,VRnldat_decimated, TorqueL_decimated); % ==>  [VRnldat, TorqueL]
%   CAT(2,A,B) is the same as [A,B].
%   CAT(1,A,B) is the same as [A;B].
vr2tqR_decimated = cat(2,VRnldat_decimated, TorqueR_decimated);
vr2shankL_decimated = cat(2,VRnldat_decimated, ShankL_decimated);
vr2shankR_decimated = cat(2,VRnldat_decimated, ShankR_decimated);
vr2hip_decimated = cat(2,VRnldat_decimated, HipA_decimated);
vr2tqSum_decimated = cat(2,VRnldat_decimated, TorqueSum_decimated);

nlags = 15 * (SR/dr);

%% Plot Auto-correlation of the input
figure(length(findobj('type','figure'))+1);
% if length of Input is N then nlags <= N/4
subplot(2,1,1); plot(cor(VRnldat_decimated,'nSides',1,'nLags', nlags));
subplot(2,1,2); plot(cor(VRnldat_decimated,'nSides',2,'nLags', nlags));
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

%% Impulse Response Functions 
% To predict (simulate) the response of a linear system
% if length of Input is N then nlags <= N/4
 
nsides = 2;

irf_vr2tqL = irf(vr2tqL_decimated,'nSides',nsides,'nLags',nlags);
irf_vr2tqR = irf(vr2tqR_decimated,'nSides',nsides,'nLags',nlags);
irf_vr2shankL = irf(vr2shankL_decimated,'nSides',nsides,'nLags',nlags);
irf_vr2shankR = irf(vr2shankR_decimated,'nSides',nsides,'nLags',nlags);

global irf_gui;

if (irf_gui==1)
    irf_vr2hip = irf(vr2hip_decimated,'nSides',nsides,'nLags',nlags);
    set(irf_vr2hip,'irfPseudoInvMode','manual', 'irfFigNum', length(findobj('type','figure'))+1 );
    irf_vr2hip = nlident(irf_vr2hip, vr2hip_decimated,'nSides', nsides,'nLags', nlags); close;
    set(irf_vr2hip, 'nSides', 1, 'nLags', nlags, 'domainStart', 0);
    I = irf_vr2hip.dataSet; I = I(floor(length(irf_vr2hip)/2) + 1 : end); irf_vr2hip.dataSet = I;
    
    irf_vr2tqSum = irf(vr2tqSum_decimated,'nSides',nsides,'nLags',nlags);
    set(irf_vr2tqSum,'irfPseudoInvMode','manual', 'irfFigNum', length(findobj('type','figure'))+1 );
    irf_vr2tqSum = nlident(irf_vr2tqSum, vr2tqSum_decimated,'nSides', nsides,'nLags', nlags); close;
    set(irf_vr2tqSum, 'nSides', 1, 'nLags', nlags, 'domainStart', 0);
    I = irf_vr2tqSum.dataSet; I = I(floor(length(irf_vr2tqSum)/2) + 1 : end); irf_vr2tqSum.dataSet = I;    
else
    irf_vr2hip = irf(vr2hip_decimated,'nSides',nsides,'nLags',nlags);
    irf_vr2tqSum = irf(vr2tqSum_decimated,'nSides',nsides,'nLags',nlags);    
end  

figure(length(findobj('type','figure'))+1)
subplot(221)
plot(irf_vr2tqL);
title('IRF: VR -> Torque Left');hold on

subplot(222)
plot(irf_vr2tqR);
title('IRF: VR -> Torque Right');hold on

subplot(223)
plot(irf_vr2shankL);
title('IRF: VR -> Left Shank Angle');hold on

subplot(224)
plot(irf_vr2shankR);
title('IRF: VR -> Right Shank Angle');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(length(findobj('type','figure'))+1)
subplot(211)
plot(irf_vr2hip);
title('IRF: VR -> Hip Angle');hold on

subplot(212)
plot(irf_vr2tqSum);
title('IRF: VR -> Torque Sum');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

%% VAF is "Variance Accounted For" between observed output and predicted(simulated) output

% VAF<100% : 
%          A) There is noise
%          B) System is Nonlinear
%          C) There is not enough Lags in IRF

vr2tqL_sim = nlsim(irf_vr2tqL,VRnldat_decimated);
vaf_tqL = vaf(TorqueL_decimated, vr2tqL_sim);

vr2tqR_sim = nlsim(irf_vr2tqR,VRnldat_decimated);
vaf_tqR = vaf(TorqueR_decimated, vr2tqR_sim);

vr2shankL_sim = nlsim(irf_vr2shankL,VRnldat_decimated);
vaf_shankL = vaf(ShankL_decimated, vr2shankL_sim);

vr2shankR_sim = nlsim(irf_vr2shankR,VRnldat_decimated);
vaf_shankR = vaf(ShankR_decimated, vr2shankR_sim);

vr2hip_sim = nlsim(irf_vr2hip,VRnldat_decimated);
vaf_hip = vaf(HipA_decimated, vr2hip_sim);

vr2tqSum_sim = nlsim(irf_vr2tqSum,VRnldat_decimated);
vaf_tqSum = vaf(TorqueSum_decimated, vr2tqSum_sim);

figure(length(findobj('type','figure'))+1)
subplot(221)
plot(TorqueL_decimated); hold on
plot(vr2tqL_sim);
title(['Left torque, VAF = %' num2str(double(vaf_tqL),2)]);
legend('Measured','Simulated')

subplot(222)
plot(TorqueR_decimated); hold on
plot(vr2tqR_sim);
title(['Right torque, VAF = %' num2str(double(vaf_tqR),2)]);
legend('Measured','Simulated')

subplot(223)
plot(ShankL_decimated); hold on
plot(vr2shankL_sim);
title(['Left shank angle, VAF = %' num2str(double(vaf_shankL),2)]);
legend('Measured','Simulated')

subplot(224)
plot(ShankR_decimated);hold on
plot(vr2shankR_sim);
title(['Right shank angle, VAF = %' num2str(double(vaf_shankR),2)]);
legend('Measured','Simulated')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(length(findobj('type','figure'))+1)
subplot(211)
plot(TorqueSum_decimated);hold on
plot(vr2tqSum_sim);
title(['Sum torque, VAF = %' num2str(double(vaf_tqSum),2)]);
legend('Measured','Simulated')

subplot(212)
plot(HipA_decimated);hold on
plot(vr2hip_sim);
title(['Hip Angle, VAF = %' num2str(double(vaf_hip),2)]);
legend('Measured','Simulated')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])



