function unit_struct = make_unit(input_char)
%make_unit makes a unit struct from an input char
%   
%   Args :
%       input_char : char of unit to construct
%   
%   returns:
%       unit_struct : struct of composite units struct(unit_name,struct(prefix,power))
%
%   see also name_prefixunit (used)
%   char_quick_split (used)

function [unit_char,prefix_power_struct,char_id] = unitpower_to_unit_power(unit_power_char,positive)
    %unitpower_to_unit_power turns a unit with power char into a unit and prefix-power struct
    %
    % Args:
    %   unit_power_char : char of unit + power (unit^power)
    %   positive : 1 or -1 depending on if unit positive (which side of /)
    %
    % returns:
    %   unit_char : char of unit
    %   prefix_power_struct : struct containing prefix and power of unit

    if contains(unit_power_char, '^')
        %If there is a '^' charachter in unit_power_char, extract the power
        unit_power_char_split = char_quick_split(unit_power_char,'^');
        [prefix_char,unit_char,char_id] = name_prefixunit(unit_power_char_split{1});
        power = positive*str2double(unit_power_char_split{2});
    else
        %If not the power is equal to 1
        [prefix_char,unit_char,char_id] = name_prefixunit(unit_power_char);
        power = positive;
    end
    if prefix_char ~= ' '
        prefix_power_struct = struct( ...
            'prefix', constants_mavu.prefixes_multiplier.(prefix_char), ...
            'power',power);
    else
        prefix_power_struct = struct( ...
            'prefix',1, ...
            'power',power);
    end
end
function output_struct = make_unit_struct(output_struct,all_prefix_unit_power_char,positive)
    %make_unit_struct constructs full composite unit struct
    %
    % Args:
    %   output_struct : struct of output
    %   all_prefix_unit_power_char : char of one side of /
    %   positive : 1 if on left of / -1 if on right

    prefix_unit_power_chars = char_quick_split(all_prefix_unit_power_char,'*');
    for j=1:length(prefix_unit_power_chars)
        [unit_char,prefix_power_struct,char_id] = unitpower_to_unit_power(prefix_unit_power_chars{j},positive);
        if ~isfield(output_struct.power,unit_char)
            output_struct.power(char_id) = prefix_power_struct.power;
            output_struct.prefix(char_id) = prefix_power_struct.prefix;
        else
            error('Unit %s is defined twice',unit_char)
        end
    end
end

unit_struct = struct('prefix',ones(length(constants_mavu.accepted_units),1), ...
                     'power',zeros(length(constants_mavu.accepted_units),1));
if strcmp(input_char,'')
    return
end

%splits positive and negative
unit_char_split = char_quick_split(input_char,'/');

unit_struct = make_unit_struct(unit_struct,unit_char_split{1},1);
if length(unit_char_split) > 1
    unit_struct = make_unit_struct(unit_struct,unit_char_split{2},-1);
end
end