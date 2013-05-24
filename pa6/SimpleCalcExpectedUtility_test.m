%!test source "SimpleCalcExpectedUtility_test.m"

function test_case_1()
  X1 = struct('var', [1], 'card', [2], 'val', [7, 3]);
  X1.val = X1.val / sum(X1.val);
  D = struct('var', [2], 'card', [2], 'val', [1 0]);
  U1 = struct('var', [1, 2], 'card', [2, 2], 'val', [10, 1, 5, 1]);

  I1.RandomFactors = X1;
  I1.DecisionFactors = D;
  I1.UtilityFactors = U1;

  % All possible decision rules.
  D1 = D;
  D2 = D;
  D2.val = [0 1];
  AllDs = [D1 D2];

  allEU = zeros(length(AllDs),1);
  for i=1:length(AllDs)
    I1.DecisionFactors = AllDs(i);
    allEU(i) = SimpleCalcExpectedUtility(I1);
  end

  assert(allEU, [7.3000; 3.8000], 0.0001)
endfunction
%!test test_case_1()

function test_case_2()
  % Add node between 1 and 2 and the utility
  X1 = struct('var', [1], 'card', [2], 'val', [7, 3]);
  X1.val = X1.val / sum(X1.val);
  D = struct('var', [2], 'card', [2], 'val', [1 0]);
  X3 = struct('var', [3,1,2], 'card', [2,2,2], 'val', [4 4 1 1 1 1 4 4]);
  X3 = CPDFromFactor(X3,3);

  % U is now a function of 3 instead of 2.
  U1 = struct('var', [2,3], 'card', [2, 2], 'val', [10, 1, 5, 1]);

  I2.RandomFactors = [X1 X3];
  I2.DecisionFactors = D;
  I2.UtilityFactors = U1;

  % All possible decision rules.
  D1 = D;
  D2 = D;
  D2.val = [0 1];
  AllDs = [D1 D2];

  allEU = zeros(length(AllDs),1);
  for i=1:length(AllDs)
    I2.DecisionFactors = AllDs(i);
    allEU(i) = SimpleCalcExpectedUtility(I2);
  end

  assert(allEU, [7.5000; 1.0000], 0.0001)
endfunction
%!test test_case_2()

function test_case_3()
  X1 = struct('var', [1], 'card', [2], 'val', [7, 3]);
  X1.val = X1.val / sum(X1.val);
  D = struct('var', [2,1], 'card', [2,2], 'val', [1,0,0,1]);
  X3 = struct('var', [3,1,2], 'card', [2,2,2], 'val', [4 4 1 1 1 1 4 4]);
  X3 = CPDFromFactor(X3,3);

  % U is now a function of 3 instead of 2.
  U1 = struct('var', [2,3], 'card', [2, 2], 'val', [10, 1, 5, 1]);

  I3.RandomFactors = [X1 X3];
  I3.DecisionFactors = D;
  I3.UtilityFactors = U1;

  % All possible decision rules
  D1 = D;D2 = D;D3 = D;D4 = D;
  D1.val = [1 0 1 0];
  D2.val = [1 0 0 1];
  D3.val = [0 1 1 0];
  D4.val = [0 1 0 1];

  AllDs = [D1 D2 D3 D4];
  allEU = zeros(length(AllDs),1);
  for i=1:length(AllDs)
    I3.DecisionFactors = AllDs(i);
    allEU(i) = SimpleCalcExpectedUtility(I3);
  end

  assert(allEU, [7.500; 5.5500; 2.9500; 1.0000], 0.0001)
endfunction
%!test test_case_3()
