function cell_char = char_quick_split(to_split_char,split_char)
    %char_quick_split splits a char quickly given a separtor
    %   
    % Various alternatives have been tested, this was found to be the best
    % for our project (a lot splitting of small chars)
    %
    %   :param to_split_char: char to be split
    %   :param split_char: char used to separate parts to be split
    %
    %   :returns cell_char: cell of split chars
    %
    %   see also util_index (index)

    if contains(to_split_char,split_char)
        %strsplit implementation (slow)
        %cell_char = strsplit(to_split_char,split_char);%splits
        %textscan implementation (30% faster for many entries, 1000% faster for large entries)
        %cell_char = textscan(to_split_char,'%s','Delimiter',split_char,'Whitespace','');%altsplit
        %cell_char = transpose(cell_char{1});
        %regexp 60% faster for many entries, ~200-500% faster for large entries

        cell_char = regexp(to_split_char, ['[^' split_char ']+'], 'match');
        %if delimiter is first, add empty array, mirroring strsplit
        %behaviour
        if to_split_char(1) == split_char
            cell_char = [{''},cell_char];
        end
    else
        cell_char = {to_split_char};
    end
end