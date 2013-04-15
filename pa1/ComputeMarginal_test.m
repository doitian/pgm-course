%!test source "ComputeMarginal_test.m"

function test_sample_in_tutorial()
  FactorTutorial
  result = ComputeMarginal([2, 3], FACTORS.INPUT, [1, 2]);
  assert(result, FACTORS.MARGINAL, 0.0001)
endfunction
%!test test_sample_in_tutorial()
