%!test source "FactorProduct_test.m"
function test_self_product()
  a = struct('var', [1], 'card', [2], 'val', ones(1, 2));
  b = struct('var', [1], 'card', [2], 'val', ones(1, 2));
  product = FactorProduct(a, b);

  assert(getfield(product, "var"), [1])
  assert(getfield(product, "card"), [2])
  assert(getfield(product, "val"), ones(1, 2))
endfunction
%!test test_self_product()

function test_product_of_two_single_variable_factors()
  # x1 val | x2 val | x1 x2 val
  #  1   1 |  1   3 |  1  1 1*3
  #  2   2 |  2   4 |  2  1 2*3
  #        |  3   5 |  1  2 1*4
  #                 |  2  2 2*4
  #                 |  1  3 1*5
  #                 |  2  3 2*5
  a = struct('var', [1], 'card', [2], 'val', [1,2]);
  b = struct('var', [2], 'card', [3], 'val', [3,4,5]);
  product = FactorProduct(a, b);

  assert(getfield(product, "var"), [1,2])
  assert(getfield(product, "card"), [2,3])
  assert(getfield(product, "val"), [3,6,4,8,5,10])
endfunction
%!test test_product_of_two_single_variable_factors()

function test_product_of_intersect_factors()
  # x1 x2 val | x2 x3 val | x1 x2 x3 val
  #  1  1   1 |  1  1   5 |  1  1  1 1*5
  #  2  1   2 |  2  1   6 |  2  1  1 2*5
  #  1  2   3 |  1  2   7 |  1  2  1 3*6
  #  2  2   4    2  2   8 |  2  2  1 4*6
  #                       |  1  1  2 1*7
  #                       |  2  1  2 2*7
  #                       |  1  2  2 3*8
  #                       |  2  2  2 4*8
  a = struct('var', [1,2], 'card', [2,2], 'val', [1,2,3,4]);
  b = struct('var', [2,3], 'card', [2,2], 'val', [5,6,7,8]);
  product = FactorProduct(a, b);

  assert(getfield(product, "var"), [1,2,3])
  assert(getfield(product, "card"), [2,2,2])
  assert(getfield(product, "val"), [5,10,18,24,7,14,24,32])
endfunction
%!test test_product_of_intersect_factors()

function test_sample_in_tutorial()
  expect = struct('var', [1, 2], 'card', [2, 2], 'val', [0.0649, 0.1958, 0.0451, 0.6942]);
  a = struct('var', [1], 'card', [2], 'val', [0.11, 0.89]);
  b = struct('var', [2, 1], 'card', [2, 2], 'val', [0.59, 0.41, 0.22, 0.78]);
  product = FactorProduct(a, b);

  assert(product.var, expect.var)
  assert(product.card, expect.card)
  assert(product.val, expect.val, 0.0001)
endfunction
%!test test_sample_in_tutorial()

