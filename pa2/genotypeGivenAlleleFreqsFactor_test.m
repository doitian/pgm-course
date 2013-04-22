%!test source "genotypeGivenAlleleFreqsFactor_test.m"

function test_sample()
  % Testing genotypeGivenAlleleFreqsFactor:
  alleleFreqs = [0.1; 0.9];
  genotypeVar = 1;
  expectation = struct('var', [1], 'card', [3], 'val', [0.01,0.18,0.81]); % Comment out this line for testing
  actual = genotypeGivenAlleleFreqsFactor(alleleFreqs, genotypeVar);
  assert(actual, expectation, 0.001)
endfunction
%!test test_sample()
