%!test source "GetNextCliques_test.m"

function test_sample()
  load("PA4Sample", "GetNextC")

  [i, j] = GetNextCliques(GetNextC.INPUT1, GetNextC.INPUT2);
  assert(i, GetNextC.RESULT1)
  assert(j, GetNextC.RESULT2)
endfunction
%!test test_sample()
