%!test source "phenotypeGivenCopiesFactor_test.m"
function test_sample()
  % Testing phenotypeGivenCopiesFactor:
  alphaListThree = [0.8; 0.6; 0.1; 0.5; 0.05; 0.01];
  numAllelesThree = 3;
  genotypeVarMotherCopy = 1;
  genotypeVarFatherCopy = 2;
  phenotypeVar = 3;
  expectation = struct('var', [3,1,2], 'card', [2,3,3], 'val', [0.8,0.2,0.6,0.4,0.1,0.9,0.6,0.4,0.5,0.5,0.05,0.95,0.1,0.9,0.05,0.95,0.01,0.99]); % Comment out this line for testing
  actual = phenotypeGivenCopiesFactor(alphaListThree, numAllelesThree, genotypeVarMotherCopy, genotypeVarFatherCopy, phenotypeVar);

  assert(actual, expectation, 0.01)
endfunction
%!test test_sample()
