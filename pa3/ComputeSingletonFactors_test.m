%!test source "ComputeSingletonFactors_test.m"

function test_sample()
  load PA3Data.mat
  load PA3Models.mat
  load PA3SampleCases.mat

  factors = ComputeSingletonFactors(Part1SampleImagesInput, imageModel);

  assert(factors(1).var, Part1SampleFactorsOutput(1).var)
  assert(factors(1).card, Part1SampleFactorsOutput(1).card)
  assert(factors(1).val, Part1SampleFactorsOutput(1).val, 0.00001)

  assert(factors(2).var, Part1SampleFactorsOutput(2).var)
  assert(factors(2).card, Part1SampleFactorsOutput(2).card)
  assert(factors(2).val, Part1SampleFactorsOutput(2).val, 0.00001)

  assert(factors(3).var, Part1SampleFactorsOutput(3).var)
  assert(factors(3).card, Part1SampleFactorsOutput(3).card)
  assert(factors(3).val, Part1SampleFactorsOutput(3).val, 0.00001)

  assert(factors(4).var, Part1SampleFactorsOutput(4).var)
  assert(factors(4).card, Part1SampleFactorsOutput(4).card)
  assert(factors(4).val, Part1SampleFactorsOutput(4).val, 0.00001)

  assert(factors(5).var, Part1SampleFactorsOutput(5).var)
  assert(factors(5).card, Part1SampleFactorsOutput(5).card)
  assert(factors(5).val, Part1SampleFactorsOutput(5).val, 0.00001)
endfunction
%!test test_sample()

