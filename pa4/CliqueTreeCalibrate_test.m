%!test source "CliqueTreeCalibrate_test.m"

function test_sum_product()
  load("PA4Sample", "SumProdCalibrate")
  result = CliqueTreeCalibrate(SumProdCalibrate.INPUT, 0);
  assert(result.edges, SumProdCalibrate.RESULT.edges)
  assert(length(result.cliqueList), length(SumProdCalibrate.RESULT.cliqueList))

  for i = 1:length(SumProdCalibrate.RESULT.cliqueList)
    ## clique = SumProdCalibrate.RESULT.cliqueList(i)
    assert(result.cliqueList(i).var, SumProdCalibrate.RESULT.cliqueList(i).var)
    assert(result.cliqueList(i).card, SumProdCalibrate.RESULT.cliqueList(i).card)
    assert(result.cliqueList(i).val, SumProdCalibrate.RESULT.cliqueList(i).val, 0.000001)
  end
endfunction
%!test test_sum_product()

function test_max_sum()
  load("PA4Sample", "MaxSumCalibrate")
  result = CliqueTreeCalibrate(MaxSumCalibrate.INPUT, 1);
  assert(result.edges, MaxSumCalibrate.RESULT.edges)
  assert(length(result.cliqueList), length(MaxSumCalibrate.RESULT.cliqueList))

  for i = 1:length(MaxSumCalibrate.RESULT.cliqueList)
    ## clique = MaxSumCalibrate.RESULT.cliqueList(i)
    assert(result.cliqueList(i).var, MaxSumCalibrate.RESULT.cliqueList(i).var)
    assert(result.cliqueList(i).card, MaxSumCalibrate.RESULT.cliqueList(i).card)
    assert(result.cliqueList(i).val, MaxSumCalibrate.RESULT.cliqueList(i).val, 0.000001)
  end
endfunction
%!test test_max_sum()
