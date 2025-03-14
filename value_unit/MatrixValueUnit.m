classdef MatrixValueUnit
    properties
        value
        unit
    end

    properties (Dependent)
        is_unitless
    end

    methods
        function self = MatrixValueUnit(value,unit)
            self.value = value;
            self.unit = unit;
        end


        %% Unit Handlers

        function multiplier = same_unit(self,other)
            %same_unit by what does other need to be multiplied to match self ?
            if isequal(self.unit.power,other.unit.power)
                multiplier = prod(other.unit.prefix./self.unit.prefix);
            else
                error('MatrixValueUnit:UnitMismatch','Units do not match');
            end
        end

        function [multiplier,new_unit] = combine_unit(self,other)
            %combine_unit combines two units, first matches shared units then combines (adding powers) units
            new_unit = struct();
            %Prefixes are those of self...
            new_unit.prefix = self.unit.prefix;
            %except when self does not have a unit, where they are those of other
            new_unit.prefix(self.unit.power==0) = ...
                other.unit.prefix(self.unit.power==0);
            
            %multiplier if difference in prefixes
            multiplier = prod(other.unit.prefix./new_unit.prefix);

            %power is the sum of powers
            new_unit.power = self.unit.power + other.unit.power;
        end

        function new_unit = power_unit(self,pow)
            %power_unit returns unit with same prefixes but powers multipleid by power
            new_unit = self.unit;
            new_unit.power = new_unit.power.*pow;
        end

        function unitless = get.is_unitless(self)
            unitless = all(self.unit.power(:) == 0);
        end
        %%


        %% Logical Overloads

        function equals = eq(self,other)
            %plus overloads ==
            multiplier = self.same_unit(other);
            equals = self.value == (multiplier.*other.value);
        end

        function equal = isequal(self,other)
            %plus overloads isequal
            try
                multiplier = self.same_unit(other);
                equal = isequal(self.value,other.value.*multiplier);
            catch ME
                if strcmp(ME.identifier, 'MatrixValueUnit:UnitMismatch')
                    equal = false;
                else
                    rethrow(ME); % Rethrow other errors
                end
            end
        end

        function greater = gt(self,other)
            %gt overloads >
            multiplier = self.same_unit(other);
            greater = self.value > (multiplier*other.value);
        end

        function greater_equals = ge(self,other)
            %ge overloads >=
            multiplier = self.same_unit(other);
            greater_equals = self.value >= (multiplier*other.value);
        end

        function lesser = lt(self,other)
            %lt overloads <
            multiplier = self.same_unit(other);
            lesser = self.value < (multiplier*other.value);
        end

        function lesser_equals = le(self,other)
            %le overloads <=
            multiplier = self.same_unit(other);
            lesser_equals = self.value <= (multiplier*other.value);
        end
        %%
        
        %% Arithmatic Overloads
        function new = plus(self,other) 
            %plus overloads +
            multiplier = self.same_unit(other);
            new = MatrixValueUnit(self.value+multiplier.*other.value,self.unit);
        end

        function new = minus(self,other)
            %minus overloads -
            multiplier = self.same_unit(other);
            new = MatrixValueUnit(self.value-multiplier.*other.value,self.unit);
        end

        function new = times(self,other)
            %times overloads .*
            [multiplier,new_unit] = self.combine_unit(other);
            new = MatrixValueUnit(self.value*multiplier.*other.value,new_unit);
        end

        function new = rdivide(self,other)
            %rdivides overloads ./
            [multiplier,new_unit] = self.combine_unit(other);
            new = MatrixValueUnit(self.value./(other.value*multiplier),new_unit);
        end

        function new = ldivide(self,other)
            %ldivides overloads .\
            [multiplier,new_unit] = self.combine_unit(other);
            new = MatrixValueUnit(self.value.\(other.value*multiplier),new_unit);
        end

        function new = power(self,pow)
            %power overloads .^
            new_unit = self.power_unit(pow);
            new = MatrixValueUnit(self.value.^pow,new_unit);
        end

        function new = mtimes(self,other)
            %mtimes overloads *
            [multiplier,new_unit] = self.combine_unit(other);
            new = MatrixValueUnit(self.value*(other.value*multiplier),new_unit);
        end

        function new = mrdivide(self,other)
            %mrdivides overloads /
            [multiplier,new_unit] = self.combine_unit(other);
            new = MatrixValueUnit(self.value/(other.value*multiplier),new_unit);
        end

        function new = mldivide(self,other)
            %mldivides overloads \
            [multiplier,new_unit] = self.combine_unit(other);
            new = MatrixValueUnit(self.value\(other.value*multiplier),new_unit);
        end

        function new = mpower(self,pow)
            %mpower overloads ^
            new_unit = self.power_unit(pow);
            new = MatrixValueUnit(self.value^pow,new_unit);
        end
        
        %%

        %% Common Operator Overloads
        function new = abs(self)
            new = MatrixValueUnit(abs(self.value),self.unit);
        end

        function new = exp(self)
            %exp overloads exp
            if self.is_unitless
                new = MatrixValueUnit(exp(self.value),self.unit);
            else
                error('MatrixValueUnit:ExpectedUnitless','Expected Unitless for exponential.')
            end
        end

        function new = log(self)
            %log overloads log
            if self.is_unitless
                new = MatrixValueUnit(log(self.value),self.unit);
            else
                error('MatrixValueUnit:ExpectedUnitless','Expected Unitless for log.')
            end
        end

        function sum_ = sum(self,dim)
            if nargin < 2
                dim = 1;
            end
            sum_ = MatrixValueUnit(sum(self.value,dim),self.unit);
        end

        function prod_ = prod(self,dim)
            if nargin < 2
                dim = 1;
            end
            shape = size(self);
            new_unit = self.power_unit(shape(dim));
            prod_ = MatrixValueUnit(prod(self.value,dim),new_unit);
        end
        %%

        %% Matrix
        function out = subsref(self,S)
            %subsref overloads getting an index (Avu(i,j))
            if strcmp(S(1).type, '()')
                out = MatrixValueUnit(self.value(S(1).subs{:}),self.unit);
            else
                out = builtin('subsref', self, S); % Default behavior
            end
        end

        function self = subsasgn(self, S, value)
            %subsasgn overloads setting an index (Avu(i,j)=value)
            if strcmp(S(1).type, '()')
                self.value(S(1).subs{:}) = value;
            else
                self = builtin('subsasgn', self, S, value); % Default behavior
            end
        end

        function self_transposed = transpose(self)
            self_transposed = MatrixValueUnit(transpose(self.value),self.unit);
        end

        function self_ctransposed = ctranspose(self)
            self_ctransposed = MatrixValueUnit(ctranspose(self.value),self.unit);
        end

        function shape = size(self)
            shape = size(self.value);
        end

        function len = length(self)
            len = length(self.value);
        end
        
        function ndims_ = ndims(self)
            ndims_ = ndims(self.value);
        end

        function isdiag_ = isdiag(self)
            isdiag_ = isdiag(self.value);
        end
        %%

        %% Utility
        function nans = isnan(self)
            nans = isnan(self.value);
        end

        function infs = isinf(self)
            infs = isinf(self.value);
        end

        function issparse_ = issparse(self)
            issparse_ = issparse(self.value);
        end

        function disp(self)
            % Get the number of rows
            [numRows, numCols] = size(self.value);
        
            % Print each row of the matrix
            for i = 1:numRows
                fprintf('%4d ', self.value(i, :));  % Print matrix row with spacing
                if i == numRows  % Append string only to the last row
                    fprintf('%s', write_unit(self.unit));
                end
                fprintf('\n'); % Move to the next line
            end
        end

        function display(self)
            self.disp()
        end
        %%
    end
end