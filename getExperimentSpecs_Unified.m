function [Experiment, NN, trials, Amp, FigsPath, Averaging, stackTrials] = getExperimentSpecs_Unified(trialsfile, SubjIndex, AmpCase, VelCase, trial_case)

% datestring = datestr(now,'ddmmmyyyy_HH-MM');
datestring = datestr(now,'dd-mmm-yyyy');
Averaging = 0; avgstr = 'NoAvrg';
ExperimentStr = 'TrapV';
Experiment = 1;
stackTrials = 2;
stackcondstr = 'NoStack';

fid = fopen(trialsfile);
Trials_Info = textscan(fid, '%d %s %d %q %q %q %q %q %q %q %q %q %q %q %q', 'Delimiter', ',', 'HeaderLines', 1);
fclose(fid);

if (VelCase == 2) && (AmpCase == 1)  % 1deg 2dps
    NN = 1;
    Amp = 1.0;
    AmpStr = '1deg';
    SpecStr = '2dps';
    trials = str2num(Trials_Info{4}{SubjIndex});
end
    
if (VelCase == 2) && (AmpCase == 2)  % 2deg 2dps  
    NN = 2;
    Amp = 2.0;
    AmpStr = '2deg';
    SpecStr = '2dps';
    trials = str2num(Trials_Info{5}{SubjIndex});
end

if (VelCase == 2) && (AmpCase == 5)  % 5deg 2dps
    NN = 3;
    Amp = 5.0;
    AmpStr = '5deg';
    SpecStr = '2dps';
    trials = str2num(Trials_Info{6}{SubjIndex});
end

if (VelCase == 2) && (AmpCase == 10)  % 10deg 2dps
    NN = 4;
    Amp = 10.0;
    AmpStr = '10deg';
    SpecStr = '2dps';
    trials = str2num(Trials_Info{7}{SubjIndex});
end

    
if (VelCase == 5) && (AmpCase == 1)  % 1deg 5dps
    NN = 5;
    Amp = 1.0;
    AmpStr = '1deg';
    SpecStr = '5dps';
    trials = str2num(Trials_Info{8}{SubjIndex});
end

if (VelCase == 5) && (AmpCase == 2)  % 2deg 5dps
    NN = 6;
    Amp = 2.0;
    AmpStr = '2deg';
    SpecStr = '5dps';
    trials = str2num(Trials_Info{9}{SubjIndex});
end

if (VelCase == 5) && (AmpCase == 5)  % 5deg 5dps
    NN = 7;
    Amp = 5.0;
    AmpStr = '5deg';
    SpecStr = '5dps';
    trials = str2num(Trials_Info{10}{SubjIndex});
end

if (VelCase == 5) && (AmpCase == 10)  % 10deg 5dps
    NN = 8;
    Amp = 10.0;
    AmpStr = '10deg';
    SpecStr = '5dps';
    trials = str2num(Trials_Info{11}{SubjIndex});
end

    
if (VelCase == 10) && (AmpCase == 1)  % 1deg 10dps
    NN = 8;
    Amp = 1.0;
    AmpStr = '1deg';
    SpecStr = '10dps';
    trials = str2num(Trials_Info{12}{SubjIndex});
end

if (VelCase == 10) && (AmpCase == 2)  % 2deg 10dps 
    NN = 8;
    Amp = 2.0;
    AmpStr = '2deg';
    SpecStr = '10dps';
    trials = str2num(Trials_Info{13}{SubjIndex});
end
if (VelCase == 10) && (AmpCase == 5)  % 5deg 10dps
    NN = 8;
    Amp = 5.0;
    AmpStr = '5deg';
    SpecStr = '10dps';
    trials = str2num(Trials_Info{14}{SubjIndex});
end

if (VelCase == 10) && (AmpCase == 10)  % 10deg 10dps
    NN = 8;
    Amp = 10.0;
    AmpStr = '10deg';
    SpecStr = '10dps';
    trials = str2num(Trials_Info{15}{SubjIndex});
end

% trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n 3) Third Trial\n');
trials = trials(trial_case);

condstr = strcat(avgstr,'_',stackcondstr, '_Tr', int2str(trial_case));
FigsPath = strcat('FigLogs/',datestring,'/',ExperimentStr,'_',AmpStr,SpecStr,'_',condstr);

end





