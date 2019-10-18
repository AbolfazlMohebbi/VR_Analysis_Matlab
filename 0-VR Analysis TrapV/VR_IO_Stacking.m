function  StackSignal = VR_IO_Stacking(SignalSegments)

StackSignal = [];
for i=1:size(SignalSegments,1)    
    StackSignal = [StackSignal, SignalSegments(i, :)];    
end


end

