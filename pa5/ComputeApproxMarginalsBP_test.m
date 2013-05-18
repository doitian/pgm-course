%!test source "ComputeApproxMarginalsBP_test.m"

function test_sample()
  load("exampleIOPA5.mat")

  F = exampleINPUT.t5a1;
  out = exampleOUTPUT.t5;

  r = ComputeApproxMarginalsBP(F, []);

  assert(length(r), length(out))
  for i = 1:length(out)
    assert(r(i).var, out(i).var)
    assert(r(i).card, out(i).card)
    assert(r(i).val, out(i).val, 0.00001)
  end
endfunction
%!test test_sample()
