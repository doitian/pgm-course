%!test source "genotypeGivenParentsGenotypesFactor_test.m"

function test_sample()
  % Testing genotypeGivenParentsGenotypesFactor:
  numAlleles = 2;
  genotypeVarChild = 3;
  genotypeVarParentOne = 1;
  genotypeVarParentTwo = 2;
  genotypeFactorPar = struct('var', [3,1,2], 'card', [3,3,3], 'val', [1,0,0,0.5,0.5,0,0,1,0,0.5,0.5,0,0.25,0.5,0.25,0,0.5,0.5,0,1,0,0,0.5,0.5,0,0,1]); % Comment out this line for testing

  actual = genotypeGivenParentsGenotypesFactor(numAlleles, genotypeVarChild, genotypeVarParentOne, genotypeVarParentTwo);

  assert(actual, genotypeFactorPar, 0.01)
endfunction
%!test test_sample()
