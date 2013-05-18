%!test source "GibbsTrans_test.m"

function test_sample()
  load("exampleIOPA5.mat")
  randi('seed',1)

  As = exampleINPUT.t7a1;
  Gs = exampleINPUT.t7a2;
  Fs = exampleINPUT.t7a3;
  Os = exampleOUTPUT.t7;

  for i = 1:length(As)
    assert(GibbsTrans(As{i}, Gs{i}, Fs{i}), Os{i})
  end
endfunction
%!test test_sample()
