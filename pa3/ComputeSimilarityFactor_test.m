%!test source "ComputeSimilarityFactor_test.m"

function test_sample()
  load PA3Data.mat
  load PA3Models.mat
  load PA3SampleCases.mat

  factor = ComputeSimilarityFactor(Part4SampleImagesInput, imageModel.K, 1, 2);
  assert(factor.var, Part4SampleFactorOutput.var)
  assert(factor.card, Part4SampleFactorOutput.card)
  assert(factor.val, Part4SampleFactorOutput.val, 0.00001)
endfunction
%!test test_sample()

