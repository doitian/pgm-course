%!test source "ComputeTripletFactors_test.m"

function test_sample()
  load PA3Data.mat
  load PA3Models.mat
  load PA3SampleCases.mat

  factors = ComputeTripletFactors(Part3SampleImagesInput, tripletList, imageModel.K);

  assert(factors(1).var, Part3SampleFactorsOutput(1).var)
  assert(factors(1).card, Part3SampleFactorsOutput(1).card)
  assert(factors(1).val, Part3SampleFactorsOutput(1).val, 0.00001)

  assert(factors(2).var, Part3SampleFactorsOutput(2).var)
  assert(factors(2).card, Part3SampleFactorsOutput(2).card)
  assert(factors(2).val, Part3SampleFactorsOutput(2).val, 0.00001)

  assert(factors(3).var, Part3SampleFactorsOutput(3).var)
  assert(factors(3).card, Part3SampleFactorsOutput(3).card)
  assert(factors(3).val, Part3SampleFactorsOutput(3).val, 0.00001)
endfunction
%!test test_sample()
