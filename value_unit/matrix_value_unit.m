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

        function multiplier = same_unit(self,other)
            if isequal(self.unit.power,other.unit.power)
                multiplier = prod(other.unit.prefix./self.unit.prefix);
            else
                error('UnitMismatch')
            end
        end

        function new = plus(self,other) 
            %plus overloads +
            multiplier = self.same_unit(other);
            new = matrix_value_unit(self.value+multiplier.*other.value,self.unit);
        end

        function equals = eq(self,other)
            %plus overloads ==
            multiplier = self.same_unit(other);
            equals = self.value == (multiplier.*other.value);
        end

        function equal = isequal(self,other)
            %plus overloads isequal
            equal = all(self.eq(other));
        end

    end
end