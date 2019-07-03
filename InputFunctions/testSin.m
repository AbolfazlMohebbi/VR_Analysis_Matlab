t = 0:0.001:19.999;
x = sin(2*pi*t) + sin(4*pi*t);
px = nldat(x', 'domainIncr', 0.001);
plot(t, x);
figure();plot(spect(px, 'nFFT', 1000)); hold on
plot(spect(px, 'nFFT', 996)); 

