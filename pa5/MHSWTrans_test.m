%!test source "MHSWTrans_test.m"

function test_variant1()
  addpath 'gaimc'
  load("exampleIOPA5.mat")
  randi('seed',1);

  a1 = exampleINPUT.t10a1;
  a2 = exampleINPUT.t10a2;
  a3 = exampleINPUT.t10a3;
  a4 = exampleINPUT.t10a4;
  o = exampleOUTPUT.t10;

  for i = 1:length(o)
    assert(MHSWTrans(a1{i}, a2{i}, a3{i}, a4{i}), o{i})
  end
endfunction
%!test test_variant1()

function test_variant2()
  addpath 'gaimc'
  load("exampleIOPA5.mat")
  randi('seed',1);

  a1 = exampleINPUT.t11a1;
  a2 = exampleINPUT.t11a2;
  a3 = exampleINPUT.t11a3;
  a4 = exampleINPUT.t11a4;
  o = exampleOUTPUT.t11;

  for i = 1:length(o)
    assert(MHSWTrans(a1{i}, a2{i}, a3{i}, a4{i}), o{i})
  end
endfunction
%!test test_variant2()
