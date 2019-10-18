clc;
close all

dr = 100;
SR = 1000;

SubjectIndex = 1;

Amp = [2];
Vel = [5];

nsides = 2;

VR = Trials_All_NLD.VRnldat{1, SubjectIndex}{Vel, Amp};
Hip = Trials_All_NLD.BodyA{1, SubjectIndex}{Vel, Amp};
VR_dec = decimate(VR, dr);
Hip_dec = decimate(Hip, dr);
Hip_det = Hip_dec;

% Detrending Options

% Detrend output
poly_order = 6;
bp = floor(length(double(Hip_dec))/2);
t = (1:length(double(Hip_dec)))';
[p,s,mu] = polyfit(t, double(Hip_dec), poly_order);
f_y = polyval(p,t,[],mu);
set(Hip_det, 'dataSet', double(Hip_dec) - f_y);

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
i = 1;
leg_sim{1} = 'Original Signal';

for nlags = [5 10 15 20]    
    irf_det = irf(vr2body_det,'nSides',nsides,'nLags',nlags*(SR/dr));
    leg{i} = strcat('IRF with Detrend for nLags = ', num2str(nlags));
    figure(2)
    plot(irf_det); hold on;    
    
    sim_det = nlsim(irf_det, VR_dec);    
    vaf_det = vaf(Hip_det, sim_det);
    
    figure(3)    
    plot(sim_det); hold on
    leg_sim{i+1} = strcat('Simulation with Detrend for nLags =', num2str(nlags), ' with VAF=%', num2str(vaf_det.dataSet));    
    i=i+1;
end

figure(2)
legend(leg)
set(gcf,'Units','Normalized','OuterPosition', [0 0 1 1]); 
title(strcat('IRF for Amp = ', num2str(Amp), ' and Vel = ', num2str(Vel)));hold off

figure(3)
plot(Hip_det); hold on
legend(leg_sim);
set(gcf,'Units','Normalized','OuterPosition', [0 0 1 1]);
title(strcat('IRF Simulations for Amp = ', num2str(Amp), ' and Vel = ', num2str(Vel)));  hold off

%%

















