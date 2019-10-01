function vr_input_deg = inputVolts2Deg_App(SubjIndex, Experiment, Amp, vr_input_volts, NN)

vr_input_deg = (Amp/2) * ((vr_input_volts/2.5) - 1.0);        


end

