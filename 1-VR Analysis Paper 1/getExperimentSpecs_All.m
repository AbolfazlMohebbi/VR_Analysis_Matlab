function trialsAll = getExperimentSpecs_All(trialsfile, VelCase, AmpCase, Subject_No)

fid = fopen(trialsfile);
Trials_Info = textscan(fid, '%d %s %d %q %q %q %q %q %q %q %q %q %q %q %q', 'Delimiter', ',', 'HeaderLines', 1);
fclose(fid);

trialsAll = {};
for s = 1:Subject_No    
    k = 4; %the column trial numbers start from
    for i = VelCase
        for j = AmpCase
            trialsAll{1,s}{i, j}(:) = str2num(Trials_Info{1,k}{s,1});
            k = k + 1;
        end
    end    
    
end

end





