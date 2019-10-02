%% Frequency Response 
% nOverlap = nFFT/(2*dr);
nOverlap = 0.6 * nFFT/dr;

%% Body Angle

fr_body = fresp(vr2body_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap);

figure(length(findobj('type','figure'))+1)
plot(gain(fr_body), 'ymode', 'db', 'LineWidth', 2);
set(gca, 'XScale', 'log')
title('Frequency Response Gain: VR to Body Angle')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(length(findobj('type','figure'))+1)
plot(phase(fr_body)*(180/pi), 'ymode', 'linear', 'LineWidth', 2);
ylabel('Phase (degrees)')
set(gca, 'XScale', 'log')
title('Frequency Response Phase: VR to Body Angle')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(length(findobj('type','figure'))+1)
plot(coherence(fr_body), 'ymode', 'linear', 'LineWidth', 2);
ylabel('Coherence \gamma_{xy}')
set(gca, 'XScale', 'log')
title('Frequency Response Coherence: VR to Body Angle')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])


%% Sum Torque

fr_tqSum = fresp(vr2tqSum_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap);

figure(length(findobj('type','figure'))+1)
plot(gain(fr_tqSum), 'ymode', 'db', 'LineWidth', 2);
set(gca, 'XScale', 'log')
title('Frequency Response Gain: VR to Torque Sum')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(length(findobj('type','figure'))+1)
plot(phase(fr_tqSum)*(180/pi), 'ymode', 'linear', 'LineWidth', 2);
ylabel('Phase (degrees)')
set(gca, 'XScale', 'log')
title('Frequency Response Phase: VR to Torque Sum')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(length(findobj('type','figure'))+1)
plot(coherence(fr_tqSum), 'ymode', 'linear', 'LineWidth', 2);
ylabel('Coherence \gamma_{xy}')
set(gca, 'XScale', 'log')
title('Frequency Response Coherence: VR to Torque Sum')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])


%% Simulations and VAF

FR_vr2body_sim = nlsim(fr_body, VRnldat_decimated);
FR_vaf_body = vaf(BodyA_decimated, FR_vr2body_sim);

figure(length(findobj('type','figure'))+1)
plot(BodyA_decimated);hold on
plot(FR_vr2body_sim);
title(['FR Simulated Model vs. Measured Body Angle, VAF = %' num2str(double(FR_vaf_body),2)]);
legend('Measured','Simulated FR')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])


FR_vr2tqSum_sim = nlsim(fr_tqSum, VRnldat_decimated);
FR_vaf_tqSum = vaf(TorqueSum_decimated, FR_vr2tqSum_sim);
figure(length(findobj('type','figure'))+1)
plot(TorqueSum_decimated);hold on
plot(FR_vr2tqSum_sim);
title(['FR Simulated Model vs. Measured Torque Sum, VAF = %' num2str(double(FR_vaf_tqSum),2)]);
legend('Measured','Simulated FR')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])









