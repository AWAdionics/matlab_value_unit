function found_col = excel_find_col(file_name,sheet_name,entry,row,max_col)
    %excel_find_col finds the column corresponding to entry and returns it
    %
    % All excels are in data/excel
    %
    %   :param file_name: char name of excel file
    %   :param sheet_name: char name of sheet to check
    %   :param entry: char of entry to check (does not work for numbers)
    %   :param row: number of row we expect to find entry in (default 1)
    %   :param max_col: numer of columns to check (default 100)
    %
    %   :returns found_col:
    %
    %   see also util_index (index)
    
    %% defaults
    if nargin < 5
        max_col = 100;
    end
    if nargin <4 
        row = 1;
    end
    %%

    %% entry adjust
    entry = strrep(entry, ' ', '');
    %%
    
    %% Find Loop
    found_col = 'inexistant';
    for col=1:max_col
        trial_entry = excel_entry(file_name,sheet_name,row,col);
        trial_entry = strrep(trial_entry, ' ', '');
        if strcmp(trial_entry,entry)
            found_col = col;
            return
        end
    end
    %%
end

