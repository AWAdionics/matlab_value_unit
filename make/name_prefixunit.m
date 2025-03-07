function [prefix,unit,i] = name_prefixunit(name)
    %name_prefixunit given a name that is potentiall a prefix-unit, returns the prefix unit pair (or an error)
    %
    % Args:
    %   name : char of name
    %
    % returns: 
    %   prefix : char of prefix
    %   unit : char of unit
    %
    % see also 
    
    % Loop over the units
    for i = 1:length(constants_mavu.accepted_units)
        if endsWith(name, constants_mavu.accepted_units{i})  % Check if each ends with a valid unit
            unit = constants_mavu.accepted_units{i};
            prefix_candidate = name(1:end-length(constants_mavu.accepted_units{i}));
            
            %IF yes, then check if correct prefix
            if ismember(prefix_candidate, constants_mavu.accepted_prefixes)
                prefix = prefix_candidate;
                return;
            else
                error('%s is not a valid prefix-unit combination',name)
            end
        end
    end
    
    error('%s is not a valid prefix-unit combination',name);
end
