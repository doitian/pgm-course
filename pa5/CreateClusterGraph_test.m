%!test source "CreateClusterGraph_test.m"

function test_sample()
  load("exampleIOPA5.mat")

  F = exampleINPUT.t2a1;
  E = exampleINPUT.t2a2;
  out = exampleOUTPUT.t2;

  result = CreateClusterGraph(F, E);
  assert(result.edges, out.edges)
  assert(length(result.clusterList), length(out.clusterList))

  for i = 1:length(result.clusterList)
    assert(result.clusterList(i).var, out.clusterList(i).var)
    assert(result.clusterList(i).card, out.clusterList(i).card)
    assert(result.clusterList(i).val, out.clusterList(i).val, 0.00001)
  end
endfunction
%!test test_sample()
