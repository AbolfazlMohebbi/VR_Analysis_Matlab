function Trials_Data_SG = SGfilter_App(Trials_Data, filtorder, framelen)
%SGfilter_App Savitzky–Golay filter outputs (angles and torques)

Trials_Data_SG = Trials_Data;

Trials_Data_SG.BodyAngle = sgolayfilt(Trials_Data.BodyAngle, filtorder, framelen);
Trials_Data_SG.LeftShAngle = sgolayfilt(Trials_Data.LeftShAngle, filtorder, framelen);
Trials_Data_SG.RightShAngle = sgolayfilt(Trials_Data.RightShAngle, filtorder, framelen);
Trials_Data_SG.Torque_L = sgolayfilt(Trials_Data.Torque_L, filtorder, framelen);
Trials_Data_SG.Torque_R = sgolayfilt(Trials_Data.Torque_R, filtorder, framelen);

end
