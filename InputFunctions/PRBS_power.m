prbs100 = nldat;set(prbs100,'dataSet',PRBS100,'domainIncr',.02);
prbs100_power = spect(prbs100,'nFFT',200);hold on

prbs200 = nldat;set(prbs200,'dataSet',PRBS200,'domainIncr',.02);
prbs200_power = spect(prbs200,'nFFT',200);

prbs400 = nldat;set(prbs400,'dataSet',PRBS400,'domainIncr',.02);
prbs400_power = spect(prbs400,'nFFT',200);


prbs800 = nldat;set(prbs800,'dataSet',PRBS800,'domainIncr',.02);
prbs800_power = spect(prbs800,'nFFT',200);

subplot(211)
plot(prbs100);hold on
plot(prbs200)
plot(prbs400)
plot(prbs800)
ylim([-1 1])

subplot(212)
plot(prbs100_power);hold on
plot(prbs200_power);
plot(prbs400_power);
plot(prbs800_power);
legend('PRBS100','PRBS200','PRBS400','PRBS800')
set(gcf,'Units','Normalized','OuterPosition',[.1 .1 .9 .9]);
