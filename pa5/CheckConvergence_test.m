%!test source "CheckConvergence_test.m"

function test_sample()
  load("exampleIOPA5.mat")

  news = exampleINPUT.t3a1;
  olds = exampleINPUT.t3a2;
  out = exampleOUTPUT.t3;

  for i = 1:length(news)
    assert(CheckConvergence(news{i}, olds{i}), out{i} == 1)
  end
endfunction
%!test test_sample()
