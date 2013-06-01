load("TestI0.mat")

function money = ToMoney(diff)
  money = exp(diff / 100) - 1;
endfunction

base = OptimizeWithJointUtility(TestI0)

TestI1 = TestI0;
TestI1.DecisionFactors(1).var = [9, 11];
TestI1.DecisionFactors(1).card = [2, 2];
TestI1.DecisionFactors(1).val = [1 0 1 0];
TestI1.RandomFactors(10).val = [0.75 0.25 0.001, 0.999];

test1 = OptimizeWithJointUtility(TestI1)
m1 = ToMoney(test1 - base)

TestI2 = TestI0;
TestI2.DecisionFactors(1).var = [9, 11];
TestI2.DecisionFactors(1).card = [2, 2];
TestI2.DecisionFactors(1).val = [1 0 1 0];
TestI2.RandomFactors(10).val = [0.999 0.001 0.25, 0.75];

test2 = OptimizeWithJointUtility(TestI2)
m2 = ToMoney(test2 - base)

TestI3 = TestI0;
TestI3.DecisionFactors(1).var = [9, 11];
TestI3.DecisionFactors(1).card = [2, 2];
TestI3.DecisionFactors(1).val = [1 0 1 0];
TestI3.RandomFactors(10).val = [0.999 0.001 0.001, 0.999];

test3 = OptimizeWithJointUtility(TestI3)
m3 = ToMoney(test3 - base)
