%!test source "NaiveGetNextClusters_test.m"

function test_sample()
  load("exampleIOPA5.mat")

  P = exampleINPUT.t1a1;
  ms = exampleINPUT.t1a2;
  out = exampleOUTPUT.t1;
  for m = 1:length(ms)
    [i, j] = NaiveGetNextClusters(P, ms{m});
    assert([i, j], out{m})
  end
endfunction
%!test test_sample()
