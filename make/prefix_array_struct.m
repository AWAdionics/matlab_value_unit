function prefix_struct = prefix_array_struct(prefix_array)
    prefix_struct = struct();
    for i=1:length(constants_mavu.accepted_units)
        unit = constants_mavu.accepted_units{i};
        if prefix_array(i)~= 1
            prefix_struct.(unit) = struct_find_key_from_val( ...
                                                constants_mavu.prefixes_multiplier,...
                                                prefix_array(i));
        else
            prefix_struct.(unit) = ' ';
        end
    end
end