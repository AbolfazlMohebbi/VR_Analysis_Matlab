function Trials_Data_All_deg = inputVolts2Deg_AllSubj(Trials_Data_All)

Trials_Data_All_deg = Trials_Data_All;

for S = 1:Trials_Data_All.SubjNo    
    for i = Trials_Data_All.VelCase
        for j = Trials_Data_All.AmpCase
            Trials_Data_All_deg.vr_input_deg{1,S}{i,j} = (j/2) * ((Trials_Data_All.vr_input{1,S}{i,j}/2.5) - 1.0);
        end
    end    
end

end

