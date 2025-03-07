function vec = map_vec(map, key_order)
    %map_vec converts a containers.Map to a vector based on a predefined order of keys.
    %
    %   :param map: a containers.Map object with key-value pairs.
    %   :param key_order: a cell array of keys (strings or numbers) in the desired order.
    %
    %   :returns vec: a vector containing the values from the map corresponding to the key order.
    %
    %   see also util_index (index)

    vec = zeros(1, length(key_order));
    % Loop through the predefined key order
    for i = 1:length(key_order)
        key = key_order{i};
        
        % Check if the key exists in the map
        if isKey(map, key)
            vec(i) = map(key);
        else
            error('MATLAB:containers:Map:NoKey','Key "%s" does not exist in the map.', key);
        end
    end
end
