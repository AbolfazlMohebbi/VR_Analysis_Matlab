function teta=angle_cal(d,d0,h)
% This function calculates the angle of the shank
% the inputs are:
%           h  scalar, the height of the laser relative the axis of rotation (mm)
%           d  the vector of the distances measured by the laser
%           d0 initial distance between the laser and the shank
% the equation is true assuming the shank is verticl at the start;
% for shanks the output is positive when the shank rotates CCW, consistent
% with the pedals.
teta=-atan((d0-d)/h);