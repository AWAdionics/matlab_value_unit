function entry_excel(filename, sheetName, row, col, value)
    %entry_excel writes an entry into an excel cell
    %   
    % All excels are in data/excel
    %
    %   :param filename: char of file name
    %   :param sheetName: char of sheet name
    %   :param row: row of cell to write to
    %   :param col: col of cell to write to
    %   :param value: char (or float or int) of value to write
    %
    %   see also util_index (index)

    % Check if the value is numeric or character
    if isnumeric(value)
        value = num2str(value);  % Convert numeric values to string if needed
    end
    
    % Check if the file exists
    if exist(filename, 'file') == 2
        % File exists, write data to the specified sheet, row, and column
        writecell({value}, filename, 'Sheet', sheetName, 'Range', sprintf('%s%d', char(col+64), row));
    else
        % Create a new file if it doesn't exist
        writetable(table(value), filename, 'Sheet', sheetName, 'Range', sprintf('%s%d', char(col+64), row));
    end
end
