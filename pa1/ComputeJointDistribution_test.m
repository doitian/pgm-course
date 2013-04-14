%!test source "ComputeJointDistribution_test.m"

function test_sample_in_tutorial()
  FactorTutorial
  result = ComputeJointDistribution(FACTORS.INPUT);
  assert(result, FACTORS.JOINT, 0.000001)
endfunction
%!test test_sample_in_tutorial()
