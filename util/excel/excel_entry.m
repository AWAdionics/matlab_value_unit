function entry = excel_entry(file_name, sheetName, row, col)
    %excel_entry Reads a specific entry from an Excel file.
    %
    % All excels are in data/excel
    %
    %   :param file_path: Full or relative path to the Excel file.
    %   :param sheetName: Name of the sheet (or index) in the Excel file.
    %   :param row: Row number of the entry to be read.
    %   :param col: Column number (or letter) of the entry to be read.
    %
    %   :returns entry: The value at the specified row and column.
    %
    %   see also util_index (index)
    
    % Get the path of the current function's file
    functionDir = fileparts(mfilename('fullpath'));  % Get the directory of this function
    % Define the relative path to the Excel file from the function directory
    file_path = fullfile(functionDir, '..','..', 'data', 'excel', file_name);  % Navigate up two levels to 'Project'
    
    % Check if the provided file exists
    if ~isfile(file_path)
        error('The specified Excel file does not exist: %s', file_path);
    end
    
    % Read the data from the specified sheet
    data = readcell(file_path, 'Sheet', sheetName);
    
    % Check if row and column are within the size of the data
    [numRows, numCols] = size(data);
    if row > numRows || col > numCols
        error('The specified row and column are out of bounds.');
    end
    
    % Get the value at the specified row and column
    entry = data{row, col};
end
