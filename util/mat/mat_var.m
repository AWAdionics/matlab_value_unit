function data = mat_var(file_name)
    %mat_var loads variables from a specified .mat file
    %
    % All such files are in data/mat
    %
    %   :param file_name: char of file name
    %
    %   :param data: struct of file data
    %   
    %   see also util_index (index)

    % Get the path of the current function's file
    functionDir = fileparts(mfilename('fullpath'));  % Get the directory of this function
    % Define the relative path to the Excel file from the function directory
    file_path = fullfile(functionDir, '..','..', 'data', 'mat', file_name);  % Navigate up two levels

    % Check if the file exists
    if exist(file_path, 'file') ~= 2
        error('The specified .mat file does not exist.');
    end
    
    % Load the variables from the .mat file
    data = load(file_path);
    
    % Optionally, assign the loaded variables to the base workspace (optional)
    % This will assign each variable to the workspace with the name given in the .mat file
    %fieldNames = fieldnames(data);
    %for i = 1:length(fieldNames)
    %    assignin('base', fieldNames{i}, data.(fieldNames{i}));
    %end
end
