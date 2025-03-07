function switched_map = map_order_switch(input_map)
    %map_order_switch given a nested map returns a nested map but reversed inner keys become outer keys, outerkeys become inner keys
    %
    %   :param input_map: input map
    %
    %   :returns switched_map: switched map
    %
    %   see also util_index (index)


    keys_outer = keys(input_map);
    key_1 = keys_outer(1);
    keys_inner = keys(input_map(key_1{1}));
    switched_map = containers.Map;

    for j=1:length(keys_inner)
        current_key_inner = keys_inner(j);
        current_key_inner = current_key_inner{1};
        new_interior_map = containers.Map;

        for i=1:length(keys_outer)
            current_key_outer = keys_outer(i);
            current_key_outer = current_key_outer{1};
            current_map_outer = input_map(current_key_outer);

            if isKey(current_map_outer, current_key_inner)
                new_interior_map(current_key_outer) = current_map_outer(current_key_inner);
            else
                error('MATLAB:containers:Map:KeyDiff','Interior containers do not share keys.')
            end
            
        end
        switched_map(current_key_inner) = new_interior_map;
    end 
end
