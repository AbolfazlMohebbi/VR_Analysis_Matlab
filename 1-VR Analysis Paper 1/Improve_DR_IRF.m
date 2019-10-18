clc;
close all

% dr = 100;
SR = 1000;

SubjectIndex = 2;

Amp = [2];
Vel = [5];

for dr = [20 50 100 200]
    VR = Trials_All_NLD.VRnldat{1, SubjectIndex}{Vel, Amp};
    Hip = Trials_All_NLD.BodyA{1, SubjectIndex}{Vel, Amp};
    VR_dec = decimate(VR, dr);
    Hip_dec = decimate(Hip, dr);
    Hip_det = Hip_dec;
   
    % Detrending Options
    
    % Detrend VR?
    VR_det = VR_dec;
    
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
    
    nsides = 2;
    nlags = 15 * (SR/dr);
    
    vr2body_dec =  cat(2, VR_dec, Hip_dec);
    vr2body_det = cat(2, VR_dec, Hip_det);
    
    irf_dec = irf(vr2body_dec,'nSides',nsides,'nLags',nlags);
    irf_det = irf(vr2body_det,'nSides',nsides,'nLags',nlags);
    
    figure()
    plot(irf_dec); hold on;
    plot(irf_det); hold on;
    legend('IRF No Detrend', 'IRF Detrend')
    set(gcf,'Units','Normalized','OuterPosition', [0 0 1 1]); hold off
    title(strcat('IRF for Amp = ', num2str(Amp), ' and Vel = ', num2str(vel), ' For dr=', num2str(dr) ));
    
    %%
    sim_dec = nlsim(irf_dec, VR_dec);
    sim_det = nlsim(irf_det, VR_dec);
    
    vaf_dec = vaf(Hip_dec, sim_dec);
    vaf_det = vaf(Hip_det, sim_det);
    
    figure()
    plot(Hip_dec);hold on
    plot(sim_dec);
    hold on
    plot(sim_det); hold on
    
    leg{1} = 'Original Signal';
    leg{2} = strcat('Simulation No Detrend with VAF=%', num2str(vaf_0.dataSet));
    leg{3} = strcat('Simulation Detrend with VAF=%', num2str(vaf_1.dataSet));
    legend(leg);
    title(strcat('IRF Simulations for Amp = ', num2str(Amp), ' and Vel = ', num2str(vel), ' For dr=', num2str(dr) ));
    set(gcf,'Units','Normalized','OuterPosition', [0 0 1 1]); hold off
    
end

















