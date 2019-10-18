function trialsAll = getExperimentSpecs_AllSubj(trialsfile, VelCase, AmpCase, Subject_No)

fid = fopen(trialsfile);
Trials_Info = textscan(fid, '%d %s %d %q %q %q %q %q %q %q %q %q %q %q %q', 'Delimiter', ',', 'HeaderLines', 1);
fclose(fid);

trialsAll = {};
for s = 1:Subject_No    
    k = 4; %the column trial numbers start from
    for i = VelCase
        for j = AmpCase
            trialsAll{s}(i, j) = str2num(Trials_Info{k}{s});
            k = k + 1;
        end
    end    
    
end

end





