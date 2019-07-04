function Trials_Data = removeNAN(Trials_Data, DataType)

if nargin < 2
      DataType = 'Trials_Data';
end

if (strcmp(DataType, 'Trials_Data'))
    fields = fieldnames(Trials_Data);
    for i = 1:numel(fields)
        bufferData = Trials_Data.(fields{i});
        bufferData = bufferData(~isnan(bufferData));
        Trials_Data.(fields{i}) = bufferData;
    end
    % Trials_Data.vr_input = Trials_Data.vr_input(1:end-3);    
end

if not(strcmp(DataType, 'Trials_Data'))
    for i = 1:size(Trials_Data, 2)
        bufferData = Trials_Data(:,i);
        bufferData = bufferData(~isnan(bufferData));
        Trials_Data_New(:,i) = bufferData;
    end 
    Trials_Data = Trials_Data_New;
end


end

