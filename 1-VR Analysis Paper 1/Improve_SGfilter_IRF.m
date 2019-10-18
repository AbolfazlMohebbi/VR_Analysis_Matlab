close all
dr = 100;
SR = 1000;

SubjectIndex = 1;
Amp = [5];
Vel = [2];

for filtorder = [2 3 6 9]
     for framelen = [1 2 5 10 15] * (SR/dr) + 1
%     for framelen = [2] * (SR/dr) + 1
        VR = Trials_All_NLD.VRnldat{1, SubjectIndex}{Vel, Amp};
        Hip = Trials_All_NLD.BodyA{1, SubjectIndex}{Vel, Amp};
        VR_dec = decimate(VR, dr);
        Hip_dec = decimate(Hip, dr);
        Hip_det = Hip_dec;
        
        % Detrend output
        poly_order = 6;
        set(Hip_det, 'dataSet', DetrendPoly(Hip_dec.dataSet', poly_order));
        
        %filter data
        yy = sgolayfilt(Hip_det.dataSet', filtorder, framelen);
        set(Hip_dec, 'dataSet', yy);
        
        VR_dec = VR_dec - mean(VR_dec);
        Hip_dec = Hip_dec - mean(Hip_dec);
        
        figure()
        yyaxis left
        plot(VR_dec.dataSet, 'g--')
        
        yyaxis right
        plot(Hip_det.dataSet, 'b'); hold on;
        plot(Hip_dec.dataSet);
        
        legend('VR', 'Hip Deterend no filt', strcat('Hip Detrend with SGfilt order = ', num2str(filtorder), ' and framelen =', num2str(framelen)))
        title(strcat('Original and Deterened Data for Amp = ', num2str(Amp), ' and Vel = ', num2str(Vel) ));
        set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);hold off        
    end
end


%% IRF

figNo = length(findobj('type','figure'))+1;
leg_irf={};
leg_sim={};
nsides = 2;
nlags = 5 * (SR/dr);

for filtorder = [2 3 6 9]
     for framelen = [1 2 5 10 15] * (SR/dr) + 1
%     for framelen = [2] * (SR/dr) + 1
        VR = Trials_All_NLD.VRnldat{1, SubjectIndex}{Vel, Amp};
        Hip = Trials_All_NLD.BodyA{1, SubjectIndex}{Vel, Amp};
        VR_dec = decimate(VR, dr);
        Hip_dec = decimate(Hip, dr);
        Hip_det = Hip_dec;
        
        % Detrend output
        poly_order = 6;
        set(Hip_det, 'dataSet', (DetrendPoly(Hip_dec.dataSet', poly_order))');
        
        %filter data
        yy = sgolayfilt(Hip_det.dataSet, filtorder, framelen);
        set(Hip_dec, 'dataSet', yy);
        
        VR_dec = VR_dec - mean(VR_dec);
        Hip_dec = Hip_dec - mean(Hip_dec);
        Hip_det = Hip_det - mean(Hip_det);
        
        vr2body_dec =  cat(2, VR_dec, Hip_dec);
        irf_vr2body = irf(vr2body_dec,'nSides',nsides,'nLags',nlags);
        
        vr2body_det =  cat(2, VR_dec, Hip_det);
        irf_vr2body_det = irf(vr2body_det,'nSides',nsides,'nLags',nlags);
        
        figure(figNo)
        plot(irf_vr2body); hold on;                   
        leg_irf{end+1}= strcat('IRF - SGfilt order = ', num2str(filtorder), ' and framelen =', num2str(framelen));

        sim_vr2body = nlsim(irf_vr2body, VR_dec);
        vaf_vr2body = vaf(Hip_dec, sim_vr2body);
        
        sim_vr2body_det = nlsim(irf_vr2body_det, VR_dec);
        vaf_vr2body_det = vaf(Hip_det, sim_vr2body_det);
        
        figure(figNo+1)
        plot(sim_vr2body); hold on
        leg_sim{end+1} = strcat('IRF Simulations - SGfilt order = ', num2str(filtorder), ' and framelen =', num2str(framelen), ' VAF = ', num2str(vaf_vr2body));
        
    end
end


figure(figNo)
plot(irf_vr2body_det);
leg_irf{end+1} = 'IRF - No filtering';
legend(leg_irf)
title(strcat('Original and Deterened Data for Amp = ', num2str(Amp), ' and Vel = ', num2str(Vel) ));
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]);hold off

figure(figNo+1)
plot(Hip_det,'linecolor','b', 'LineWidth', 4); hold on
leg_sim{end+1} = 'Original Hip Signal';
plot(sim_vr2body_det);
leg_sim{end+1} = strcat('IRF Simulations - No Filter with VAF = ', num2str(vaf_vr2body_det));
legend(leg_sim);
title(strcat('IRF Simulations for Amp = ', num2str(Amp), ' and Vel = ', num2str(Vel) ));
set(gcf,'Units','Normalized','OuterPosition', [0 0 1 1]); hold off


















