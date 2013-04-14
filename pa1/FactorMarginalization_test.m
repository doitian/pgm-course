%!test source "FactorMarginalization_test.m"

function test_single_variable_factor()
  a = struct("var", [1], "card", [2], "val", [1,2]);
  FactorMarginalization(a, [1])
endfunction
%!error <empty scope> test_single_variable_factor()

function test_marginalize_one_variable_on_another()
  # 1 1 1
  # 2 1 2
  # 1 2 3
  # 2 2 4
  a = struct("var", [1,2], "card", [2,2], "val", [1,2,3,4]);
  result = FactorMarginalization(a, [1]);
  assert(result.var, [2])
  assert(result.card, [2])
  assert(result.val, [3,7])
endfunction
%!test test_marginalize_one_variable_on_another()

function test_marginalize_one_variable_on_other_two()
  a = struct("var", [1,2,3], "card", [2,2,2], "val", [1,2,3,4,5,6,7,8]);
  result = FactorMarginalization(a, [1,2]);
  assert(result.var, [3])
  assert(result.card, [2])
  assert(result.val, [10, 26])
endfunction
%!test test_marginalize_one_variable_on_another()

function test_sample_in_tutorial()
  a = struct('var', [2, 1], 'card', [2, 2], 'val', [0.59, 0.41, 0.22, 0.78]);
  expect = struct('var', [1], 'card', [2], 'val', [1 1]);
  result = FactorMarginalization(a, [2]);
  assert(result, expect)
endfunction
%!test test_sample_in_tutorial()
