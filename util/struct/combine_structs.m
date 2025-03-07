function combined_struct = combine_structs(varargin)
    %Combines the structs given in vararging
    %
    %   WARNING:
    %   no overlapping field names
    %   needs at least 2 inputs
    %   
    %   :params varargin: structs (in format combine_struct(struct1,struct2,...))
    %   
    %   :returns combined_struct: struct that is combination of inputs
    %
    %   see also util_index (index)

    % Check if there are at least two structs
    if nargin < 2
        error('At least two structs must be provided.');
    end
    
    % Initialize the combined struct as the first input struct
    combined_struct = varargin{1};
    
    % Iterate over the other input structs and combine them
    for i = 2:nargin
        % Get the current struct
        currentStruct = varargin{i};
        
        % Get the field names of both the current struct and the combined struct
        fields1 = fieldnames(combined_struct);
        fields2 = fieldnames(currentStruct);
        
        % Check for overlapping field names
        overlapFields = intersect(fields1, fields2);
        if ~isempty(overlapFields)
            error('MATLAB:combine_structs:FieldNameOverlap','There is an overlap in field names: %s', strjoin(overlapFields, ', '));
        end
        
        % Add fields from the current struct to the combined struct
        for f = 1:numel(fields2)
            fieldName = fields2{f};
            combined_struct.(fieldName) = currentStruct.(fieldName);
        end
    end
end
