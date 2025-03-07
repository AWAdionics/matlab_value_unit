function keys = struct_keys(s)
    %struct_keys Returns keys of struct
    %
    %   converts numeric strings to numerics if needed
    %
    %   :param s: struct
    %
    %   :returns keys: cell array of keys
    %
    %   see also util_index (index)
    
    keys = fieldnames(s);
    for i=1:length(keys)
        prefix = 'amnum_';
        if length(keys{i}) > length(prefix)
            if strncmp(keys{i}, prefix, length(prefix))
                remainder_str = keys{i}(length(prefix) + 1:end);
                numeric_value = str2double(remainder_str);
                if mod(numeric_value,1) == 0
                    numeric_value = int32(numeric_value);
                end
                keys{i} = numeric_value(1);
            end
        end
    end
end