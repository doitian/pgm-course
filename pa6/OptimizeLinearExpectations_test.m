%!test source "OptimizeLinearExpectations_test.m"

function test_case_1()

  X1 = struct('var', [1], 'card', [2], 'val', [7, 3]);
  X1.val = X1.val / sum(X1.val);
  D = struct('var', [2], 'card', [2], 'val', [1 0]);
  U1 = struct('var', [1, 2], 'card', [2, 2], 'val', [10, 1, 5, 1]);

  I1.RandomFactors = X1;
  I1.DecisionFactors = D;
  I1.UtilityFactors = U1;

  [meu optdr] = OptimizeLinearExpectations(I1);

  assert(meu, 7.3, 0.00001)
  assert(optdr.var, [2])
  assert(optdr.card, [2])
  assert(optdr.val, [1, 0])
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

  [meu optdr] = OptimizeLinearExpectations(I2);

  assert(meu, 7.5, 0.00001)
  assert(optdr.var, [2])
  assert(optdr.card, [2])
  assert(optdr.val, [1, 0])
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

  [meu optdr] = OptimizeLinearExpectations(I3);

  assert(meu, 7.5, 0.00001)
  assert(optdr.var, [1, 2])
  assert(optdr.card, [2, 2])
  assert(optdr.val, [1, 1, 0, 0])
endfunction
%!test test_case_3()

function test_case_3_2()
  % swap variable ID for X1 and D
  X1 = struct('var', [2], 'card', [2], 'val', [7, 3]);
  X1.val = X1.val / sum(X1.val);
  D = struct('var', [1,2], 'card', [2,2], 'val', [1,0,0,1]);
  X3 = struct('var', [3,2,1], 'card', [2,2,2], 'val', [4 4 1 1 1 1 4 4]);
  X3 = CPDFromFactor(X3,3);

  % U is now a function of 3 instead of 2.
  U1 = struct('var', [1,3], 'card', [2, 2], 'val', [10, 1, 5, 1]);

  I3.RandomFactors = [X1 X3];
  I3.DecisionFactors = D;
  I3.UtilityFactors = U1;

  [meu optdr] = OptimizeLinearExpectations(I3);

  assert(meu, 7.5, 0.00001)
  assert(optdr.var, [1, 2])
  assert(optdr.card, [2, 2])
  assert(optdr.val, [1, 0, 1, 0])
endfunction
%!test test_case_3_2()

function test_case_4()
  X1 = struct('var', [1], 'card', [2], 'val', [7, 3]);
  X1.val = X1.val / sum(X1.val);
  D = struct('var', [2,1], 'card', [2,2], 'val', [1,0,0,1]);
  X3 = struct('var', [3,1,2], 'card', [2,2,2], 'val', [4 4 1 1 1 1 4 4]);
  X3 = CPDFromFactor(X3,3);

  % U is now a function of 3 instead of 2.
  U1 = struct('var', [2,3], 'card', [2, 2], 'val', [10, 1, 5, 1]);
  U2 = struct('var', [2], 'card', [2], 'val', [1, 10]);

  I4.RandomFactors = [X1 X3];
  I4.DecisionFactors = D;
  I4.UtilityFactors = [U1 U2];

  [meu optdr] = OptimizeLinearExpectations(I4);
  assert(meu, 11);
endfunction
%!test test_case_4()
