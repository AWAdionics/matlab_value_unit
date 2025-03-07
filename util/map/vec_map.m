function map = vec_map(vec, key_order)
    %vec_map converts a vector to a containers.Map based on a predefined order of keys.
    %
    %   :param vec: a row vector containing values to be mapped.
    %   :param key_order: a cell array of keys (strings or numbers) corresponding to the values in the vector.
    %
    %   :returns map: a containers.Map object with the values from vec associated with keys from key_order.
    %
    %   see also util_index (index)

    % Check if the length of vec and key_order match
    if length(vec) ~= length(key_order)
        error('MATLAB:assertion:failed','The length of the vector and the key order must be the same.');
    end
    
    % Initialize the map
    map = containers.Map();
    
    % Loop through the vector and key order, adding key-value pairs to the map
    for i = 1:length(vec)
        key = key_order{i};
        value = vec(i);
        map(key) = value;
    end
end
