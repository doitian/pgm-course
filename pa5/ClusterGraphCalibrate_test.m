%!test source "ClusterGraphCalibrate_test.m"

function test_sample()
  load("exampleIOPA5.mat")

  P = exampleINPUT.t4a1;
  PE = exampleOUTPUT.t4o1;
  ME = exampleOUTPUT.t4o2;

  [PR, MR] = ClusterGraphCalibrate(P);

  assert(PR.edges, PE.edges)
  assert(length(PR.clusterList), length(PE.clusterList))

  for i = 1:length(PE.clusterList)
    assert(PR.clusterList(i).var, PE.clusterList(i).var)
    assert(PR.clusterList(i).card, PE.clusterList(i).card)
    assert(PR.clusterList(i).val, PE.clusterList(i).val, 0.00001)
  end

  MR = MR(:);
  ME = ME(:);
  assert(size(MR), size(ME))
  for i = 1:length(MR)
    assert(MR(i).var, ME(i).var)
    assert(MR(i).card, ME(i).card)
    assert(MR(i).val, ME(i).val, 0.00001)
  end
endfunction
%!test test_sample()
