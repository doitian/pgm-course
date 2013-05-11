%!test source "FactorMaxMarginalization_test.m"

function test_sample()
  load("PA4Sample", "FactorMax")
  result = FactorMaxMarginalization(FactorMax.INPUT1, FactorMax.INPUT2);

  assert(result.var, FactorMax.RESULT.var)
  assert(result.card, FactorMax.RESULT.card)
  assert(result.val, FactorMax.RESULT.val, 0.000001)
endfunction
%!test test_sample()
