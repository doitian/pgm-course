%!test source "ComputeInitialPotentials_test.m"

function test_sample()
  load("PA4Sample", "InitPotential")

  result = ComputeInitialPotentials(InitPotential.INPUT);
  assert(result.edges, InitPotential.RESULT.edges)
  assert(length(result.cliqueList), length(InitPotential.RESULT.cliqueList))

  for i = 1:length(InitPotential.RESULT.cliqueList)
    assert(result.cliqueList(i).var, InitPotential.RESULT.cliqueList(i).var)
    assert(result.cliqueList(i).card, InitPotential.RESULT.cliqueList(i).card)
    assert(result.cliqueList(i).val, InitPotential.RESULT.cliqueList(i).val)
  end
endfunction
%!test test_sample()
