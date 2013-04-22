%!test source "phenotypeGivenGenotypeMendelianFactor_test.m"

function test_dominate_phenotype_factor()
  isDominant = 1;
  genotypeVar = 1;
  phenotypeVar = 3;
  expectation = struct('var', [3,1], 'card', [2,3], 'val', [1,0,1,0,0,1]); % Comment out this line for testing
  actual = phenotypeGivenGenotypeMendelianFactor(isDominant, genotypeVar, phenotypeVar);

  assert(actual, expectation)
endfunction
%!test test_dominate_phenotype_factor()


function test_ressesive_phenotype_factor()
  isDominant = 0;
  genotypeVar = 1;
  phenotypeVar = 3;
  expectation = struct('var', [3,1], 'card', [2,3], 'val', [0,1,0,1,1,0]); % Comment out this line for testing
  actual = phenotypeGivenGenotypeMendelianFactor(isDominant, genotypeVar, phenotypeVar);

  assert(actual, expectation)
endfunction
%!test test_dominate_phenotype_factor()
