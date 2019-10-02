function QS = QuietStance(data , fc, tQS , flag)
% This function estimates the offsets of torques and angle during quiet
% stance to find the analges in perturbed trials.
%
% input: 
%       data: the data structure collected using spastic which contains
%           collected data during quiet stance.
% 
% output:
%       QS: structure data containting:
%           dLeftSh_QS: mean distance of laser to the shank during QS
%           dRighSh_QS: mean distance of laser to the shank during QS
%           dHip_QS: mean distance of laser to the Hip during QS
%           tetaFootL_QS: mean left foot angle oduring QS
%           tetaFootR_QS: mean left foot angle oduring QS
%           TL_QS: mean left torque during quiet stance
%           TR_QS: mean right torque during quiet stance
%           By Pouya Amiri, Sep 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
N = data.chanLen;SR = 1/data.domainIncr; 
LasDel = 4;
vLeft = data.Data(1:N,14);vRight = data.Data(1:N,13);vHip = data.Data(1:N,12);
[dLeftSh,dRightSh,dHip] = LasDisQS(vLeft(LasDel:end),vRight(LasDel:end),vHip(LasDel:end));
% filtering the data using Bessel filter
% % % [fil_num,fil_den] = besself(10,2*pi*fc);
% % % dis_fil = c2d(tf(fil_num,fil_den),1/SR);
% % % tetaFootL = filtfilt(cell2mat(dis_fil.num),cell2mat(dis_fil.den),data.Data(1:N - LasDel + 1,1));
% % % tetaFootR = filtfilt(cell2mat(dis_fil.num),cell2mat(dis_fil.den),data.Data(1:N - LasDel + 1,3));
% % % TL = filtfilt(cell2mat(dis_fil.num),cell2mat(dis_fil.den),data.Data(1:N - LasDel + 1,2));
% % % TR = filtfilt(cell2mat(dis_fil.num),cell2mat(dis_fil.den),data.Data(1:N - LasDel + 1,4));

% Butterworth filter
[fil_num,fil_den] = butter(10,fc/(SR/2));
tetaFootL = filtfilt(fil_num,fil_den,data.Data(1:N - LasDel + 1,1));
tetaFootR = filtfilt(fil_num,fil_den,data.Data(1:N - LasDel + 1,3));
TL = filtfilt(fil_num,fil_den,data.Data(1:N - LasDel + 1,2));
TR = filtfilt(fil_num,fil_den,data.Data(1:N - LasDel + 1,4));

% offset values during quiet stance
aa = int32(tQS*SR);
QS.dLeftSh_QS = mean(dLeftSh(1:aa));
QS.dRightSh_QS = mean(dRightSh(1:aa));
QS.dHip_QS = mean(dHip(1:aa));
QS.tetaFootL_QS = mean(tetaFootL(1:aa));
QS.tetaFootR_QS = mean(tetaFootR(1:aa));
QS.TL_QS = mean(TL(1:aa));
QS.TR_QS = mean(TR(1:aa));

% plot
t = 0 : 1/SR: (length(dLeftSh)-1)/SR;
if flag=='y'
    subplot(421)
    plot(t,dLeftSh);
    set(gca,'fontsize',14);title(['Left Shank distance' num2str(QS.dLeftSh_QS)],'fontsize',14);
    subplot(422)
    plot(t,dRightSh);
    set(gca,'fontsize',14);title(['Right Shank distance' num2str(QS.dRightSh_QS)],'fontsize',14);
    subplot(423)
    plot(t,dHip);
    set(gca,'fontsize',14);title(['Hip distance' num2str(QS.dHip_QS )],'fontsize',14);
    subplot(424)
    plot(t,tetaFootL);
    set(gca,'fontsize',14);title(['Left foot angle' num2str(QS.tetaFootL_QS )],'fontsize',14);
    subplot(425)
    plot(t,tetaFootR);
    set(gca,'fontsize',14);title(['Right foot angle' num2str(QS.tetaFootR_QS )],'fontsize',14);
    subplot(426)
    plot(t,TL);
    set(gca,'fontsize',14);title(['Left TQ' num2str(QS.TL_QS)],'fontsize',14);
    xlabel('Time (s)','fontsize',14)
    subplot(427)
    plot(t,TR);
    set(gca,'fontsize',14);title(['Right TQ' num2str(QS.TR_QS)],'fontsize',14);
    xlabel('Time (s)','fontsize',14)
end
% pause;

