function Trials_Data_All_deg = inputVolts2Deg_All(Trials_Data_All)

Trials_Data_All_deg = Trials_Data_All;

for S = 1:Trials_Data_All.SubjNo    
    for i = Trials_Data_All.VelCase
        for j = Trials_Data_All.AmpCase
            trials = Trials_Data_All.trialsAll{1,S}{i,j};            
            for T = 1:length(trials)
                Trials_Data_All_deg.vr_input_deg{1,S}{i,j}{1,T} = (j/2) * ((Trials_Data_All.vr_input{1,S}{i,j}{1,T}/2.5) - 1.0);
            end
        end
    end    
end

end

