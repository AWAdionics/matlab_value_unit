classdef test_mavu < matlab.unittest.TestCase
    methods (Test)

        function unimplementedTest(testCase)
            val1 = matrix_value_unit([1,1],make_unit('mmol/ L'));
            val2 = matrix_value_unit([1e-3,1e-3],make_unit(' mol/ L'));
            val3_truth = matrix_value_unit([2,2],make_unit('mmol/ L'));
            
            testCase.verifyTrue(all(val1==val2))
                
            
            testCase.verifyTrue(isequal(val1,val2))
            
            val3 = val1+val2;
            testCase.verifyTrue(isequal(val3,val3_truth))
        end
    end

end