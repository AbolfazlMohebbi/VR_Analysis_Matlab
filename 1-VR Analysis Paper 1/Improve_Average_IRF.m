
dr = 100;
SR = 1000;
nsides = 2;
nlags = 15 * (SR/dr);
SubjectIndex = 2;
close all

% for Amp = [1 2 5 10]
%     for Vel = [2 5 10]
for Amp = 5
    for Vel = 5
        
        trials = Trials_Data_All.trialsAll{1,SubjectIndex}{Vel, Amp};
        IRF_Body_Trials = [];
        IRF_Tq_Trials = [];
        
        for T = 1:length(trials)
            
            VR = Trials_All_NLD.VRnldat{1, SubjectIndex}{Vel, Amp}{1,T};
            Hip = Trials_All_NLD.BodyA{1, SubjectIndex}{Vel, Amp}{1,T};
            TqSum = Trials_All_NLD.TorqueSum{1, SubjectIndex}{Vel, Amp}{1,T};
            VR_dec = decimate(VR, dr);
            Hip_dec = decimate(Hip, dr);
            TqSum_dec = decimate(TqSum, dr);
            
            set(Hip_dec, 'dataSet', DetrendPoly(Hip_dec.dataSet')');
            set(TqSum_dec, 'dataSet', DetrendPoly(TqSum_dec.dataSet')');
            
            VR_dec = VR_dec - mean(VR_dec);
            Hip_dec = Hip_dec - mean(Hip_dec);
            TqSum_dec = TqSum_dec - mean(TqSum_dec);
            
%             figure()
%             yyaxis left
%             plot(VR_dec.dataSet)
%             yyaxis right
%             plot(Hip_dec.dataSet); hold on;close all
%             legend('VR', 'Hip No Detrend', 'Hip Deterend')
%             title(strcat('Original and Deterened Hip Data for Amp = ', num2str(Amp), ' and Vel = ', num2str(Vel), ' in Trial-', num2str(T) ));
%             set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]); hold off;
%             
%             figure()
%             yyaxis left
%             plot(VR_dec.dataSet)
%             yyaxis right
%             plot(TqSum_dec.dataSet); hold on;
%             legend('VR', 'Torque No Detrend', 'Torque Deterend')
%             title(strcat('Original and Deterened Torque Data for Amp = ', num2str(Amp), ' and Vel = ', num2str(Vel), ' in Trial-', num2str(T) ));
%             set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]); hold off;
            
            vr2body_dec =  cat(2, VR_dec, Hip_dec);
            irf_vr2body = irf(vr2body_dec,'nSides',nsides,'nLags',nlags);
            
            vr2tq_dec = cat(2, VR_dec, TqSum_dec);
            irf_vr2tq = irf(vr2tq_dec,'nSides',nsides,'nLags',nlags);            
                       
            IRF_Body_Trials = [IRF_Body_Trials; irf_vr2body.dataSet'];
            IRF_Tq_Trials = [IRF_Tq_Trials; irf_vr2tq.dataSet'];         
        end
        
        mean_IRF_Body = irf_vr2body;
        mean_IRF_Tq = irf_vr2tq;
        
        set(mean_IRF_Body, 'dataSet', mean(IRF_Body_Trials)');
        set(mean_IRF_Tq, 'dataSet', mean(IRF_Tq_Trials)');
        
        figure()            
        plot(IRF_Body_Trials(:,floor(length(IRF_Body_Trials)/2): floor(length(IRF_Body_Trials)/2)+50)'); hold on;
        I = mean_IRF_Body.dataSet;
        plot(I( floor(length(I)/2): floor(length(I)/2)+50), '-.', 'LineWidth', 6);
        legend('IRF Tr1', 'IRF Tr1', 'IRF Tr3', 'Mean IRF');
        title(strcat('Mean IRF VR2Body for Amp = ', num2str(Amp), ' and Vel = ', num2str(Vel)));
        set(gcf,'Units','Normalized','OuterPosition', [0 0 1 1]); hold off
        
%         figure()            
%         plot(IRF_Tq_Trials(:,floor(length(IRF_Tq_Trials)/2): floor(length(IRF_Tq_Trials)/2)+50)'); hold on;
%         I = mean_IRF_Tq.dataSet;
%         plot(I( floor(length(I)/2): floor(length(I)/2)+50), '-.', 'LineWidth', 6);
%         legend('IRF Tr1', 'IRF Tr1', 'IRF Tr3', 'Mean IRF');
%         title(strcat('Mean IRF VR2Tq for Amp = ', num2str(Amp), ' and Vel = ', num2str(Vel)));
%         set(gcf,'Units','Normalized','OuterPosition', [0 0 1 1]); hold off
               
        for T = 1:length(trials)
            
            VR = Trials_All_NLD.VRnldat{1, SubjectIndex}{Vel, Amp}{1,T};
            Hip = Trials_All_NLD.BodyA{1, SubjectIndex}{Vel, Amp}{1,T};
            TqSum = Trials_All_NLD.TorqueSum{1, SubjectIndex}{Vel, Amp}{1,T};
            VR_dec = decimate(VR, dr);
            Hip_dec = decimate(Hip, dr);
            TqSum_dec = decimate(TqSum, dr);
            
            set(Hip_dec, 'dataSet', (DetrendPoly(double(Hip_dec)')'));
            set(TqSum_dec, 'dataSet', (DetrendPoly(double(TqSum_dec)')'));
            
            VR_dec = VR_dec - mean(VR_dec);
            Hip_dec = Hip_dec-mean(Hip_dec);
            TqSum_dec = TqSum_dec-mean(TqSum_dec);
            
            sim_Body = nlsim(mean_IRF_Body, VR_dec);
            sim_Tq = nlsim(mean_IRF_Tq, VR_dec);
            
            vaf_Body = vaf(Hip_dec, sim_Body);
            vaf_Tq = vaf(TqSum_dec, sim_Tq);
            
            figure()
            plot(Hip_dec);hold on
            plot(sim_Body);hold on
            legend(strcat('Original Body-Angle Signal Trial-', num2str(T)), strcat('Body IRF Simulation with VAF=%', num2str(vaf_Body.dataSet)));
            title(strcat('Simulations using Mean Body-IRF for Amp = ', num2str(Amp), ' and Vel = ', num2str(Vel), ' in Trial-', num2str(T) ));
            set(gcf,'Units','Normalized','OuterPosition', [0 0 1 1]); hold off
            
%             figure()
%             plot(TqSum_dec);hold on
%             plot(sim_Tq);hold on
%             legend('Original Torque Signal', strcat('Torque IRF Simulation with VAF=%', num2str(vaf_Tq.dataSet)));
%             title(strcat('Simulations using Mean Torque-IRF for Amp = ', num2str(Amp), ' and Vel = ', num2str(Vel), ' in Trial-', num2str(T) ));
%             set(gcf,'Units','Normalized','OuterPosition', [0 0 1 1]); hold off
            
        end
    end
end

