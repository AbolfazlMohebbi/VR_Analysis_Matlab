function vr_input_deg = inputVolts2Deg(SubjIndex, Experiment, Amp, vr_input_volts, NN)

if (SubjIndex == 1) 
% To be completed
end

if (SubjIndex == 2) 
% To be completed
end

if (SubjIndex == 3)
    if (Experiment == 1) % TrapZ
        vr_input_deg = Amp * ((vr_input_volts/2.5) - 1.0);
        
    elseif (Experiment == 2)    % for PRTS inputs (2 Period)
        
        min_PRTS = 0;
        if (Amp == 2.0) min_PRTS = -0.4705809; end
        if (Amp == 5.0) min_PRTS = -1.176452; end
        if (Amp == 10.0) min_PRTS = -2.352905; end
        
        vr_input_deg = ((Amp/5.0) * vr_input_volts) + min_PRTS;
        
    elseif (Experiment == 3)  % Sum of Sin
        vr_input_deg = (vr_input_volts/5.0)* Amp;
        
    elseif (Experiment == 4) % PRBS
        vr_input_deg = ((vr_input_volts/2.5)-1.0) * Amp;
    end
end

if (SubjIndex == 4)    
    if (Experiment == 1) % TrapZ
        vr_input_deg = (Amp/2) * ((vr_input_volts/2.5) - 1.0);
        
    elseif (Experiment == 2)    % for PRTS inputs (2 Period)
        vr_input_deg = (vr_input_volts-1.173)*(Amp/5.0);
        
    elseif (Experiment == 3)  % Sum of Sin
        % Change volts to degrees
        vr_input_deg = (vr_input_volts/5.0)* Amp;   % NO other option for now!!!
    end    
end

if (SubjIndex == 5)    
    if (Experiment == 1) % TrapZ
        vr_input_deg = (Amp/2) * ((vr_input_volts/2.5) - 1.0);
    end    
end

if (SubjIndex == 6)    
    if (Experiment == 1) % TrapZ
        vr_input_deg = (Amp/2) * ((vr_input_volts/2.5) - 1.0);
        
    elseif (Experiment == 2)    % for PRTS inputs (2 Period)
        vr_input_deg = (vr_input_volts-1.173)*(Amp/5.0);
    end    
end

if (SubjIndex == 7)    
    if (Experiment == 1) % TrapZ
        vr_input_deg = (Amp/2) * ((vr_input_volts/2.5) - 1.0);
        
    elseif (Experiment == 2)    % for PRTS inputs (2 Period)
        vr_input_deg = (vr_input_volts-1.173)*(Amp/5.0);
    end    
end

if (SubjIndex == 8)    
    if (Experiment == 1) % TrapZ
        vr_input_deg = (Amp/2) * ((vr_input_volts/2.5) - 1.0);
    end    
end

if (SubjIndex == 9)    
    if (Experiment == 1) % TrapZ
        vr_input_deg = (Amp/2) * ((vr_input_volts/2.5) - 1.0);
    end    
end

if (SubjIndex == 10)    
    if (Experiment == 1) % TrapZ
        vr_input_deg = (Amp/2) * ((vr_input_volts/2.5) - 1.0);
        
    elseif (Experiment == 2)    % for PRTS inputs (2 Period)
        vr_input_deg = (vr_input_volts-1.173)*(Amp/5.0);
    end    
end

if (SubjIndex == 11)    
    if ((Experiment == 1) || (Experiment == 4) || (Experiment == 5))
        vr_input_deg = (Amp/2) * ((vr_input_volts/2.5) - 1.0);
        
    elseif (Experiment == 2)
        if (NN==4)
            vr_input_deg = (vr_input_volts-0.03411765)*(Amp/5.0);
        else
            vr_input_deg = (vr_input_volts-1.176471)*(Amp/5.0);
        end
        
    elseif (Experiment == 3)
        if (NN==4)
            vr_input_deg = (vr_input_volts-0.03411767)*(Amp/5.0);
        else
            vr_input_deg = (vr_input_volts-1.176472)*(Amp/5.0);          
        end
    end    
end

if (SubjIndex == 12)
    if (Experiment == 1)
        vr_input_deg = (Amp/2) * ((vr_input_volts/2.5) - 1.0);        
    elseif (Experiment == 2)
        vr_input_deg = (vr_input_volts-1.176471)*(Amp/5.0);        
    elseif (Experiment == 3)
        vr_input_deg = (vr_input_volts-1.176472)*(Amp/5.0);
    end
end

if (SubjIndex == 13)      
    if (Experiment == 1)
        vr_input_deg = (vr_input_volts-1.176471)*(Amp/5.0);        
    elseif (Experiment == 2)
        vr_input_deg = (vr_input_volts-1.176472)*(Amp/5.0);
    end
end

if (SubjIndex == 14)
    if (Experiment == 1)
        vr_input_deg = (Amp/2) * ((vr_input_volts/2.5) - 1.0);        
    end
end


end

