function s = keyvals_struct(keys,values)
    %keyvals_struct from key values make struct
    % given a cell array of keys and values returns a
    % truct if keys are numeri it will automatically transform them into
    % chars
    %   :param keys: cell array of keys
    %   :param values: cell array of values
    %
    %   :returns s: struct
    %
    %   see also util_index (index)

    % Initialize an empty struct
    s = struct();
    
    % Loop through the keys and values to assign them to the struct
    for i = 1:length(keys)
        key = keys{i};
        if isnumeric(key)
            key = ['amnum_',num2str(key)];
        end
        s.(key) = values{i};
    end
end