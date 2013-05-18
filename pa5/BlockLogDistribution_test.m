%!test source "BlockLogDistribution_test.m"

function test_sample()
  load("exampleIOPA5.mat")
  V = exampleINPUT.t6a1;
  G = exampleINPUT.t6a2;
  F = exampleINPUT.t6a3;
  A = exampleINPUT.t6a4;

  assert(BlockLogDistribution(V, G, F, A), exampleOUTPUT.t6, 0.00001)
endfunction
%!test test_sample()
