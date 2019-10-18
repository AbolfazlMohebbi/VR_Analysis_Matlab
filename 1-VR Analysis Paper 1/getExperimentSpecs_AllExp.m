function trialsMatrix = getExperimentSpecs_AllExp(trialsfile, VelCase, AmpCase, SubjIndex)

fid = fopen(trialsfile);
Trials_Info = textscan(fid, '%d %s %d %q %q %q %q %q %q %q %q %q %q %q %q', 'Delimiter', ',', 'HeaderLines', 1);
fclose(fid);
trialsMatrix = zeros(max(VelCase), max(AmpCase));

k = 4;
for i = VelCase
    for j = AmpCase        
        trialsMatrix(i, j) = str2num(Trials_Info{k}{SubjIndex});
        k = k + 1;        
    end
end


end





