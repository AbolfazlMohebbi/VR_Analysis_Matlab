function Trials_Data = removeNAN(Trials_Data)

fields = fieldnames(Trials_Data);
for i = 1:numel(fields)
    bufferData = Trials_Data.(fields{i});
    bufferData = bufferData(~isnan(bufferData));
    Trials_Data.(fields{i}) = bufferData;
end

end

