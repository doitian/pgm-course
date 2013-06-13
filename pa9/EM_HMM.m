% File: EM_HMM.m
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

function [P loglikelihood ClassProb PairProb] = EM_HMM(actionData, poseData, G, InitialClassProb, InitialPairProb, maxIter)

% INPUTS
% actionData: structure holding the actions as described in the PA
% poseData: N x 10 x 3 matrix, where N is number of poses in all actions
% G: graph parameterization as explained in PA description
% InitialClassProb: N x K matrix, initial allocation of the N poses to the K
%   states. InitialClassProb(i,j) is the probability that example i belongs
%   to state j.
%   This is described in more detail in the PA.
% InitialPairProb: V x K^2 matrix, where V is the total number of pose
%   transitions in all HMM action models, and K is the number of states.
%   This is described in more detail in the PA.
% maxIter: max number of iterations to run EM

% OUTPUTS
% P: structure holding the learned parameters as described in the PA
% loglikelihood: #(iterations run) x 1 vector of loglikelihoods stored for
%   each iteration
% ClassProb: N x K matrix of the conditional class probability of the N examples to the
%   K states in the final iteration. ClassProb(i,j) is the probability that
%   example i belongs to state j. This is described in more detail in the PA.
% PairProb: V x K^2 matrix, where V is the total number of pose transitions
%   in all HMM action models, and K is the number of states. This is
%   described in more detail in the PA.

% Initialize variables
N = size(poseData, 1);
K = size(InitialClassProb, 2);
L = size(actionData, 2); % number of actions
V = size(InitialPairProb, 1);

ClassProb = InitialClassProb;
PairProb = InitialPairProb;

loglikelihood = zeros(maxIter,1);

P.c = [];
P.clg.sigma_x = [];
P.clg.sigma_y = [];
P.clg.sigma_angle = [];

PriorSIndex = arrayfun(@(e) e.marg_ind(1), actionData);

% EM algorithm
for iter=1:maxIter
  
  % M-STEP to estimate parameters for Gaussians
  % Fill in P.c, the initial state prior probability (NOT the class probability as in PA8 and EM_cluster.m)
  % Fill in P.clg for each body part and each class
  % Make sure to choose the right parameterization based on G(i,1)
  % Hint: This part should be similar to your work from PA8 and EM_cluster.m
  
  P.c = zeros(1,K);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  P.c = mean(ClassProb(PriorSIndex, :));

  for p = 1:size(G, 1)
    for k = 1:K
      weights = ClassProb(:, k);
      if G(p, 1) == 0 # Gaussian
        [P.clg(p).mu_y(k), P.clg(p).sigma_y(k)] = FitG(poseData(:, p, 1), weights);
        [P.clg(p).mu_x(k), P.clg(p).sigma_x(k)] = FitG(poseData(:, p, 2), weights);
        [P.clg(p).mu_angle(k), P.clg(p).sigma_angle(k)] = FitG(poseData(:, p, 3), weights);
      else # CLG
        parent = squeeze(poseData(:, G(p, 2), :));
        [Beta1, P.clg(p).sigma_y(k)] = FitLG(poseData(:, p, 1), parent, weights);
        [Beta2, P.clg(p).sigma_x(k)] = FitLG(poseData(:, p, 2), parent, weights);
        [Beta3, P.clg(p).sigma_angle(k)] = FitLG(poseData(:, p, 3), parent, weights);

        P.clg(p).theta(k, :) = [Beta1(end), Beta1(1:3)', Beta2(end), Beta2(1:3)', Beta3(end), Beta3(1:3)'];
      end
    end
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % M-STEP to estimate parameters for transition matrix
  % Fill in P.transMatrix, the transition matrix for states
  % P.transMatrix(i,j) is the probability of transitioning from state i to state j
  P.transMatrix = zeros(K,K);
  
  % Add Dirichlet prior based on size of poseData to avoid 0 probabilities
  P.transMatrix = P.transMatrix + size(PairProb,1) * .05;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  P.transMatrix += reshape(sum(PairProb), 3, 3);
  P.transMatrix ./= repmat(sum(P.transMatrix, 2), 1, 3);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    
  % E-STEP preparation: compute the emission model factors (emission probabilities) in log space for each 
  % of the poses in all actions = log( P(Pose | State) )
  % Hint: This part should be similar to (but NOT the same as) your code in EM_cluster.m
  
  logEmissionProb = zeros(N,K);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  sigma = permute(reshape([P.clg.sigma_y, P.clg.sigma_x, P.clg.sigma_angle], K, size(G, 1), 3), [2, 3, 1]);
  mu = zeros(size(sigma));
  for p = find(~G(:, 1))'
    mu(p, 1, :) = P.clg(p).mu_y;
    mu(p, 2, :) = P.clg(p).mu_x;
    mu(p, 3, :) = P.clg(p).mu_angle;
  end

  partsWithParent = find(G(:, 1));

  for i = 1:N
    example = repmat(squeeze(poseData(i, :, :)), [1, 1, K]);

    for p = partsWithParent'
      for k = 1:K
         theta = reshape(P.clg(p).theta(k, :), 4, 3);
        parentIndex = G(p, 2);
        parent = example(parentIndex, :, k);
        mu(p, :, k) = [1, parent] * theta;
      end
    end

    logP = arrayfun(@lognormpdf, example, mu, sigma);
    logP = squeeze(sum(sum(logP, 1), 2));

    logEmissionProb(i, :) = logP';
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    
  % E-STEP to compute expected sufficient statistics
  % ClassProb contains the conditional class probabilities for each pose in all actions
  % PairProb contains the expected sufficient statistics for the transition CPDs (pairwise transition probabilities)
  % Also compute log likelihood of dataset for this iteration
  % You should do inference and compute everything in log space, only converting to probability space at the end
  % Hint: You should use the logsumexp() function here to do probability normalization in log space to avoid numerical issues
  
  ClassProb = zeros(N,K);
  PairProb = zeros(V,K^2);
  loglikelihood(iter) = 0;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  for l = 1:L
    a = actionData(l);

    F = repmat(struct("var", [], "card", [], "val", []), length(a.marg_ind) + length(a.pair_ind) + 1, 1);

    # Prior
    F(1) = struct("var", [1], "card", [K], "val", log(P.c));

    # Emission
    for i = 1:length(a.marg_ind)
      F(i + 1) = struct("var", [i], "card", [K], "val", logEmissionProb(a.marg_ind(i), :));
    end

    for i = 1:length(a.pair_ind)
      F(i + 1 + length(a.marg_ind)) = struct("var", [i, i + 1], "card", [K, K], "val", log(P.transMatrix(:)'));
    end

    [M, PCalibrated] = ComputeExactMarginalsHMM(F);

    singularProb = reshape([M.val], K, length(a.marg_ind))';
    sumSingularProb = logsumexp(singularProb);
    # normalize
    singularProb -= repmat(sumSingularProb, 1, K);

    ClassProb(a.marg_ind, :) = exp(singularProb);

    # Because clique tree is a chain, it is gurantee Si-1,Si appear once and only once.
    for i = 1:length(PCalibrated.cliqueList)
      clique = PCalibrated.cliqueList(i);
      index = min(clique.var);
      PairProb(a.pair_ind(index), :) = exp(clique.val .- logsumexp(clique.val));
    end

    loglikelihood(iter) += logsumexp(PCalibrated.cliqueList(1).val);
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Print out loglikelihood
  disp(sprintf('EM iteration %d: log likelihood: %f', ...
    iter, loglikelihood(iter)));
  if exist('OCTAVE_VERSION')
    fflush(stdout);
  end
  
  % Check for overfitting by decreasing loglikelihood
  if iter > 1
    if loglikelihood(iter) < loglikelihood(iter-1)
      break;
    end
  end
  
end

% Remove iterations if we exited early
loglikelihood = loglikelihood(1:iter);
