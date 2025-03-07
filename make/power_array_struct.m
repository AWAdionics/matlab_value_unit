function unit_struct = power_array_struct(unit_array)
    unit_struct = struct();
    for i=1:length(constants_mavu.accepted_units)
        unit = constants_mavu.accepted_units{i};
        unit_struct.(unit) = unit_array(i);
    end
end