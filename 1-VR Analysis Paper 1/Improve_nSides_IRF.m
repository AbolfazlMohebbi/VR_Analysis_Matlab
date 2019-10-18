clc;
close all

dr = 100;
SR = 1000;

SubjectIndex = 1;

Amp = [1];
Vel = [2];

nlags = 15 * (SR/dr);

%%

VR = Trials_All_NLD.VRnldat{1, SubjectIndex}{Vel, Amp};
Hip = Trials_All_NLD.BodyA{1, SubjectIndex}{Vel, Amp};
VR_dec = decimate(VR, dr);
Hip_dec = decimate(Hip, dr);
Hip_det = Hip_dec;

% Detrending Options

% Detrend output
poly_order = 6;
bp = floor(length(double(Hip_dec))/2);

set(Hip_det, 'dataSet', detrend(double(Hip_dec), 'Linear', bp));

% t = (1:length(double(Hip_dec)))';
% [p,s,mu] = polyfit(t, double(Hip_dec), poly_order);
% f_y = polyval(p,t,[],mu);
% set(Hip_det, 'dataSet', double(Hip_dec) - f_y);

% Detrend VR?
% set(VR_dec, 'dataSet', detrend(double(VR_dec), 'Linear', bp));

VR_dec = VR_dec - mean(VR_dec);
Hip_dec = Hip_dec-mean(Hip_dec);
Hip_det = Hip_det-mean(Hip_det);

figure()
yyaxis left
plot(double(VR_dec))

yyaxis right
plot(Hip_dec.dataSet); hold on;
plot(Hip_det.dataSet, 'b-.'); hold on;
legend('VR', 'Hip No Detrend', 'Hip Deterend ')
title(strcat('Original and Deterened Data for Amp = ', num2str(Amp), ' and Vel = ', num2str(vel), ' For dr=', num2str(dr) ));
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);hold off

%% IRF

vr2body_dec =  cat(2, VR_dec, Hip_dec);
vr2body_det = cat(2, VR_dec, Hip_det);

irf_dec_1s = irf(vr2body_dec,'nSides', 1,'nLags',nlags);
irf_det_1s = irf(vr2body_det,'nSides', 1,'nLags',nlags);

irf_dec_2s = irf(vr2body_dec,'nSides', 2,'nLags',nlags);
irf_det_2s = irf(vr2body_det,'nSides', 2,'nLags',nlags);

irf_dec_2hs = irf(vr2body_dec,'nSides', 2,'nLags',nlags);
I = irf_dec_2hs.dataSet; I = I(floor(length(irf_dec_2hs)/2) + 1 : end); irf_dec_2hs.dataSet = I;
irf_det_2hs = irf(vr2body_det,'nSides', 2,'nLags',nlags);
I = irf_det_2hs.dataSet; I = I(floor(length(irf_det_2hs)/2) + 1 : end); irf_det_2hs.dataSet = I;

figure()
plot(irf_dec_1s); hold on;
plot(irf_det_1s); hold on;
plot(irf_dec_2s); hold on;
plot(irf_det_2s); hold on;
plot(irf_dec_2hs); hold on;
plot(irf_det_2hs); hold on;
legend('IRF No Detrend 1-Sided', 'IRF Detrend 1-Sided', 'IRF No Detrend 2-Sided', 'IRF Detrend 2-Sided', 'IRF No Detrend 1.5-Sided', 'IRF Detrend 1.5-Sided')
set(gcf,'Units','Normalized','OuterPosition', [0 0 1 1]);
title(strcat('IRF for Amp = ', num2str(Amp), ' and Vel = ', num2str(vel), ' For dr=', num2str(dr) ));
hold off

%%
sim_dec_1s = nlsim(irf_dec_1s, VR_dec);
sim_det_1s = nlsim(irf_det_1s, VR_dec);
sim_dec_2s = nlsim(irf_dec_2s, VR_dec);
sim_det_2s = nlsim(irf_det_2s, VR_dec);
sim_dec_2hs = nlsim(irf_dec_2hs, VR_dec);
sim_det_2hs = nlsim(irf_det_2hs, VR_dec);

vaf_dec_1s = vaf(Hip_dec, sim_dec_1s);
vaf_det_1s = vaf(Hip_det, sim_det_1s);
vaf_dec_2s = vaf(Hip_dec, sim_dec_2s);
vaf_det_2s = vaf(Hip_det, sim_det_2s);
vaf_dec_2hs = vaf(Hip_dec, sim_dec_2hs);
vaf_det_2hs = vaf(Hip_det, sim_det_2hs);

figure()
plot(Hip_dec);hold on
plot(sim_dec_1s); hold on
plot(sim_det_1s); hold on
plot(sim_dec_2s); hold on
plot(sim_det_2s); hold on
plot(sim_dec_2hs); hold on
plot(sim_det_2hs); hold on

leg{1} = 'Original Signal';
leg{2} = strcat('Simulation No Detrend 1-sided with VAF=%', num2str(vaf_dec_1s.dataSet));
leg{3} = strcat('Simulation Detrend 1-sided with VAF=%', num2str(vaf_det_1s.dataSet));
leg{4} = strcat('Simulation No Detrend 2-sided with VAF=%', num2str(vaf_dec_2s.dataSet));
leg{5} = strcat('Simulation Detrend 2-sided with VAF=%', num2str(vaf_det_2s.dataSet));
leg{6} = strcat('Simulation No Detrend 1.5-sided with VAF=%', num2str(vaf_dec_2hs.dataSet));
leg{7} = strcat('Simulation Detrend 1.5-sided with VAF=%', num2str(vaf_det_2hs.dataSet));

legend(leg);
title(strcat('IRF Simulations for Amp = ', num2str(Amp), ' and Vel = ', num2str(vel), ' For dr=', num2str(dr) ));
set(gcf,'Units','Normalized','OuterPosition', [0 0 1 1]); hold off













