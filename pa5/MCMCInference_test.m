%!test source "MCMCInference_test.m"

function test_part1()
  load("exampleIOPA5.mat")

  a1 = exampleINPUT.t8a1;
  a2 = exampleINPUT.t8a2;
  a3 = exampleINPUT.t8a3;
  a4 = exampleINPUT.t8a4;
  a5 = exampleINPUT.t8a5;
  a6 = exampleINPUT.t8a6;
  a7 = exampleINPUT.t8a7;
  a8 = exampleINPUT.t8a8;
  o1 = exampleOUTPUT.t8o1;
  o2 = exampleOUTPUT.t8o2;

  a4{2} = "MHGibbs"
  r1 = {[], []}
  r2 = {[], []}

  randi('seed', 1)
  for i = 1:2
    [M, all_samples] = MCMCInference(a1{i}, a2{i}, a3{i}, a4{i}, a5{i}, a6{i}, a7{i}, a8{i});
    r1{i} = M;
    r2{i} = all_samples;
  end

  for i = 1:2
    assert(length(r1{i}), length(o1{i}))
    for j = 1:length(r1{i})
      disp(["  variable " num2str(j)])
      assert(r1{i}(j).var, o1{i}(j).var)
      assert(r1{i}(j).card, o1{i}(j).card)
      assert(r1{i}(j).val, o1{i}(j).val, 0.00001)
    end

    assert(r2{i}, o2{i})
  end
endfunction
%!test test_part1()
