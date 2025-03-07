classdef matrix_value_unit
    properties
        value
        unit
    end

    methods
        function self = matrix_value_unit(value,unit)
            self.value = value;
            self.unit = unit;
        end
    end
end