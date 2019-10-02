close all;

fr_body = fresp(vr2body_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap);

figure(length(findobj('type','figure'))+1)
plot(fr_body);
title('FR: VR -> Body angle ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])


figure(length(findobj('type','figure'))+1)
plot(fr_body);
title('FR: VR -> Body angle ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
allAxesInFigure = findall(gcf,'type','axes');
set(allAxesInFigure(1), 'XScale', 'log')
set(allAxesInFigure(2), 'XScale', 'log')
set(allAxesInFigure(3), 'XScale', 'log')


figure(length(findobj('type','figure'))+1)
plot(gain(fr_body), 'ymode', 'db', 'LineWidth', 2);
set(gca, 'XScale', 'log')
title('Frequency Response Gain: VR to Body Angle')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])


figure(length(findobj('type','figure'))+1)
plot(phase(fr_body)*(180/pi), 'ymode', 'linear', 'LineWidth', 2);
ylabel('Phase (degrees)')
set(gca, 'XScale', 'log')
title('Frequency Response Phase: VR to Body Angle')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

figure(length(findobj('type','figure'))+1)
plot(coherence(fr_body), 'ymode', 'linear', 'LineWidth', 2);
ylabel('Phase (degrees)')
set(gca, 'XScale', 'log')
title('Frequency Response Coherence: VR to Body Angle')
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])

