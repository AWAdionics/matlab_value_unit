classdef test_mavu < matlab.unittest.TestCase
    methods (Test)
        function eq(testCase)
            val1 = mavu([1,1],make_unit('mmol/ L'));
            val2 = mavu([1e-3,1e-3],make_unit(' mol/ L'));
            testCase.verifyTrue(all(val1==val2))
        end
        
        function equals(testCase)
            val1 = mavu([1,1],make_unit('mmol/ L'));
            val2 = mavu([1e-3,1e-3],make_unit(' mol/ L'));
            testCase.verifyTrue(isequal(val1,val2))
        end


        function add(testCase)
            val1 = mavu([1,1],make_unit('mmol/ L'));
            val2 = mavu([1e-3,1e-3],make_unit(' mol/ L'));
            val3_truth = mavu([2,2],make_unit('mmol/ L'));
            val3 = val1+val2;
            testCase.verifyTrue(isequal(val3,val3_truth))
        end

        function add_mismatch(testCase)
            val1 = mavu([1,1],make_unit('mmol/ m'));
            val2 = mavu([1e-3,1e-3],make_unit(' mol/ L'));
            testCase.verifyError(@() val1 + val2,'MatrixValueUnit:UnitMismatch')
        end

        function minus(testCase)
            val1 = mavu([1,1],make_unit('mmol/ L'));
            val2 = mavu([1e-3,1e-3],make_unit(' mol/ L'));
            val4_truth =  mavu([0,0],make_unit('mmol/ L'));
            val4 = val1-val2;
            testCase.verifyTrue(isequal(val4,val4_truth))
        end

        function minus_mismatch(testCase)
            val1 = mavu([1,1],make_unit('mmol/ m'));
            val2 = mavu([1e-3,1e-3],make_unit(' mol/ L'));
            testCase.verifyError(@() val1 - val2,'MatrixValueUnit:UnitMismatch')
        end

        function times(testCase)
            val1 = mavu([2,1],make_unit('mmol/ L'));
            val2 = mavu([1e-3,1e-3],make_unit('kg* mol/ L'));
            val3 = val1.*val2;
            val3_truth = mavu([2,1],make_unit('mmol^2*kg/ L^2'));
            testCase.verifyTrue(isequal(val3,val3_truth))
        end

        function ldivide(testCase)
            val1 = mavu([2,1],make_unit('mmol/ L'));
            val2 = mavu([1e-3,1e-3],make_unit('kg* mol/ L'));
            val3 = val1.\val2;
            val3_truth = mavu([0.5,1],make_unit('kg*mmol^2/ L^2'));
            testCase.verifyTrue(isequal(val3,val3_truth))
        end

        function rdivide(testCase)
            val1 = MatrixValueUnit([2,1],make_unit(' mol/ L'));
            val2 = MatrixValueUnit([1e3,1e3],make_unit('kg*mmol/ L'));
            val3 = val2./val1;
            val3_truth = mavu([500,1000],make_unit('kg*mmol^2/ L^2'));
            testCase.verifyTrue(isequal(val3,val3_truth))
        end

        function power(testCase)
            val1 = MatrixValueUnit([2,1],make_unit(' mol/ L'));
            val3 = val1.^2;
            val3_truth = mavu([4,1],make_unit(' mol^2/ L^2'));
            testCase.verifyTrue(isequal(val3,val3_truth))
        end

        function mtimes(testCase)
            %A*B
            val1 = MatrixValueUnit([1,2;3,4],make_unit(' mol/ L'));
            val2 = MatrixValueUnit([5,6;7,8]*1e3,make_unit('kg*mmol/ L'));
            val3 = val1*val2;
            val3_truth = mavu([19,22;43,50],make_unit('kg* mol^2/ L^2'));
            testCase.verifyTrue(isequal(val3,val3_truth))
            
            %A*b
            val4 = MatrixValueUnit([1,2;3,4],make_unit(' mol/ L'));
            val5 = MatrixValueUnit([5;6]*1e3,make_unit('kg*mmol/ L'));
            val6 = val4*val5;
            val6_truth = mavu([17;39],make_unit('kg* mol^2/ L^2'));
            testCase.verifyTrue(isequal(val6,val6_truth))
            
            %a*B
            val7 = MatrixValueUnit([1,2],make_unit(' mol/ L'));
            val8 = MatrixValueUnit([3,4;5,6]*1e3,make_unit('kg*mmol/ L'));
            val9 = val7*val8;
            val9_truth = mavu([13,16],make_unit('kg* mol^2/ L^2'));
            testCase.verifyTrue(isequal(val9,val9_truth))
        end

        function gt(testCase)
            A = [1,6;3,8];
            B = [5,2;7,4];
            Avu = mavu(A,make_unit(' mol/ L'));
            Bvu = mavu(B*1e3,make_unit('mmol/ L'));
            t1 = A>B;
            t2 = Avu>Bvu;
            testCase.verifyTrue(isequal(t1,t2))
        end

        function ge(testCase)
            A = [1,6;3,8];
            B = [5,6;7,4];
            Avu = mavu(A,make_unit(' mol/ L'));
            Bvu = mavu(B*1e3,make_unit('mmol/ L'));
            t1 = A>=B;
            t2 = Avu>=Bvu;
            testCase.verifyTrue(isequal(t1,t2))
        end

        function lt(testCase)
            A = [1,6;3,8];
            B = [5,2;7,4];
            Avu = mavu(A,make_unit(' mol/ L'));
            Bvu = mavu(B*1e3,make_unit('mmol/ L'));
            t1 = A<B;
            t2 = Avu<Bvu;
            testCase.verifyTrue(isequal(t1,t2))
        end

        function le(testCase)
            A = [1,6;3,8];
            B = [5,6;7,4];
            Avu = mavu(A,make_unit(' mol/ L'));
            Bvu = mavu(B*1e3,make_unit('mmol/ L'));
            t1 = A<=B;
            t2 = Avu<=Bvu;
            testCase.verifyTrue(isequal(t1,t2))
        end

        function mrtimes(testCase)
            val1 = MatrixValueUnit([1,2;3,4],make_unit(' mol/ L'));
            val2 = MatrixValueUnit([5,6;7,8]*1e3,make_unit('kg*mmol/ L'));
            val3 = val1/val2;
            val3_truth = mavu([3,-2;2,-1],make_unit(' mol^2*kg/ L^2'));
            testCase.verifyTrue(isalmostequal(val3,val3_truth))
        end

        function isalmostequal(testCase)
            val1 = MatrixValueUnit([1,2;3,4],make_unit(' mol/ L'));
            val2 = MatrixValueUnit([1-1e-15,2+1e-15;3-1e-16,4+1e-23],make_unit(' mol/ L'));
            testCase.verifyTrue(isalmostequal(val1,val2))
        end

        function exp(testCase)
            A = [1,6;3,8];
            Avu = mavu(A,make_unit(''));
            t1 = mavu(exp(A),make_unit(''));
            t2 = exp(Avu);
            testCase.verifyTrue(isalmostequal(t1,t2))
        end

        function exp_error(testCase)
            A = [1,6;3,8];
            Avu = mavu(A,make_unit(' m'));
            testCase.verifyError(@() exp(Avu),'MatrixValueUnit:ExpectedUnitless')
        end

        function log_(testCase)
            A = [1,6;3,8];
            Avu = mavu(A,make_unit(''));
            t1 = mavu(log(A),make_unit(''));
            t2 = log(Avu);
            testCase.verifyTrue(isalmostequal(t1,t2))
        end

        function log_error(testCase)
            A = [1,6;3,8];
            Avu = mavu(A,make_unit(' m'));
            testCase.verifyError(@() log(Avu),'MatrixValueUnit:ExpectedUnitless')
        end

        function mpower(testCase)
            A = [1,6;3,8];
            Avu = mavu(A,make_unit(' m'));
            t1 = mavu(A^2,make_unit(' m^2'));
            t2 = Avu^2;
            testCase.verifyTrue(isalmostequal(t1,t2))
        end

        function subsref_(testCase)
            A = [1,6;3,8];
            Avu = mavu(A,make_unit(' m'));
            trial = Avu(1,1:2);
            truth = mavu([1,6],make_unit(' m'));
            testCase.verifyTrue(isequal(trial,truth))
        end

        function subsasgn_(testCase)
            A = [1,6;3,8];
            Avu = mavu(A,make_unit(' m'));
            Avu(1,1) = 2;
            truth = mavu([2,6;3,8],make_unit(' m'));
            testCase.verifyTrue(isequal(Avu,truth))
        end

        function size_(testCase)
            A = [1,6;3,8];
            Avu = mavu(A,make_unit(' m'));
            testCase.verifyTrue(isequal(size(Avu),[2,2]))
        end

        function length_(testCase)
            A = [1,6;3,8];
            Avu = mavu(A,make_unit(' m'));
            testCase.verifyTrue(isequal(length(Avu),length(A)))
        end

        function isdiag_(testCase)
            A = [1,6;3,8];
            Avu = mavu(A,make_unit(' m'));
            testCase.verifyTrue(isequal(isdiag(Avu),isdiag(A)))
        end

        function isnan_(testCase)
            A = [1,6;3,8];
            Avu = mavu(A,make_unit(' m'));
            testCase.verifyTrue(isequal(isnan(Avu),isnan(A)))
        end

        function isinf_(testCase)
            A = [1,6;3,8];
            Avu = mavu(A,make_unit(' m'));
            testCase.verifyTrue(isequal(isinf(Avu),isinf(A)))
        end

         function issparse_(testCase)
            A = [1,6;3,8];
            Avu = mavu(A,make_unit(' m'));
            testCase.verifyTrue(isequal(issparse(Avu),issparse(A)))
         end

         function transpose_(testCase)
            A = [1,6;3,8];
            Avu = mavu(A,make_unit(' m'));
            testCase.verifyTrue(isequal(Avu.',mavu(A.',make_unit(' m'))))
         end

         function ctranspose_(testCase)
            A = [1,6;3,8];
            Avu = mavu(A,make_unit(' m'));
            testCase.verifyTrue(isequal(Avu',mavu(A',make_unit(' m'))))
         end

         function sum_(testCase)
            B = [1,2;3,4];
            Bvu = mavuwu(B,' m');
            t1 = mavuwu(sum(B),' m');
            t2 = sum(Bvu);
            testCase.verifyTrue(isequal(t1,t2))
         end

         function prod_(testCase)
            B = [1,2;3,4;5,6];
            Bvu = mavuwu(B,' m');
            t1 = mavuwu(prod(B),' m^3');
            t2 = prod(Bvu);
            testCase.verifyTrue(isequal(t1,t2))
         end
    end

end