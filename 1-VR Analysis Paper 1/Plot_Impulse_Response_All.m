
nSides = 2;
nlags = 15 * (SR/dr);
plotIRF_lags = 5 * floor(SR/dr);

irf_gui = 0;

VAF_TQ = {};
VAF_Body = {};
VAF_TQ_mean = {};
VAF_Body_mean = {};
VAF_TQ_allSubj = [];
VAF_Body_allSubj = [];

for i = Trials_Data_All.VelCase
    for j = Trials_Data_All.AmpCase
        for S = 1:Trials_Data_All.SubjNo
            trials = Trials_Data_All.trialsAll{1,S}{i,j};
            for T = 1:length(trials)
                
                VRnldat_decimated = decimate(Trials_All_NLD.VRnldat{1,S}{i,j}{1,T}, dr);  % position input
                % VRnldat_decimated = decimate(ddt(Trials_All_NLD.VRnldat{1,S}{i,j}{1,T}),dr);  % Velocity input
                TorqueSum_decimated = decimate(Trials_All_NLD.TorqueSum{1,S}{i,j}{1,T}, dr);
                BodyA_decimated = decimate(Trials_All_NLD.BodyA{1,S}{i,j}{1,T}, dr);
                % BodyA_decimated = decimate(ddt(Trials_All_NLD.BodyA{1,S}{i,j}{1,T}),dr);  % Body Velocity Output
                
                % remove mean
                VRnldat_decimated = VRnldat_decimated - mean(VRnldat_decimated);
                TorqueSum_decimated = TorqueSum_decimated - mean(TorqueSum_decimated);
                BodyA_decimated = BodyA_decimated - mean(BodyA_decimated);
                
                vr2body_decimated = cat(2,VRnldat_decimated, BodyA_decimated);
                vr2tqSum_decimated = cat(2,VRnldat_decimated, TorqueSum_decimated);
                
                if (irf_gui==1)
                    irf_vr2body = irf(vr2body_decimated,'nSides',nSides,'nLags',nlags);
                    set(irf_vr2body,'irfPseudoInvMode','manual', 'irfFigNum', length(findobj('type','figure'))+1 );
                    irf_vr2body = nlident(irf_vr2body, vr2body_decimated,'nSides', nSides,'nLags', nlags); close;
                    irf_vr2body_plot = irf_vr2body;
                    set(irf_vr2body_plot, 'nSides', 1, 'nLags', nlags, 'domainStart', 0);
                    I = irf_vr2body_plot.dataSet; I = I(floor(length(irf_vr2body_plot)/2) + 1 : floor(length(irf_vr2body_plot)/2) + 1 + plotIRF_lags); irf_vr2body_plot.dataSet = I;
                    
                    irf_vr2tqSum = irf(vr2tqSum_decimated,'nSides',nSides,'nLags',nlags);
                    set(irf_vr2tqSum,'irfPseudoInvMode','manual', 'irfFigNum', length(findobj('type','figure'))+1 );
                    irf_vr2tqSum = nlident(irf_vr2tqSum, vr2tqSum_decimated,'nSides', nSides,'nLags', nlags); close;
                    irf_vr2tqSum_plot = irf_vr2tqSum;
                    set(irf_vr2tqSum_plot, 'nSides', 1, 'nLags', nlags, 'domainStart', 0);
                    I = irf_vr2tqSum_plot.dataSet; I = I(floor(length(irf_vr2tqSum_plot)/2) + 1 : floor(length(irf_vr2tqSum_plot)/2) + 1 + plotIRF_lags); irf_vr2tqSum_plot.dataSet = I;

                else
                    irf_vr2body = irf(vr2body_decimated,'nSides',nSides,'nLags',nlags);
                    irf_vr2body_plot = irf_vr2body;
                    set(irf_vr2body_plot, 'nSides', 1, 'nLags', nlags, 'domainStart', 0);
                    I = irf_vr2body_plot.dataSet; I = I(floor(length(irf_vr2body_plot)/2) + 1 : floor(length(irf_vr2body_plot)/2) + 1 + plotIRF_lags); irf_vr2body_plot.dataSet = I;
                    
                    irf_vr2tqSum = irf(vr2tqSum_decimated,'nSides',nSides,'nLags',nlags);
                    irf_vr2tqSum_plot = irf_vr2tqSum;
                    set(irf_vr2tqSum_plot, 'nSides', 1, 'nLags', nlags, 'domainStart', 0);
                    I = irf_vr2tqSum_plot.dataSet; I = I(floor(length(irf_vr2tqSum_plot)/2) + 1 : floor(length(irf_vr2tqSum_plot)/2) + 1 + plotIRF_lags); irf_vr2tqSum_plot.dataSet = I;
                    
                end                
                
                vr2body_sim = nlsim(irf_vr2body,VRnldat_decimated);
                vaf_body = vaf(BodyA_decimated, vr2body_sim);
                
                vr2tqSum_sim = nlsim(irf_vr2tqSum,VRnldat_decimated);
                vaf_tqSum = vaf(TorqueSum_decimated, vr2tqSum_sim);
                
                VAF_TQ{1,S}{i,j}{1,T} = vaf_tqSum.dataSet;
                VAF_Body{1,S}{i,j}{1,T} = vaf_body.dataSet;
                
                IRF_TQ{1,S}{i,j}{1,T} = irf_vr2tqSum;
                IRF_Body{1,S}{i,j}{1,T} = irf_vr2body;                
                
            end
        end
    end
end














