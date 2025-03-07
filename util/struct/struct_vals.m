function values = struct_vals(s)
    %struct_vals returns the values of the struct s
    %
    %   :param s: struct
    %
    %   :returns values: cell array of values
    %
    %   see also util_index (index)
    values = struct2cell(s);
end