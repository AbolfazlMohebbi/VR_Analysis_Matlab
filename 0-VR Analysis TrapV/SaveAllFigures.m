function SaveAllFigures(DestinationFolder, filetype)
mkdir(DestinationFolder);
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
    FigHandle = FigList(iFig);
    FigName   = strcat('Fig',num2str(get(FigHandle, 'Number')));
    set(0, 'CurrentFigure', FigHandle);
    %savefig(FigHandle, fullfile(DestinationFolder, [FigName, '.fig'])); 
    saveas(FigHandle, fullfile(DestinationFolder, [FigName, filetype]));   
end
%Adjust the FigName to your needs.

end

