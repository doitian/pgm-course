%!test source "constructGeneticNetwork_test.m"

function test_sample()
  % Testing constructGeneticNetwork:
  pedigree = struct('parents', [0,0;1,3;0,0]);
  pedigree.names = {'Ira','James','Robin'};
  alleleFreqs = [0.1; 0.9];
  alphaList = [0.8; 0.6; 0.1];
  expectation = load('sampleFactorList.mat'); % Comment out this line for testing
  expectation = expectation.sampleFactorList;
  actual = constructGeneticNetwork(pedigree, alleleFreqs, alphaList);

  assert(actual(1), expectation(1), 0.01)
  assert(actual(2), expectation(2), 0.01)
  assert(actual(3), expectation(3), 0.01)
  assert(actual(4), expectation(4), 0.01)
  assert(actual(5), expectation(5), 0.01)
  assert(actual(6), expectation(6), 0.01)
endfunction
%!test test_sample()
