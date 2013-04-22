%!test source "phenotypeGivenGenotypeFactor_test.m"

function test_sample()
  alphaList = [0.8; 0.6; 0.1];
  genotypeVar = 1;
  phenotypeVar = 3;
  expectation = struct('var', [3,1], 'card', [2,3], 'val', [0.8,0.2,0.6,0.4,0.1,0.9]); % Comment out this line for testing
  actual = phenotypeGivenGenotypeFactor(alphaList, genotypeVar, phenotypeVar);

  assert(actual, expectation, 0.01)
endfunction
%!test test_sample()
