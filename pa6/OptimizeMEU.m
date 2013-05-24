% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeMEU( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  
  % We assume I has a single decision node.
  % You may assume that there is a unique optimal decision.
  D = I.DecisionFactors(1);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  % 
  % Some other information that might be useful for some implementations
  % (note that there are multiple ways to implement this):
  % 1.  It is probably easiest to think of two cases - D has parents and D 
  %     has no parents.
  % 2.  You may find the Matlab/Octave function setdiff useful.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

  # Map assignment that Decision variable is in the first position
  EUF = CalculateExpectedUtilityFactor(I);

  map = 1:prod(EUF.card);
  if length(EUF.var) > 1
    subs = IndexToAssignment(1:prod(EUF.card), EUF.card);
    reorderSubs = sortrows(subs, find(EUF.var != D.var(1)));
    map = AssignmentToIndex(reorderSubs, EUF.card);
  end

  pos = find(EUF.var == D.var(1));
  DecisionMatrix = reshape(EUF.val(map), EUF.card(pos), prod(EUF.card) / EUF.card(pos));
  [Max, Index] = max(DecisionMatrix, [], 1);

  MEU = sum(Max);

  IndexMap = (0:length(Index) - 1) .* EUF.card(pos) + Index;

  OptimalDecisionRule = EUF;
  OptimalDecisionRule.val(:) = 0;
  OptimalDecisionRule.val(map(IndexMap)) = 1;
end
