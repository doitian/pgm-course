%!test source "constructDecoupledGeneticNetwork_test.m"

function test_sample()
  % Testing constructDecoupledGeneticNetwork:
  pedigree = struct('parents', [0,0;1,3;0,0]);
  pedigree.names = {'Ira','James','Robin'};
  alleleFreqsThree = [0.1; 0.7; 0.2];
  alleleListThree = {'F', 'f', 'n'};
  alphaListThree = [0.8; 0.6; 0.1; 0.5; 0.05; 0.01];
  expectation = load('sampleFactorListDecoupled.mat'); % Comment out this line for testing
  expectation = expectation.sampleFactorListDecoupled;
  actual = constructDecoupledGeneticNetwork(pedigree, alleleFreqsThree, alphaListThree);

  assert(actual(1), expectation(1), 0.01)
  assert(actual(2), expectation(2), 0.01)
  assert(actual(3), expectation(3), 0.01)
  assert(actual(4), expectation(4), 0.01)
  assert(actual(5), expectation(5), 0.01)
  assert(actual(6), expectation(6), 0.01)
  assert(actual(7), expectation(7), 0.01)
  assert(actual(8), expectation(8), 0.01)
  assert(actual(9), expectation(9), 0.01)
endfunction
%!test test_sample()
