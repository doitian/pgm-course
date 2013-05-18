%!test source "MHUniformTrans_test.m"

function test_sample()
  load("exampleIOPA5.mat")
  randi('seed',1);

  a1 = exampleINPUT.t9a1;
  a2 = exampleINPUT.t9a2;
  a3 = exampleINPUT.t9a3;
  o = exampleOUTPUT.t9;

  for i = 1:length(o)
    assert(MHUniformTrans(a1{i}, a2{i}, a3{i}), o{i})
  end
endfunction
%!test test_sample()
