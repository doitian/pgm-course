%!test source "ComputeAllSimilarityFactors_test.m"

function test_sampl()
  load PA3Data.mat
  load PA3Models.mat
  load PA3SampleCases.mat

  factors = ComputeAllSimilarityFactors(Part5SampleImagesInput, imageModel.K);
 
  for i = 1:21
    assert(factors(i).var, Part5SampleFactorsOutput(i).var)
    assert(factors(i).card, Part5SampleFactorsOutput(i).card)
    assert(factors(i).val, Part5SampleFactorsOutput(i).val, 0.00001)
  end
endfunction
%!test test_sampl()
