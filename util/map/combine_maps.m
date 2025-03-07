function combinedMap = combine_maps(map1, map2,merge_duplicate)
    %combine_maps combines two containers.Map objects.
    %
    % Throws an error if any key is repeated in both maps.
    %
    %   :param map1: First containers.Map object
    %   :param map2: Second containers.Map object
    %
    %   :returns combinedMap: the resulting containers.Map after combining map1 and map2
    %
    %   see also util_index (index)
    if nargin < 3
        merge_duplicate = false;
    end

    % Create a new map to store the combined result
    combinedMap = containers.Map;
    
    % Get the keys of both maps
    mapKeys1 = keys(map1);
    mapKeys2 = keys(map2);
    
    % Check for repeated keys and throw an error if found
    repeatedKeys = intersect(mapKeys1, mapKeys2);
    if ~isempty(repeatedKeys)
        if merge_duplicate
            % Merge the values for duplicate keys by concatenating
            for k = 1:length(repeatedKeys)
                key = repeatedKeys{k};
                map1_value = map1(key);
                map2_value = map2(key);
                
                if isa(map1_value, 'containers.Map') && isa(map2_value, 'containers.Map')
                    % If both values are maps, recursively merge them
                    combinedMap(key) = combine_maps(map1_value, map2_value, merge_duplicate);
                else
                    % If values are not maps (or one of them is not a map), concatenate them as arrays
                    combinedMap(key) = [map1_value, map2_value];  % Modify this based on the desired merging logic
                end
            end
        else
            error('MATLAB:containers:Map:DuplicateKey','Duplicate keys found: %s', strjoin(repeatedKeys, ', '));
        end
    end
    % Add all entries from map1 to combinedMap
    for i = 1:length(mapKeys1)
        %unless it already is in combinedMap (from duplicate merge)
        if ~isKey(combinedMap, mapKeys1{i})
            combinedMap(mapKeys1{i}) = map1(mapKeys1{i});
        end
    end
    
    % Add all entries from map2 to combinedMap
    for i = 1:length(mapKeys2)
        %unless it already is in combinedMap (from duplicate merge)
        if ~isKey(combinedMap, mapKeys2{i})
            combinedMap(mapKeys2{i}) = map2(mapKeys2{i});
        end
    end
    
end
