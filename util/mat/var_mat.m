function var_mat(file_name,vars, var_names)
    %var_mat saves variables to a specified .mat file
    %
    % All such files are in data/mat
    %
    %   :param file_name: name of new .mat
    %   :param vars: variables to save
    %   :param var_names: set of charname of variables to save
    %
    %   see also util_index (index)

    % Check if the input vars and var_names are the same length
    if length(vars) ~= length(var_names)
        error('The number of variables and variable names must be the same.');
    end
    
    % Create a structure to hold the variables and their names
    variables_struct = struct();
    for i = 1:length(vars)
        variables_struct.(var_names{i}) = vars{i};
    end

    % Get the path of the current function's file
    functionDir = fileparts(mfilename('fullpath'));  % Get the directory of this function
    % Define the relative path to the Excel file from the function directory
    file_path = fullfile(functionDir, '..','..', 'data', 'mat', file_name);  % Navigate up two levels
    
    % Save the variables structure to the specified .mat file
    save(file_path, '-struct', 'variables_struct');
end