close all
dr = 100;
SR = 1000;

SubjectIndex = 2;

for Amp = [2]
    for Vel = [5]

% for Amp = [1 2 5 10]
%     for Vel = [2 5 10]
        
        VR = Trials_All_NLD.VRnldat{1, SubjectIndex}{Vel, Amp};
        Hip = Trials_All_NLD.BodyA{1, SubjectIndex}{Vel, Amp};
        VR_dec = decimate(VR, dr);
        Hip_dec = decimate(Hip, dr);
        
        Hip_det1 = Hip_dec;
        Hip_det2 = Hip_dec;
        Hip_det3 = Hip_dec;
        
        %% Detrending Options        
                
        % Detrend output
        poly_order = 6;
        bp = floor(length(double(Hip_dec))/2);
        set(Hip_det1, 'dataSet', detrend(double(Hip_dec), 'Linear'));
        set(Hip_det2, 'dataSet', detrend(double(Hip_dec), 'Linear', bp));
        
        % Detrend VR?
        % set(VR_dec, 'dataSet', detrend(double(VR_dec), 'Linear', bp));
        
        t = (1:length(double(Hip_dec)))';
        [p,s,mu] = polyfit(t, double(Hip_dec), poly_order);
        f_y = polyval(p,t,[],mu);
        set(Hip_det3, 'dataSet', double(Hip_dec) - f_y);
        
        VR_dec = VR_dec - mean(VR_dec);
        Hip_dec = Hip_dec-mean(Hip_dec);
        Hip_det1 = Hip_det1-mean(Hip_det1);
        Hip_det2 = Hip_det2-mean(Hip_det2);
        Hip_det3 = Hip_det3-mean(Hip_det3);
        
        figure()
        yyaxis left
        plot(VR_dec.dataSet)
        
        yyaxis right
        plot(Hip_dec.dataSet); hold on;
        plot(Hip_det1.dataSet, 'b-.'); hold on;
        plot(Hip_det2.dataSet, 'c--'); hold on;
        plot(Hip_det3.dataSet, 'g-'); hold on;
        legend('VR', 'Hip No Detrend', 'Hip Deterend 1', 'Hip Deterend 2', 'Hip Deterend 3')
        title(strcat('Original and Deterened Data for Amp = ', num2str(Amp), ' and Vel = ', num2str(Vel) ));
        set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);hold off
        
        %% IRF
        
        nsides = 2;
        nlags = 15 * (SR/dr);
        
        vr2body_dec =  cat(2, VR_dec, Hip_dec);
        vr2body_det1 = cat(2, VR_dec, Hip_det1);
        vr2body_det2 = cat(2, VR_dec, Hip_det2);
        vr2body_det3 = cat(2, VR_dec, Hip_det3);
        
        irf_0 = irf(vr2body_dec,'nSides',nsides,'nLags',nlags);
        irf_1 = irf(vr2body_det1,'nSides',nsides,'nLags',nlags);
        irf_2 = irf(vr2body_det2,'nSides',nsides,'nLags',nlags);
        irf_3 = irf(vr2body_det3,'nSides',nsides,'nLags',nlags);
        
        figure()
        plot(irf_0); hold on;
        plot(irf_1); hold on;
        plot(irf_2); hold on;
        plot(irf_3); hold on;
        legend('IRF No Detrend', 'IRF 1', 'IRF 2', 'IRF 3')
        set(gcf,'Units','Normalized','OuterPosition', [0 0 1 1]); hold off
        title(strcat('IRF for Amp = ', num2str(Amp), ' and Vel = ', num2str(Vel) ));
        
        %%
        sim_0 = nlsim(irf_0, VR_dec);
        sim_1 = nlsim(irf_1, VR_dec);
        sim_2 = nlsim(irf_2, VR_dec);
        sim_3 = nlsim(irf_3, VR_dec);
        
        vaf_0 = vaf(Hip_dec, sim_0);
        vaf_1 = vaf(Hip_det1, sim_1);
        vaf_2 = vaf(Hip_det2, sim_2);
        vaf_3 = vaf(Hip_det3, sim_3);
        
        figure()
        plot(Hip_dec);hold on
        plot(sim_0);
        hold on
        plot(sim_1); hold on
        plot(sim_2); hold on
        plot(sim_3); hold on
        
        leg{1} = 'Original Signal';
        leg{2} = strcat('Simulation 0 with VAF=%', num2str(vaf_0.dataSet));
        leg{3} = strcat('Simulation 1 with VAF=%', num2str(vaf_1.dataSet));
        leg{4} = strcat('Simulation 2 with VAF=%', num2str(vaf_2.dataSet));
        leg{5} = strcat('Simulation 3 with VAF=%', num2str(vaf_3.dataSet));
        legend(leg);
        title(strcat('IRF Simulations for Amp = ', num2str(Amp), ' and Vel = ', num2str(Vel) ));
        set(gcf,'Units','Normalized','OuterPosition', [0 0 1 1]); hold off
        
    end
end


















