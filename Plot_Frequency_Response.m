%% Frequency Response 
nOverlap = nFFT/(2*dr);

figure(14)
plot(fresp(vr2tqL_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> left tq ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
allAxesInFigure = findall(gcf,'type','axes');
set(allAxesInFigure(1), 'XScale', 'log')
set(allAxesInFigure(2), 'XScale', 'log')
set(allAxesInFigure(3), 'XScale', 'log')

figure(15)
plot(fresp(vr2tqR_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> right tq ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
allAxesInFigure = findall(gcf,'type','axes');
set(allAxesInFigure(1), 'XScale', 'log')
set(allAxesInFigure(2), 'XScale', 'log')
set(allAxesInFigure(3), 'XScale', 'log')

figure(16)
plot(fresp(vr2shankL_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> left shank angle ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
allAxesInFigure = findall(gcf,'type','axes');
set(allAxesInFigure(1), 'XScale', 'log')
set(allAxesInFigure(2), 'XScale', 'log')
set(allAxesInFigure(3), 'XScale', 'log')

figure(17)
plot(fresp(vr2shankR_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> right shank angle ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
allAxesInFigure = findall(gcf,'type','axes');
set(allAxesInFigure(1), 'XScale', 'log')
set(allAxesInFigure(2), 'XScale', 'log')
set(allAxesInFigure(3), 'XScale', 'log')

figure(18)
plot(fresp(vr2hip_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> Hip angle ');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
allAxesInFigure = findall(gcf,'type','axes');
set(allAxesInFigure(1), 'XScale', 'log')
set(allAxesInFigure(2), 'XScale', 'log')
set(allAxesInFigure(3), 'XScale', 'log')

figure(19)
plot(fresp(vr2tqSum_decimated,'nFFT',nFFT/dr,'nOverlap', nOverlap));
title('FR: VR -> Sum Torque');hold on
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
allAxesInFigure = findall(gcf,'type','axes');
set(allAxesInFigure(1), 'XScale', 'log')
set(allAxesInFigure(2), 'XScale', 'log')
set(allAxesInFigure(3), 'XScale', 'log')









