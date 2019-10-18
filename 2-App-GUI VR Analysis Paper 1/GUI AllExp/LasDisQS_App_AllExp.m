function [dLeftSh,dRightSh,dHip] = LasDisQS_App_AllExp(vLeft,vRight,vHip,calibParam_path)
% This function calculates the offset distances during QS.
% The inputs are:
%               vLeft:  left laser output voltage
%               vRight:  Right laser output voltage
%               vHip: Hip laser output voltage
%               hLeftSh: hight of the left laser in mm
%               hRightSh: hight of the right laser in mm
%               hHip: hight of the Hip laser in mm
% Outputs are:                     
%               LeftShaAngle: left shank angle
%               RightShaAngle: right shank angle
%               HipAngle: hip angle
% By Pouya Amiri, Sep 2016

% load LeftLaserCalibrationConstants
% load RightLaserCalibrationConstants
% load HipLaserCalibrationConstants

load(fullfile(calibParam_path, 'LeftLaserCalibrationConstants'))
load(fullfile(calibParam_path, 'RightLaserCalibrationConstants'))
load(fullfile(calibParam_path, 'HipLaserCalibrationConstants'))

% finding the distances
dLeftSh = mLeftLaser * vLeft + bLeftLaser;
dRightSh = mRightLaser * vRight + bRightLaser;
dHip = mHipLaser*vHip + bHipLaser;




