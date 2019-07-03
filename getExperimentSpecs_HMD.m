function [Experiment, NN, trials, Amp, FigsPath, Averaging, stackTrials] = getExperimentSpecs_HMD(SubjIndex)

% datestring = datestr(now,'ddmmmyyyy_HH-MM');
datestring = datestr(now,'dd-mmm-yyyy');
Averaging = 0;

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

