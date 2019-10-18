function Trials_Data_All_deg = outputRad2Deg_All(Trials_Data_All)

Trials_Data_All_deg = Trials_Data_All;

for S = 1:Trials_Data_All.SubjNo    
    for i = Trials_Data_All.VelCase
        for j = Trials_Data_All.AmpCase
            trials = Trials_Data_All.trialsAll{1,S}{i,j};
            for T = 1:length(trials)                
                Trials_Data_All_deg.BodyAngle{1,S}{i,j}{1,T} = Trials_Data_All.BodyAngle{1,S}{i,j}{1,T} * (180/pi);
                Trials_Data_All_deg.LeftShAngle{1,S}{i,j}{1,T} = Trials_Data_All.LeftShAngle{1,S}{i,j}{1,T} * (180/pi);
                Trials_Data_All_deg.RightShAngle{1,S}{i,j}{1,T} = Trials_Data_All.RightShAngle{1,S}{i,j}{1,T} * (180/pi);
            end
        end
    end    
end

end