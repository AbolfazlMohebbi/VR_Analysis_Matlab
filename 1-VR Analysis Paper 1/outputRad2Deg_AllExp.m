function Trials_Data_deg = outputRad2Deg_AllExp(Trials_Data)
% rad to deg
Trials_Data_deg = Trials_Data;

for i = Trials_Data.VelCase
    for j = Trials_Data.AmpCase        
        Trials_Data_deg.BodyAngle{i,j} = Trials_Data.BodyAngle{i,j} * (180/pi);
        Trials_Data_deg.LeftShAngle{i,j} = Trials_Data.LeftShAngle{i,j} * (180/pi);
        Trials_Data_deg.RightShAngle{i,j} = Trials_Data.RightShAngle{i,j} * (180/pi);        
    end
end

end

