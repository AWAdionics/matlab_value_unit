function unit_char = write_unit(unit_arrays)
    
    power_struct = power_array_struct(unit_arrays.power);
    prefix_struct = prefix_array_struct(unit_arrays.prefix);

    positive_string = '';
    negative_string = '';
    has_negative = false;

    for i=1:length(constants_mavu.accepted_units)
        unit = constants_mavu.accepted_units{i};
        prefix = prefix_struct.(unit);
        if power_struct.(unit) > 0
            if power_struct.(unit) > 1
                positive_string = append(positive_string,'*',prefix,unit,'^',num2str(power_struct.(unit)));
            else
                positive_string = append(positive_string,'*',prefix,unit);
            end
        else
            if power_struct.(unit) < 0
                has_negative = true;
                if power_struct.(unit) < -1
                    negative_string = append(negative_string,'*',prefix,unit,'^',num2str(-power_struct.(unit)));
                else
                    negative_string = append(negative_string,'*',prefix,unit);
                end
            end
        end
    end
    
    positive_string(1) = [];
    if ~has_negative
        unit_char = positive_string;
    else
        negative_string(1) = [];
        unit_char = append(positive_string,'/',negative_string);
    end

end