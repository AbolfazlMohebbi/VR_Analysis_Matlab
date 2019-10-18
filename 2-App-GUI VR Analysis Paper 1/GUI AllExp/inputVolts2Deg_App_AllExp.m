function Trials_Data_deg = inputVolts2Deg_App_AllExp(Trials_Data)

Trials_Data_deg = Trials_Data;

for i = Trials_Data.VelCase
    for j = Trials_Data.AmpCase
        Trials_Data_deg.vr_input_deg{i,j} = (j/2) * ((Trials_Data.vr_input{i,j}/2.5) - 1.0);
    end
end

end

