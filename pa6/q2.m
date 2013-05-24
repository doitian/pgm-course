load("FullI.mat")
FullI.RandomFactors = ObserveEvidence(FullI.RandomFactors, [3, 2], 1);
disp(round(SimpleCalcExpectedUtility(FullI) .* 10) ./ 10);

