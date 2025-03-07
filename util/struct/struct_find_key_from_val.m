function key = struct_find_key_from_val(astruct,val)
    %struct_find_key_from_val get key of val
    %
    % given a val finds the corresponding key in a
    % struct, assumes this value is unique (if not, will return only first item)
    %
    %   :param astruct: struct which contains a value
    %   :param val: value to be found in struct
    %
    %   :returns key: key corresponding to value
    %
    %   see also util_index (index)
    keys = struct_keys(astruct);
    for i=1:length(keys)
        if astruct.(keys{i}) == val 
            key = keys{i};
            return
        end
    end
    error('MATLAB:ValueNotFound',['struct_find_key_from_val could not find ',val])
end