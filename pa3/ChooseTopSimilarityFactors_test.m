%!test source "ChooseTopSimilarityFactors_test.m"

function test_sample()
  load PA3Data.mat
  load PA3Models.mat
  load PA3SampleCases.mat

  factors = ChooseTopSimilarityFactors(Part6SampleFactorsInput, 2);

  for i = 1:length(factors)
    assert(factors(i).var, Part6SampleFactorsOutput(i).var)
    assert(factors(i).card, Part6SampleFactorsOutput(i).card)
    assert(factors(i).val, Part6SampleFactorsOutput(i).val, 0.00001)
  end
endfunction
%!test test_sample()
