classdef test_make < matlab.unittest.TestCase
    methods(Test)
        function test_make_unit(testCase)
            a_unit = make_unit(' mol^2/kg');
            prefix_truth = [1;1;1;1000;1;1;1;1;1;1];
            power_truth = [0;0;2;-1;0;0;0;0;0;0];
            testCase.verifyEqual(a_unit.prefix,prefix_truth)
            testCase.verifyEqual(a_unit.power,power_truth)
        end

        function test_struct_conversion(testCase)
            a_unit = make_unit(' mol^2/kg');
            pow = power_array_struct(a_unit.power);
            pre = prefix_array_struct(a_unit.prefix);

            pow_truth = struct();
            pre_truth = struct();
            for i=1:length(constants_mavu.accepted_units)
                unit = constants_mavu.accepted_units{i};
                pow_truth.(unit) = 0;
                pre_truth.(unit) = ' ';
            end
            pow_truth.mol = 2;
            pow_truth.g = -1;

            pre_truth.g = 'k';

            testCase.verifyEqual(pow,pow_truth)
            testCase.verifyEqual(pre,pre_truth)
        end

        function test_write_unit(testCase)
            truth = ' mol^2/kg';
            a_unit = make_unit(' mol^2/kg');

            trial = write_unit(a_unit);
            testCase.verifyEqual(trial,truth)
        end
    end
end