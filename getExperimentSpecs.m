function [Experiment, NN, trials, Amp, FigsPath, Averaging, stackTrials] = getExperimentSpecs(SubjIndex)

% datestring = datestr(now,'ddmmmyyyy_HH-MM');
datestring = datestr(now,'dd-mmm-yyyy');
Averaging = 0;

if (SubjIndex == 1) 
% To be completed
end

if (SubjIndex == 2) 
% To be completed
end

if (SubjIndex == 3)    
    Experiment = input('Which experiment would you like to examine?\n 1) TrapZ \n 2) PRTS \n 3) Sum of Sinusoids \n 4) PRBS \n ');
    if (Experiment == 1)
        ExperimentStr = 'TrapZ';
        NN = input('Which experiment do you want to examine for TrapZ?\n 1) TrapZ 2deg, 6dps\n 2) TrapZ 2deg, 3dps\n 3) TrapZ 5deg, 3dps\n 4) TrapZ 5deg, 6dps\n 5) TrapZ 10deg, 3dps\n');
        if NN == 1
            trials = 3:4;
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = '6dps';
        elseif NN == 2
            trials = 5:6;
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = '3dps';
        elseif NN == 3
            trials = 7:8;
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = '3dps';
        elseif NN == 4
            trials = 9:10;
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = '6dps';
        elseif NN == 5
            trials = 11:12;
            Amp = 10.0;
            AmpStr = '10deg';
            SpecStr = '3dps';
        end
    end
    
    if (Experiment == 2)   % PRTS
        NN = input('Which experiment do you want to examine for PRTS?\n 1) PRTS 2deg, dt=0.22s\n 2) PRTS 5deg, dt=0.22s\n 3) PRTS 10deg, dt=0.22s\n 4) PRTS 5deg, dt=0.44s\n');
        ExperimentStr = 'PRTS';
        if NN == 1
            trials = 13:14;  % 2deg, dt=0.22s
            Amp = 2.0;
            AmpStr = '2deg';
            min_PRTS = -0.4705809;
            SpecStr = 'dt220ms';
        elseif NN == 2
            trials = 17:18;  % 5deg, dt=0.22s
            Amp = 5.0;
            AmpStr = '5deg';
            min_PRTS = -1.176452;
            SpecStr = 'dt220ms';
        elseif NN == 3
            trials = 15:16;  % 10deg, dt=0.22s
            Amp = 10.0;
            AmpStr = '10deg';
            min_PRTS = -2.352905;
            SpecStr = 'dt220ms';
        elseif NN == 4
            trials = 21:22;  % 5 deg, dt=0.44s
            Amp = 5.0;
            AmpStr = '5deg';
            min_PRTS = -1.176452;
            SpecStr = 'dt440ms';
        end
    end
    
    if (Experiment == 3)
        NN = input('Which experiment do you want to examine for Sum of Sinusoids?\n 1) SOS 2deg, maxFR=3Hz\n 2) SOS 5deg, maxFR=3Hz\n 3) SOS 2deg, maxFR=1.5Hz\n 4) SOS 5deg, maxFR=1.5Hz\n');
        ExperimentStr = 'SoS';
        if NN == 1
            trials = 23:24;
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = 'BW3Hz';
        elseif NN == 2
            trials = [25 27];
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = 'BW3Hz';
        elseif NN == 3
            trials = [28 39];
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = 'BW1-5Hz';
        elseif NN == 4
            trials = 29:30;
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = 'BW1-5Hz';
        end
    end
    
    if (Experiment == 4)
        NN = input('Which experiment do you want to examine for Sum of PRBS?\n 1) PRBS 2deg, SR=0.22s\n 2) PRBS 5deg, SR=0.22s\n 3) PRBS 2deg, SR=0.44s\n 4) PRBS 5deg, SR=0.44s\n');
        ExperimentStr = 'PRBS';
        if NN == 1
            trials = 31:32;
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = 'SR220ms';
        elseif NN == 2
            trials = 33:34;
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = 'SR220ms';
        elseif NN == 3
            trials = 35:36;
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = 'SR440ms';
        elseif NN == 4
            trials = 37:38;
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = 'SR440ms';
        end
    end
    
    trial_case = 0;
    stackTrials = input('Do you wish to stack trials together as one signal?\n 1) Yes\n 2) No\n');
    if (stackTrials == 2)
        if (Experiment == 2)
            Averaging = input('Which kind of averaging?\n 0)No Averaging (each trial separately)\n 1)Average on periods for each trial\n 2)Average on periods and trials\n');
            if ((Averaging == 0) || (Averaging == 1))
                trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
                trials = trials(trial_case);
            end
            
        elseif (Experiment == 3)
            Averaging = input('Which kind of averaging?\n 0)No Averaging (each trial separately)\n 1)Average on periods for each trial\n');
            trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
            trials = trials(trial_case);
        else
            trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
            trials = trials(trial_case);
        end
    end
    
    if (stackTrials == 2) stackcondstr = 'NoStack'; end
    if (stackTrials == 1) stackcondstr = 'WStack'; end
    if (Averaging == 0) avgstr = 'NoAvrg'; end
    if (Averaging == 1) avgstr = 'AvrgPeriod'; end
    if (Averaging == 2) avgstr = 'AvrgAll'; end
    
    condstr = strcat(avgstr,'_',stackcondstr, '_Tr', int2str(trial_case));
    FigsPath = strcat('FigLogs/',datestring,'/',ExperimentStr,'_',AmpStr,SpecStr,'_',condstr);
end


if (SubjIndex == 4) 
    Experiment = input('Which experiment would you like to examine?\n 1) TrapZ \n 2) PRTS \n 3) Sum of Sinusoids \n');
    if (Experiment == 1)
        ExperimentStr = 'TrapZ';
        NN = input('Which experiment do you want to examine for TrapZ?\n 1) TrapZ 2deg, 5dps\n 2) TrapZ 2deg, 10dps\n 3) TrapZ 5deg, 5dps\n 4) TrapZ 5deg, 10dps\n');
        if NN == 1
            trials = 8:9;
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = '5dps';
        elseif NN == 2
            trials = 12:13;
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = '10dps';
        elseif NN == 3
            trials = 10:11;
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = '5dps';
        elseif NN == 4
            trials = 6:7;
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = '10dps';
        end
    end
    
    if (Experiment == 2)   % PRTS
        NN = input('Which experiment do you want to examine for PRTS?\n 1) PRTS 2deg, dt=0.16s\n 2) PRTS 5deg, dt=0.16s\n 3) PRTS 2deg, dt=0.22s\n 4) PRTS 5deg, dt=0.22s\n');
        ExperimentStr = 'PRTS';
        if NN == 1
            trials = 16:17;  % 2deg, dt=0.166s
            Amp = 2.0;
            AmpStr = '2deg';
            min_PRTS = -0.3529356;
            SpecStr = 'dt166ms';
        elseif NN == 2
            trials = 14:15;  % 5deg, dt=0.166s
            Amp = 5.0;
            AmpStr = '5deg';
            min_PRTS = -1.176452;
            SpecStr = 'dt166ms';
        elseif NN == 3
            trials = 18:19;  % 10deg, dt=0.222s
            Amp = 2.0;
            AmpStr = '2deg';
            min_PRTS = -2.352905;
            SpecStr = 'dt222ms';
        elseif NN == 4
            trials = 20:21;  % 5 deg, dt=0.222s
            Amp = 5.0;
            AmpStr = '5deg';
            min_PRTS = -1.176452;
            SpecStr = 'dt222ms';
        end
    end
    
    if (Experiment == 3)
        NN = input('Which experiment do you want to examine for Sum of Sinusoids?\n 1) SOS 2deg, maxFR=1.5Hz\n 2) SOS 5deg, maxFR=1.5Hz\n');
        ExperimentStr = 'SoS';
        if NN == 1
            trials = 25:26;
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = 'BW1n5Hz';
        elseif NN == 2
            trials = [22 24];
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = 'BW1n5Hz';
        end
    end
    
    trial_case = 0;
    stackTrials = input('Do you wish to stack trials together as one signal?\n 1) Yes\n 2) No\n');
    if (stackTrials == 2)
        if (Experiment == 2)
            Averaging = input('Which kind of averaging?\n 0)No Averaging (each trial separately)\n 1)Average on periods for each trial\n 2)Average on periods and trials\n');
            if ((Averaging == 0) || (Averaging == 1))
                trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
                trials = trials(trial_case);
            end
            
        elseif (Experiment == 3)
            Averaging = input('Which kind of averaging?\n 0)No Averaging (each trial separately)\n 1)Average on periods for each trial\n');
            trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
            trials = trials(trial_case);
        else
            trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
            trials = trials(trial_case);
        end
    end
    
    if (stackTrials == 2) stackcondstr = 'NoStack'; end
    if (stackTrials == 1) stackcondstr = 'WStack'; end
    if (Averaging == 0) avgstr = 'NoAvrg'; end
    if (Averaging == 1) avgstr = 'AvrgPeriod'; end
    if (Averaging == 2) avgstr = 'AvrgAll'; end
    
    condstr = strcat(avgstr,'_',stackcondstr, '_Tr', int2str(trial_case));
    FigsPath = strcat('FigLogs/',datestring,'/',ExperimentStr,'_',AmpStr,SpecStr,'_',condstr);    
end

if (SubjIndex == 5) 
    Experiment = input('Which experiment would you like to examine?\n 1) TrapZ \n NO OTHER EXPERIMENT IS PRESENT\n');
    if (Experiment == 1)
        ExperimentStr = 'TrapZ';
        disp('Which experiment do you want to examine for TrapZ?\n ');
        disp('Note:');
        disp('omega = pulse width');
        disp('delta = time delay between pulses ');
        NN = input(' 1) TrapZ 2deg, 8dps, delta=1.0sec, omega=0.0sec\n 2) TrapZ 5deg, 8dps, delta=1.0sec, omega=0.0sec\n 3) TrapZ 8deg, 8dps, delta=1.0sec, omega=0.0sec\n 4) TrapZ 10deg, 8dps, delta=1.0sec, omega=0.0sec\n');
        if NN == 1
            trials = 6:7;
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = '8dps';
        elseif NN == 2
            trials = 4:5;
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = '8dps';
        elseif NN == 3
            trials = 10:11;
            Amp = 8.0;
            AmpStr = '8deg';
            SpecStr = '8dps';
        elseif NN == 4
            trials = 8:9;
            Amp = 10.0;
            AmpStr = '10deg';
            SpecStr = '8dps';
        end
    end
    
    trial_case = 0;
    stackTrials = input('Do you wish to stack trials together as one signal?\n 1) Yes\n 2) No\n');
    if (stackTrials == 2)
        trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
        trials = trials(trial_case);
    end
    
    if (stackTrials == 2) stackcondstr = 'NoStack'; end
    if (stackTrials == 1) stackcondstr = 'WStack'; end
    if (Averaging == 0) avgstr = 'NoAvrg'; end
    if (Averaging == 1) avgstr = 'AvrgPeriod'; end
    if (Averaging == 2) avgstr = 'AvrgAll'; end
    
    condstr = strcat(avgstr,'_',stackcondstr, '_Tr', int2str(trial_case));
    FigsPath = strcat('FigLogs/',datestring,'/',ExperimentStr,'_',AmpStr,SpecStr,'_',condstr);    
end


if (SubjIndex == 6)   % Abolfazl Exp 1 
    Experiment = input('Which experiment would you like to examine?\n 1) TrapZ \n 2) PRTS \n');
    if (Experiment == 1)
        ExperimentStr = 'TrapZ';
        NN = input('Which experiment do you want to examine for TrapZ?\n 1) TrapZ 2deg, 5dps\n 2) TrapZ 2deg, 10dps\n 3) TrapZ 5deg, 5dps\n 4) TrapZ 5deg, 10dps\n');
        if NN == 1
            trials = 7:8;
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = '5dps';
        elseif NN == 2
            trials = [11,13];
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = '10dps';
        elseif NN == 3
            trials = [9, 12];
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = '5dps';
        elseif NN == 4
            trials = [10, 14];
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = '10dps';
        end
    end
    
    if (Experiment == 2)   % PRTS
        NN = input('Which experiment do you want to examine for PRTS?\n 1) PRTS 2deg, dt=0.16s\n 2) PRTS 5deg, dt=0.16s\n 3) PRTS 2deg, dt=0.22s\n 4) PRTS 5deg, dt=0.22s\n');
        ExperimentStr = 'PRTS';
        if NN == 1
            trials = 15;  % 2deg, dt=0.166s
            Amp = 2.0;
            AmpStr = '2deg';
            min_PRTS = -0.3529356;
            SpecStr = 'dt166ms';
        elseif NN == 2
            trials = 18;  % 5deg, dt=0.166s
            Amp = 5.0;
            AmpStr = '5deg';
            min_PRTS = -1.176452;
            SpecStr = 'dt166ms';
        elseif NN == 3
            trials = 16;  % 2 deg, dt=0.222s
            Amp = 2.0;
            AmpStr = '2deg';
            min_PRTS = -2.352905;
            SpecStr = 'dt222ms';
        elseif NN == 4
            trials = 17;  % 5 deg, dt=0.222s
            Amp = 5.0;
            AmpStr = '5deg';
            min_PRTS = -1.176452;
            SpecStr = 'dt222ms';
        end
    end
        
    trial_case = 0;
    stackTrials = input('Do you wish to stack trials together as one signal?\n 1) Yes\n 2) No\n');
    if (stackTrials == 2)
        if (Experiment == 2)
            Averaging = input('Which kind of averaging?\n 0)No Averaging (each trial separately)\n 1)Average on periods for each trial\n 2)Average on periods and trials\n');
            if ((Averaging == 0) || (Averaging == 1))
                trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
                trials = trials(trial_case);
            end          
        else
            trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
            trials = trials(trial_case);
        end
    end
    
    if (stackTrials == 2) stackcondstr = 'NoStack'; end
    if (stackTrials == 1) stackcondstr = 'WStack'; end
    if (Averaging == 0) avgstr = 'NoAvrg'; end
    if (Averaging == 1) avgstr = 'AvrgPeriod'; end
    if (Averaging == 2) avgstr = 'AvrgAll'; end
    
    condstr = strcat(avgstr,'_',stackcondstr, '_Tr', int2str(trial_case));
    FigsPath = strcat('FigLogs/',datestring,'/',ExperimentStr,'_',AmpStr,SpecStr,'_',condstr);    
end


if (SubjIndex == 7)   % Shkar Shaho
    Experiment = input('Which experiment would you like to examine?\n 1) TrapZ \n 2) PRTS \n');
    if (Experiment == 1)
        ExperimentStr = 'TrapZ';
        NN = input('Which experiment do you want to examine for TrapZ?\n 1) TrapZ 2deg, 5dps\n 2) TrapZ 2deg, 10dps\n 3) TrapZ 5deg, 5dps\n 4) TrapZ 5deg, 10dps\n');
        if NN == 1
            trials = 5:6;
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = '5dps';
        elseif NN == 2
            trials = [11,12];
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = '10dps';
        elseif NN == 3
            trials = [7, 8];
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = '5dps';
        elseif NN == 4
            trials = [9, 10];
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = '10dps';
        end
    end
    
    if (Experiment == 2)   % PRTS
        NN = input('Which experiment do you want to examine for PRTS?\n 1) PRTS 5deg, dt=0.16s\n 2) PRTS 2deg, dt=0.22s\n 3) PRTS 5deg, dt=0.22s\n');
        ExperimentStr = 'PRTS';
        if NN == 1
            trials = 14;  % 5deg, dt=0.166s
            Amp = 5.0;
            AmpStr = '5deg';
            min_PRTS = -1.176452;
            SpecStr = 'dt166ms';
        elseif NN == 2
            trials = 15;  % 2 deg, dt=0.222s
            Amp = 2.0;
            AmpStr = '2deg';
            min_PRTS = -2.352905;
            SpecStr = 'dt222ms';
        elseif NN == 3
            trials = 13;  % 5 deg, dt=0.222s
            Amp = 5.0;
            AmpStr = '5deg';
            min_PRTS = -1.176452;
            SpecStr = 'dt222ms';
        end
    end
        
    trial_case = 0;
    stackTrials = input('Do you wish to stack trials together as one signal?\n 1) Yes\n 2) No\n');
    if (stackTrials == 2)
        if (Experiment == 2)
            Averaging = input('Which kind of averaging?\n 0)No Averaging (each trial separately)\n 1)Average on periods for each trial\n 2)Average on periods and trials\n');
            if ((Averaging == 0) || (Averaging == 1))
                trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
                trials = trials(trial_case);
            end          
        else
            trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
            trials = trials(trial_case);
        end
    end
    
    if (stackTrials == 2) stackcondstr = 'NoStack'; end
    if (stackTrials == 1) stackcondstr = 'WStack'; end
    if (Averaging == 0) avgstr = 'NoAvrg'; end
    if (Averaging == 1) avgstr = 'AvrgPeriod'; end
    if (Averaging == 2) avgstr = 'AvrgAll'; end
    
    condstr = strcat(avgstr,'_',stackcondstr, '_Tr', int2str(trial_case));
    FigsPath = strcat('FigLogs/',datestring,'/',ExperimentStr,'_',AmpStr,SpecStr,'_',condstr);    
end


if (SubjIndex == 8)   % Pouya 
    Experiment = input('Which experiment would you like to examine?\n 1) TrapZ \n 2) NO OTHER EXPERIMENTS ARE PRESENT \n');
    if (Experiment == 1)
        ExperimentStr = 'TrapZ';
        NN = input('Which experiment do you want to examine for TrapZ?\n 1) TrapZ 2deg, 5dps\n 2) TrapZ 2deg, 10dps\n 3) TrapZ 5deg, 5dps\n 4) TrapZ 5deg, 10dps\n 5) TrapZ 4deg, 5dps\n 6) TrapZ 10deg, 5dps\n 7) TrapZ 5deg, 5dps with MUSIC ON\n');
        if NN == 1
            trials = 6;
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = '5dps';
        elseif NN == 2
            trials = 7;
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = '10dps';
        elseif NN == 3
            trials = 11;
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = '5dps';
        elseif NN == 4
            trials = 8;
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = '10dps';
        elseif NN == 5
            trials = 5;
            Amp = 4.0;
            AmpStr = '4deg';
            SpecStr = '5dps';
        elseif NN == 6
            trials = 10;
            Amp = 10.0;
            AmpStr = '10deg';
            SpecStr = '5dps';
        elseif NN == 7
            trials = 12;
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = '5dps_MUSIC';
        end
    end   
        
    trial_case = 0;
    stackTrials = input('Do you wish to stack trials together as one signal?\n 1) Yes\n 2) No\n');
    if (stackTrials == 2)
        if (Experiment == 2)
            Averaging = input('Which kind of averaging?\n 0)No Averaging (each trial separately)\n 1)Average on periods for each trial\n 2)Average on periods and trials\n');
            if ((Averaging == 0) || (Averaging == 1))
                trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
                trials = trials(trial_case);
            end          
        else
            trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
            trials = trials(trial_case);
        end
    end
    
    if (stackTrials == 2) stackcondstr = 'NoStack'; end
    if (stackTrials == 1) stackcondstr = 'WStack'; end
    if (Averaging == 0) avgstr = 'NoAvrg'; end
    if (Averaging == 1) avgstr = 'AvrgPeriod'; end
    if (Averaging == 2) avgstr = 'AvrgAll'; end
    
    condstr = strcat(avgstr,'_',stackcondstr, '_Tr', int2str(trial_case));
    FigsPath = strcat('FigLogs/',datestring,'/',ExperimentStr,'_',AmpStr,SpecStr,'_',condstr);    
end


if (SubjIndex == 9)   % Abolfazl No Shank 
    Experiment = input('Which experiment would you like to examine?\n 1) TrapZ \n 2) NO OTHER EXPERIMENTS ARE PRESENT \n');
    if (Experiment == 1)
        ExperimentStr = 'TrapZ';
        NN = input('Which experiment do you want to examine for TrapZ?\n 1) TrapZ 2deg, 5dps\n 2) TrapZ 2deg, 10dps\n 3) TrapZ 5deg, 5dps\n 4) TrapZ 5deg, 10dps\n 5) TrapZ 10deg, 5dps\n 6) TrapZ 5deg, 2dps\n 7) TrapZ 5deg, 5dps with MUSIC ON\n');
        if NN == 1
            trials = 3;
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = '5dps';
        elseif NN == 2
            trials = 5;
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = '10dps';
        elseif NN == 3
            trials = 4;
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = '5dps';
        elseif NN == 4
            trials = 6;
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = '10dps';
        elseif NN == 5
            trials = 7;
            Amp = 4.0;
            AmpStr = '10deg';
            SpecStr = '5dps';
        elseif NN == 6
            trials = 8;
            Amp = 10.0;
            AmpStr = '5deg';
            SpecStr = '2dps';
        elseif NN == 7
            trials = 9;
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = '5dps_MUSIC';
        end
    end   
        
    trial_case = 0;
    stackTrials = input('Do you wish to stack trials together as one signal?\n 1) Yes\n 2) No\n');
    if (stackTrials == 2)
        if (Experiment == 2)
            Averaging = input('Which kind of averaging?\n 0)No Averaging (each trial separately)\n 1)Average on periods for each trial\n 2)Average on periods and trials\n');
            if ((Averaging == 0) || (Averaging == 1))
                trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
                trials = trials(trial_case);
            end          
        else
            trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
            trials = trials(trial_case);
        end
    end
    
    if (stackTrials == 2) stackcondstr = 'NoStack'; end
    if (stackTrials == 1) stackcondstr = 'WStack'; end
    if (Averaging == 0) avgstr = 'NoAvrg'; end
    if (Averaging == 1) avgstr = 'AvrgPeriod'; end
    if (Averaging == 2) avgstr = 'AvrgAll'; end
    
    condstr = strcat(avgstr,'_',stackcondstr, '_Tr', int2str(trial_case));
    FigsPath = strcat('FigLogs/',datestring,'/',ExperimentStr,'_',AmpStr,SpecStr,'_',condstr);    
end


if (SubjIndex == 10)   % Guy Tsror
    Experiment = input('Which experiment would you like to examine?\n 1) TrapZ \n 2) PRTS \n');
    if (Experiment == 1)
        ExperimentStr = 'TrapZ';
        NN = input('Which experiment do you want to examine for TrapZ?\n 1) TrapZ 2deg, 5dps\n 2) TrapZ 2deg, 10dps\n 3) TrapZ 5deg, 5dps\n 4) TrapZ 5deg, 10dps\n');
        if NN == 1
            trials = [6,7];
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = '5dps';
        elseif NN == 2
            trials = [8,9];
            Amp = 2.0;
            AmpStr = '2deg';
            SpecStr = '10dps';
        elseif NN == 3
            trials = [3, 4, 5];
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = '5dps';
        elseif NN == 4
            trials = [10, 11];
            Amp = 5.0;
            AmpStr = '5deg';
            SpecStr = '10dps';
        end
    end
    
    if (Experiment == 2)   % PRTS
        NN = input('Which experiment do you want to examine for PRTS?\n 1) PRTS 2deg, dt=0.22s\n 2) PRTS 5deg, dt=0.22s\n');
        ExperimentStr = 'PRTS';
        if NN == 1
            trials = 12;  % 2 deg, dt=0.222s
            Amp = 2.0;
            AmpStr = '2deg';
            min_PRTS = -2.352905;
            SpecStr = 'dt222ms';
        elseif NN == 2
            trials = 13;  % 5 deg, dt=0.222s
            Amp = 5.0;
            AmpStr = '5deg';
            min_PRTS = -1.176452;
            SpecStr = 'dt222ms';
        end
    end
    
    trial_case = 0;
    stackTrials = input('Do you wish to stack trials together as one signal?\n 1) Yes\n 2) No\n');
    if (stackTrials == 2)
        if (Experiment == 2)
            Averaging = input('Which kind of averaging?\n 0)No Averaging (each trial separately)\n 1)Average on periods for each trial\n 2)Average on periods and trials\n');
            if ((Averaging == 0) || (Averaging == 1))
                trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
                trials = trials(trial_case);
            end
        else
            trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
            trials = trials(trial_case);
        end
    end
    
    if (stackTrials == 2) stackcondstr = 'NoStack'; end
    if (stackTrials == 1) stackcondstr = 'WStack'; end
    if (Averaging == 0) avgstr = 'NoAvrg'; end
    if (Averaging == 1) avgstr = 'AvrgPeriod'; end
    if (Averaging == 2) avgstr = 'AvrgAll'; end
    
    condstr = strcat(avgstr,'_',stackcondstr, '_Tr', int2str(trial_case));
    FigsPath = strcat('FigLogs/',datestring,'/',ExperimentStr,'_',AmpStr,SpecStr,'_',condstr);
end


if (SubjIndex == 11) % Shkar Shaho - 20 June 2019    
    NN = input('Which VR Scene would you like to analyze?\n 1) Nordic Home \n 2) Rotating Cylinder \n 3) Moving Room \n 4) Chessboard Tunnel \n ');    
    if (NN == 1)
        VRStr = 'NordicHome';
        AmpStr = '5deg';
        SpecStr = '5dps';        
        Experiment = input('Which experiment do you want to examine?\n 1) Half-Sin 5deg \n 2) PRTS 5deg, dt=0.1 \n 3) PRTS 5deg, dt=0.2\n 4) TrapZ 5deg, 5dps\n 5) TrapV 5deg \n');
        Amp = 5.0; % Degree
        if Experiment == 1
            ExperimentStr = 'HalfSin';
            trials = 3:4;
        elseif Experiment == 2
            ExperimentStr = 'PRTSdt01';
            trials = 5:6;
            min_PRTS = -1.176471;
        elseif Experiment == 3
            ExperimentStr = 'PRTSdt02';
            trials = 7:8;
            min_PRTS = -1.176472;
        elseif Experiment == 4
            ExperimentStr = 'TrapZ';
            trials = 9:10;
        elseif Experiment == 5
            ExperimentStr = 'TrapV';
            trials = 11:12;
        end
    end
    
    if (NN == 2)
        VRStr = 'Cylinder';
        AmpStr = '5deg';
        SpecStr = '5dps';        
        Experiment = input('Which experiment do you want to examine?\n 1) Half-Sin 5deg \n 2) PRTS 5deg, dt=0.1 \n 3) PRTS 5deg, dt=0.2\n 4) TrapZ 5deg, 5dps\n 5) TrapV 5deg \n');
        Amp = 5.0; % Degree
        if Experiment == 1
            ExperimentStr = 'HalfSin';
            trials = 13:14;
        elseif Experiment == 2
            ExperimentStr = 'PRTSdt01';
            trials = 17:18;
            min_PRTS = -1.176471;
        elseif Experiment == 3
            ExperimentStr = 'PRTSdt02';
            trials = 15:16;
            min_PRTS = -1.176472;
        elseif Experiment == 4
            ExperimentStr = 'TrapZ';
            trials = 19:20;
        elseif Experiment == 5
            ExperimentStr = 'TrapV';
            trials = 21:22;
        end
    end
    
    if (NN == 3)
        VRStr = 'MovingRoom';
        AmpStr = '5deg';
        SpecStr = '5dps';
        Experiment = input('Which experiment do you want to examine?\n 1) Half-Sin 5deg \n 2) PRTS 5deg, dt=0.1 \n 3) PRTS 5deg, dt=0.2\n 4) TrapZ 5deg, 5dps\n 5) TrapV 5deg \n');
        Amp = 5.0; % Degree
        if Experiment == 1
            ExperimentStr = 'HalfSin';
            trials = 25:26;
        elseif Experiment == 2
            ExperimentStr = 'PRTSdt01';
            trials = 28;
            min_PRTS = -1.176471;
        elseif Experiment == 3
            ExperimentStr = 'PRTSdt02';
            trials = 27;
            min_PRTS = -1.176472;
        elseif Experiment == 4
            ExperimentStr = 'TrapZ';
            trials = 29:30;
        elseif Experiment == 5
            ExperimentStr = 'TrapV';
            trials = 31:32;
        end
    end
    
    if (NN == 4)
        AmpStr = '145mm';
        SpecStr = '145mmps';
        VRStr = 'Tunnel';
        Experiment = input('Which experiment do you want to examine?\n 1) Half-Sin 5deg \n 2) PRTS 5deg, dt=0.1 \n 3) PRTS 5deg, dt=0.2\n 4) TrapZ 5deg, 5dps\n 5) TrapV 5deg \n');
        Amp = 14.5; % cm
        if Experiment == 1
            ExperimentStr = 'HalfSin';
            trials = 33:34;
        elseif Experiment == 2
            ExperimentStr = 'PRTSdt01';
            trials = 36;
            min_PRTS = -0.03411765;
        elseif Experiment == 3
            ExperimentStr = 'PRTSdt02';
            trials = 35;
            min_PRTS = -0.03411767;
        elseif Experiment == 4
            ExperimentStr = 'TrapZ';
            trials = 37:38;
        elseif Experiment == 5
            ExperimentStr = 'TrapV';
            trials = 39:40;
        end
    end    
    
    trial_case = 0;
    stackTrials = input('Do you wish to stack trials together as one signal?\n 1) Yes\n 2) No\n');
    if (stackTrials == 2)
        if ((Experiment == 2) || (Experiment == 3))
            Averaging = input('Which kind of averaging?\n 0)No Averaging (each trial separately)\n 1)Average on periods for each trial\n 2)Average on periods and trials\n');
            if ((Averaging == 0) || (Averaging == 1))
                trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
                trials = trials(trial_case);
            end            
        else
            trial_case = input('Which trial of this experiment do you want to examine?\n 1) First Trial\n 2) Second Trial\n ');
            trials = trials(trial_case);
        end
    end
    
    if (stackTrials == 2) stackcondstr = 'NoStack'; end
    if (stackTrials == 1) stackcondstr = 'WStack'; end
    if (Averaging == 0) avgstr = 'NoAvrg'; end
    if (Averaging == 1) avgstr = 'AvrgPeriod'; end
    if (Averaging == 2) avgstr = 'AvrgAll'; end
    
    condstr = strcat(avgstr,'_',stackcondstr, '_Tr', int2str(trial_case));
    FigsPath = strcat('FigLogs/',datestring,'/',VRStr, ExperimentStr,'_',AmpStr,'_',condstr);    
end



end

