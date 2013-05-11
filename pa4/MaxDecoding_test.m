%!test source "MaxDecoding_test.m"

function test_sample()
  load("PA4Sample", "MaxDecoded")

  result = MaxDecoding(MaxDecoded.INPUT)
  assert(result, MaxDecoded.RESULT)
endfunction
%!test test_sample()
