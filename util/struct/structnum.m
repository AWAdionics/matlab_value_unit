function formatted_str = structnum(num)
    %structnum writes a number in scientificnotation appropriate for struct (defunct)
    %
    %   :param num: float input
    %
    %   :returns formatted_str: char of formatted output
    %
    %   see also util_index (index)

    % Extract the base and exponent from the scientific notation
    exponent = log10(abs(num));
    
    % Convert to scientific notation with the desired format
    if exponent < 0
        % For negative exponents, format as '1p2345en5'
        formatted_str = sprintf('%.4f', num);
        formatted_str = strrep(formatted_str, '.', 'p'); % Replace dot with 'p'
        formatted_exponent = num2str(abs(exponent));
        formatted_exponent = strrep(formatted_exponent, '.', 'p'); % Replace dot with 'p'
        formatted_str = [formatted_str, 'en', formatted_exponent];
    else
        % For non-negative exponents, format as '1p2345e5'
        formatted_str = sprintf('%.4f', num);
        formatted_str = strrep(formatted_str, '.', 'p'); % Replace dot with 'p'
        formatted_exponent = num2str(abs(exponent));
        formatted_exponent = strrep(formatted_exponent, '.', 'p'); % Replace dot with 'p'
        formatted_str = [formatted_str, 'e', formatted_exponent];
    end
end
