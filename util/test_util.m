classdef test_util < matlab.unittest.TestCase
    % Test class for map_vec and vec_map
    
    methods(Test)
        %% Map
        % Test map_vec
        function testmap_vec(testCase)
            % Create a containers.Map
            map = containers.Map({'apple', 'banana', 'cherry'}, {1, 2, 3});
            
            % Predefined order of keys
            keyOrder = {'banana', 'cherry', 'apple'};
            
            % Convert map to vector
            vec = map_vec(map, keyOrder);
            
            % Expected output
            expectedVec = [2, 3, 1];
            
            % Verify the result
            testCase.verifyEqual(vec, expectedVec);
        end
        
        % Test vec_map
        function testvec_map(testCase)
            % Define vector and key order
            vec = [2, 3, 1];
            keyOrder = {'banana', 'cherry', 'apple'};
            
            % Convert vector to map
            map = vec_map(vec, keyOrder);
            
            % Verify the key-value pairs in the map
            testCase.verifyEqual(map('banana'), 2);
            testCase.verifyEqual(map('cherry'), 3);
            testCase.verifyEqual(map('apple'), 1);
        end
        
        % Test mismatched lengths between vector and key order
        function testMismatchedLength(testCase)
            % Define vector and key order with mismatched lengths
            vec = [1, 2];
            keyOrder = {'apple', 'banana', 'cherry'};  % Too many keys
            
            % Verify that an error is thrown
            testCase.verifyError(@() vec_map(vec, keyOrder), 'MATLAB:assertion:failed');
        end
        
        % Test missing key in map_vec
        function testMissingKey(testCase)
            % Create a containers.Map
            map = containers.Map({'apple', 'banana'}, {1, 2});
            
            % Predefined order of keys with a missing key
            keyOrder = {'banana', 'cherry', 'apple'};  % 'cherry' is missing
            
            % Verify that an error is thrown
            testCase.verifyError(@() map_vec(map, keyOrder), 'MATLAB:containers:Map:NoKey');
        end

        function testAllKeysInArray(testCase)
            % Create a containers.Map
            map = containers.Map({'apple', 'banana', 'cherry'}, {1, 2, 3});
            
            % Define a cell array of keys, all of which are in the map
            keys = {'apple', 'banana', 'cherry'};
            
            % Call the function
            missingKeys = map_not_keys(map, keys);
            
            % Verify that no keys are missing
            testCase.verifyEmpty(missingKeys);  % Expected output: {}
        end
        
        function testMissingKeyError(testCase)
            % Create a containers.Map
            map = containers.Map({'apple', 'banana', 'cherry'}, {1, 2, 3});
            
            % Define a cell array of keys, one of which is missing from the map
            keys = {'apple', 'banana'};  % 'cherry' is not a key in keys
            
            % Verify that an error is raised when the missing key is found
            testCase.verifyError(@() map_not_keys(map, keys), 'MATLAB:containers:Map:map_key_not_in_keys_');
        end
        
        function testMissingKeysInInput(testCase)
            % Create a containers.Map
            map = containers.Map({'apple', 'banana'}, {1, 2});
            
            % Define a cell array of keys, some of which are not in the map
            keys = {'apple', 'kiwi', 'banana'};  % 'kiwi' is not a key in the map
            
            % Call the function
            missingKeys = map_not_keys(map, keys);
            
            % Verify that 'kiwi' is the missing key
            testCase.verifyEqual(missingKeys, {'kiwi'});  % Expected missing key: 'kiwi'
        end

        function testCombineWithoutDuplicates(testCase)
            % Create the first map
            map1 = containers.Map({'a', 'b', 'c'}, {1, 2, 3});
            
            % Create the second map
            map2 = containers.Map({'d', 'e', 'f'}, {4, 5, 6});
            
            % Call the function to combine maps
            combinedMap = combine_maps(map1, map2);
            
            % Verify that the combined map has the expected keys and values
            testCase.verifyEqual(keys(combinedMap), {'a', 'b', 'c', 'd', 'e', 'f'});
            testCase.verifyEqual(combinedMap('a'), 1);
            testCase.verifyEqual(combinedMap('b'), 2);
            testCase.verifyEqual(combinedMap('c'), 3);
            testCase.verifyEqual(combinedMap('d'), 4);
            testCase.verifyEqual(combinedMap('e'), 5);
            testCase.verifyEqual(combinedMap('f'), 6);
        end
        
        function testCombineWithDuplicateKeys(testCase)
            % Create the first map
            map1 = containers.Map({'a', 'b', 'c'}, {1, 2, 3});
            
            % Create the second map with a duplicate key 'b'
            map2 = containers.Map({'b', 'd', 'e'}, {4, 5, 6});
            
            % Verify that an error is thrown for the repeated key 'b'
            testCase.verifyError(@() combine_maps(map1, map2), ...
                'MATLAB:containers:Map:DuplicateKey');
        end

        function testMergeWithDuplicates(testCase)
            % Test case where there are duplicate keys that need to be merged
            map1 = containers.Map({'key1', 'key2'}, {{'a', 'b'}, {'c', 'd'}});
            map2 = containers.Map({'key2', 'key3'}, {{'e', 'f'}, {'g', 'h'}});
            
            % Combine maps with merge_duplicate set to true
            mergedMap = combine_maps(map1, map2, true);
            
            % Verify combined map has all keys
            testCase.verifyTrue(isKey(mergedMap, 'key1'));
            testCase.verifyTrue(isKey(mergedMap, 'key2'));  % key2 should be merged
            testCase.verifyTrue(isKey(mergedMap, 'key3'));
            
            % Verify correct merging of cell arrays for duplicate keys
            testCase.verifyEqual(mergedMap('key2'), {'c', 'd', 'e', 'f'});  % merged values
            
            % Verify other keys are unchanged
            testCase.verifyEqual(mergedMap('key1'), {'a', 'b'});
            testCase.verifyEqual(mergedMap('key3'), {'g', 'h'});
        end

        function testMergeMapsWithDuplicates(testCase)
            % Test case where there are duplicate keys that need to be merged
            map1 = containers.Map({'key1', 'key2'}, {containers.Map({'a'}, {1}), containers.Map({'b'}, {2})});
            map2 = containers.Map({'key2', 'key3'}, {containers.Map({'c'}, {3}), containers.Map({'d'}, {4})});
            
            % Combine maps with merge_duplicate set to true
            mergedMap = combine_maps(map1, map2, true);
            
            % Verify combined map has all keys
            testCase.verifyTrue(isKey(mergedMap, 'key1'));
            testCase.verifyTrue(isKey(mergedMap, 'key2'));  % key2 should be merged
            testCase.verifyTrue(isKey(mergedMap, 'key3'));
            
            % Verify correct merging of maps for duplicate keys (key2)
            testCase.verifyEqual(mergedMap('key2').keys, {'b', 'c'});  % Merged inner maps
            
            % Verify other keys are unchanged
            testCase.verifyEqual(mergedMap('key1').keys, {'a'});
            testCase.verifyEqual(mergedMap('key3').keys, {'d'});
        end
        
        function testCombineEmptyMaps(testCase)
            % Create two empty maps
            map1 = containers.Map();
            map2 = containers.Map();
            
            % Call the function to combine the empty maps
            combinedMap = combine_maps(map1, map2);
            
            % Verify that the combined map is still empty
            testCase.verifyEmpty(keys(combinedMap));
        end
        
        function testCombineEmptyAndNonEmptyMaps(testCase)
            % Create an empty map
            map1 = containers.Map();
            
            % Create a non-empty map
            map2 = containers.Map({'a', 'b'}, {1, 2});
            
            % Combine the maps
            combinedMap = combine_maps(map1, map2);
            
            % Verify the combined map contains keys 'a' and 'b'
            testCase.verifyEqual(keys(combinedMap), {'a', 'b'});
            testCase.verifyEqual(combinedMap('a'), 1);
            testCase.verifyEqual(combinedMap('b'), 2);
        end

        function testCombineUniqueKeys(testCase)
            % Create the first map
            map = containers.Map({'apple', 'banana', 'cherry'}, {1, 2, 3});
            
            % Define a cell array of keys (no duplicates)
            cellArray = {'kiwi', 'mango'};
            
            % Combine the keys of the map with the cell array
            combinedKeys = combine_map_cell(map, cellArray);
            
            % Verify the combined keys
            expectedKeys = {'apple', 'banana', 'cherry', 'kiwi', 'mango'};
            testCase.verifyEqual(combinedKeys, expectedKeys);
        end
        
        function testCombineWithDuplicates(testCase)
            % Create the first map
            map = containers.Map({'apple', 'banana', 'cherry'}, {1, 2, 3});
            
            % Define a cell array of keys (with duplicates)
            cellArray = {'banana', 'kiwi', 'mango'};
            
            % Verify that an error is thrown for the repeated key 'banana'
            testCase.verifyError(@() combine_map_cell(map, cellArray), ...
                'MATLAB:containers:Map:DuplicateKey');
        end
        
        function testCombineEmptyMap(testCase)
            % Create an empty map
            map = containers.Map();
            
            % Define a cell array of keys
            cellArray = {'kiwi', 'mango'};
            
            % Combine the keys of the empty map with the cell array
            combinedKeys = combine_map_cell(map, cellArray);
            
            % Verify that the combined keys are just from the cell array
            expectedKeys = {'kiwi', 'mango'};
            testCase.verifyEqual(combinedKeys, expectedKeys);
        end
        
        function testCombineEmptyCellArray(testCase)
            % Create the first map
            map = containers.Map({'apple', 'banana', 'cherry'}, {1, 2, 3});
            
            % Define an empty cell array
            cellArray = {};
            
            % Combine the keys of the map with the empty cell array
            combinedKeys = combine_map_cell(map, cellArray);
            
            % Verify that the combined keys are just from the map
            expectedKeys = {'apple', 'banana', 'cherry'};
            testCase.verifyEqual(combinedKeys, expectedKeys);
        end

        function testMapSwitch(testCase)
            cations = containers.Map({'Cation'}, {containers.Map({'y','c'},{'5','7'})});
            switched = map_order_switch(cations);
            
            t1 = switched('y');
            trial_1 = t1('Cation');
            t2 = switched('c');
            trial_2 = t2('Cation');
            t1 = cations('Cation');
            truth_1 = t1('y');
            t2 = cations('Cation');
            truth_2 = t2('c');
            
            testCase.verifyTrue(trial_1 == truth_1)
            testCase.verifyTrue(trial_2 == truth_2)
        end
        %%

        %% Excel

        function testexcel_entry(testCase)
            entry = excel_entry('test.xlsx', 'Data', 2, 2);
            testCase.verifyTrue(strcmp(entry,'mmol/ L'))
            
            entry = excel_entry('test.xlsx', 'Data', 3, 2);
            testCase.verifyTrue(entry==1)
            
            entry = excel_entry('test.xlsx', 'Data', 30, 9);
            testCase.verifyTrue((entry-165.758691627237)<=1e12)
        end

        function testexcel_fin_nonzero_rows_in_col(testCase)
            truth = 1;
            trial = excel_find_col('test.xlsx','Data','Li aq ini');
            testCase.verifyEqual(trial,truth)
            truth = 2;
            trial = excel_find_col('test.xlsx','Data','Na aq ini');
            testCase.verifyEqual(trial,truth)
            truth = 3;
            trial = excel_find_col('test.xlsx','Data','Ca aq ini');
            testCase.verifyEqual(trial,truth)
            truth = 4;
            trial = excel_find_col('test.xlsx','Data','Mg aq ini');
            testCase.verifyEqual(trial,truth)
            truth = 5;
            trial = excel_find_col('test.xlsx','Data','ClO4 aq ini');
            testCase.verifyEqual(trial,truth)

            truth = 6;
            trial = excel_find_col('test.xlsx','Data','Li aq eq');
            testCase.verifyEqual(trial,truth)
            truth = 7;
            trial = excel_find_col('test.xlsx','Data','Na aq eq');
            testCase.verifyEqual(trial,truth)
            truth = 8;
            trial = excel_find_col('test.xlsx','Data','Ca aq eq');
            testCase.verifyEqual(trial,truth)
            truth = 9;
            trial = excel_find_col('test.xlsx','Data','Mg aq eq');
            testCase.verifyEqual(trial,truth)
            truth = 10;
            trial = excel_find_col('test.xlsx','Data','ClO4 aq eq');
            testCase.verifyEqual(trial,truth)

            truth = 11;
            trial = excel_find_col('test.xlsx','Data','Li org eq');
            testCase.verifyEqual(trial,truth)
            truth = 12;
            trial = excel_find_col('test.xlsx','Data','Na org eq');
            testCase.verifyEqual(trial,truth)
            truth = 13;
            trial = excel_find_col('test.xlsx','Data','Ca org eq');
            testCase.verifyEqual(trial,truth)
            truth = 14;
            trial = excel_find_col('test.xlsx','Data','Mg org eq');
            testCase.verifyEqual(trial,truth)
            truth = 15;
            trial = excel_find_col('test.xlsx','Data','ClO4 org eq');
            testCase.verifyEqual(trial,truth)
        end

        function testexcel_find_nonzero_rows_in_col(testCase)
            truth = [10,11,12,13,14,15,16];
            trial = excel_find_nonzero_rows_in_col('test.xlsx','Data',1,3,30);
            testCase.verifyEqual(trial,truth)
        end

        %%

        %% Mat
        function testSaveLoadVariables(testCase)
            % Define variables for testing
            a = 10;
            b = [1, 2, 3];
            c = 'Hello';
            
            % Create a cell array of variables and their names
            vars = {a, b, c};
            var_names = {'a', 'b', 'c'};

            % Save variables to the .mat file
            var_mat('test.mat',vars, var_names);
            
            % Load the variables from the .mat file
            mat_var('test.mat');
            
            % Check if the variables exist in the workspace
            testCase.verifyEqual(exist('a', 'var'), 1);  % Variable 'a' should exist
            testCase.verifyEqual(exist('b', 'var'), 1);  % Variable 'b' should exist
            testCase.verifyEqual(exist('c', 'var'), 1);  % Variable 'c' should exist
            
            % Verify the content of the variables
            testCase.verifyEqual(a, 10);          % Check if 'a' is 10
            testCase.verifyEqual(b, [1, 2, 3]);   % Check if 'b' is [1, 2, 3]
            testCase.verifyEqual(c, 'Hello');     % Check if 'c' is 'Hello'
            
            % Get the path of the current function's file
            functionDir = fileparts(mfilename('fullpath'));  % Get the directory of this function
            file_path = fullfile(functionDir, '..', 'data', 'mat', 'test.mat');
            % Clean up the test .mat file
            delete(file_path);
        end
        %%

        %% struct
        function test_basic_struct(testCase)
            keys = {1,'kartoffel'};
            values = {1,2};
            
            astruct = keyvals_struct(keys,values);
            keys = struct_keys(astruct);
            testCase.verifyEqual(keys{1},int32(1))
            testCase.verifyEqual(keys{2},'kartoffel')
            values = struct_vals(astruct);
            testCase.verifyEqual(values{1},1)
            testCase.verifyEqual(values{2},2)
        end

        % Test 1: Combine two structs with non-overlapping fields
        function testCombineNonOverlappingFields(testCase)
            struct1 = struct('a', 1, 'b', 2);
            struct2 = struct('c', 3, 'd', 4);
            
            % Call the function
            result = combine_structs(struct1, struct2);
            
            % Define the expected result
            expectedResult = struct('a', 1, 'b', 2, 'c', 3, 'd', 4);
            
            % Verify the result matches the expected output
            testCase.verifyEqual(result, expectedResult);
        end
        
        % Test 2: Try to combine structs with overlapping fields (should throw error)
        function testCombineWithOverlappingFields(testCase)
            struct1 = struct('a', 1, 'b', 2);
            struct2 = struct('b', 3, 'c', 4);
            
            % Verify that calling combine_structs throws an error for overlapping fields
            testCase.verifyError(@() combine_structs(struct1, struct2), ...
                'MATLAB:combine_structs:FieldNameOverlap');
        end
        
        % Test 3: Combine two structs with completely different field names
        function testCombineWithDifferentFields(testCase)
            struct1 = struct('x', 10);
            struct2 = struct('y', 20, 'z', 30);
            
            % Call the function
            result = combine_structs(struct1, struct2);
            
            % Define the expected result
            expectedResult = struct('x', 10, 'y', 20, 'z', 30);
            
            % Verify the result matches the expected output
            testCase.verifyEqual(result, expectedResult);
        end


        function testKeyFound(testCase)
            % Test case where key is found
            astruct = struct('a', 10, 'b', 20, 'c', 30);
            val = 20;
            expectedKey = 'b';
            key = struct_find_key_from_val(astruct, val);
            testCase.verifyEqual(key, expectedKey, 'Key should be found correctly for value');
        end
        
        function testKeyNotFound(testCase)
            % Test case where key is not found
            astruct = struct('a', 10, 'b', 20, 'c', 30);
            val = 40;
            testCase.verifyError(@() struct_find_key_from_val(astruct, val), ...
                'MATLAB:ValueNotFound', 'Error should be thrown when value is not found');
        end
        
        function testEmptyStruct(testCase)
            % Test case with an empty struct
            astruct = struct();
            val = 10;
            testCase.verifyError(@() struct_find_key_from_val(astruct, val), ...
                'MATLAB:ValueNotFound', 'Error should be thrown when struct is empty');
        end
        
        function testMultipleKeysWithSameValue(testCase)
            % Test case where multiple keys have the same value
            astruct = struct('a', 10, 'b', 10, 'c', 30);
            val = 10;
            expectedKey = 'a'; % In this case, it should return the first match
            key = struct_find_key_from_val(astruct, val);
            testCase.verifyEqual(key, expectedKey, 'First key should be returned when multiple keys have the same value');
        end

        %% char
        function testquicksplit(testCase)
            input = ' mol/ s';
            truth = strsplit(input,'/');
            trial = char_quick_split(input,'/');
            testCase.verifyEqual(trial,truth);

            input = ' mol* m^2* s';
            truth = strsplit(input,'*');
            trial = char_quick_split(input,'*');
            testCase.verifyEqual(trial,truth);

            input = ' mol';
            truth = {' mol'};
            trial = char_quick_split(input,'*');
            testCase.verifyEqual(trial,truth);

            input = '/ s';
            truth = strsplit(input,'/');
            trial = char_quick_split(input,'/');
            testCase.verifyEqual(trial,truth);
        end
        %%
    end
end
