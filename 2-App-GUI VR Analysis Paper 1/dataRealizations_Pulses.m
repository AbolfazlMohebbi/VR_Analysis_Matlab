function [Pos_Pulse_Data, Neg_Pulse_Data] = dataRealizations_Pulses(SubjIndex, Trials_Data)
global SR

vel_treshold = 0.04;
dt_trapZ_pulse = 2.0 * SR; % 1 seconds


t_test = 10 * SR;
bPulseFinish = true;
d_vr = (diff(Trials_Data.'))';

for k = 1:length(trials)
    
    vr_input_shrink = vr_input_deg(k,:);
    d_vr_shrink = d_vr(k,:);
    LeftShAngle_shrink = LeftShAngle(k,:);
    RightShAngle_shrink = RightShAngle(k,:);
    HipAngle_shrink = HipAngle(k,:);
    Torque_L_shrink = Torque_L(k,:);
    Torque_R_shrink = Torque_R(k,:);
    bPulseFinish = true;
    
    for i = 1: floor(tf/t_test)+1
        for t = 1:t_test
            if ((bPulseFinish==true) && (d_vr_shrink(t)> vel_treshold) && (vr_input_shrink(t) > 0) )
                TrapZ_allPosPulses = [TrapZ_allPosPulses; vr_input_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                
                TrapZ_PosPulse_RightSh = [TrapZ_PosPulse_RightSh; RightShAngle_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                TrapZ_PosPulse_LeftSh = [TrapZ_PosPulse_LeftSh; LeftShAngle_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                TrapZ_PosPulse_TorqueL = [TrapZ_PosPulse_TorqueL; Torque_L_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                TrapZ_PosPulse_TorqueR = [TrapZ_PosPulse_TorqueR; Torque_R_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                TrapZ_PosPulse_hip = [TrapZ_PosPulse_hip; HipAngle_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                
                vr_input_shrink = vr_input_shrink(t+dt_trapZ_pulse:end);
                d_vr_shrink = d_vr_shrink(t+dt_trapZ_pulse:end);
                LeftShAngle_shrink = LeftShAngle_shrink(t+dt_trapZ_pulse:end);
                RightShAngle_shrink = RightShAngle_shrink(t+dt_trapZ_pulse:end);
                HipAngle_shrink = HipAngle_shrink(t+dt_trapZ_pulse:end);
                Torque_R_shrink = Torque_R_shrink(t+dt_trapZ_pulse:end);
                Torque_L_shrink = Torque_L_shrink(t+dt_trapZ_pulse:end);
                bPulseFinish = false;
            end
            
            if ((bPulseFinish==true) && (d_vr_shrink(t) < -vel_treshold) && (vr_input_shrink(t) < 0))
                TrapZ_allNegPulses = [TrapZ_allNegPulses; vr_input_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                
                TrapZ_NegPulse_RightSh = [TrapZ_NegPulse_RightSh; RightShAngle_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                TrapZ_NegPulse_LeftSh = [TrapZ_NegPulse_LeftSh; LeftShAngle_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                TrapZ_NegPulse_TorqueL = [TrapZ_NegPulse_TorqueL; Torque_L_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                TrapZ_NegPulse_TorqueR = [TrapZ_NegPulse_TorqueR; Torque_R_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                TrapZ_NegPulse_hip = [TrapZ_NegPulse_hip; HipAngle_shrink(t-dt_trapZ_pulse:t+dt_trapZ_pulse)];
                
                vr_input_shrink = vr_input_shrink(t+dt_trapZ_pulse:end);
                d_vr_shrink = d_vr_shrink(t+dt_trapZ_pulse:end);
                LeftShAngle_shrink = LeftShAngle_shrink(t+dt_trapZ_pulse:end);
                RightShAngle_shrink = RightShAngle_shrink(t+dt_trapZ_pulse:end);
                HipAngle_shrink = HipAngle_shrink(t+dt_trapZ_pulse:end);
                Torque_R_shrink = Torque_R_shrink(t+dt_trapZ_pulse:end);
                Torque_L_shrink = Torque_L_shrink(t+dt_trapZ_pulse:end);
                bPulseFinish = false;
            end
        end
        bPulseFinish = true;
    end
end




end

