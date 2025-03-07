function rows = excel_find_nonzero_rows_in_col(file_name,sheet_name,col,start_row,end_row)
    %excel_find_nonzero_rows_in_col returns the set of non-zero rows of a specified column of an excel sheet
    %
    % All excels are in data/excel
    %
    %   :param file_name: char name of the excel file
    %   :param sheet_name: char name of the sheet
    %   :param col: integer number of the column
    %   :param start_row: integer of starting row to check (default is 1)
    %   :param end_row: integer of ending row to check (default is 100)
    %
    %   :returns rows: array of non-zero rows
    %
    %   see also excel_entry (used in checks)
    %   util_index (index)

    if nargin <4
        start_row = 1;
    end
    if nargin <5
        end_row = 100;
    end
    
    rows = [];
    for row=start_row:end_row
        entry = excel_entry(file_name,sheet_name,row,col);
        if isempty(entry) || ischar(entry) || isstring(entry) || isequal(entry,0)
        else
            rows = [rows,row];
        end
    end
end

