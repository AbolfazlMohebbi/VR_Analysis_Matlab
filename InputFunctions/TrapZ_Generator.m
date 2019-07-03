function [PositionArray daqInputArray] = TrapZ_Generator(P2PAmp, Vel, minW_Sec, minDelta_sec, Total_Time_Sec, SamplingRate, b_plot)

% SS_Time ==> delta = SS_Time + rand(0, SS_Time)

Amp = P2PAmp/2;
Time = Total_Time_Sec * SamplingRate; 
dt = (Amp / Vel) * SamplingRate;

minDelta = minDelta_sec * SamplingRate;
minW = minW_Sec * SamplingRate;

P_Previous = 0;
P = 0;
PositionArray = [];
daqInputArray = [];
TrapZ_pulsedone = true;

for t = 1:Time
    
    if (TrapZ_pulsedone == true)
        t0 = t;
        delta = minDelta + (minDelta * rand);
        W = minW + (minW * rand);
        randBit = randi([-1 1]);
        TrapZ_pulsedone = false;
    end
    
    tz = t - t0;
    
    if (tz < delta) 
        P = 0;    
    elseif ((tz >= delta) && (tz < delta + dt))
        P = randBit * Vel * (tz - delta) * (1/SamplingRate);    
    elseif ((tz >= delta + dt) && (tz < W + delta + dt))
        P = randBit * Amp;    
    elseif ((tz >= W + delta + dt) && (tz <= W + delta + 2*dt))
        P = randBit * (delta + W + 2*dt - tz) * Vel * (1/SamplingRate);    
    elseif (tz > W + delta + 2 * dt)
        TrapZ_pulsedone = true;
        P = 0;
    end
    
    deltaXori = (P - P_Previous);    
    daqInput = 2.5 + 2.5 * (P / Amp);
    P_Previous = P;
    
    PositionArray = [PositionArray, P];
    daqInputArray = [daqInputArray, daqInput];
    
end
       
if (b_plot == 'y') 
    figure();
    plot((1/SamplingRate)*[1:Time], PositionArray, 'LineWidth', 2);
    titlestr = strcat('TrapZ Perturbation with Amplitude=', string(P2PAmp), ' and Velocity=', string(Vel));
    title(titlestr, 'fontsize', 18);hold on
    xlabel('Time (sec)', 'fontsize', 18); ylabel('Signal', 'fontsize', 18)
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
end

end

