%!test source "ComputeExactMarginalsBP_test.m"

function test_sum_product()
  load("PA4Sample", "ExactMarginal")
  result = ComputeExactMarginalsBP(ExactMarginal.INPUT, [], 0);

  assert(length(result), length(ExactMarginal.RESULT))

  for i = 1:length(ExactMarginal.RESULT)
    ## clique = ExactMarginal.RESULT.cliqueList(i)
    assert(result(i).var, ExactMarginal.RESULT(i).var)
    assert(result(i).card, ExactMarginal.RESULT(i).card)
    assert(result(i).val, ExactMarginal.RESULT(i).val, 0.000001)
  end
endfunction
%!test test_sum_product()
