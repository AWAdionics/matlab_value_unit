function missingKeys = map_not_keys(map, keys_)
    % Function to check if all keys of the map are in the given cell array
    % and return the keys that are not in the map.
    %
    %   :param map: a containers.Map object
    %   :param keys: a cell array of keys to check
    %
    %   :returns missingKeys: cell array of keys from `keys` that are not in the map
    %
    %   see also util_index (index)

    % Check if all map keys are present in the input `keys` cell array
    mapKeys = keys(map);  % Retrieve all the keys in the map
    
    for i = 1:length(mapKeys)
        if ~ismember(mapKeys{i}, keys_)
            error('MATLAB:containers:Map:map_key_not_in_keys_','The key "%s" from the map is not found in the input keys array.', mapKeys{i});
        end
    end
    
    % Now, find which keys from the input are NOT in the map
    missingKeys = setdiff(keys_, mapKeys);
    
end
