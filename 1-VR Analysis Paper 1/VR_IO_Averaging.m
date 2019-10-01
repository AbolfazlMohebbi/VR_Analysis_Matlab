function  Segments = VR_IO_Averaging(Signal, trials, periodTime, periodCount, b_Figure)

pp = 1;
for i = 1:length(trials)
    for m = 1:periodCount % number of periods
        Segments(pp,:) = Signal(i, (m-1)*periodTime + 1 : m*periodTime);
        pp = pp + 1;
    end
end

time = 0.001 * (1:length(Segments));

if (b_Figure == 'y')    
    figure(length(findobj('type','figure'))+1);
    plot(time, Segments','linewidth',1); title(strcat(inputname(1), ' Segments and Mean'));
    hold on
    plot(time,(mean(Segments))','b-', 'linewidth', 2)
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
end


end

