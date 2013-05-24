%!test source "CalculateExpectedUtilityFactor_test.m"

function test_case_1()
  X1 = struct('var', [1], 'card', [2], 'val', [7, 3]);
  X1.val = X1.val / sum(X1.val);
  D = struct('var', [2], 'card', [2], 'val', [1 0]);
  U1 = struct('var', [1, 2], 'card', [2, 2], 'val', [10, 1, 5, 1]);

  I1.RandomFactors = X1;
  I1.DecisionFactors = D;
  I1.UtilityFactors = U1;

  euf = CalculateExpectedUtilityFactor(I1);

  assert(euf.var, [2])
  assert(euf.card, [2])
  assert(euf.val, [7.3000 3.8000], 0.0001)
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

  euf = CalculateExpectedUtilityFactor(I2);
  assert(euf.var, [2])
  assert(euf.card, [2])
  assert(euf.val, [7.5000 1.0000], 0.0001)
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

  euf = CalculateExpectedUtilityFactor(I3);
  assert(euf.var, [1, 2])
  assert(euf.card, [2, 2])
  assert(euf.val, [5.25, 2.25, 0.7, 0.3], 0.0001)
endfunction
%!test test_case_3()
