function Output = PRTS_Generator(NumOfPeriods, SwitchingRate, timeRes, VelocityAmp)

% Example : 
% PRTS_Pos = PRTS(PRTS_NumPeriod, PRTS_dt, PRTS_dtVR, PRTS_Velocity);
%
% PRTS_dtVR = 0.011111f; //Time resolution (time per frame) measured for VR device with FixedUpdate() method       
% PRTS_Kt = 20; // How many frames per each PRTS input
% PRTS_dt = PRTS_Kt * PRTS_dtVR;  // switching rate for PRTS inputs
% PRTS_NumPeriod = 6;
% PRTS_TimeTotal = 242 * PRTS_dt * PRTS_NumPeriod;


dt = DateTime.Now;
dateString = dt.ToString("dd-MM-yyyy_hh-mm");

TextWriter PRTS_posFile = new StreamWriter("log/Offline/PRTS/PRTS_Pos_" + dateString + ".txt");  // Write to file
TextWriter PRTS_velFile = new StreamWriter("log/Offline/PRTS/PRTS_Vel_" + dateString + ".txt");  // Write to file
int repeatCount = (int)Math.Round(SwitchingRate / timeRes);

int[] ShiftRegisters = {2, 0, 2, 0, 2};
int m = 5;
int[] VelocitySequence = new int[NumOfPeriods * ((int)Math.Pow(3, m) - 1)]; // T = (3^m - 1).dt
float[] PositionSequence = new float[NumOfPeriods * repeatCount * ((int)Math.Pow(3, m) - 1)];
float[] VelocityVector = new float[NumOfPeriods * ((int)Math.Pow(3, m) - 1)];
float[] VelocityVectorExtended = new float[NumOfPeriods * repeatCount * ((int)Math.Pow(3, m) - 1)];
PositionSequence[0] = 0.0f;
PRTS_posFile.WriteLine(PositionSequence[0] + ",");

for (int k = 1; k <= VelocitySequence.Length; k++)
    {
        VelocitySequence[k-1] = cmod( (ShiftRegisters[2] - ShiftRegisters[3] - ShiftRegisters[4]), 3);
        ShiftRegisters[4] = ShiftRegisters[3];
        ShiftRegisters[3] = ShiftRegisters[2];
        ShiftRegisters[2] = ShiftRegisters[1];
        ShiftRegisters[1] = ShiftRegisters[0];
        ShiftRegisters[0] = VelocitySequence[k-1];
        if (k % ((int)Math.Pow(3, m) - 1) == 1)
        {
            ShiftRegisters[0] = 0;
            ShiftRegisters[1] = 2;
            ShiftRegisters[2] = 0;
            ShiftRegisters[3] = 2;
            ShiftRegisters[4] = 0;
            }
        //print("VelocitySequence[" + k + "] = " + VelocitySequence[k-1]);
        //PRTS_velFile.WriteLine(VelocitySequence[k - 1] + ",");
        }
        
        // scale to -v and v:   0-->0  1-->v  2-->-v
        for (int k = 0; k < VelocitySequence.Length; k++)
            {
                if (VelocitySequence[k] == 1) { VelocityVector[k] = VelocityAmp; }
                if (VelocitySequence[k] == 2) { VelocityVector[k] = -VelocityAmp; }
                    if (VelocitySequence[k] == 0) { VelocityVector[k] = 0; }
                        }
                        
                        // repeat elements based on switching rate and update rate
                        for (int k = 1; k <= VelocityVector.Length; k++)
                            {
                                for (int i = 0; i< repeatCount; i++)
                                {
                                    VelocityVectorExtended[repeatCount * (k - 1) + i] = VelocityVector[k - 1];
                                    PRTS_velFile.WriteLine(VelocityVectorExtended[repeatCount * (k - 1) + i] + ",");
                                    }
                                }
                                
                                // Integral of velocity = position
                                for (int i = 1; i < PositionSequence.Length; i++)
                                    {
                                        PositionSequence[i] = (VelocityVectorExtended[i] * timeRes) + PositionSequence[i - 1];
                                        PRTS_posFile.WriteLine(PositionSequence[i] + ",");
                                        }
                                    
                                    PRTS_posFile.Close();
                                    PRTS_velFile.Close();
                                    return PositionSequence;




end

