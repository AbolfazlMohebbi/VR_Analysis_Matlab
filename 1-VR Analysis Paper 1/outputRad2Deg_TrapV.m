function Trials_Data_deg = outputRad2Deg_TrapV(Trials_Data)
% rad to deg

Trials_Data_deg = Trials_Data;

Trials_Data_deg.BodyAngle = Trials_Data.BodyAngle * (180/pi);
Trials_Data_deg.LeftShAngle = Trials_Data.LeftShAngle * (180/pi);
Trials_Data_deg.RightShAngle = Trials_Data.RightShAngle * (180/pi);

end

