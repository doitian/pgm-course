%!test source "ObserveEvidence_test.m"

function test_two_variables()
  f = struct('var', [1,2], 'card', [2,2], 'val', [1,1,1,1]);
  result = ObserveEvidence(f, [1 2]);
  assert(result, struct('var', [1,2], 'card', [2,2], 'val', [0,1,0,1]))
endfunction
%!test test_two_variables

function test_sample_in_tutorial()
  % FACTORS.INPUT(1) contains P(X_1)
  FACTORS.INPUT(1) = struct('var', [1], 'card', [2], 'val', [0.11, 0.89]);

  % FACTORS.INPUT(2) contains P(X_2 | X_1)
  FACTORS.INPUT(2) = struct('var', [2, 1], 'card', [2, 2], 'val', [0.59, 0.41, 0.22, 0.78]);

  % FACTORS.INPUT(3) contains P(X_3 | X_2)
  FACTORS.INPUT(3) = struct('var', [3, 2], 'card', [2, 2], 'val', [0.39, 0.61, 0.06, 0.94]);

  % Observe Evidence
  % FACTORS.EVIDENCE = ObserveEvidence(FACTORS.INPUT, [2 1; 3 2]);
  FACTORS.EVIDENCE(1) = struct('var', [1], 'card', [2], 'val', [0.11, 0.89]);
  FACTORS.EVIDENCE(2) = struct('var', [2, 1], 'card', [2, 2], 'val', [0.59, 0, 0.22, 0]);
  FACTORS.EVIDENCE(3) = struct('var', [3, 2], 'card', [2, 2], 'val', [0, 0.61, 0, 0]);

  result = ObserveEvidence(FACTORS.INPUT, [2 1; 3 2]);
  assert(length(result), 3)
  assert(result(1), FACTORS.EVIDENCE(1), 0.01)
  assert(result(2), FACTORS.EVIDENCE(2), 0.01)
  assert(result(3), FACTORS.EVIDENCE(3), 0.01)
endfunction
%!test test_sample_in_tutorial()
