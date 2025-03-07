function combinedKeys = combine_map_cell(map, cellArray)
    %combine_map_cell combines the keys of a containers.Map with a given cell array of keys.
    %
    % Throws an error if there are any duplicate keys between the map and the cell array.
    %
    %   :param map: a containers.Map object
    %   :param cellArray: a cell array of keys
    %
    %   :returns combinedKeys: a cell array of both the map keys and the cell array keys
    %
    %   see also util_index (index)
    
    % Get the keys of the map
    mapKeys = keys(map);  % Retrieve keys from the map (this is a cell array)
    
    % Check for duplicated keys between map keys and cell array
    duplicatedKeys = intersect(mapKeys, cellArray);
    if ~isempty(duplicatedKeys)
        error('MATLAB:containers:Map:DuplicateKey','Duplicate keys found: %s', strjoin(duplicatedKeys, ', '));
    end
    
    % Combine the map keys and cell array keys
    combinedKeys = [mapKeys, cellArray];
end