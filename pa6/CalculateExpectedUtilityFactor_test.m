%!test source "CalculateExpectedUtilityFactor_test.m"

function test_sample()
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

  euf = CalculateExpectedUtilityFactor(I1);

  assert(euf.var, [2])
  assert(euf.card, [2])
  assert(euf.val, [7.3000 3.8000], 0.0001)
endfunction
%!test test_sample()
